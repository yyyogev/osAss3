#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
int rmPhysicalPage(int virtualAddress) {
  //look for a phusycal page with the given virtual adress 
  virtualAddress = PTE_ADDR(virtualAddress);
  struct pageLink* page = myproc()->pagesHead;
  while (page && page->va != virtualAddress)
    page = page->next;
  
  if (!page)
    return 0;

  //phys page found, remove it
  myproc()->physicalPagesCount--;
  if (page->prev)
    page->prev->next = page->next;
  if (page->next)
    page->next->prev = page->prev;
  
  //check if the page was head or tail
  if (page == myproc()->pagesHead)
    myproc()->pagesHead = page->next;
  if (page == myproc()->pagesTail)
    myproc()->pagesTail = page->prev;
  
  page->allocated = 0;

  return 1;
    
}

void removePagesHead()
{
    struct pageLink* newHead = myproc()->pagesHead->next;
    myproc()->pagesHead->va = 0xffffffff; //free the page in the table
    myproc()->pagesHead = newHead;
    //proc->pagesInPhysic[proc->physcPageHead].prev = -1;  check how to set prev to null!
}

void removePagesTail()
{
    struct pageLink* newTale = myproc()->pagesTail->prev;
    myproc()->pagesTail->va = 0xffffffff; //free the page in the table
    myproc()->pagesTail = newTale;
    //proc->pagesInPhysic[proc->physcPageTail].next = -1;
}


int 
popFromNFUA() {
    int min = 0xffffffff; 
    struct pageLink* p = myproc()->pagesHead;
    struct pageLink* oldest=p;
    while (p){
      pte_t* pte = walkpgdir(myproc()->pgdir, (void*)p->va, 0);
      p->age >>=1;
      if(*pte & PTE_A)
          p->age |=CR0_PG; //0x80000000
      if (min > p->age){
          min = p->age;
          oldest = p;
      }
      p = p->next;   
    }
  int va=oldest->va;

  //remove oldest
  if (oldest->prev)
    oldest->prev->next = oldest->next;
  if (oldest->next)
    oldest->next->prev = oldest->prev;
  //check if oldest is head or tail
  if (oldest == myproc()->pagesHead)
    removePagesHead();
  if (oldest == myproc()->pagesTail)
    removePagesTail();
  
  oldest->allocated = 0;

  return va;
}

int
getNumOfOnes(int num){
  int counter=0;
  int i;
  for (i=0; i<32; i++){
    if(num & 0x00000001)
      counter ++;
    num >>= 1;
  }
  return counter;
}

int 
popFromLAPA() {
    int min = 0xffffffff; 
    struct pageLink* p = myproc()->pagesHead;
    struct pageLink* pageToRemove=p;
    while (p){
      pte_t* pte = walkpgdir(myproc()->pgdir, (void*)p->va, 0);
      p->age >>=1;
      if(*pte & PTE_A)
          p->age |=CR0_PG; //0x80000000
      if (min > getNumOfOnes(p->age)){
          min = getNumOfOnes(p->age);
          pageToRemove = p;
      }
      p = p->next;    
    }
    int va=pageToRemove->va;

    //remove oldest
    if (pageToRemove->prev)
      pageToRemove->prev->next = pageToRemove->next;
    if (pageToRemove->next)
      pageToRemove->next->prev = pageToRemove->prev;
    //check if pageToRemove is head or tail
    if (pageToRemove == myproc()->pagesHead)
      removePagesHead();
    if (pageToRemove == myproc()->pagesTail)
      removePagesTail();
    
    pageToRemove->allocated = 0;

    return va;
}

void moveHeadToTail ()
{
    struct pageLink* oldHead = myproc()->pagesHead; 
    struct pageLink* newhead = myproc()->pagesHead->next;
    
    myproc()->pagesHead = newhead;
    //proc->pagesInPhysic[proc->physcPageHead].prev = -1; check how to set prev of newhead to null   
    myproc()->pagesTail->next = oldHead;
    //proc->pagesInPhysic[oldHead].next = -1; check how to set head's next to null
    oldHead->prev = myproc()->pagesTail;
    myproc()->pagesTail = oldHead;
    
}

int 
popFromSCFIFO() {
    struct pageLink* pageToRemove=myproc()->pagesHead;
    pte_t* pte = walkpgdir(myproc()->pgdir, (void*)pageToRemove->va, 0);
    int accessed = (*pte) & PTE_A;
    while (accessed){
      *pte &= ~PTE_A;
      moveHeadToTail();
      pageToRemove = myproc()->pagesHead;
      pte = walkpgdir(myproc()->pgdir, (void*)pageToRemove->va, 0);
      accessed = (*pte) & PTE_A;
    }
    int va=pageToRemove->va;
    removePagesHead();
    return va;   
}


int 
popFromAQ() {
    struct pageLink* p = myproc()->pagesHead;
    while (p!=myproc()->pagesTail){
      pte_t* pte = walkpgdir(myproc()->pgdir, (void*)p->va, 0);
      if(*pte & PTE_A)
      {
        struct pageLink* nextPage = p->next;
        struct pageLink* prevPage = p->prev;
        struct pageLink* superNextPage = nextPage->next;
        if (p != myproc()->pagesHead)
          prevPage->next = nextPage;
        p->next = superNextPage;
        p->prev = nextPage;
        nextPage->next = p;
        nextPage->prev = prevPage;
        if (nextPage != myproc()->pagesTail)
          superNextPage->prev = p;

      }
      p = p->next;
    }
    int va = myproc()->pagesHead->va;
    removePagesHead();
  return va;
}

int popPhysicalPage(){
  int va = 0;
  #ifdef NFUA
  cprintf("NFUA-------------\n" );
  va = popFromNFUA();
  #elif LAPA
  va = popFromLAPA();
  #elif SCFIFO
  va = popFromSCFIFO();
  #elif AQ
  va = popFromAQ();
  #endif
  
  myproc()->physicalPagesCount--;
  return va;
}

int findFreeSpace(){
  int i=0;
  while(i < MAX_PSYC_PAGES){
    if (myproc()->physicalPages[i].allocated == 0)
      break;
    i++;
  }
  return i;
}

void 
storingPages(void* virtualAddress) {
  int i;
  int virtualPage = PTE_ADDR(virtualAddress);
  pte_t* pte = walkpgdir(myproc()->pgdir, (void*)virtualPage, 0);
  if (pte == 0) 
      panic("storing pages: page doesn't exist for virutal address");
  
  *pte &= (~PTE_P);
  *pte |= (PTE_PG);
  
  // if ((*pte & PTE_P) != 0)
  //   panic("Flag is up.");
 
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
    if (myproc()->swappedPages[i] == -1) 
      break;
  }
  
  if (i == MAX_PSYC_PAGES)
    panic("storing pages: MAX_PSYC_PAGES exceeded");

   //write the page to the proccess swap file
  writeToSwapFile(myproc(), (char*)PTE_ADDR((void *) ((*pte) + KERNBASE)), i*PGSIZE, PGSIZE);
  myproc()->swappedPages[i] = virtualPage;
  lcr3(((uint) (myproc()->pgdir))  - KERNBASE); 
  myproc()->swappedPagesCount += 1;
  kfree((char*)PTE_ADDR((*pte) + KERNBASE));
 
}

void pushPhysicalPage(int virtualAddress) {
  virtualAddress = PTE_ADDR(virtualAddress);
  cprintf("%d: Adding page at %x (%d)\n", myproc()->pid, virtualAddress, myproc()->physicalPagesCount);
  rmPhysicalPage(virtualAddress);

  if (myproc()->physicalPagesCount >= MAX_PSYC_PAGES) {
      int virtualAddress = popPhysicalPage();
      storingPages((void*)virtualAddress);
      myproc()->pageOutCount++;
  }

  int i=findFreeSpace();
  
  if (i == MAX_PSYC_PAGES) 
    panic("push physcial page: physical pages queue is full");

  struct pageLink* page = &myproc()->physicalPages[i];
  page->allocated = 1;
  page->va = virtualAddress;
  page->next = 0;
  

  if (myproc()->pagesTail)
    myproc()->pagesTail->next = page;
  
  page->prev = myproc()->pagesTail;
  page->accesses = 0;
  myproc()->pagesTail = page;
 
  if (!myproc()->pagesHead)
    myproc()->pagesHead = page;

  myproc()->physicalPagesCount++;
}


int retrievingPages(void* virtualAddress)
{
   int virtualPage = PTE_ADDR(virtualAddress);
  //try to page in
  pte_t* pte = walkpgdir(myproc()->pgdir, (char*)virtualPage, 0);

  if (pte && ((*pte & PTE_PG) != 0)){
    int i = 0;
    while(i < MAX_PSYC_PAGES){
      if (myproc()->swappedPages[i] == virtualPage)
        break;
      i++;
    }

    if (i == MAX_PSYC_PAGES) 
      panic("retrieving Pages: page doesn't exist");

    char *mem = kalloc();

    if(mem == 0)
      panic("retrieving Pages: out of memory");

    //read the page from the swap file
    if (readFromSwapFile(myproc(), mem, i * PGSIZE, PGSIZE) == -1)
      panic("retrieving pages: error reading page");

    //mark as unswapped
    myproc()->swappedPages[i] = -1;

    mappages(myproc()->pgdir, (char*)virtualPage, PGSIZE, (uint) (mem)  - KERNBASE, PTE_W|PTE_U|PTE_P);
    pushPhysicalPage(virtualPage);
    lcr3(((uint) (myproc()->pgdir))  - KERNBASE);

    return 1;
  }

  return 0;
}



static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}


// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    #ifndef NONE  
      cprintf("hadpasa\n");
      pushPhysicalPage(a);
    #endif
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.


