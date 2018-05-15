
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 32 10 80       	mov    $0x80103220,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 00 7d 10 80       	push   $0x80107d00
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 b5 46 00 00       	call   80104710 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 7d 10 80       	push   $0x80107d07
80100097:	50                   	push   %eax
80100098:	e8 63 45 00 00       	call   80104600 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 27 47 00 00       	call   80104810 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 c9 47 00 00       	call   80104930 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 44 00 00       	call   80104640 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 2d 23 00 00       	call   801024b0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 7d 10 80       	push   $0x80107d0e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 2d 45 00 00       	call   801046e0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 e7 22 00 00       	jmp    801024b0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 7d 10 80       	push   $0x80107d1f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ec 44 00 00       	call   801046e0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 44 00 00       	call   801046a0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 00 46 00 00       	call   80104810 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 cf 46 00 00       	jmp    80104930 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 7d 10 80       	push   $0x80107d26
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 7f 45 00 00       	call   80104810 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002a6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 a0 0f 11 80       	push   $0x80110fa0
801002bd:	e8 be 3e 00 00       	call   80104180 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 e9 38 00 00       	call   80103bc0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 45 46 00 00       	call   80104930 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 13 00 00       	call   80101670 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 e5 45 00 00       	call   80104930 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 22 27 00 00       	call   80102ab0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 2d 7d 10 80       	push   $0x80107d2d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 44 87 10 80 	movl   $0x80108744,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 73 43 00 00       	call   80104730 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 41 7d 10 80       	push   $0x80107d41
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 51 5c 00 00       	call   80106070 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 98 5b 00 00       	call   80106070 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 8c 5b 00 00       	call   80106070 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 80 5b 00 00       	call   80106070 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 17 45 00 00       	call   80104a30 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 52 44 00 00       	call   80104980 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 45 7d 10 80       	push   $0x80107d45
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 70 7d 10 80 	movzbl -0x7fef8290(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 f0 41 00 00       	call   80104810 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 e4 42 00 00       	call   80104930 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 1e 42 00 00       	call   80104930 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 58 7d 10 80       	mov    $0x80107d58,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 43 40 00 00       	call   80104810 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 5f 7d 10 80       	push   $0x80107d5f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 08 40 00 00       	call   80104810 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100836:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 c3 40 00 00       	call   80104930 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008f1:	68 a0 0f 11 80       	push   $0x80110fa0
801008f6:	e8 45 3a 00 00       	call   80104340 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100934:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 b4 3a 00 00       	jmp    80104430 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 68 7d 10 80       	push   $0x80107d68
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 5b 3d 00 00       	call   80104710 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 82 1c 00 00       	call   80102660 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 bf 31 00 00       	call   80103bc0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 04 25 00 00       	call   80102f10 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 a9 14 00 00       	call   80101ec0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 43 0c 00 00       	call   80101670 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 12 0f 00 00       	call   80101950 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 b1 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a4f:	e8 2c 25 00 00       	call   80102f80 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 d7 6f 00 00       	call   80107a50 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 83 0e 00 00       	call   80101950 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 77 6d 00 00       	call   80107880 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 81 6c 00 00       	call   801077c0 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 72 6e 00 00       	call   801079d0 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 91 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b6f:	e8 0c 24 00 00       	call   80102f80 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 e6 6c 00 00       	call   80107880 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 1f 6e 00 00       	call   801079d0 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 bd 23 00 00       	call   80102f80 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 81 7d 10 80       	push   $0x80107d81
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 fa 6e 00 00       	call   80107af0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 8e 3f 00 00       	call   80104bc0 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 7b 3f 00 00       	call   80104bc0 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 fa 6f 00 00       	call   80107c50 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 90 6f 00 00       	call   80107c50 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 7b 3e 00 00       	call   80104b80 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 ff 68 00 00       	call   80107630 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 97 6c 00 00       	call   801079d0 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 8d 7d 10 80       	push   $0x80107d8d
80100d5b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d60:	e8 ab 39 00 00       	call   80104710 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 0f 11 80       	push   $0x80110fc0
80100d81:	e8 8a 3a 00 00       	call   80104810 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 0f 11 80       	push   $0x80110fc0
80100db1:	e8 7a 3b 00 00       	call   80104930 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc8:	e8 63 3b 00 00       	call   80104930 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 0f 11 80       	push   $0x80110fc0
80100def:	e8 1c 3a 00 00       	call   80104810 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0c:	e8 1f 3b 00 00       	call   80104930 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 94 7d 10 80       	push   $0x80107d94
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 ca 39 00 00       	call   80104810 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 bf 3a 00 00       	jmp    80104930 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 93 3a 00 00       	call   80104930 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 ea 27 00 00       	call   801036b0 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 3b 20 00 00       	call   80102f10 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 c0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 91 20 00 00       	jmp    80102f80 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 9c 7d 10 80       	push   $0x80107d9c
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 56 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 f9 09 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 20 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 f1 06 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 c4 09 00 00       	call   80101950 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 ad 07 00 00       	call   80101750 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 8e 28 00 00       	jmp    80103850 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 a6 7d 10 80       	push   $0x80107da6
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 17 07 00 00       	call   80101750 <iunlock>
      end_op();
80101039:	e8 42 1f 00 00       	call   80102f80 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 a5 1e 00 00       	call   80102f10 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 fa 05 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 c8 09 00 00       	call   80101a50 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 b3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010109d:	e8 de 1e 00 00       	call   80102f80 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 6f 26 00 00       	jmp    80103750 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 af 7d 10 80       	push   $0x80107daf
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 b5 7d 10 80       	push   $0x80107db5
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 85 00 00 00    	je     8010119f <balloc+0x9f>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2d                	jmp    8010117a <balloc+0x7a>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
80101152:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101169:	85 d7                	test   %edx,%edi
8010116b:	74 43                	je     801011b0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116d:	83 c0 01             	add    $0x1,%eax
80101170:	83 c6 01             	add    $0x1,%esi
80101173:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101178:	74 05                	je     8010117f <balloc+0x7f>
8010117a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117d:	72 d1                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 75 e4             	pushl  -0x1c(%ebp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101197:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010119d:	77 82                	ja     80101121 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 bf 7d 10 80       	push   $0x80107dbf
801011a7:	e8 c4 f1 ff ff       	call   80100370 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	09 fa                	or     %edi,%edx
801011b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 2e 1f 00 00       	call   801030f0 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 96 37 00 00       	call   80104980 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 fe 1e 00 00       	call   801030f0 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101225:	68 e0 19 11 80       	push   $0x801119e0
8010122a:	e8 e1 35 00 00       	call   80104810 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101250:	74 4e                	je     801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101268:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 b9 36 00 00       	call   80104930 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101299:	75 b7                	jne    80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 e0 19 11 80       	push   $0x801119e0
801012bf:	e8 6c 36 00 00       	call   80104930 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 d5 7d 10 80       	push   $0x80107dd5
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 83 00 00 00    	ja     80101397 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 6a                	je     80101388 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 9e 1d 00 00       	call   801030f0 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101364:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 06                	mov    (%esi),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 71 fd ff ff       	call   80101100 <balloc>
8010138f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101395:	eb 87                	jmp    8010131e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101397:	83 ec 0c             	sub    $0xc,%esp
8010139a:	68 e5 7d 10 80       	push   $0x80107de5
8010139f:	e8 cc ef ff ff       	call   80100370 <panic>
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 5a 36 00 00       	call   80104a30 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 c0 19 11 80       	push   $0x801119c0
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101423:	ba 01 00 00 00       	mov    $0x1,%edx
80101428:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142b:	c1 fb 03             	sar    $0x3,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 27                	je     80101463 <bfree+0x73>
8010143c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143e:	f7 d2                	not    %edx
80101440:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101442:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101445:	21 d0                	and    %edx,%eax
80101447:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010144b:	56                   	push   %esi
8010144c:	e8 9f 1c 00 00       	call   801030f0 <log_write>
  brelse(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101463:	83 ec 0c             	sub    $0xc,%esp
80101466:	68 f8 7d 10 80       	push   $0x80107df8
8010146b:	e8 00 ef ff ff       	call   80100370 <panic>

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	68 0b 7e 10 80       	push   $0x80107e0b
80101481:	68 e0 19 11 80       	push   $0x801119e0
80101486:	e8 85 32 00 00       	call   80104710 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 12 7e 10 80       	push   $0x80107e12
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 5c 31 00 00       	call   80104600 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 c0 19 11 80       	push   $0x801119c0
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 d8 19 11 80    	pushl  0x801119d8
801014c5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801014cb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801014d1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801014d7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801014dd:	ff 35 c4 19 11 80    	pushl  0x801119c4
801014e3:	ff 35 c0 19 11 80    	pushl  0x801119c0
801014e9:	68 bc 7e 10 80       	push   $0x80107ebc
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 fd 33 00 00       	call   80104980 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 5b 1b 00 00       	call   801030f0 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 18 7e 10 80       	push   $0x80107e18
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 0a 34 00 00       	call   80104a30 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 c2 1a 00 00       	call   801030f0 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 e0 19 11 80       	push   $0x801119e0
8010164f:	e8 bc 31 00 00       	call   80104810 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010165f:	e8 cc 32 00 00       	call   80104930 <release>
  return ip;
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b7 00 00 00    	je     80101737 <ilock+0xc7>
80101680:	8b 53 08             	mov    0x8(%ebx),%edx
80101683:	85 d2                	test   %edx,%edx
80101685:	0f 8e ac 00 00 00    	jle    80101737 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 a9 2f 00 00       	call   80104640 <acquiresleep>

  if(ip->valid == 0){
80101697:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 0f                	je     801016b0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5d                   	pop    %ebp
801016a7:	c3                   	ret    
801016a8:	90                   	nop
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 23 33 00 00       	call   80104a30 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101715:	83 c4 10             	add    $0x10,%esp
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101724:	0f 85 77 ff ff ff    	jne    801016a1 <ilock+0x31>
      panic("ilock: no type");
8010172a:	83 ec 0c             	sub    $0xc,%esp
8010172d:	68 30 7e 10 80       	push   $0x80107e30
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 2a 7e 10 80       	push   $0x80107e2a
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
80101744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101750 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 78 2f 00 00       	call   801046e0 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010177f:	e9 1c 2f 00 00       	jmp    801046a0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 3f 7e 10 80       	push   $0x80107e3f
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	57                   	push   %edi
801017b0:	e8 8b 2e 00 00       	call   80104640 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 d2                	test   %edx,%edx
801017bd:	74 07                	je     801017c6 <iput+0x26>
801017bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c4:	74 32                	je     801017f8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	57                   	push   %edi
801017ca:	e8 d1 2e 00 00       	call   801046a0 <releasesleep>

  acquire(&icache.lock);
801017cf:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017d6:	e8 35 30 00 00       	call   80104810 <acquire>
  ip->ref--;
801017db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5f                   	pop    %edi
801017ef:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017f0:	e9 3b 31 00 00       	jmp    80104930 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 e0 19 11 80       	push   $0x801119e0
80101800:	e8 0b 30 00 00       	call   80104810 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010180f:	e8 1c 31 00 00       	call   80104930 <release>
    if(r == 1){
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	83 fb 01             	cmp    $0x1,%ebx
8010181a:	75 aa                	jne    801017c6 <iput+0x26>
8010181c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101822:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101825:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x97>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xb0>
    if(ip->addrs[i]){
80101837:	8b 13                	mov    (%ebx),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e8 ac fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101844:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010184a:	eb e4                	jmp    80101830 <iput+0x90>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 33                	jne    80101890 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010185d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101860:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101867:	56                   	push   %esi
80101868:	e8 53 fd ff ff       	call   801015c0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010186d:	31 c0                	xor    %eax,%eax
8010186f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101873:	89 34 24             	mov    %esi,(%esp)
80101876:	e8 45 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010187b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	e9 3c ff ff ff       	jmp    801017c6 <iput+0x26>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	89 cf                	mov    %ecx,%edi
801018af:	eb 0e                	jmp    801018bf <iput+0x11f>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018bb:	39 fb                	cmp    %edi,%ebx
801018bd:	74 0f                	je     801018ce <iput+0x12e>
      if(a[j])
801018bf:	8b 13                	mov    (%ebx),%edx
801018c1:	85 d2                	test   %edx,%edx
801018c3:	74 f3                	je     801018b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018c5:	8b 06                	mov    (%esi),%eax
801018c7:	e8 24 fb ff ff       	call   801013f0 <bfree>
801018cc:	eb ea                	jmp    801018b8 <iput+0x118>
    }
    brelse(bp);
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018d7:	e8 04 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018dc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e2:	8b 06                	mov    (%esi),%eax
801018e4:	e8 07 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f0:	00 00 00 
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	e9 62 ff ff ff       	jmp    8010185d <iput+0xbd>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 10             	sub    $0x10,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	53                   	push   %ebx
8010190b:	e8 40 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101910:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101913:	83 c4 10             	add    $0x10,%esp
}
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 81 fe ff ff       	jmp    801017a0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101962:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101967:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010196a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101970:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101973:	0f 84 a7 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101979:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010197c:	8b 40 58             	mov    0x58(%eax),%eax
8010197f:	39 f0                	cmp    %esi,%eax
80101981:	0f 82 c1 00 00 00    	jb     80101a48 <readi+0xf8>
80101987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010198a:	89 fa                	mov    %edi,%edx
8010198c:	01 f2                	add    %esi,%edx
8010198e:	0f 82 b4 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101994:	89 c1                	mov    %eax,%ecx
80101996:	29 f1                	sub    %esi,%ecx
80101998:	39 d0                	cmp    %edx,%eax
8010199a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	31 ff                	xor    %edi,%edi
8010199f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a4:	74 6d                	je     80101a13 <readi+0xc3>
801019a6:	8d 76 00             	lea    0x0(%esi),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019b3:	89 f2                	mov    %esi,%edx
801019b5:	c1 ea 09             	shr    $0x9,%edx
801019b8:	89 d8                	mov    %ebx,%eax
801019ba:	e8 21 f9 ff ff       	call   801012e0 <bmap>
801019bf:	83 ec 08             	sub    $0x8,%esp
801019c2:	50                   	push   %eax
801019c3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019c5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ca:	e8 01 e7 ff ff       	call   801000d0 <bread>
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d4:	89 f1                	mov    %esi,%ecx
801019d6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019dc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e2:	29 cb                	sub    %ecx,%ebx
801019e4:	29 f8                	sub    %edi,%eax
801019e6:	39 c3                	cmp    %eax,%ebx
801019e8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019eb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019ef:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	01 df                	add    %ebx,%edi
801019f2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019f4:	50                   	push   %eax
801019f5:	ff 75 e0             	pushl  -0x20(%ebp)
801019f8:	e8 33 30 00 00       	call   80104a30 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a11:	77 9d                	ja     801019b0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a19:	5b                   	pop    %ebx
80101a1a:	5e                   	pop    %esi
80101a1b:	5f                   	pop    %edi
80101a1c:	5d                   	pop    %ebp
80101a1d:	c3                   	ret    
80101a1e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3b:	5b                   	pop    %ebx
80101a3c:	5e                   	pop    %esi
80101a3d:	5f                   	pop    %edi
80101a3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a3f:	ff e0                	jmp    *%eax
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c7                	jmp    80101a16 <readi+0xc6>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 eb 00 00 00    	jb     80101b70 <writei+0x120>
80101a85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a88:	89 f8                	mov    %edi,%eax
80101a8a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a8c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a91:	0f 87 d9 00 00 00    	ja     80101b70 <writei+0x120>
80101a97:	39 c6                	cmp    %eax,%esi
80101a99:	0f 87 d1 00 00 00    	ja     80101b70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9f:	85 ff                	test   %edi,%edi
80101aa1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa8:	74 78                	je     80101b22 <writei+0xd2>
80101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ab3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aba:	c1 ea 09             	shr    $0x9,%edx
80101abd:	89 f8                	mov    %edi,%eax
80101abf:	e8 1c f8 ff ff       	call   801012e0 <bmap>
80101ac4:	83 ec 08             	sub    $0x8,%esp
80101ac7:	50                   	push   %eax
80101ac8:	ff 37                	pushl  (%edi)
80101aca:	e8 01 e6 ff ff       	call   801000d0 <bread>
80101acf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ad4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ad7:	89 f1                	mov    %esi,%ecx
80101ad9:	83 c4 0c             	add    $0xc,%esp
80101adc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ae2:	29 cb                	sub    %ecx,%ebx
80101ae4:	39 c3                	cmp    %eax,%ebx
80101ae6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101aed:	53                   	push   %ebx
80101aee:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	50                   	push   %eax
80101af4:	e8 37 2f 00 00       	call   80104a30 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 ef 15 00 00       	call   801030f0 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b0f:	83 c4 10             	add    $0x10,%esp
80101b12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b15:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b18:	77 96                	ja     80101ab0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b20:	77 36                	ja     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 36                	ja     80101b70 <writei+0x120>
80101b3a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 2b                	je     80101b70 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b61:	50                   	push   %eax
80101b62:	e8 59 fa ff ff       	call   801015c0 <iupdate>
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	eb b6                	jmp    80101b22 <writei+0xd2>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b75:	eb ae                	jmp    80101b25 <writei+0xd5>
80101b77:	89 f6                	mov    %esi,%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	6a 0e                	push   $0xe
80101b88:	ff 75 0c             	pushl  0xc(%ebp)
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 1d 2f 00 00       	call   80104ab0 <strncmp>
}
80101b93:	c9                   	leave  
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 80 00 00 00    	jne    80101c37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 5b                	jmp    80101c20 <dirlookup+0x80>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 50                	jbe    80101c20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	6a 10                	push   $0x10
80101bd2:	57                   	push   %edi
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	e8 76 fd ff ff       	call   80101950 <readi>
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	83 f8 10             	cmp    $0x10,%eax
80101be0:	75 48                	jne    80101c2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101be2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be7:	74 df                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101be9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bec:	83 ec 04             	sub    $0x4,%esp
80101bef:	6a 0e                	push   $0xe
80101bf1:	50                   	push   %eax
80101bf2:	ff 75 0c             	pushl  0xc(%ebp)
80101bf5:	e8 b6 2e 00 00       	call   80104ab0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	75 c7                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c01:	8b 45 10             	mov    0x10(%ebp),%eax
80101c04:	85 c0                	test   %eax,%eax
80101c06:	74 05                	je     80101c0d <dirlookup+0x6d>
        *poff = off;
80101c08:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c11:	8b 03                	mov    (%ebx),%eax
80101c13:	e8 f8 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
80101c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c23:	31 c0                	xor    %eax,%eax
}
80101c25:	5b                   	pop    %ebx
80101c26:	5e                   	pop    %esi
80101c27:	5f                   	pop    %edi
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 59 7e 10 80       	push   $0x80107e59
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 47 7e 10 80       	push   $0x80107e47
80101c3f:	e8 2c e7 ff ff       	call   80100370 <panic>
80101c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	89 cf                	mov    %ecx,%edi
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c63:	0f 84 53 01 00 00    	je     80101dbc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 52 1f 00 00       	call   80103bc0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c71:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c74:	68 e0 19 11 80       	push   $0x801119e0
80101c79:	e8 92 2b 00 00       	call   80104810 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101c89:	e8 a2 2c 00 00       	call   80104930 <release>
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	eb 08                	jmp    80101c9b <namex+0x4b>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c98:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c9b:	0f b6 03             	movzbl (%ebx),%eax
80101c9e:	3c 2f                	cmp    $0x2f,%al
80101ca0:	74 f6                	je     80101c98 <namex+0x48>
    path++;
  if(*path == 0)
80101ca2:	84 c0                	test   %al,%al
80101ca4:	0f 84 e3 00 00 00    	je     80101d8d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101caa:	0f b6 03             	movzbl (%ebx),%eax
80101cad:	89 da                	mov    %ebx,%edx
80101caf:	84 c0                	test   %al,%al
80101cb1:	0f 84 ac 00 00 00    	je     80101d63 <namex+0x113>
80101cb7:	3c 2f                	cmp    $0x2f,%al
80101cb9:	75 09                	jne    80101cc4 <namex+0x74>
80101cbb:	e9 a3 00 00 00       	jmp    80101d63 <namex+0x113>
80101cc0:	84 c0                	test   %al,%al
80101cc2:	74 0a                	je     80101cce <namex+0x7e>
    path++;
80101cc4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc7:	0f b6 02             	movzbl (%edx),%eax
80101cca:	3c 2f                	cmp    $0x2f,%al
80101ccc:	75 f2                	jne    80101cc0 <namex+0x70>
80101cce:	89 d1                	mov    %edx,%ecx
80101cd0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cd2:	83 f9 0d             	cmp    $0xd,%ecx
80101cd5:	0f 8e 8d 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cdb:	83 ec 04             	sub    $0x4,%esp
80101cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ce1:	6a 0e                	push   $0xe
80101ce3:	53                   	push   %ebx
80101ce4:	57                   	push   %edi
80101ce5:	e8 46 2d 00 00       	call   80104a30 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ced:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cf0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf5:	75 11                	jne    80101d08 <namex+0xb8>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 5f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d19:	0f 85 7f 00 00 00    	jne    80101d9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d22:	85 d2                	test   %edx,%edx
80101d24:	74 09                	je     80101d2f <namex+0xdf>
80101d26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d29:	0f 84 a3 00 00 00    	je     80101dd2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2f:	83 ec 04             	sub    $0x4,%esp
80101d32:	6a 00                	push   $0x0
80101d34:	57                   	push   %edi
80101d35:	56                   	push   %esi
80101d36:	e8 65 fe ff ff       	call   80101ba0 <dirlookup>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	74 5c                	je     80101d9e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d42:	83 ec 0c             	sub    $0xc,%esp
80101d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d48:	56                   	push   %esi
80101d49:	e8 02 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	83 c4 10             	add    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
80101d5e:	e9 38 ff ff ff       	jmp    80101c9b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d63:	31 c9                	xor    %ecx,%ecx
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d68:	83 ec 04             	sub    $0x4,%esp
80101d6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d71:	51                   	push   %ecx
80101d72:	53                   	push   %ebx
80101d73:	57                   	push   %edi
80101d74:	e8 b7 2c 00 00       	call   80104a30 <memmove>
    name[len] = 0;
80101d79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d86:	89 d3                	mov    %edx,%ebx
80101d88:	e9 65 ff ff ff       	jmp    80101cf2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	75 54                	jne    80101de8 <namex+0x198>
80101d94:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d99:	5b                   	pop    %ebx
80101d9a:	5e                   	pop    %esi
80101d9b:	5f                   	pop    %edi
80101d9c:	5d                   	pop    %ebp
80101d9d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	56                   	push   %esi
80101da2:	e8 a9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101da7:	89 34 24             	mov    %esi,(%esp)
80101daa:	e8 f1 f9 ff ff       	call   801017a0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101daf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101db5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dbc:	ba 01 00 00 00       	mov    $0x1,%edx
80101dc1:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc6:	e8 45 f4 ff ff       	call   80101210 <iget>
80101dcb:	89 c6                	mov    %eax,%esi
80101dcd:	e9 c9 fe ff ff       	jmp    80101c9b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	56                   	push   %esi
80101dd6:	e8 75 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101ddb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101de1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de3:	5b                   	pop    %ebx
80101de4:	5e                   	pop    %esi
80101de5:	5f                   	pop    %edi
80101de6:	5d                   	pop    %ebp
80101de7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	56                   	push   %esi
80101dec:	e8 af f9 ff ff       	call   801017a0 <iput>
    return 0;
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	31 c0                	xor    %eax,%eax
80101df6:	eb 9e                	jmp    80101d96 <namex+0x146>
80101df8:	90                   	nop
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 20             	sub    $0x20,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	6a 00                	push   $0x0
80101e0e:	ff 75 0c             	pushl  0xc(%ebp)
80101e11:	53                   	push   %ebx
80101e12:	e8 89 fd ff ff       	call   80101ba0 <dirlookup>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	75 67                	jne    80101e85 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e24:	85 ff                	test   %edi,%edi
80101e26:	74 29                	je     80101e51 <dirlink+0x51>
80101e28:	31 ff                	xor    %edi,%edi
80101e2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2d:	eb 09                	jmp    80101e38 <dirlink+0x38>
80101e2f:	90                   	nop
80101e30:	83 c7 10             	add    $0x10,%edi
80101e33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e36:	76 19                	jbe    80101e51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 0e fb ff ff       	call   80101950 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 4e                	jne    80101e98 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	75 df                	jne    80101e30 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e54:	83 ec 04             	sub    $0x4,%esp
80101e57:	6a 0e                	push   $0xe
80101e59:	ff 75 0c             	pushl  0xc(%ebp)
80101e5c:	50                   	push   %eax
80101e5d:	e8 be 2c 00 00       	call   80104b20 <strncpy>
  de.inum = inum;
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e65:	6a 10                	push   $0x10
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6e:	e8 dd fb ff ff       	call   80101a50 <writei>
80101e73:	83 c4 20             	add    $0x20,%esp
80101e76:	83 f8 10             	cmp    $0x10,%eax
80101e79:	75 2a                	jne    80101ea5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e7b:	31 c0                	xor    %eax,%eax
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	5b                   	pop    %ebx
80101e81:	5e                   	pop    %esi
80101e82:	5f                   	pop    %edi
80101e83:	5d                   	pop    %ebp
80101e84:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	50                   	push   %eax
80101e89:	e8 12 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb e5                	jmp    80101e7d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	68 68 7e 10 80       	push   $0x80107e68
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 f1 84 10 80       	push   $0x801084f1
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 7d fd ff ff       	call   80101c50 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ee0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ee6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eee:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eef:	e9 5c fd ff ff       	jmp    80101c50 <namex>
80101ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f00 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f00:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f01:	b8 38 39 00 00       	mov    $0x3938,%eax


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f06:	89 e5                	mov    %esp,%ebp
80101f08:	57                   	push   %edi
80101f09:	56                   	push   %esi
80101f0a:	53                   	push   %ebx
80101f0b:	83 ec 10             	sub    $0x10,%esp
80101f0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f11:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f18:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f1f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f23:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f27:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f2a:	85 c9                	test   %ecx,%ecx
80101f2c:	78 62                	js     80101f90 <itoa+0x90>
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
80101f2e:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f30:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f35:	8d 76 00             	lea    0x0(%esi),%esi
80101f38:	89 d8                	mov    %ebx,%eax
80101f3a:	c1 fb 1f             	sar    $0x1f,%ebx
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
    do{ //Move to where representation ends
        ++p;
80101f3d:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101f40:	f7 ef                	imul   %edi
80101f42:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101f45:	29 da                	sub    %ebx,%edx
80101f47:	89 d3                	mov    %edx,%ebx
80101f49:	75 ed                	jne    80101f38 <itoa+0x38>
    *p = '\0';
80101f4b:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f4e:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101f53:	90                   	nop
80101f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f58:	89 c8                	mov    %ecx,%eax
80101f5a:	83 ee 01             	sub    $0x1,%esi
80101f5d:	f7 eb                	imul   %ebx
80101f5f:	89 c8                	mov    %ecx,%eax
80101f61:	c1 f8 1f             	sar    $0x1f,%eax
80101f64:	c1 fa 02             	sar    $0x2,%edx
80101f67:	29 c2                	sub    %eax,%edx
80101f69:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101f6c:	01 c0                	add    %eax,%eax
80101f6e:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101f70:	85 d2                	test   %edx,%edx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f72:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101f77:	89 d1                	mov    %edx,%ecx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f79:	88 06                	mov    %al,(%esi)
        i = i/10;
    }while(i);
80101f7b:	75 db                	jne    80101f58 <itoa+0x58>
    return b;
}
80101f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f80:	83 c4 10             	add    $0x10,%esp
80101f83:	5b                   	pop    %ebx
80101f84:	5e                   	pop    %esi
80101f85:	5f                   	pop    %edi
80101f86:	5d                   	pop    %ebp
80101f87:	c3                   	ret    
80101f88:	90                   	nop
80101f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80101f90:	89 f0                	mov    %esi,%eax
        i *= -1;
80101f92:	f7 d9                	neg    %ecx

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80101f94:	8d 76 01             	lea    0x1(%esi),%esi
80101f97:	c6 00 2d             	movb   $0x2d,(%eax)
80101f9a:	eb 92                	jmp    80101f2e <itoa+0x2e>
80101f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fa0 <removeSwapFile>:
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	57                   	push   %edi
80101fa4:	56                   	push   %esi
80101fa5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fa6:	8d 75 bc             	lea    -0x44(%ebp),%esi
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fa9:	83 ec 40             	sub    $0x40,%esp
80101fac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101faf:	6a 06                	push   $0x6
80101fb1:	68 75 7e 10 80       	push   $0x80107e75
80101fb6:	56                   	push   %esi
80101fb7:	e8 74 2a 00 00       	call   80104a30 <memmove>
  itoa(p->pid, path+ 6);
80101fbc:	58                   	pop    %eax
80101fbd:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80101fc0:	5a                   	pop    %edx
80101fc1:	50                   	push   %eax
80101fc2:	ff 73 10             	pushl  0x10(%ebx)
80101fc5:	e8 36 ff ff ff       	call   80101f00 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
80101fca:	8b 43 7c             	mov    0x7c(%ebx),%eax
80101fcd:	83 c4 10             	add    $0x10,%esp
80101fd0:	85 c0                	test   %eax,%eax
80101fd2:	0f 84 88 01 00 00    	je     80102160 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80101fd8:	83 ec 0c             	sub    $0xc,%esp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101fdb:	8d 5d ca             	lea    -0x36(%ebp),%ebx

  if(0 == p->swapFile)
  {
    return -1;
  }
  fileclose(p->swapFile);
80101fde:	50                   	push   %eax
80101fdf:	e8 4c ee ff ff       	call   80100e30 <fileclose>

  begin_op();
80101fe4:	e8 27 0f 00 00       	call   80102f10 <begin_op>
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101fe9:	89 f0                	mov    %esi,%eax
80101feb:	89 d9                	mov    %ebx,%ecx
80101fed:	ba 01 00 00 00       	mov    $0x1,%edx
80101ff2:	e8 59 fc ff ff       	call   80101c50 <namex>
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101ffc:	89 c6                	mov    %eax,%esi
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
80101ffe:	0f 84 66 01 00 00    	je     8010216a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102004:	83 ec 0c             	sub    $0xc,%esp
80102007:	50                   	push   %eax
80102008:	e8 63 f6 ff ff       	call   80101670 <ilock>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
8010200d:	83 c4 0c             	add    $0xc,%esp
80102010:	6a 0e                	push   $0xe
80102012:	68 7d 7e 10 80       	push   $0x80107e7d
80102017:	53                   	push   %ebx
80102018:	e8 93 2a 00 00       	call   80104ab0 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010201d:	83 c4 10             	add    $0x10,%esp
80102020:	85 c0                	test   %eax,%eax
80102022:	0f 84 f0 00 00 00    	je     80102118 <removeSwapFile+0x178>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80102028:	83 ec 04             	sub    $0x4,%esp
8010202b:	6a 0e                	push   $0xe
8010202d:	68 7c 7e 10 80       	push   $0x80107e7c
80102032:	53                   	push   %ebx
80102033:	e8 78 2a 00 00       	call   80104ab0 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102038:	83 c4 10             	add    $0x10,%esp
8010203b:	85 c0                	test   %eax,%eax
8010203d:	0f 84 d5 00 00 00    	je     80102118 <removeSwapFile+0x178>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102043:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102046:	83 ec 04             	sub    $0x4,%esp
80102049:	50                   	push   %eax
8010204a:	53                   	push   %ebx
8010204b:	56                   	push   %esi
8010204c:	e8 4f fb ff ff       	call   80101ba0 <dirlookup>
80102051:	83 c4 10             	add    $0x10,%esp
80102054:	85 c0                	test   %eax,%eax
80102056:	89 c3                	mov    %eax,%ebx
80102058:	0f 84 ba 00 00 00    	je     80102118 <removeSwapFile+0x178>
    goto bad;
  ilock(ip);
8010205e:	83 ec 0c             	sub    $0xc,%esp
80102061:	50                   	push   %eax
80102062:	e8 09 f6 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
80102067:	83 c4 10             	add    $0x10,%esp
8010206a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010206f:	0f 8e 11 01 00 00    	jle    80102186 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102075:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010207a:	74 74                	je     801020f0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010207c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010207f:	83 ec 04             	sub    $0x4,%esp
80102082:	6a 10                	push   $0x10
80102084:	6a 00                	push   $0x0
80102086:	57                   	push   %edi
80102087:	e8 f4 28 00 00       	call   80104980 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010208c:	6a 10                	push   $0x10
8010208e:	ff 75 b8             	pushl  -0x48(%ebp)
80102091:	57                   	push   %edi
80102092:	56                   	push   %esi
80102093:	e8 b8 f9 ff ff       	call   80101a50 <writei>
80102098:	83 c4 20             	add    $0x20,%esp
8010209b:	83 f8 10             	cmp    $0x10,%eax
8010209e:	0f 85 d5 00 00 00    	jne    80102179 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020a4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020a9:	0f 84 91 00 00 00    	je     80102140 <removeSwapFile+0x1a0>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020af:	83 ec 0c             	sub    $0xc,%esp
801020b2:	56                   	push   %esi
801020b3:	e8 98 f6 ff ff       	call   80101750 <iunlock>
  iput(ip);
801020b8:	89 34 24             	mov    %esi,(%esp)
801020bb:	e8 e0 f6 ff ff       	call   801017a0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801020c0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801020c5:	89 1c 24             	mov    %ebx,(%esp)
801020c8:	e8 f3 f4 ff ff       	call   801015c0 <iupdate>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801020cd:	89 1c 24             	mov    %ebx,(%esp)
801020d0:	e8 7b f6 ff ff       	call   80101750 <iunlock>
  iput(ip);
801020d5:	89 1c 24             	mov    %ebx,(%esp)
801020d8:	e8 c3 f6 ff ff       	call   801017a0 <iput>

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();
801020dd:	e8 9e 0e 00 00       	call   80102f80 <end_op>

  return 0;
801020e2:	83 c4 10             	add    $0x10,%esp
801020e5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801020e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020ea:	5b                   	pop    %ebx
801020eb:	5e                   	pop    %esi
801020ec:	5f                   	pop    %edi
801020ed:	5d                   	pop    %ebp
801020ee:	c3                   	ret    
801020ef:	90                   	nop
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801020f0:	83 ec 0c             	sub    $0xc,%esp
801020f3:	53                   	push   %ebx
801020f4:	e8 97 30 00 00       	call   80105190 <isdirempty>
801020f9:	83 c4 10             	add    $0x10,%esp
801020fc:	85 c0                	test   %eax,%eax
801020fe:	0f 85 78 ff ff ff    	jne    8010207c <removeSwapFile+0xdc>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102104:	83 ec 0c             	sub    $0xc,%esp
80102107:	53                   	push   %ebx
80102108:	e8 43 f6 ff ff       	call   80101750 <iunlock>
  iput(ip);
8010210d:	89 1c 24             	mov    %ebx,(%esp)
80102110:	e8 8b f6 ff ff       	call   801017a0 <iput>
80102115:	83 c4 10             	add    $0x10,%esp

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102118:	83 ec 0c             	sub    $0xc,%esp
8010211b:	56                   	push   %esi
8010211c:	e8 2f f6 ff ff       	call   80101750 <iunlock>
  iput(ip);
80102121:	89 34 24             	mov    %esi,(%esp)
80102124:	e8 77 f6 ff ff       	call   801017a0 <iput>

  return 0;

  bad:
    iunlockput(dp);
    end_op();
80102129:	e8 52 0e 00 00       	call   80102f80 <end_op>
    return -1;
8010212e:	83 c4 10             	add    $0x10,%esp

}
80102131:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

  bad:
    iunlockput(dp);
    end_op();
    return -1;
80102134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
80102139:	5b                   	pop    %ebx
8010213a:	5e                   	pop    %esi
8010213b:	5f                   	pop    %edi
8010213c:	5d                   	pop    %ebp
8010213d:	c3                   	ret    
8010213e:	66 90                	xchg   %ax,%ax

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80102140:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	56                   	push   %esi
80102149:	e8 72 f4 ff ff       	call   801015c0 <iupdate>
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	e9 59 ff ff ff       	jmp    801020af <removeSwapFile+0x10f>
80102156:	8d 76 00             	lea    0x0(%esi),%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
  {
    return -1;
80102160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102165:	e9 7d ff ff ff       	jmp    801020e7 <removeSwapFile+0x147>
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
  {
    end_op();
8010216a:	e8 11 0e 00 00       	call   80102f80 <end_op>
    return -1;
8010216f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102174:	e9 6e ff ff ff       	jmp    801020e7 <removeSwapFile+0x147>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80102179:	83 ec 0c             	sub    $0xc,%esp
8010217c:	68 91 7e 10 80       	push   $0x80107e91
80102181:	e8 ea e1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80102186:	83 ec 0c             	sub    $0xc,%esp
80102189:	68 7f 7e 10 80       	push   $0x80107e7f
8010218e:	e8 dd e1 ff ff       	call   80100370 <panic>
80102193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021a0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	56                   	push   %esi
801021a4:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801021a5:	8d 75 ea             	lea    -0x16(%ebp),%esi


//return 0 on success
int
createSwapFile(struct proc* p)
{
801021a8:	83 ec 14             	sub    $0x14,%esp
801021ab:	8b 5d 08             	mov    0x8(%ebp),%ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801021ae:	6a 06                	push   $0x6
801021b0:	68 75 7e 10 80       	push   $0x80107e75
801021b5:	56                   	push   %esi
801021b6:	e8 75 28 00 00       	call   80104a30 <memmove>
  itoa(p->pid, path+ 6);
801021bb:	58                   	pop    %eax
801021bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021bf:	5a                   	pop    %edx
801021c0:	50                   	push   %eax
801021c1:	ff 73 10             	pushl  0x10(%ebx)
801021c4:	e8 37 fd ff ff       	call   80101f00 <itoa>

    begin_op();
801021c9:	e8 42 0d 00 00       	call   80102f10 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801021ce:	6a 00                	push   $0x0
801021d0:	6a 00                	push   $0x0
801021d2:	6a 02                	push   $0x2
801021d4:	56                   	push   %esi
801021d5:	e8 c6 31 00 00       	call   801053a0 <create>
  iunlock(in);
801021da:	83 c4 14             	add    $0x14,%esp
  char path[DIGITS];
  memmove(path,"/.swap", 6);
  itoa(p->pid, path+ 6);

    begin_op();
    struct inode * in = create(path, T_FILE, 0, 0);
801021dd:	89 c6                	mov    %eax,%esi
  iunlock(in);
801021df:	50                   	push   %eax
801021e0:	e8 6b f5 ff ff       	call   80101750 <iunlock>

  p->swapFile = filealloc();
801021e5:	e8 86 eb ff ff       	call   80100d70 <filealloc>
  if (p->swapFile == 0)
801021ea:	83 c4 10             	add    $0x10,%esp
801021ed:	85 c0                	test   %eax,%eax

    begin_op();
    struct inode * in = create(path, T_FILE, 0, 0);
  iunlock(in);

  p->swapFile = filealloc();
801021ef:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801021f2:	74 32                	je     80102226 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801021f4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801021f7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801021fa:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102200:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102203:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010220a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010220d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102211:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102214:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102218:	e8 63 0d 00 00       	call   80102f80 <end_op>

    return 0;
}
8010221d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102220:	31 c0                	xor    %eax,%eax
80102222:	5b                   	pop    %ebx
80102223:	5e                   	pop    %esi
80102224:	5d                   	pop    %ebp
80102225:	c3                   	ret    
    struct inode * in = create(path, T_FILE, 0, 0);
  iunlock(in);

  p->swapFile = filealloc();
  if (p->swapFile == 0)
    panic("no slot for files on /store");
80102226:	83 ec 0c             	sub    $0xc,%esp
80102229:	68 a0 7e 10 80       	push   $0x80107ea0
8010222e:	e8 3d e1 ff ff       	call   80100370 <panic>
80102233:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102240 <writeToSwapFile>:
}

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
80102249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010224c:	8b 45 10             	mov    0x10(%ebp),%eax
8010224f:	8b 7d 14             	mov    0x14(%ebp),%edi
80102252:	8b 75 0c             	mov    0xc(%ebp),%esi
  p->swapFile->off = placeOnFile;
80102255:	8b 53 7c             	mov    0x7c(%ebx),%edx
80102258:	89 42 14             	mov    %eax,0x14(%edx)
  cprintf("writeToSwapFile: p=%s, buffer=%s, placeOnFile=%d, size= %d",p->name,buffer,placeOnFile,size);
8010225b:	57                   	push   %edi
8010225c:	50                   	push   %eax
8010225d:	8d 43 6c             	lea    0x6c(%ebx),%eax
80102260:	56                   	push   %esi
80102261:	50                   	push   %eax
80102262:	68 10 7f 10 80       	push   $0x80107f10
80102267:	e8 f4 e3 ff ff       	call   80100660 <cprintf>
  return filewrite(p->swapFile, buffer, size);
8010226c:	89 7d 10             	mov    %edi,0x10(%ebp)
8010226f:	89 75 0c             	mov    %esi,0xc(%ebp)
80102272:	83 c4 20             	add    $0x20,%esp
80102275:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102278:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010227b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227e:	5b                   	pop    %ebx
8010227f:	5e                   	pop    %esi
80102280:	5f                   	pop    %edi
80102281:	5d                   	pop    %ebp
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;
  cprintf("writeToSwapFile: p=%s, buffer=%s, placeOnFile=%d, size= %d",p->name,buffer,placeOnFile,size);
  return filewrite(p->swapFile, buffer, size);
80102282:	e9 59 ed ff ff       	jmp    80100fe0 <filewrite>
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <readFromSwapFile>:
}

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102299:	8b 50 7c             	mov    0x7c(%eax),%edx
8010229c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010229f:	8b 55 14             	mov    0x14(%ebp),%edx
801022a2:	89 55 10             	mov    %edx,0x10(%ebp)
801022a5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022a8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022ab:	5d                   	pop    %ebp
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return fileread(p->swapFile, buffer,  size);
801022ac:	e9 9f ec ff ff       	jmp    80100f50 <fileread>
801022b1:	66 90                	xchg   %ax,%ax
801022b3:	66 90                	xchg   %ax,%ax
801022b5:	66 90                	xchg   %ax,%ax
801022b7:	66 90                	xchg   %ax,%ax
801022b9:	66 90                	xchg   %ax,%ax
801022bb:	66 90                	xchg   %ax,%ax
801022bd:	66 90                	xchg   %ax,%ax
801022bf:	90                   	nop

801022c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022c0:	55                   	push   %ebp
  if(b == 0)
801022c1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022c3:	89 e5                	mov    %esp,%ebp
801022c5:	56                   	push   %esi
801022c6:	53                   	push   %ebx
  if(b == 0)
801022c7:	0f 84 ad 00 00 00    	je     8010237a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022cd:	8b 58 08             	mov    0x8(%eax),%ebx
801022d0:	89 c1                	mov    %eax,%ecx
801022d2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022d8:	0f 87 8f 00 00 00    	ja     8010236d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022de:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022e3:	90                   	nop
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e9:	83 e0 c0             	and    $0xffffffc0,%eax
801022ec:	3c 40                	cmp    $0x40,%al
801022ee:	75 f8                	jne    801022e8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022f0:	31 f6                	xor    %esi,%esi
801022f2:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022f7:	89 f0                	mov    %esi,%eax
801022f9:	ee                   	out    %al,(%dx)
801022fa:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022ff:	b8 01 00 00 00       	mov    $0x1,%eax
80102304:	ee                   	out    %al,(%dx)
80102305:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010230a:	89 d8                	mov    %ebx,%eax
8010230c:	ee                   	out    %al,(%dx)
8010230d:	89 d8                	mov    %ebx,%eax
8010230f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102314:	c1 f8 08             	sar    $0x8,%eax
80102317:	ee                   	out    %al,(%dx)
80102318:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010231d:	89 f0                	mov    %esi,%eax
8010231f:	ee                   	out    %al,(%dx)
80102320:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102324:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102329:	83 e0 01             	and    $0x1,%eax
8010232c:	c1 e0 04             	shl    $0x4,%eax
8010232f:	83 c8 e0             	or     $0xffffffe0,%eax
80102332:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102333:	f6 01 04             	testb  $0x4,(%ecx)
80102336:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010233b:	75 13                	jne    80102350 <idestart+0x90>
8010233d:	b8 20 00 00 00       	mov    $0x20,%eax
80102342:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102343:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102346:	5b                   	pop    %ebx
80102347:	5e                   	pop    %esi
80102348:	5d                   	pop    %ebp
80102349:	c3                   	ret    
8010234a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102350:	b8 30 00 00 00       	mov    $0x30,%eax
80102355:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102356:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010235b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010235e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102363:	fc                   	cld    
80102364:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102366:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102369:	5b                   	pop    %ebx
8010236a:	5e                   	pop    %esi
8010236b:	5d                   	pop    %ebp
8010236c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010236d:	83 ec 0c             	sub    $0xc,%esp
80102370:	68 54 7f 10 80       	push   $0x80107f54
80102375:	e8 f6 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010237a:	83 ec 0c             	sub    $0xc,%esp
8010237d:	68 4b 7f 10 80       	push   $0x80107f4b
80102382:	e8 e9 df ff ff       	call   80100370 <panic>
80102387:	89 f6                	mov    %esi,%esi
80102389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102390 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102396:	68 66 7f 10 80       	push   $0x80107f66
8010239b:	68 80 b5 10 80       	push   $0x8010b580
801023a0:	e8 6b 23 00 00       	call   80104710 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023a5:	58                   	pop    %eax
801023a6:	a1 00 3d 11 80       	mov    0x80113d00,%eax
801023ab:	5a                   	pop    %edx
801023ac:	83 e8 01             	sub    $0x1,%eax
801023af:	50                   	push   %eax
801023b0:	6a 0e                	push   $0xe
801023b2:	e8 a9 02 00 00       	call   80102660 <ioapicenable>
801023b7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ba:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023bf:	90                   	nop
801023c0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023c1:	83 e0 c0             	and    $0xffffffc0,%eax
801023c4:	3c 40                	cmp    $0x40,%al
801023c6:	75 f8                	jne    801023c0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023c8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023cd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023d2:	ee                   	out    %al,(%dx)
801023d3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023dd:	eb 06                	jmp    801023e5 <ideinit+0x55>
801023df:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801023e0:	83 e9 01             	sub    $0x1,%ecx
801023e3:	74 0f                	je     801023f4 <ideinit+0x64>
801023e5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023e6:	84 c0                	test   %al,%al
801023e8:	74 f6                	je     801023e0 <ideinit+0x50>
      havedisk1 = 1;
801023ea:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801023f1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023f4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023f9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023fe:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801023ff:	c9                   	leave  
80102400:	c3                   	ret    
80102401:	eb 0d                	jmp    80102410 <ideintr>
80102403:	90                   	nop
80102404:	90                   	nop
80102405:	90                   	nop
80102406:	90                   	nop
80102407:	90                   	nop
80102408:	90                   	nop
80102409:	90                   	nop
8010240a:	90                   	nop
8010240b:	90                   	nop
8010240c:	90                   	nop
8010240d:	90                   	nop
8010240e:	90                   	nop
8010240f:	90                   	nop

80102410 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	57                   	push   %edi
80102414:	56                   	push   %esi
80102415:	53                   	push   %ebx
80102416:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102419:	68 80 b5 10 80       	push   $0x8010b580
8010241e:	e8 ed 23 00 00       	call   80104810 <acquire>

  if((b = idequeue) == 0){
80102423:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102429:	83 c4 10             	add    $0x10,%esp
8010242c:	85 db                	test   %ebx,%ebx
8010242e:	74 34                	je     80102464 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102430:	8b 43 58             	mov    0x58(%ebx),%eax
80102433:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102438:	8b 33                	mov    (%ebx),%esi
8010243a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102440:	74 3e                	je     80102480 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102442:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102445:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102448:	83 ce 02             	or     $0x2,%esi
8010244b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010244d:	53                   	push   %ebx
8010244e:	e8 ed 1e 00 00       	call   80104340 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102453:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102458:	83 c4 10             	add    $0x10,%esp
8010245b:	85 c0                	test   %eax,%eax
8010245d:	74 05                	je     80102464 <ideintr+0x54>
    idestart(idequeue);
8010245f:	e8 5c fe ff ff       	call   801022c0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102464:	83 ec 0c             	sub    $0xc,%esp
80102467:	68 80 b5 10 80       	push   $0x8010b580
8010246c:	e8 bf 24 00 00       	call   80104930 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102474:	5b                   	pop    %ebx
80102475:	5e                   	pop    %esi
80102476:	5f                   	pop    %edi
80102477:	5d                   	pop    %ebp
80102478:	c3                   	ret    
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102480:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102485:	8d 76 00             	lea    0x0(%esi),%esi
80102488:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102489:	89 c1                	mov    %eax,%ecx
8010248b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010248e:	80 f9 40             	cmp    $0x40,%cl
80102491:	75 f5                	jne    80102488 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102493:	a8 21                	test   $0x21,%al
80102495:	75 ab                	jne    80102442 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102497:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010249a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010249f:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024a4:	fc                   	cld    
801024a5:	f3 6d                	rep insl (%dx),%es:(%edi)
801024a7:	8b 33                	mov    (%ebx),%esi
801024a9:	eb 97                	jmp    80102442 <ideintr+0x32>
801024ab:	90                   	nop
801024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 10             	sub    $0x10,%esp
801024b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801024bd:	50                   	push   %eax
801024be:	e8 1d 22 00 00       	call   801046e0 <holdingsleep>
801024c3:	83 c4 10             	add    $0x10,%esp
801024c6:	85 c0                	test   %eax,%eax
801024c8:	0f 84 ad 00 00 00    	je     8010257b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024ce:	8b 03                	mov    (%ebx),%eax
801024d0:	83 e0 06             	and    $0x6,%eax
801024d3:	83 f8 02             	cmp    $0x2,%eax
801024d6:	0f 84 b9 00 00 00    	je     80102595 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024dc:	8b 53 04             	mov    0x4(%ebx),%edx
801024df:	85 d2                	test   %edx,%edx
801024e1:	74 0d                	je     801024f0 <iderw+0x40>
801024e3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801024e8:	85 c0                	test   %eax,%eax
801024ea:	0f 84 98 00 00 00    	je     80102588 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	68 80 b5 10 80       	push   $0x8010b580
801024f8:	e8 13 23 00 00       	call   80104810 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024fd:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102503:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102506:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	85 d2                	test   %edx,%edx
8010250f:	75 09                	jne    8010251a <iderw+0x6a>
80102511:	eb 58                	jmp    8010256b <iderw+0xbb>
80102513:	90                   	nop
80102514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102518:	89 c2                	mov    %eax,%edx
8010251a:	8b 42 58             	mov    0x58(%edx),%eax
8010251d:	85 c0                	test   %eax,%eax
8010251f:	75 f7                	jne    80102518 <iderw+0x68>
80102521:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102524:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102526:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010252c:	74 44                	je     80102572 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 e0 06             	and    $0x6,%eax
80102533:	83 f8 02             	cmp    $0x2,%eax
80102536:	74 23                	je     8010255b <iderw+0xab>
80102538:	90                   	nop
80102539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102540:	83 ec 08             	sub    $0x8,%esp
80102543:	68 80 b5 10 80       	push   $0x8010b580
80102548:	53                   	push   %ebx
80102549:	e8 32 1c 00 00       	call   80104180 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010254e:	8b 03                	mov    (%ebx),%eax
80102550:	83 c4 10             	add    $0x10,%esp
80102553:	83 e0 06             	and    $0x6,%eax
80102556:	83 f8 02             	cmp    $0x2,%eax
80102559:	75 e5                	jne    80102540 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010255b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102565:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102566:	e9 c5 23 00 00       	jmp    80104930 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010256b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102570:	eb b2                	jmp    80102524 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102572:	89 d8                	mov    %ebx,%eax
80102574:	e8 47 fd ff ff       	call   801022c0 <idestart>
80102579:	eb b3                	jmp    8010252e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010257b:	83 ec 0c             	sub    $0xc,%esp
8010257e:	68 6a 7f 10 80       	push   $0x80107f6a
80102583:	e8 e8 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	68 95 7f 10 80       	push   $0x80107f95
80102590:	e8 db dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102595:	83 ec 0c             	sub    $0xc,%esp
80102598:	68 80 7f 10 80       	push   $0x80107f80
8010259d:	e8 ce dd ff ff       	call   80100370 <panic>
801025a2:	66 90                	xchg   %ax,%ax
801025a4:	66 90                	xchg   %ax,%ax
801025a6:	66 90                	xchg   %ax,%ax
801025a8:	66 90                	xchg   %ax,%ax
801025aa:	66 90                	xchg   %ax,%ax
801025ac:	66 90                	xchg   %ax,%ax
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025b0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025b1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801025b8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025bb:	89 e5                	mov    %esp,%ebp
801025bd:	56                   	push   %esi
801025be:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025c6:	00 00 00 
  return ioapic->data;
801025c9:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801025cf:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801025d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025d8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025de:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025e5:	89 f0                	mov    %esi,%eax
801025e7:	c1 e8 10             	shr    $0x10,%eax
801025ea:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801025ed:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025f0:	c1 e8 18             	shr    $0x18,%eax
801025f3:	39 d0                	cmp    %edx,%eax
801025f5:	74 16                	je     8010260d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025f7:	83 ec 0c             	sub    $0xc,%esp
801025fa:	68 b4 7f 10 80       	push   $0x80107fb4
801025ff:	e8 5c e0 ff ff       	call   80100660 <cprintf>
80102604:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010260a:	83 c4 10             	add    $0x10,%esp
8010260d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102610:	ba 10 00 00 00       	mov    $0x10,%edx
80102615:	b8 20 00 00 00       	mov    $0x20,%eax
8010261a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102620:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102622:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102628:	89 c3                	mov    %eax,%ebx
8010262a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102630:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102633:	89 59 10             	mov    %ebx,0x10(%ecx)
80102636:	8d 5a 01             	lea    0x1(%edx),%ebx
80102639:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010263c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010263e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102640:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102646:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010264d:	75 d1                	jne    80102620 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010264f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102652:	5b                   	pop    %ebx
80102653:	5e                   	pop    %esi
80102654:	5d                   	pop    %ebp
80102655:	c3                   	ret    
80102656:	8d 76 00             	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102660:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102661:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102667:	89 e5                	mov    %esp,%ebp
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010266c:	8d 50 20             	lea    0x20(%eax),%edx
8010266f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102673:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102675:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010267b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010267e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102681:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102684:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102686:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010268e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	66 90                	xchg   %ax,%ax
80102695:	66 90                	xchg   %ax,%ax
80102697:	66 90                	xchg   %ax,%ax
80102699:	66 90                	xchg   %ax,%ax
8010269b:	66 90                	xchg   %ax,%ax
8010269d:	66 90                	xchg   %ax,%ax
8010269f:	90                   	nop

801026a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	53                   	push   %ebx
801026a4:	83 ec 04             	sub    $0x4,%esp
801026a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026b0:	75 70                	jne    80102722 <kfree+0x82>
801026b2:	81 fb a8 db 11 80    	cmp    $0x8011dba8,%ebx
801026b8:	72 68                	jb     80102722 <kfree+0x82>
801026ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026c5:	77 5b                	ja     80102722 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026c7:	83 ec 04             	sub    $0x4,%esp
801026ca:	68 00 10 00 00       	push   $0x1000
801026cf:	6a 01                	push   $0x1
801026d1:	53                   	push   %ebx
801026d2:	e8 a9 22 00 00       	call   80104980 <memset>

  if(kmem.use_lock)
801026d7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801026dd:	83 c4 10             	add    $0x10,%esp
801026e0:	85 d2                	test   %edx,%edx
801026e2:	75 2c                	jne    80102710 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026e4:	a1 78 36 11 80       	mov    0x80113678,%eax
801026e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026eb:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801026f0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801026f6:	85 c0                	test   %eax,%eax
801026f8:	75 06                	jne    80102700 <kfree+0x60>
    release(&kmem.lock);
}
801026fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026fd:	c9                   	leave  
801026fe:	c3                   	ret    
801026ff:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102700:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010270a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010270b:	e9 20 22 00 00       	jmp    80104930 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102710:	83 ec 0c             	sub    $0xc,%esp
80102713:	68 40 36 11 80       	push   $0x80113640
80102718:	e8 f3 20 00 00       	call   80104810 <acquire>
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	eb c2                	jmp    801026e4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102722:	83 ec 0c             	sub    $0xc,%esp
80102725:	68 e6 7f 10 80       	push   $0x80107fe6
8010272a:	e8 41 dc ff ff       	call   80100370 <panic>
8010272f:	90                   	nop

80102730 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	56                   	push   %esi
80102734:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102735:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102738:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010273b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102741:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102747:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010274d:	39 de                	cmp    %ebx,%esi
8010274f:	72 23                	jb     80102774 <freerange+0x44>
80102751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102758:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010275e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102761:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102767:	50                   	push   %eax
80102768:	e8 33 ff ff ff       	call   801026a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	39 f3                	cmp    %esi,%ebx
80102772:	76 e4                	jbe    80102758 <freerange+0x28>
    kfree(p);
}
80102774:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102777:	5b                   	pop    %ebx
80102778:	5e                   	pop    %esi
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	56                   	push   %esi
80102784:	53                   	push   %ebx
80102785:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102788:	83 ec 08             	sub    $0x8,%esp
8010278b:	68 ec 7f 10 80       	push   $0x80107fec
80102790:	68 40 36 11 80       	push   $0x80113640
80102795:	e8 76 1f 00 00       	call   80104710 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010279a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010279d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801027a0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801027a7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027aa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027bc:	39 de                	cmp    %ebx,%esi
801027be:	72 1c                	jb     801027dc <kinit1+0x5c>
    kfree(p);
801027c0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027c6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027cf:	50                   	push   %eax
801027d0:	e8 cb fe ff ff       	call   801026a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d5:	83 c4 10             	add    $0x10,%esp
801027d8:	39 de                	cmp    %ebx,%esi
801027da:	73 e4                	jae    801027c0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801027dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027df:	5b                   	pop    %ebx
801027e0:	5e                   	pop    %esi
801027e1:	5d                   	pop    %ebp
801027e2:	c3                   	ret    
801027e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801027f8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102801:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102807:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010280d:	39 de                	cmp    %ebx,%esi
8010280f:	72 23                	jb     80102834 <kinit2+0x44>
80102811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102818:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010281e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102821:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102827:	50                   	push   %eax
80102828:	e8 73 fe ff ff       	call   801026a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010282d:	83 c4 10             	add    $0x10,%esp
80102830:	39 de                	cmp    %ebx,%esi
80102832:	73 e4                	jae    80102818 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102834:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010283b:	00 00 00 
}
8010283e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102841:	5b                   	pop    %ebx
80102842:	5e                   	pop    %esi
80102843:	5d                   	pop    %ebp
80102844:	c3                   	ret    
80102845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102850 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	53                   	push   %ebx
80102854:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102857:	a1 74 36 11 80       	mov    0x80113674,%eax
8010285c:	85 c0                	test   %eax,%eax
8010285e:	75 30                	jne    80102890 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102860:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102866:	85 db                	test   %ebx,%ebx
80102868:	74 1c                	je     80102886 <kalloc+0x36>
    kmem.freelist = r->next;
8010286a:	8b 13                	mov    (%ebx),%edx
8010286c:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
80102872:	85 c0                	test   %eax,%eax
80102874:	74 10                	je     80102886 <kalloc+0x36>
    release(&kmem.lock);
80102876:	83 ec 0c             	sub    $0xc,%esp
80102879:	68 40 36 11 80       	push   $0x80113640
8010287e:	e8 ad 20 00 00       	call   80104930 <release>
80102883:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102886:	89 d8                	mov    %ebx,%eax
80102888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288b:	c9                   	leave  
8010288c:	c3                   	ret    
8010288d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102890:	83 ec 0c             	sub    $0xc,%esp
80102893:	68 40 36 11 80       	push   $0x80113640
80102898:	e8 73 1f 00 00       	call   80104810 <acquire>
  r = kmem.freelist;
8010289d:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801028a3:	83 c4 10             	add    $0x10,%esp
801028a6:	a1 74 36 11 80       	mov    0x80113674,%eax
801028ab:	85 db                	test   %ebx,%ebx
801028ad:	75 bb                	jne    8010286a <kalloc+0x1a>
801028af:	eb c1                	jmp    80102872 <kalloc+0x22>
801028b1:	66 90                	xchg   %ax,%ax
801028b3:	66 90                	xchg   %ax,%ax
801028b5:	66 90                	xchg   %ax,%ax
801028b7:	66 90                	xchg   %ax,%ax
801028b9:	66 90                	xchg   %ax,%ax
801028bb:	66 90                	xchg   %ax,%ax
801028bd:	66 90                	xchg   %ax,%ax
801028bf:	90                   	nop

801028c0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801028c0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c1:	ba 64 00 00 00       	mov    $0x64,%edx
801028c6:	89 e5                	mov    %esp,%ebp
801028c8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028c9:	a8 01                	test   $0x1,%al
801028cb:	0f 84 af 00 00 00    	je     80102980 <kbdgetc+0xc0>
801028d1:	ba 60 00 00 00       	mov    $0x60,%edx
801028d6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028d7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801028da:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028e0:	74 7e                	je     80102960 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028e2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028e4:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801028ea:	79 24                	jns    80102910 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028ec:	f6 c1 40             	test   $0x40,%cl
801028ef:	75 05                	jne    801028f6 <kbdgetc+0x36>
801028f1:	89 c2                	mov    %eax,%edx
801028f3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801028f6:	0f b6 82 20 81 10 80 	movzbl -0x7fef7ee0(%edx),%eax
801028fd:	83 c8 40             	or     $0x40,%eax
80102900:	0f b6 c0             	movzbl %al,%eax
80102903:	f7 d0                	not    %eax
80102905:	21 c8                	and    %ecx,%eax
80102907:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010290c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010290e:	5d                   	pop    %ebp
8010290f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102910:	f6 c1 40             	test   $0x40,%cl
80102913:	74 09                	je     8010291e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102915:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102918:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010291b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010291e:	0f b6 82 20 81 10 80 	movzbl -0x7fef7ee0(%edx),%eax
80102925:	09 c1                	or     %eax,%ecx
80102927:	0f b6 82 20 80 10 80 	movzbl -0x7fef7fe0(%edx),%eax
8010292e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102930:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102932:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102938:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010293b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010293e:	8b 04 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%eax
80102945:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102949:	74 c3                	je     8010290e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010294b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010294e:	83 fa 19             	cmp    $0x19,%edx
80102951:	77 1d                	ja     80102970 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102953:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
80102958:	90                   	nop
80102959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102960:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102962:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102969:	5d                   	pop    %ebp
8010296a:	c3                   	ret    
8010296b:	90                   	nop
8010296c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102970:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102973:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102976:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102977:	83 f9 19             	cmp    $0x19,%ecx
8010297a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010297d:	c3                   	ret    
8010297e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102985:	5d                   	pop    %ebp
80102986:	c3                   	ret    
80102987:	89 f6                	mov    %esi,%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102990 <kbdintr>:

void
kbdintr(void)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102996:	68 c0 28 10 80       	push   $0x801028c0
8010299b:	e8 50 de ff ff       	call   801007f0 <consoleintr>
}
801029a0:	83 c4 10             	add    $0x10,%esp
801029a3:	c9                   	leave  
801029a4:	c3                   	ret    
801029a5:	66 90                	xchg   %ax,%ax
801029a7:	66 90                	xchg   %ax,%ax
801029a9:	66 90                	xchg   %ax,%ax
801029ab:	66 90                	xchg   %ax,%ax
801029ad:	66 90                	xchg   %ax,%ax
801029af:	90                   	nop

801029b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029b0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801029b5:	55                   	push   %ebp
801029b6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029b8:	85 c0                	test   %eax,%eax
801029ba:	0f 84 c8 00 00 00    	je     80102a88 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ca:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029cd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029da:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029e1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029e4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029e7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029ee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029f1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029f4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029fb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029fe:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a01:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a08:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a0e:	8b 50 30             	mov    0x30(%eax),%edx
80102a11:	c1 ea 10             	shr    $0x10,%edx
80102a14:	80 fa 03             	cmp    $0x3,%dl
80102a17:	77 77                	ja     80102a90 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a19:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a20:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a23:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a26:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a2d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a30:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a33:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a3a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a3d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a40:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a47:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a4d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a5a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a61:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a64:	8b 50 20             	mov    0x20(%eax),%edx
80102a67:	89 f6                	mov    %esi,%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a70:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a76:	80 e6 10             	and    $0x10,%dh
80102a79:	75 f5                	jne    80102a70 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a7b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a82:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a85:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a88:	5d                   	pop    %ebp
80102a89:	c3                   	ret    
80102a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a90:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a97:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9a:	8b 50 20             	mov    0x20(%eax),%edx
80102a9d:	e9 77 ff ff ff       	jmp    80102a19 <lapicinit+0x69>
80102aa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102ab0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102ab5:	55                   	push   %ebp
80102ab6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102ab8:	85 c0                	test   %eax,%eax
80102aba:	74 0c                	je     80102ac8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102abc:	8b 40 20             	mov    0x20(%eax),%eax
}
80102abf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102ac0:	c1 e8 18             	shr    $0x18,%eax
}
80102ac3:	c3                   	ret    
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102ac8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102aca:	5d                   	pop    %ebp
80102acb:	c3                   	ret    
80102acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ad0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ad5:	55                   	push   %ebp
80102ad6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ad8:	85 c0                	test   %eax,%eax
80102ada:	74 0d                	je     80102ae9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102adc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ae3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102ae9:	5d                   	pop    %ebp
80102aea:	c3                   	ret    
80102aeb:	90                   	nop
80102aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102af0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
}
80102af3:	5d                   	pop    %ebp
80102af4:	c3                   	ret    
80102af5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b00 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b00:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b01:	ba 70 00 00 00       	mov    $0x70,%edx
80102b06:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b0b:	89 e5                	mov    %esp,%ebp
80102b0d:	53                   	push   %ebx
80102b0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b11:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b14:	ee                   	out    %al,(%dx)
80102b15:	ba 71 00 00 00       	mov    $0x71,%edx
80102b1a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b1f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b20:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b22:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b25:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b2b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b2d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b30:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b33:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b35:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102b38:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b3e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102b43:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b49:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b4c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b53:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b56:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b59:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b60:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b63:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b66:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b6c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b6f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b75:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b78:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b7e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b81:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b87:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102b8a:	5b                   	pop    %ebx
80102b8b:	5d                   	pop    %ebp
80102b8c:	c3                   	ret    
80102b8d:	8d 76 00             	lea    0x0(%esi),%esi

80102b90 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102b90:	55                   	push   %ebp
80102b91:	ba 70 00 00 00       	mov    $0x70,%edx
80102b96:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b9b:	89 e5                	mov    %esp,%ebp
80102b9d:	57                   	push   %edi
80102b9e:	56                   	push   %esi
80102b9f:	53                   	push   %ebx
80102ba0:	83 ec 4c             	sub    $0x4c,%esp
80102ba3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ba9:	ec                   	in     (%dx),%al
80102baa:	83 e0 04             	and    $0x4,%eax
80102bad:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb0:	31 db                	xor    %ebx,%ebx
80102bb2:	88 45 b7             	mov    %al,-0x49(%ebp)
80102bb5:	bf 70 00 00 00       	mov    $0x70,%edi
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bc0:	89 d8                	mov    %ebx,%eax
80102bc2:	89 fa                	mov    %edi,%edx
80102bc4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102bca:	89 ca                	mov    %ecx,%edx
80102bcc:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102bcd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd0:	89 fa                	mov    %edi,%edx
80102bd2:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102bd5:	b8 02 00 00 00       	mov    $0x2,%eax
80102bda:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdb:	89 ca                	mov    %ecx,%edx
80102bdd:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102bde:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be1:	89 fa                	mov    %edi,%edx
80102be3:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102be6:	b8 04 00 00 00       	mov    $0x4,%eax
80102beb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bec:	89 ca                	mov    %ecx,%edx
80102bee:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102bef:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf2:	89 fa                	mov    %edi,%edx
80102bf4:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bf7:	b8 07 00 00 00       	mov    $0x7,%eax
80102bfc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfd:	89 ca                	mov    %ecx,%edx
80102bff:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c00:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c03:	89 fa                	mov    %edi,%edx
80102c05:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c08:	b8 08 00 00 00       	mov    $0x8,%eax
80102c0d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0e:	89 ca                	mov    %ecx,%edx
80102c10:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c11:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c14:	89 fa                	mov    %edi,%edx
80102c16:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102c19:	b8 09 00 00 00       	mov    $0x9,%eax
80102c1e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1f:	89 ca                	mov    %ecx,%edx
80102c21:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c22:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c25:	89 fa                	mov    %edi,%edx
80102c27:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102c2a:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c2f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c30:	89 ca                	mov    %ecx,%edx
80102c32:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c33:	84 c0                	test   %al,%al
80102c35:	78 89                	js     80102bc0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c37:	89 d8                	mov    %ebx,%eax
80102c39:	89 fa                	mov    %edi,%edx
80102c3b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3c:	89 ca                	mov    %ecx,%edx
80102c3e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c3f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c42:	89 fa                	mov    %edi,%edx
80102c44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c47:	b8 02 00 00 00       	mov    $0x2,%eax
80102c4c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c4d:	89 ca                	mov    %ecx,%edx
80102c4f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c50:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c53:	89 fa                	mov    %edi,%edx
80102c55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c58:	b8 04 00 00 00       	mov    $0x4,%eax
80102c5d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5e:	89 ca                	mov    %ecx,%edx
80102c60:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c61:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	89 fa                	mov    %edi,%edx
80102c66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c69:	b8 07 00 00 00       	mov    $0x7,%eax
80102c6e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6f:	89 ca                	mov    %ecx,%edx
80102c71:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102c72:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c75:	89 fa                	mov    %edi,%edx
80102c77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c7f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c80:	89 ca                	mov    %ecx,%edx
80102c82:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102c83:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c86:	89 fa                	mov    %edi,%edx
80102c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c90:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c91:	89 ca                	mov    %ecx,%edx
80102c93:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102c94:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c97:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c9d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ca0:	6a 18                	push   $0x18
80102ca2:	56                   	push   %esi
80102ca3:	50                   	push   %eax
80102ca4:	e8 27 1d 00 00       	call   801049d0 <memcmp>
80102ca9:	83 c4 10             	add    $0x10,%esp
80102cac:	85 c0                	test   %eax,%eax
80102cae:	0f 85 0c ff ff ff    	jne    80102bc0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102cb4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102cb8:	75 78                	jne    80102d32 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102cba:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cbd:	89 c2                	mov    %eax,%edx
80102cbf:	83 e0 0f             	and    $0xf,%eax
80102cc2:	c1 ea 04             	shr    $0x4,%edx
80102cc5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cc8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ccb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102cce:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cd1:	89 c2                	mov    %eax,%edx
80102cd3:	83 e0 0f             	and    $0xf,%eax
80102cd6:	c1 ea 04             	shr    $0x4,%edx
80102cd9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cdc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cdf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102ce2:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ce5:	89 c2                	mov    %eax,%edx
80102ce7:	83 e0 0f             	and    $0xf,%eax
80102cea:	c1 ea 04             	shr    $0x4,%edx
80102ced:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cf0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cf3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cf6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cf9:	89 c2                	mov    %eax,%edx
80102cfb:	83 e0 0f             	and    $0xf,%eax
80102cfe:	c1 ea 04             	shr    $0x4,%edx
80102d01:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d04:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d07:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d0a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d0d:	89 c2                	mov    %eax,%edx
80102d0f:	83 e0 0f             	and    $0xf,%eax
80102d12:	c1 ea 04             	shr    $0x4,%edx
80102d15:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d18:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d1b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d1e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d21:	89 c2                	mov    %eax,%edx
80102d23:	83 e0 0f             	and    $0xf,%eax
80102d26:	c1 ea 04             	shr    $0x4,%edx
80102d29:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d2c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d2f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d32:	8b 75 08             	mov    0x8(%ebp),%esi
80102d35:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d38:	89 06                	mov    %eax,(%esi)
80102d3a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d3d:	89 46 04             	mov    %eax,0x4(%esi)
80102d40:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d43:	89 46 08             	mov    %eax,0x8(%esi)
80102d46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d49:	89 46 0c             	mov    %eax,0xc(%esi)
80102d4c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d4f:	89 46 10             	mov    %eax,0x10(%esi)
80102d52:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d55:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d58:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d62:	5b                   	pop    %ebx
80102d63:	5e                   	pop    %esi
80102d64:	5f                   	pop    %edi
80102d65:	5d                   	pop    %ebp
80102d66:	c3                   	ret    
80102d67:	66 90                	xchg   %ax,%ax
80102d69:	66 90                	xchg   %ax,%ax
80102d6b:	66 90                	xchg   %ax,%ax
80102d6d:	66 90                	xchg   %ax,%ax
80102d6f:	90                   	nop

80102d70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d70:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102d76:	85 c9                	test   %ecx,%ecx
80102d78:	0f 8e 85 00 00 00    	jle    80102e03 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102d7e:	55                   	push   %ebp
80102d7f:	89 e5                	mov    %esp,%ebp
80102d81:	57                   	push   %edi
80102d82:	56                   	push   %esi
80102d83:	53                   	push   %ebx
80102d84:	31 db                	xor    %ebx,%ebx
80102d86:	83 ec 0c             	sub    $0xc,%esp
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d90:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102d95:	83 ec 08             	sub    $0x8,%esp
80102d98:	01 d8                	add    %ebx,%eax
80102d9a:	83 c0 01             	add    $0x1,%eax
80102d9d:	50                   	push   %eax
80102d9e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102da4:	e8 27 d3 ff ff       	call   801000d0 <bread>
80102da9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dab:	58                   	pop    %eax
80102dac:	5a                   	pop    %edx
80102dad:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102db4:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dba:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102dbd:	e8 0e d3 ff ff       	call   801000d0 <bread>
80102dc2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102dc4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102dc7:	83 c4 0c             	add    $0xc,%esp
80102dca:	68 00 02 00 00       	push   $0x200
80102dcf:	50                   	push   %eax
80102dd0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dd3:	50                   	push   %eax
80102dd4:	e8 57 1c 00 00       	call   80104a30 <memmove>
    bwrite(dbuf);  // write dst to disk
80102dd9:	89 34 24             	mov    %esi,(%esp)
80102ddc:	e8 bf d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102de1:	89 3c 24             	mov    %edi,(%esp)
80102de4:	e8 f7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102de9:	89 34 24             	mov    %esi,(%esp)
80102dec:	e8 ef d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102dfa:	7f 94                	jg     80102d90 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dff:	5b                   	pop    %ebx
80102e00:	5e                   	pop    %esi
80102e01:	5f                   	pop    %edi
80102e02:	5d                   	pop    %ebp
80102e03:	f3 c3                	repz ret 
80102e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	53                   	push   %ebx
80102e14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e17:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102e1d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e23:	e8 a8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e28:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e2e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e31:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e33:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e35:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e38:	7e 1f                	jle    80102e59 <write_head+0x49>
80102e3a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102e41:	31 d2                	xor    %edx,%edx
80102e43:	90                   	nop
80102e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e48:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102e4e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102e52:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102e55:	39 c2                	cmp    %eax,%edx
80102e57:	75 ef                	jne    80102e48 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102e59:	83 ec 0c             	sub    $0xc,%esp
80102e5c:	53                   	push   %ebx
80102e5d:	e8 3e d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e62:	89 1c 24             	mov    %ebx,(%esp)
80102e65:	e8 76 d3 ff ff       	call   801001e0 <brelse>
}
80102e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e6d:	c9                   	leave  
80102e6e:	c3                   	ret    
80102e6f:	90                   	nop

80102e70 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 2c             	sub    $0x2c,%esp
80102e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102e7a:	68 20 82 10 80       	push   $0x80108220
80102e7f:	68 80 36 11 80       	push   $0x80113680
80102e84:	e8 87 18 00 00       	call   80104710 <initlock>
  readsb(dev, &sb);
80102e89:	58                   	pop    %eax
80102e8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e8d:	5a                   	pop    %edx
80102e8e:	50                   	push   %eax
80102e8f:	53                   	push   %ebx
80102e90:	e8 1b e5 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102e95:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102e98:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102e9b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102e9c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ea2:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ea8:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ead:	5a                   	pop    %edx
80102eae:	50                   	push   %eax
80102eaf:	53                   	push   %ebx
80102eb0:	e8 1b d2 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102eb5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102eb8:	83 c4 10             	add    $0x10,%esp
80102ebb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ebd:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ec3:	7e 1c                	jle    80102ee1 <initlog+0x71>
80102ec5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102ecc:	31 d2                	xor    %edx,%edx
80102ece:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ed0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ed4:	83 c2 04             	add    $0x4,%edx
80102ed7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102edd:	39 da                	cmp    %ebx,%edx
80102edf:	75 ef                	jne    80102ed0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ee1:	83 ec 0c             	sub    $0xc,%esp
80102ee4:	50                   	push   %eax
80102ee5:	e8 f6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102eea:	e8 81 fe ff ff       	call   80102d70 <install_trans>
  log.lh.n = 0;
80102eef:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ef6:	00 00 00 
  write_head(); // clear the log
80102ef9:	e8 12 ff ff ff       	call   80102e10 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f01:	c9                   	leave  
80102f02:	c3                   	ret    
80102f03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f16:	68 80 36 11 80       	push   $0x80113680
80102f1b:	e8 f0 18 00 00       	call   80104810 <acquire>
80102f20:	83 c4 10             	add    $0x10,%esp
80102f23:	eb 18                	jmp    80102f3d <begin_op+0x2d>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f28:	83 ec 08             	sub    $0x8,%esp
80102f2b:	68 80 36 11 80       	push   $0x80113680
80102f30:	68 80 36 11 80       	push   $0x80113680
80102f35:	e8 46 12 00 00       	call   80104180 <sleep>
80102f3a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102f3d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	75 e2                	jne    80102f28 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f46:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f4b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f51:	83 c0 01             	add    $0x1,%eax
80102f54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f5a:	83 fa 1e             	cmp    $0x1e,%edx
80102f5d:	7f c9                	jg     80102f28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f5f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102f62:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102f67:	68 80 36 11 80       	push   $0x80113680
80102f6c:	e8 bf 19 00 00       	call   80104930 <release>
      break;
    }
  }
}
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	c9                   	leave  
80102f75:	c3                   	ret    
80102f76:	8d 76 00             	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f89:	68 80 36 11 80       	push   $0x80113680
80102f8e:	e8 7d 18 00 00       	call   80104810 <acquire>
  log.outstanding -= 1;
80102f93:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102f98:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102f9e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102fa1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102fa4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102fa6:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102fab:	0f 85 23 01 00 00    	jne    801030d4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fb1:	85 c0                	test   %eax,%eax
80102fb3:	0f 85 f7 00 00 00    	jne    801030b0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fb9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102fbc:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102fc3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fc6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fc8:	68 80 36 11 80       	push   $0x80113680
80102fcd:	e8 5e 19 00 00       	call   80104930 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fd2:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102fd8:	83 c4 10             	add    $0x10,%esp
80102fdb:	85 c9                	test   %ecx,%ecx
80102fdd:	0f 8e 8a 00 00 00    	jle    8010306d <end_op+0xed>
80102fe3:	90                   	nop
80102fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fe8:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102fed:	83 ec 08             	sub    $0x8,%esp
80102ff0:	01 d8                	add    %ebx,%eax
80102ff2:	83 c0 01             	add    $0x1,%eax
80102ff5:	50                   	push   %eax
80102ff6:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ffc:	e8 cf d0 ff ff       	call   801000d0 <bread>
80103001:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103003:	58                   	pop    %eax
80103004:	5a                   	pop    %edx
80103005:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
8010300c:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103012:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103015:	e8 b6 d0 ff ff       	call   801000d0 <bread>
8010301a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010301c:	8d 40 5c             	lea    0x5c(%eax),%eax
8010301f:	83 c4 0c             	add    $0xc,%esp
80103022:	68 00 02 00 00       	push   $0x200
80103027:	50                   	push   %eax
80103028:	8d 46 5c             	lea    0x5c(%esi),%eax
8010302b:	50                   	push   %eax
8010302c:	e8 ff 19 00 00       	call   80104a30 <memmove>
    bwrite(to);  // write the log
80103031:	89 34 24             	mov    %esi,(%esp)
80103034:	e8 67 d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103039:	89 3c 24             	mov    %edi,(%esp)
8010303c:	e8 9f d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
80103041:	89 34 24             	mov    %esi,(%esp)
80103044:	e8 97 d1 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103049:	83 c4 10             	add    $0x10,%esp
8010304c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80103052:	7c 94                	jl     80102fe8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103054:	e8 b7 fd ff ff       	call   80102e10 <write_head>
    install_trans(); // Now install writes to home locations
80103059:	e8 12 fd ff ff       	call   80102d70 <install_trans>
    log.lh.n = 0;
8010305e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80103065:	00 00 00 
    write_head();    // Erase the transaction from the log
80103068:	e8 a3 fd ff ff       	call   80102e10 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010306d:	83 ec 0c             	sub    $0xc,%esp
80103070:	68 80 36 11 80       	push   $0x80113680
80103075:	e8 96 17 00 00       	call   80104810 <acquire>
    log.committing = 0;
    wakeup(&log);
8010307a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103081:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103088:	00 00 00 
    wakeup(&log);
8010308b:	e8 b0 12 00 00       	call   80104340 <wakeup>
    release(&log.lock);
80103090:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103097:	e8 94 18 00 00       	call   80104930 <release>
8010309c:	83 c4 10             	add    $0x10,%esp
  }
}
8010309f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030a2:	5b                   	pop    %ebx
801030a3:	5e                   	pop    %esi
801030a4:	5f                   	pop    %edi
801030a5:	5d                   	pop    %ebp
801030a6:	c3                   	ret    
801030a7:	89 f6                	mov    %esi,%esi
801030a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
801030b0:	83 ec 0c             	sub    $0xc,%esp
801030b3:	68 80 36 11 80       	push   $0x80113680
801030b8:	e8 83 12 00 00       	call   80104340 <wakeup>
  }
  release(&log.lock);
801030bd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801030c4:	e8 67 18 00 00       	call   80104930 <release>
801030c9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
801030cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cf:	5b                   	pop    %ebx
801030d0:	5e                   	pop    %esi
801030d1:	5f                   	pop    %edi
801030d2:	5d                   	pop    %ebp
801030d3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
801030d4:	83 ec 0c             	sub    $0xc,%esp
801030d7:	68 24 82 10 80       	push   $0x80108224
801030dc:	e8 8f d2 ff ff       	call   80100370 <panic>
801030e1:	eb 0d                	jmp    801030f0 <log_write>
801030e3:	90                   	nop
801030e4:	90                   	nop
801030e5:	90                   	nop
801030e6:	90                   	nop
801030e7:	90                   	nop
801030e8:	90                   	nop
801030e9:	90                   	nop
801030ea:	90                   	nop
801030eb:	90                   	nop
801030ec:	90                   	nop
801030ed:	90                   	nop
801030ee:	90                   	nop
801030ef:	90                   	nop

801030f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	53                   	push   %ebx
801030f4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030f7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103100:	83 fa 1d             	cmp    $0x1d,%edx
80103103:	0f 8f 97 00 00 00    	jg     801031a0 <log_write+0xb0>
80103109:	a1 b8 36 11 80       	mov    0x801136b8,%eax
8010310e:	83 e8 01             	sub    $0x1,%eax
80103111:	39 c2                	cmp    %eax,%edx
80103113:	0f 8d 87 00 00 00    	jge    801031a0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103119:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010311e:	85 c0                	test   %eax,%eax
80103120:	0f 8e 87 00 00 00    	jle    801031ad <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103126:	83 ec 0c             	sub    $0xc,%esp
80103129:	68 80 36 11 80       	push   $0x80113680
8010312e:	e8 dd 16 00 00       	call   80104810 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103133:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80103139:	83 c4 10             	add    $0x10,%esp
8010313c:	83 fa 00             	cmp    $0x0,%edx
8010313f:	7e 50                	jle    80103191 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103141:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103144:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103146:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
8010314c:	75 0b                	jne    80103159 <log_write+0x69>
8010314e:	eb 38                	jmp    80103188 <log_write+0x98>
80103150:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80103157:	74 2f                	je     80103188 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103159:	83 c0 01             	add    $0x1,%eax
8010315c:	39 d0                	cmp    %edx,%eax
8010315e:	75 f0                	jne    80103150 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103160:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103167:	83 c2 01             	add    $0x1,%edx
8010316a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80103170:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103173:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
8010317a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010317d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010317e:	e9 ad 17 00 00       	jmp    80104930 <release>
80103183:	90                   	nop
80103184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103188:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
8010318f:	eb df                	jmp    80103170 <log_write+0x80>
80103191:	8b 43 08             	mov    0x8(%ebx),%eax
80103194:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103199:	75 d5                	jne    80103170 <log_write+0x80>
8010319b:	eb ca                	jmp    80103167 <log_write+0x77>
8010319d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
801031a0:	83 ec 0c             	sub    $0xc,%esp
801031a3:	68 33 82 10 80       	push   $0x80108233
801031a8:	e8 c3 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
801031ad:	83 ec 0c             	sub    $0xc,%esp
801031b0:	68 49 82 10 80       	push   $0x80108249
801031b5:	e8 b6 d1 ff ff       	call   80100370 <panic>
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031c7:	e8 d4 09 00 00       	call   80103ba0 <cpuid>
801031cc:	89 c3                	mov    %eax,%ebx
801031ce:	e8 cd 09 00 00       	call   80103ba0 <cpuid>
801031d3:	83 ec 04             	sub    $0x4,%esp
801031d6:	53                   	push   %ebx
801031d7:	50                   	push   %eax
801031d8:	68 64 82 10 80       	push   $0x80108264
801031dd:	e8 7e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801031e2:	e8 79 2a 00 00       	call   80105c60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031e7:	e8 34 09 00 00       	call   80103b20 <mycpu>
801031ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031ee:	b8 01 00 00 00       	mov    $0x1,%eax
801031f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031fa:	e8 81 0c 00 00       	call   80103e80 <scheduler>
801031ff:	90                   	nop

80103200 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103206:	e8 05 44 00 00       	call   80107610 <switchkvm>
  seginit();
8010320b:	e8 d0 3a 00 00       	call   80106ce0 <seginit>
  lapicinit();
80103210:	e8 9b f7 ff ff       	call   801029b0 <lapicinit>
  mpmain();
80103215:	e8 a6 ff ff ff       	call   801031c0 <mpmain>
8010321a:	66 90                	xchg   %ax,%ax
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103220:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103224:	83 e4 f0             	and    $0xfffffff0,%esp
80103227:	ff 71 fc             	pushl  -0x4(%ecx)
8010322a:	55                   	push   %ebp
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	53                   	push   %ebx
8010322e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010322f:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103234:	83 ec 08             	sub    $0x8,%esp
80103237:	68 00 00 40 80       	push   $0x80400000
8010323c:	68 a8 db 11 80       	push   $0x8011dba8
80103241:	e8 3a f5 ff ff       	call   80102780 <kinit1>
  kvmalloc();      // kernel page table
80103246:	e8 85 48 00 00       	call   80107ad0 <kvmalloc>
  mpinit();        // detect other processors
8010324b:	e8 70 01 00 00       	call   801033c0 <mpinit>
  lapicinit();     // interrupt controller
80103250:	e8 5b f7 ff ff       	call   801029b0 <lapicinit>
  seginit();       // segment descriptors
80103255:	e8 86 3a 00 00       	call   80106ce0 <seginit>
  picinit();       // disable pic
8010325a:	e8 31 03 00 00       	call   80103590 <picinit>
  ioapicinit();    // another interrupt controller
8010325f:	e8 4c f3 ff ff       	call   801025b0 <ioapicinit>
  consoleinit();   // console hardware
80103264:	e8 37 d7 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103269:	e8 42 2d 00 00       	call   80105fb0 <uartinit>
  pinit();         // process table
8010326e:	e8 8d 08 00 00       	call   80103b00 <pinit>
  tvinit();        // trap vectors
80103273:	e8 48 29 00 00       	call   80105bc0 <tvinit>
  binit();         // buffer cache
80103278:	e8 c3 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010327d:	e8 ce da ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80103282:	e8 09 f1 ff ff       	call   80102390 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103287:	83 c4 0c             	add    $0xc,%esp
8010328a:	68 8a 00 00 00       	push   $0x8a
8010328f:	68 8c b4 10 80       	push   $0x8010b48c
80103294:	68 00 70 00 80       	push   $0x80007000
80103299:	e8 92 17 00 00       	call   80104a30 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010329e:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801032a5:	00 00 00 
801032a8:	83 c4 10             	add    $0x10,%esp
801032ab:	05 80 37 11 80       	add    $0x80113780,%eax
801032b0:	39 d8                	cmp    %ebx,%eax
801032b2:	76 6f                	jbe    80103323 <main+0x103>
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801032b8:	e8 63 08 00 00       	call   80103b20 <mycpu>
801032bd:	39 d8                	cmp    %ebx,%eax
801032bf:	74 49                	je     8010330a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032c1:	e8 8a f5 ff ff       	call   80102850 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032c6:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801032cb:	c7 05 f8 6f 00 80 00 	movl   $0x80103200,0x80006ff8
801032d2:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032d5:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801032dc:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801032df:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032e4:	0f b6 03             	movzbl (%ebx),%eax
801032e7:	83 ec 08             	sub    $0x8,%esp
801032ea:	68 00 70 00 00       	push   $0x7000
801032ef:	50                   	push   %eax
801032f0:	e8 0b f8 ff ff       	call   80102b00 <lapicstartap>
801032f5:	83 c4 10             	add    $0x10,%esp
801032f8:	90                   	nop
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103300:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103306:	85 c0                	test   %eax,%eax
80103308:	74 f6                	je     80103300 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010330a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103311:	00 00 00 
80103314:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010331a:	05 80 37 11 80       	add    $0x80113780,%eax
8010331f:	39 c3                	cmp    %eax,%ebx
80103321:	72 95                	jb     801032b8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103323:	83 ec 08             	sub    $0x8,%esp
80103326:	68 00 00 00 8e       	push   $0x8e000000
8010332b:	68 00 00 40 80       	push   $0x80400000
80103330:	e8 bb f4 ff ff       	call   801027f0 <kinit2>
  userinit();      // first user process
80103335:	e8 b6 08 00 00       	call   80103bf0 <userinit>
  mpmain();        // finish this processor's setup
8010333a:	e8 81 fe ff ff       	call   801031c0 <mpmain>
8010333f:	90                   	nop

80103340 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103345:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010334b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010334c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010334f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103352:	39 de                	cmp    %ebx,%esi
80103354:	73 48                	jae    8010339e <mpsearch1+0x5e>
80103356:	8d 76 00             	lea    0x0(%esi),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103360:	83 ec 04             	sub    $0x4,%esp
80103363:	8d 7e 10             	lea    0x10(%esi),%edi
80103366:	6a 04                	push   $0x4
80103368:	68 78 82 10 80       	push   $0x80108278
8010336d:	56                   	push   %esi
8010336e:	e8 5d 16 00 00       	call   801049d0 <memcmp>
80103373:	83 c4 10             	add    $0x10,%esp
80103376:	85 c0                	test   %eax,%eax
80103378:	75 1e                	jne    80103398 <mpsearch1+0x58>
8010337a:	8d 7e 10             	lea    0x10(%esi),%edi
8010337d:	89 f2                	mov    %esi,%edx
8010337f:	31 c9                	xor    %ecx,%ecx
80103381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103388:	0f b6 02             	movzbl (%edx),%eax
8010338b:	83 c2 01             	add    $0x1,%edx
8010338e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103390:	39 fa                	cmp    %edi,%edx
80103392:	75 f4                	jne    80103388 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103394:	84 c9                	test   %cl,%cl
80103396:	74 10                	je     801033a8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103398:	39 fb                	cmp    %edi,%ebx
8010339a:	89 fe                	mov    %edi,%esi
8010339c:	77 c2                	ja     80103360 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010339e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801033a1:	31 c0                	xor    %eax,%eax
}
801033a3:	5b                   	pop    %ebx
801033a4:	5e                   	pop    %esi
801033a5:	5f                   	pop    %edi
801033a6:	5d                   	pop    %ebp
801033a7:	c3                   	ret    
801033a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ab:	89 f0                	mov    %esi,%eax
801033ad:	5b                   	pop    %ebx
801033ae:	5e                   	pop    %esi
801033af:	5f                   	pop    %edi
801033b0:	5d                   	pop    %ebp
801033b1:	c3                   	ret    
801033b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033d7:	c1 e0 08             	shl    $0x8,%eax
801033da:	09 d0                	or     %edx,%eax
801033dc:	c1 e0 04             	shl    $0x4,%eax
801033df:	85 c0                	test   %eax,%eax
801033e1:	75 1b                	jne    801033fe <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801033e3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033ea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033f1:	c1 e0 08             	shl    $0x8,%eax
801033f4:	09 d0                	or     %edx,%eax
801033f6:	c1 e0 0a             	shl    $0xa,%eax
801033f9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801033fe:	ba 00 04 00 00       	mov    $0x400,%edx
80103403:	e8 38 ff ff ff       	call   80103340 <mpsearch1>
80103408:	85 c0                	test   %eax,%eax
8010340a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010340d:	0f 84 37 01 00 00    	je     8010354a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103416:	8b 58 04             	mov    0x4(%eax),%ebx
80103419:	85 db                	test   %ebx,%ebx
8010341b:	0f 84 43 01 00 00    	je     80103564 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103421:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103427:	83 ec 04             	sub    $0x4,%esp
8010342a:	6a 04                	push   $0x4
8010342c:	68 7d 82 10 80       	push   $0x8010827d
80103431:	56                   	push   %esi
80103432:	e8 99 15 00 00       	call   801049d0 <memcmp>
80103437:	83 c4 10             	add    $0x10,%esp
8010343a:	85 c0                	test   %eax,%eax
8010343c:	0f 85 22 01 00 00    	jne    80103564 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103442:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103449:	3c 01                	cmp    $0x1,%al
8010344b:	74 08                	je     80103455 <mpinit+0x95>
8010344d:	3c 04                	cmp    $0x4,%al
8010344f:	0f 85 0f 01 00 00    	jne    80103564 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103455:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010345c:	85 ff                	test   %edi,%edi
8010345e:	74 21                	je     80103481 <mpinit+0xc1>
80103460:	31 d2                	xor    %edx,%edx
80103462:	31 c0                	xor    %eax,%eax
80103464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103468:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010346f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103470:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103473:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103475:	39 c7                	cmp    %eax,%edi
80103477:	75 ef                	jne    80103468 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103479:	84 d2                	test   %dl,%dl
8010347b:	0f 85 e3 00 00 00    	jne    80103564 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103481:	85 f6                	test   %esi,%esi
80103483:	0f 84 db 00 00 00    	je     80103564 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103489:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010348f:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103494:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010349b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801034a1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034a6:	01 d6                	add    %edx,%esi
801034a8:	90                   	nop
801034a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034b0:	39 c6                	cmp    %eax,%esi
801034b2:	76 23                	jbe    801034d7 <mpinit+0x117>
801034b4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801034b7:	80 fa 04             	cmp    $0x4,%dl
801034ba:	0f 87 c0 00 00 00    	ja     80103580 <mpinit+0x1c0>
801034c0:	ff 24 95 bc 82 10 80 	jmp    *-0x7fef7d44(,%edx,4)
801034c7:	89 f6                	mov    %esi,%esi
801034c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034d0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034d3:	39 c6                	cmp    %eax,%esi
801034d5:	77 dd                	ja     801034b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034d7:	85 db                	test   %ebx,%ebx
801034d9:	0f 84 92 00 00 00    	je     80103571 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034e2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801034e6:	74 15                	je     801034fd <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034e8:	ba 22 00 00 00       	mov    $0x22,%edx
801034ed:	b8 70 00 00 00       	mov    $0x70,%eax
801034f2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034f3:	ba 23 00 00 00       	mov    $0x23,%edx
801034f8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f9:	83 c8 01             	or     $0x1,%eax
801034fc:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801034fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103500:	5b                   	pop    %ebx
80103501:	5e                   	pop    %esi
80103502:	5f                   	pop    %edi
80103503:	5d                   	pop    %ebp
80103504:	c3                   	ret    
80103505:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103508:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010350e:	83 f9 07             	cmp    $0x7,%ecx
80103511:	7f 19                	jg     8010352c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103513:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103517:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010351d:	83 c1 01             	add    $0x1,%ecx
80103520:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103526:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010352c:	83 c0 14             	add    $0x14,%eax
      continue;
8010352f:	e9 7c ff ff ff       	jmp    801034b0 <mpinit+0xf0>
80103534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103538:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010353c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010353f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
80103545:	e9 66 ff ff ff       	jmp    801034b0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010354a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010354f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103554:	e8 e7 fd ff ff       	call   80103340 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103559:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010355b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010355e:	0f 85 af fe ff ff    	jne    80103413 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103564:	83 ec 0c             	sub    $0xc,%esp
80103567:	68 82 82 10 80       	push   $0x80108282
8010356c:	e8 ff cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103571:	83 ec 0c             	sub    $0xc,%esp
80103574:	68 9c 82 10 80       	push   $0x8010829c
80103579:	e8 f2 cd ff ff       	call   80100370 <panic>
8010357e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103580:	31 db                	xor    %ebx,%ebx
80103582:	e9 30 ff ff ff       	jmp    801034b7 <mpinit+0xf7>
80103587:	66 90                	xchg   %ax,%ax
80103589:	66 90                	xchg   %ax,%ax
8010358b:	66 90                	xchg   %ax,%ax
8010358d:	66 90                	xchg   %ax,%ax
8010358f:	90                   	nop

80103590 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103590:	55                   	push   %ebp
80103591:	ba 21 00 00 00       	mov    $0x21,%edx
80103596:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010359b:	89 e5                	mov    %esp,%ebp
8010359d:	ee                   	out    %al,(%dx)
8010359e:	ba a1 00 00 00       	mov    $0xa1,%edx
801035a3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035a4:	5d                   	pop    %ebp
801035a5:	c3                   	ret    
801035a6:	66 90                	xchg   %ax,%ax
801035a8:	66 90                	xchg   %ax,%ax
801035aa:	66 90                	xchg   %ax,%ax
801035ac:	66 90                	xchg   %ax,%ax
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 0c             	sub    $0xc,%esp
801035b9:	8b 75 08             	mov    0x8(%ebp),%esi
801035bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801035c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035cb:	e8 a0 d7 ff ff       	call   80100d70 <filealloc>
801035d0:	85 c0                	test   %eax,%eax
801035d2:	89 06                	mov    %eax,(%esi)
801035d4:	0f 84 a8 00 00 00    	je     80103682 <pipealloc+0xd2>
801035da:	e8 91 d7 ff ff       	call   80100d70 <filealloc>
801035df:	85 c0                	test   %eax,%eax
801035e1:	89 03                	mov    %eax,(%ebx)
801035e3:	0f 84 87 00 00 00    	je     80103670 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035e9:	e8 62 f2 ff ff       	call   80102850 <kalloc>
801035ee:	85 c0                	test   %eax,%eax
801035f0:	89 c7                	mov    %eax,%edi
801035f2:	0f 84 b0 00 00 00    	je     801036a8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035f8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801035fb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103602:	00 00 00 
  p->writeopen = 1;
80103605:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010360c:	00 00 00 
  p->nwrite = 0;
8010360f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103616:	00 00 00 
  p->nread = 0;
80103619:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103620:	00 00 00 
  initlock(&p->lock, "pipe");
80103623:	68 d0 82 10 80       	push   $0x801082d0
80103628:	50                   	push   %eax
80103629:	e8 e2 10 00 00       	call   80104710 <initlock>
  (*f0)->type = FD_PIPE;
8010362e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103630:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103633:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103639:	8b 06                	mov    (%esi),%eax
8010363b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010363f:	8b 06                	mov    (%esi),%eax
80103641:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103645:	8b 06                	mov    (%esi),%eax
80103647:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010364a:	8b 03                	mov    (%ebx),%eax
8010364c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103652:	8b 03                	mov    (%ebx),%eax
80103654:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103658:	8b 03                	mov    (%ebx),%eax
8010365a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010365e:	8b 03                	mov    (%ebx),%eax
80103660:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103663:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103666:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103668:	5b                   	pop    %ebx
80103669:	5e                   	pop    %esi
8010366a:	5f                   	pop    %edi
8010366b:	5d                   	pop    %ebp
8010366c:	c3                   	ret    
8010366d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103670:	8b 06                	mov    (%esi),%eax
80103672:	85 c0                	test   %eax,%eax
80103674:	74 1e                	je     80103694 <pipealloc+0xe4>
    fileclose(*f0);
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	50                   	push   %eax
8010367a:	e8 b1 d7 ff ff       	call   80100e30 <fileclose>
8010367f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103682:	8b 03                	mov    (%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	74 0c                	je     80103694 <pipealloc+0xe4>
    fileclose(*f1);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	50                   	push   %eax
8010368c:	e8 9f d7 ff ff       	call   80100e30 <fileclose>
80103691:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103694:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036a8:	8b 06                	mov    (%esi),%eax
801036aa:	85 c0                	test   %eax,%eax
801036ac:	75 c8                	jne    80103676 <pipealloc+0xc6>
801036ae:	eb d2                	jmp    80103682 <pipealloc+0xd2>

801036b0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	56                   	push   %esi
801036b4:	53                   	push   %ebx
801036b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036bb:	83 ec 0c             	sub    $0xc,%esp
801036be:	53                   	push   %ebx
801036bf:	e8 4c 11 00 00       	call   80104810 <acquire>
  if(writable){
801036c4:	83 c4 10             	add    $0x10,%esp
801036c7:	85 f6                	test   %esi,%esi
801036c9:	74 45                	je     80103710 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801036cb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801036d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036db:	00 00 00 
    wakeup(&p->nread);
801036de:	50                   	push   %eax
801036df:	e8 5c 0c 00 00       	call   80104340 <wakeup>
801036e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036ed:	85 d2                	test   %edx,%edx
801036ef:	75 0a                	jne    801036fb <pipeclose+0x4b>
801036f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036f7:	85 c0                	test   %eax,%eax
801036f9:	74 35                	je     80103730 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103701:	5b                   	pop    %ebx
80103702:	5e                   	pop    %esi
80103703:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103704:	e9 27 12 00 00       	jmp    80104930 <release>
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103710:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103716:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103719:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103720:	00 00 00 
    wakeup(&p->nwrite);
80103723:	50                   	push   %eax
80103724:	e8 17 0c 00 00       	call   80104340 <wakeup>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	eb b9                	jmp    801036e7 <pipeclose+0x37>
8010372e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	53                   	push   %ebx
80103734:	e8 f7 11 00 00       	call   80104930 <release>
    kfree((char*)p);
80103739:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010373c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010373f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103742:	5b                   	pop    %ebx
80103743:	5e                   	pop    %esi
80103744:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103745:	e9 56 ef ff ff       	jmp    801026a0 <kfree>
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103750 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	57                   	push   %edi
80103754:	56                   	push   %esi
80103755:	53                   	push   %ebx
80103756:	83 ec 28             	sub    $0x28,%esp
80103759:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010375c:	53                   	push   %ebx
8010375d:	e8 ae 10 00 00       	call   80104810 <acquire>
  for(i = 0; i < n; i++){
80103762:	8b 45 10             	mov    0x10(%ebp),%eax
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	85 c0                	test   %eax,%eax
8010376a:	0f 8e b9 00 00 00    	jle    80103829 <pipewrite+0xd9>
80103770:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103773:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103779:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010377f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103785:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103788:	03 4d 10             	add    0x10(%ebp),%ecx
8010378b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010378e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103794:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010379a:	39 d0                	cmp    %edx,%eax
8010379c:	74 38                	je     801037d6 <pipewrite+0x86>
8010379e:	eb 59                	jmp    801037f9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801037a0:	e8 1b 04 00 00       	call   80103bc0 <myproc>
801037a5:	8b 48 24             	mov    0x24(%eax),%ecx
801037a8:	85 c9                	test   %ecx,%ecx
801037aa:	75 34                	jne    801037e0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037ac:	83 ec 0c             	sub    $0xc,%esp
801037af:	57                   	push   %edi
801037b0:	e8 8b 0b 00 00       	call   80104340 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037b5:	58                   	pop    %eax
801037b6:	5a                   	pop    %edx
801037b7:	53                   	push   %ebx
801037b8:	56                   	push   %esi
801037b9:	e8 c2 09 00 00       	call   80104180 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037be:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037c4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037ca:	83 c4 10             	add    $0x10,%esp
801037cd:	05 00 02 00 00       	add    $0x200,%eax
801037d2:	39 c2                	cmp    %eax,%edx
801037d4:	75 2a                	jne    80103800 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801037d6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037dc:	85 c0                	test   %eax,%eax
801037de:	75 c0                	jne    801037a0 <pipewrite+0x50>
        release(&p->lock);
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	53                   	push   %ebx
801037e4:	e8 47 11 00 00       	call   80104930 <release>
        return -1;
801037e9:	83 c4 10             	add    $0x10,%esp
801037ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f4:	5b                   	pop    %ebx
801037f5:	5e                   	pop    %esi
801037f6:	5f                   	pop    %edi
801037f7:	5d                   	pop    %ebp
801037f8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f9:	89 c2                	mov    %eax,%edx
801037fb:	90                   	nop
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103800:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103803:	8d 42 01             	lea    0x1(%edx),%eax
80103806:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010380a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103810:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103816:	0f b6 09             	movzbl (%ecx),%ecx
80103819:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010381d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103820:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103823:	0f 85 65 ff ff ff    	jne    8010378e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103829:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010382f:	83 ec 0c             	sub    $0xc,%esp
80103832:	50                   	push   %eax
80103833:	e8 08 0b 00 00       	call   80104340 <wakeup>
  release(&p->lock);
80103838:	89 1c 24             	mov    %ebx,(%esp)
8010383b:	e8 f0 10 00 00       	call   80104930 <release>
  return n;
80103840:	83 c4 10             	add    $0x10,%esp
80103843:	8b 45 10             	mov    0x10(%ebp),%eax
80103846:	eb a9                	jmp    801037f1 <pipewrite+0xa1>
80103848:	90                   	nop
80103849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103850 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	57                   	push   %edi
80103854:	56                   	push   %esi
80103855:	53                   	push   %ebx
80103856:	83 ec 18             	sub    $0x18,%esp
80103859:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010385c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010385f:	53                   	push   %ebx
80103860:	e8 ab 0f 00 00       	call   80104810 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010386e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103874:	75 6a                	jne    801038e0 <piperead+0x90>
80103876:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010387c:	85 f6                	test   %esi,%esi
8010387e:	0f 84 cc 00 00 00    	je     80103950 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103884:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010388a:	eb 2d                	jmp    801038b9 <piperead+0x69>
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103890:	83 ec 08             	sub    $0x8,%esp
80103893:	53                   	push   %ebx
80103894:	56                   	push   %esi
80103895:	e8 e6 08 00 00       	call   80104180 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010389a:	83 c4 10             	add    $0x10,%esp
8010389d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801038a3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801038a9:	75 35                	jne    801038e0 <piperead+0x90>
801038ab:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801038b1:	85 d2                	test   %edx,%edx
801038b3:	0f 84 97 00 00 00    	je     80103950 <piperead+0x100>
    if(myproc()->killed){
801038b9:	e8 02 03 00 00       	call   80103bc0 <myproc>
801038be:	8b 48 24             	mov    0x24(%eax),%ecx
801038c1:	85 c9                	test   %ecx,%ecx
801038c3:	74 cb                	je     80103890 <piperead+0x40>
      release(&p->lock);
801038c5:	83 ec 0c             	sub    $0xc,%esp
801038c8:	53                   	push   %ebx
801038c9:	e8 62 10 00 00       	call   80104930 <release>
      return -1;
801038ce:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038d1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801038d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038d9:	5b                   	pop    %ebx
801038da:	5e                   	pop    %esi
801038db:	5f                   	pop    %edi
801038dc:	5d                   	pop    %ebp
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038e0:	8b 45 10             	mov    0x10(%ebp),%eax
801038e3:	85 c0                	test   %eax,%eax
801038e5:	7e 69                	jle    80103950 <piperead+0x100>
    if(p->nread == p->nwrite)
801038e7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038ed:	31 c9                	xor    %ecx,%ecx
801038ef:	eb 15                	jmp    80103906 <piperead+0xb6>
801038f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038fe:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103904:	74 5a                	je     80103960 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103906:	8d 70 01             	lea    0x1(%eax),%esi
80103909:	25 ff 01 00 00       	and    $0x1ff,%eax
8010390e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103914:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103919:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010391c:	83 c1 01             	add    $0x1,%ecx
8010391f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103922:	75 d4                	jne    801038f8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103924:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010392a:	83 ec 0c             	sub    $0xc,%esp
8010392d:	50                   	push   %eax
8010392e:	e8 0d 0a 00 00       	call   80104340 <wakeup>
  release(&p->lock);
80103933:	89 1c 24             	mov    %ebx,(%esp)
80103936:	e8 f5 0f 00 00       	call   80104930 <release>
  return i;
8010393b:	8b 45 10             	mov    0x10(%ebp),%eax
8010393e:	83 c4 10             	add    $0x10,%esp
}
80103941:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103944:	5b                   	pop    %ebx
80103945:	5e                   	pop    %esi
80103946:	5f                   	pop    %edi
80103947:	5d                   	pop    %ebp
80103948:	c3                   	ret    
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103950:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103957:	eb cb                	jmp    80103924 <piperead+0xd4>
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103960:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103963:	eb bf                	jmp    80103924 <piperead+0xd4>
80103965:	66 90                	xchg   %ax,%ax
80103967:	66 90                	xchg   %ax,%ax
80103969:	66 90                	xchg   %ax,%ax
8010396b:	66 90                	xchg   %ax,%ax
8010396d:	66 90                	xchg   %ax,%ax
8010396f:	90                   	nop

80103970 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
80103974:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103975:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	68 20 3d 11 80       	push   $0x80113d20
80103982:	e8 89 0e 00 00       	call   80104810 <acquire>
80103987:	83 c4 10             	add    $0x10,%esp
8010398a:	eb 16                	jmp    801039a2 <allocproc+0x32>
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103990:	81 c3 58 02 00 00    	add    $0x258,%ebx
80103996:	81 fb 54 d3 11 80    	cmp    $0x8011d354,%ebx
8010399c:	0f 84 e6 00 00 00    	je     80103a88 <allocproc+0x118>
    if(p->state == UNUSED)
801039a2:	8b 43 0c             	mov    0xc(%ebx),%eax
801039a5:	85 c0                	test   %eax,%eax
801039a7:	75 e7                	jne    80103990 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039a9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801039ae:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801039b1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
801039b8:	68 20 3d 11 80       	push   $0x80113d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039bd:	8d 50 01             	lea    0x1(%eax),%edx
801039c0:	89 43 10             	mov    %eax,0x10(%ebx)
801039c3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

  release(&ptable.lock);
801039c9:	e8 62 0f 00 00       	call   80104930 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039ce:	e8 7d ee ff ff       	call   80102850 <kalloc>
801039d3:	83 c4 10             	add    $0x10,%esp
801039d6:	85 c0                	test   %eax,%eax
801039d8:	89 43 08             	mov    %eax,0x8(%ebx)
801039db:	0f 84 c0 00 00 00    	je     80103aa1 <allocproc+0x131>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039e1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039e7:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801039ea:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  int i;
  memset(p->physicalPages, 0, sizeof(p->physicalPages));
801039ef:	8d b3 d0 00 00 00    	lea    0xd0(%ebx),%esi
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039f5:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801039f8:	c7 40 14 b2 5b 10 80 	movl   $0x80105bb2,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039ff:	6a 14                	push   $0x14
80103a01:	6a 00                	push   $0x0
80103a03:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103a04:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a07:	e8 74 0f 00 00       	call   80104980 <memset>
  p->context->eip = (uint)forkret;
80103a0c:	8b 43 1c             	mov    0x1c(%ebx),%eax
  int i;
  memset(p->physicalPages, 0, sizeof(p->physicalPages));
80103a0f:	83 c4 0c             	add    $0xc,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103a12:	c7 40 10 b0 3a 10 80 	movl   $0x80103ab0,0x10(%eax)
  int i;
  memset(p->physicalPages, 0, sizeof(p->physicalPages));
80103a19:	68 80 01 00 00       	push   $0x180
80103a1e:	6a 00                	push   $0x0
80103a20:	56                   	push   %esi
80103a21:	e8 5a 0f 00 00       	call   80104980 <memset>
80103a26:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80103a2c:	83 c4 10             	add    $0x10,%esp
80103a2f:	90                   	nop
  for (i = 0; i < MAX_PSYC_PAGES; i++){
    p->swappedPages[i] = -1;
80103a30:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
80103a36:	83 c0 04             	add    $0x4,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  int i;
  memset(p->physicalPages, 0, sizeof(p->physicalPages));
  for (i = 0; i < MAX_PSYC_PAGES; i++){
80103a39:	39 f0                	cmp    %esi,%eax
80103a3b:	75 f3                	jne    80103a30 <allocproc+0xc0>
    p->swappedPages[i] = -1;
  }
  
  p->physicalPagesCount=0;
80103a3d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103a44:	00 00 00 
  p->swappedPagesCount=0;
80103a47:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103a4e:	00 00 00 
  p->pageOutCount=0;
  p->pageFaultsCount=0;
  p->pagesHead = 0;
  p->pagesTail=0;
  return p;
80103a51:	89 d8                	mov    %ebx,%eax
    p->swappedPages[i] = -1;
  }
  
  p->physicalPagesCount=0;
  p->swappedPagesCount=0;
  p->pageOutCount=0;
80103a53:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103a5a:	00 00 00 
  p->pageFaultsCount=0;
80103a5d:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103a64:	00 00 00 
  p->pagesHead = 0;
80103a67:	c7 83 50 02 00 00 00 	movl   $0x0,0x250(%ebx)
80103a6e:	00 00 00 
  p->pagesTail=0;
80103a71:	c7 83 54 02 00 00 00 	movl   $0x0,0x254(%ebx)
80103a78:	00 00 00 
  return p;
}
80103a7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a7e:	5b                   	pop    %ebx
80103a7f:	5e                   	pop    %esi
80103a80:	5d                   	pop    %ebp
80103a81:	c3                   	ret    
80103a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103a88:	83 ec 0c             	sub    $0xc,%esp
80103a8b:	68 20 3d 11 80       	push   $0x80113d20
80103a90:	e8 9b 0e 00 00       	call   80104930 <release>
  return 0;
80103a95:	83 c4 10             	add    $0x10,%esp
  p->pageOutCount=0;
  p->pageFaultsCount=0;
  p->pagesHead = 0;
  p->pagesTail=0;
  return p;
}
80103a98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103a9b:	31 c0                	xor    %eax,%eax
  p->pageOutCount=0;
  p->pageFaultsCount=0;
  p->pagesHead = 0;
  p->pagesTail=0;
  return p;
}
80103a9d:	5b                   	pop    %ebx
80103a9e:	5e                   	pop    %esi
80103a9f:	5d                   	pop    %ebp
80103aa0:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103aa1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103aa8:	eb d1                	jmp    80103a7b <allocproc+0x10b>
80103aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ab0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ab6:	68 20 3d 11 80       	push   $0x80113d20
80103abb:	e8 70 0e 00 00       	call   80104930 <release>

  if (first) {
80103ac0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	85 c0                	test   %eax,%eax
80103aca:	75 04                	jne    80103ad0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103acc:	c9                   	leave  
80103acd:	c3                   	ret    
80103ace:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103ad0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103ad3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103ada:	00 00 00 
    iinit(ROOTDEV);
80103add:	6a 01                	push   $0x1
80103adf:	e8 8c d9 ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aeb:	e8 80 f3 ff ff       	call   80102e70 <initlog>
80103af0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103af3:	c9                   	leave  
80103af4:	c3                   	ret    
80103af5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b00 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b06:	68 d5 82 10 80       	push   $0x801082d5
80103b0b:	68 20 3d 11 80       	push   $0x80113d20
80103b10:	e8 fb 0b 00 00       	call   80104710 <initlock>
}
80103b15:	83 c4 10             	add    $0x10,%esp
80103b18:	c9                   	leave  
80103b19:	c3                   	ret    
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b20 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	56                   	push   %esi
80103b24:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b25:	9c                   	pushf  
80103b26:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103b27:	f6 c4 02             	test   $0x2,%ah
80103b2a:	75 5b                	jne    80103b87 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103b2c:	e8 7f ef ff ff       	call   80102ab0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b31:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103b37:	85 f6                	test   %esi,%esi
80103b39:	7e 3f                	jle    80103b7a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b3b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103b42:	39 d0                	cmp    %edx,%eax
80103b44:	74 30                	je     80103b76 <mycpu+0x56>
80103b46:	b9 30 38 11 80       	mov    $0x80113830,%ecx
80103b4b:	31 d2                	xor    %edx,%edx
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b50:	83 c2 01             	add    $0x1,%edx
80103b53:	39 f2                	cmp    %esi,%edx
80103b55:	74 23                	je     80103b7a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103b57:	0f b6 19             	movzbl (%ecx),%ebx
80103b5a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b60:	39 d8                	cmp    %ebx,%eax
80103b62:	75 ec                	jne    80103b50 <mycpu+0x30>
      return &cpus[i];
80103b64:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103b6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b6d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103b6e:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103b73:	5e                   	pop    %esi
80103b74:	5d                   	pop    %ebp
80103b75:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103b76:	31 d2                	xor    %edx,%edx
80103b78:	eb ea                	jmp    80103b64 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103b7a:	83 ec 0c             	sub    $0xc,%esp
80103b7d:	68 dc 82 10 80       	push   $0x801082dc
80103b82:	e8 e9 c7 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103b87:	83 ec 0c             	sub    $0xc,%esp
80103b8a:	68 c0 83 10 80       	push   $0x801083c0
80103b8f:	e8 dc c7 ff ff       	call   80100370 <panic>
80103b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ba0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ba6:	e8 75 ff ff ff       	call   80103b20 <mycpu>
80103bab:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103bb0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103bb1:	c1 f8 04             	sar    $0x4,%eax
80103bb4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bba:	c3                   	ret    
80103bbb:	90                   	nop
80103bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bc0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	53                   	push   %ebx
80103bc4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103bc7:	e8 04 0c 00 00       	call   801047d0 <pushcli>
  c = mycpu();
80103bcc:	e8 4f ff ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103bd1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd7:	e8 e4 0c 00 00       	call   801048c0 <popcli>
  return p;
}
80103bdc:	83 c4 04             	add    $0x4,%esp
80103bdf:	89 d8                	mov    %ebx,%eax
80103be1:	5b                   	pop    %ebx
80103be2:	5d                   	pop    %ebp
80103be3:	c3                   	ret    
80103be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bf0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	53                   	push   %ebx
80103bf4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103bf7:	e8 74 fd ff ff       	call   80103970 <allocproc>
80103bfc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103bfe:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103c03:	e8 48 3e 00 00       	call   80107a50 <setupkvm>
80103c08:	85 c0                	test   %eax,%eax
80103c0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c0d:	0f 84 bd 00 00 00    	je     80103cd0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c13:	83 ec 04             	sub    $0x4,%esp
80103c16:	68 2c 00 00 00       	push   $0x2c
80103c1b:	68 60 b4 10 80       	push   $0x8010b460
80103c20:	50                   	push   %eax
80103c21:	e8 1a 3b 00 00       	call   80107740 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103c26:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103c29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c2f:	6a 4c                	push   $0x4c
80103c31:	6a 00                	push   $0x0
80103c33:	ff 73 18             	pushl  0x18(%ebx)
80103c36:	e8 45 0d 00 00       	call   80104980 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c43:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c48:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c56:	8b 43 18             	mov    0x18(%ebx),%eax
80103c59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c61:	8b 43 18             	mov    0x18(%ebx),%eax
80103c64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c76:	8b 43 18             	mov    0x18(%ebx),%eax
80103c79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c80:	8b 43 18             	mov    0x18(%ebx),%eax
80103c83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c8d:	6a 10                	push   $0x10
80103c8f:	68 05 83 10 80       	push   $0x80108305
80103c94:	50                   	push   %eax
80103c95:	e8 e6 0e 00 00       	call   80104b80 <safestrcpy>
  p->cwd = namei("/");
80103c9a:	c7 04 24 0e 83 10 80 	movl   $0x8010830e,(%esp)
80103ca1:	e8 1a e2 ff ff       	call   80101ec0 <namei>
80103ca6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103ca9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cb0:	e8 5b 0b 00 00       	call   80104810 <acquire>

  p->state = RUNNABLE;
80103cb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103cbc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cc3:	e8 68 0c 00 00       	call   80104930 <release>
}
80103cc8:	83 c4 10             	add    $0x10,%esp
80103ccb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cce:	c9                   	leave  
80103ccf:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	68 ec 82 10 80       	push   $0x801082ec
80103cd8:	e8 93 c6 ff ff       	call   80100370 <panic>
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi

80103ce0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
80103ce5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ce8:	e8 e3 0a 00 00       	call   801047d0 <pushcli>
  c = mycpu();
80103ced:	e8 2e fe ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103cf2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf8:	e8 c3 0b 00 00       	call   801048c0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103cfd:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103d00:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d02:	7e 34                	jle    80103d38 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d04:	83 ec 04             	sub    $0x4,%esp
80103d07:	01 c6                	add    %eax,%esi
80103d09:	56                   	push   %esi
80103d0a:	50                   	push   %eax
80103d0b:	ff 73 04             	pushl  0x4(%ebx)
80103d0e:	e8 6d 3b 00 00       	call   80107880 <allocuvm>
80103d13:	83 c4 10             	add    $0x10,%esp
80103d16:	85 c0                	test   %eax,%eax
80103d18:	74 36                	je     80103d50 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103d1a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103d1d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d1f:	53                   	push   %ebx
80103d20:	e8 0b 39 00 00       	call   80107630 <switchuvm>
  return 0;
80103d25:	83 c4 10             	add    $0x10,%esp
80103d28:	31 c0                	xor    %eax,%eax
}
80103d2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d2d:	5b                   	pop    %ebx
80103d2e:	5e                   	pop    %esi
80103d2f:	5d                   	pop    %ebp
80103d30:	c3                   	ret    
80103d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103d38:	74 e0                	je     80103d1a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d3a:	83 ec 04             	sub    $0x4,%esp
80103d3d:	01 c6                	add    %eax,%esi
80103d3f:	56                   	push   %esi
80103d40:	50                   	push   %eax
80103d41:	ff 73 04             	pushl  0x4(%ebx)
80103d44:	e8 57 3c 00 00       	call   801079a0 <deallocuvm>
80103d49:	83 c4 10             	add    $0x10,%esp
80103d4c:	85 c0                	test   %eax,%eax
80103d4e:	75 ca                	jne    80103d1a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d55:	eb d3                	jmp    80103d2a <growproc+0x4a>
80103d57:	89 f6                	mov    %esi,%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d60 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d69:	e8 62 0a 00 00       	call   801047d0 <pushcli>
  c = mycpu();
80103d6e:	e8 ad fd ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103d73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d79:	e8 42 0b 00 00       	call   801048c0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103d7e:	e8 ed fb ff ff       	call   80103970 <allocproc>
80103d83:	85 c0                	test   %eax,%eax
80103d85:	89 c7                	mov    %eax,%edi
80103d87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d8a:	0f 84 b5 00 00 00    	je     80103e45 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d90:	83 ec 08             	sub    $0x8,%esp
80103d93:	ff 33                	pushl  (%ebx)
80103d95:	ff 73 04             	pushl  0x4(%ebx)
80103d98:	e8 83 3d 00 00       	call   80107b20 <copyuvm>
80103d9d:	83 c4 10             	add    $0x10,%esp
80103da0:	85 c0                	test   %eax,%eax
80103da2:	89 47 04             	mov    %eax,0x4(%edi)
80103da5:	0f 84 a1 00 00 00    	je     80103e4c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103dab:	8b 03                	mov    (%ebx),%eax
80103dad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103db0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103db2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103db5:	89 c8                	mov    %ecx,%eax
80103db7:	8b 79 18             	mov    0x18(%ecx),%edi
80103dba:	8b 73 18             	mov    0x18(%ebx),%esi
80103dbd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103dc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103dc4:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103dc6:	8b 40 18             	mov    0x18(%eax),%eax
80103dc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103dd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103dd4:	85 c0                	test   %eax,%eax
80103dd6:	74 13                	je     80103deb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	50                   	push   %eax
80103ddc:	e8 ff cf ff ff       	call   80100de0 <filedup>
80103de1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103de4:	83 c4 10             	add    $0x10,%esp
80103de7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103deb:	83 c6 01             	add    $0x1,%esi
80103dee:	83 fe 10             	cmp    $0x10,%esi
80103df1:	75 dd                	jne    80103dd0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103df3:	83 ec 0c             	sub    $0xc,%esp
80103df6:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df9:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103dfc:	e8 3f d8 ff ff       	call   80101640 <idup>
80103e01:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e04:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103e07:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e0d:	6a 10                	push   $0x10
80103e0f:	53                   	push   %ebx
80103e10:	50                   	push   %eax
80103e11:	e8 6a 0d 00 00       	call   80104b80 <safestrcpy>

  pid = np->pid;
80103e16:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103e19:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e20:	e8 eb 09 00 00       	call   80104810 <acquire>

  np->state = RUNNABLE;
80103e25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103e2c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e33:	e8 f8 0a 00 00       	call   80104930 <release>

  return pid;
80103e38:	83 c4 10             	add    $0x10,%esp
80103e3b:	89 d8                	mov    %ebx,%eax
}
80103e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e40:	5b                   	pop    %ebx
80103e41:	5e                   	pop    %esi
80103e42:	5f                   	pop    %edi
80103e43:	5d                   	pop    %ebp
80103e44:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103e45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e4a:	eb f1                	jmp    80103e3d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103e4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103e4f:	83 ec 0c             	sub    $0xc,%esp
80103e52:	ff 77 08             	pushl  0x8(%edi)
80103e55:	e8 46 e8 ff ff       	call   801026a0 <kfree>
    np->kstack = 0;
80103e5a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103e61:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103e68:	83 c4 10             	add    $0x10,%esp
80103e6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e70:	eb cb                	jmp    80103e3d <fork+0xdd>
80103e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e80 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103e89:	e8 92 fc ff ff       	call   80103b20 <mycpu>
80103e8e:	8d 78 04             	lea    0x4(%eax),%edi
80103e91:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e93:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e9a:	00 00 00 
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ea0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ea1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ea9:	68 20 3d 11 80       	push   $0x80113d20
80103eae:	e8 5d 09 00 00       	call   80104810 <acquire>
80103eb3:	83 c4 10             	add    $0x10,%esp
80103eb6:	eb 16                	jmp    80103ece <scheduler+0x4e>
80103eb8:	90                   	nop
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec0:	81 c3 58 02 00 00    	add    $0x258,%ebx
80103ec6:	81 fb 54 d3 11 80    	cmp    $0x8011d354,%ebx
80103ecc:	74 52                	je     80103f20 <scheduler+0xa0>
      if(p->state != RUNNABLE)
80103ece:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ed2:	75 ec                	jne    80103ec0 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ed4:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103ed7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103edd:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ede:	81 c3 58 02 00 00    	add    $0x258,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ee4:	e8 47 37 00 00       	call   80107630 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103ee9:	58                   	pop    %eax
80103eea:	5a                   	pop    %edx
80103eeb:	ff b3 c4 fd ff ff    	pushl  -0x23c(%ebx)
80103ef1:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103ef2:	c7 83 b4 fd ff ff 04 	movl   $0x4,-0x24c(%ebx)
80103ef9:	00 00 00 

      swtch(&(c->scheduler), p->context);
80103efc:	e8 da 0c 00 00       	call   80104bdb <swtch>
      switchkvm();
80103f01:	e8 0a 37 00 00       	call   80107610 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103f06:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f09:	81 fb 54 d3 11 80    	cmp    $0x8011d354,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103f0f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f16:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f19:	75 b3                	jne    80103ece <scheduler+0x4e>
80103f1b:	90                   	nop
80103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	68 20 3d 11 80       	push   $0x80113d20
80103f28:	e8 03 0a 00 00       	call   80104930 <release>

  }
80103f2d:	83 c4 10             	add    $0x10,%esp
80103f30:	e9 6b ff ff ff       	jmp    80103ea0 <scheduler+0x20>
80103f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f40 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f45:	e8 86 08 00 00       	call   801047d0 <pushcli>
  c = mycpu();
80103f4a:	e8 d1 fb ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80103f4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f55:	e8 66 09 00 00       	call   801048c0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 20 3d 11 80       	push   $0x80113d20
80103f62:	e8 29 08 00 00       	call   80104790 <holding>
80103f67:	83 c4 10             	add    $0x10,%esp
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	74 4f                	je     80103fbd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103f6e:	e8 ad fb ff ff       	call   80103b20 <mycpu>
80103f73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f7a:	75 68                	jne    80103fe4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103f7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f80:	74 55                	je     80103fd7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f82:	9c                   	pushf  
80103f83:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103f84:	f6 c4 02             	test   $0x2,%ah
80103f87:	75 41                	jne    80103fca <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f89:	e8 92 fb ff ff       	call   80103b20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f8e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103f91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f97:	e8 84 fb ff ff       	call   80103b20 <mycpu>
80103f9c:	83 ec 08             	sub    $0x8,%esp
80103f9f:	ff 70 04             	pushl  0x4(%eax)
80103fa2:	53                   	push   %ebx
80103fa3:	e8 33 0c 00 00       	call   80104bdb <swtch>
  mycpu()->intena = intena;
80103fa8:	e8 73 fb ff ff       	call   80103b20 <mycpu>
}
80103fad:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103fb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb9:	5b                   	pop    %ebx
80103fba:	5e                   	pop    %esi
80103fbb:	5d                   	pop    %ebp
80103fbc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103fbd:	83 ec 0c             	sub    $0xc,%esp
80103fc0:	68 10 83 10 80       	push   $0x80108310
80103fc5:	e8 a6 c3 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 3c 83 10 80       	push   $0x8010833c
80103fd2:	e8 99 c3 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 2e 83 10 80       	push   $0x8010832e
80103fdf:	e8 8c c3 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103fe4:	83 ec 0c             	sub    $0xc,%esp
80103fe7:	68 22 83 10 80       	push   $0x80108322
80103fec:	e8 7f c3 ff ff       	call   80100370 <panic>
80103ff1:	eb 0d                	jmp    80104000 <exit>
80103ff3:	90                   	nop
80103ff4:	90                   	nop
80103ff5:	90                   	nop
80103ff6:	90                   	nop
80103ff7:	90                   	nop
80103ff8:	90                   	nop
80103ff9:	90                   	nop
80103ffa:	90                   	nop
80103ffb:	90                   	nop
80103ffc:	90                   	nop
80103ffd:	90                   	nop
80103ffe:	90                   	nop
80103fff:	90                   	nop

80104000 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104009:	e8 c2 07 00 00       	call   801047d0 <pushcli>
  c = mycpu();
8010400e:	e8 0d fb ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104013:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104019:	e8 a2 08 00 00       	call   801048c0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010401e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104024:	8d 5e 28             	lea    0x28(%esi),%ebx
80104027:	8d 7e 68             	lea    0x68(%esi),%edi
8010402a:	0f 84 f1 00 00 00    	je     80104121 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80104030:	8b 03                	mov    (%ebx),%eax
80104032:	85 c0                	test   %eax,%eax
80104034:	74 12                	je     80104048 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104036:	83 ec 0c             	sub    $0xc,%esp
80104039:	50                   	push   %eax
8010403a:	e8 f1 cd ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
8010403f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104045:	83 c4 10             	add    $0x10,%esp
80104048:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010404b:	39 df                	cmp    %ebx,%edi
8010404d:	75 e1                	jne    80104030 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
8010404f:	e8 bc ee ff ff       	call   80102f10 <begin_op>
  iput(curproc->cwd);
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	ff 76 68             	pushl  0x68(%esi)
8010405a:	e8 41 d7 ff ff       	call   801017a0 <iput>
  end_op();
8010405f:	e8 1c ef ff ff       	call   80102f80 <end_op>
  curproc->cwd = 0;
80104064:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
8010406b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104072:	e8 99 07 00 00       	call   80104810 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104077:	8b 56 14             	mov    0x14(%esi),%edx
8010407a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104082:	eb 10                	jmp    80104094 <exit+0x94>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104088:	05 58 02 00 00       	add    $0x258,%eax
8010408d:	3d 54 d3 11 80       	cmp    $0x8011d354,%eax
80104092:	74 1e                	je     801040b2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104094:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104098:	75 ee                	jne    80104088 <exit+0x88>
8010409a:	3b 50 20             	cmp    0x20(%eax),%edx
8010409d:	75 e9                	jne    80104088 <exit+0x88>
      p->state = RUNNABLE;
8010409f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a6:	05 58 02 00 00       	add    $0x258,%eax
801040ab:	3d 54 d3 11 80       	cmp    $0x8011d354,%eax
801040b0:	75 e2                	jne    80104094 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801040b2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
801040b8:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
801040bd:	eb 0f                	jmp    801040ce <exit+0xce>
801040bf:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c0:	81 c2 58 02 00 00    	add    $0x258,%edx
801040c6:	81 fa 54 d3 11 80    	cmp    $0x8011d354,%edx
801040cc:	74 3a                	je     80104108 <exit+0x108>
    if(p->parent == curproc){
801040ce:	39 72 14             	cmp    %esi,0x14(%edx)
801040d1:	75 ed                	jne    801040c0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
801040d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801040d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040da:	75 e4                	jne    801040c0 <exit+0xc0>
801040dc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801040e1:	eb 11                	jmp    801040f4 <exit+0xf4>
801040e3:	90                   	nop
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e8:	05 58 02 00 00       	add    $0x258,%eax
801040ed:	3d 54 d3 11 80       	cmp    $0x8011d354,%eax
801040f2:	74 cc                	je     801040c0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801040f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040f8:	75 ee                	jne    801040e8 <exit+0xe8>
801040fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801040fd:	75 e9                	jne    801040e8 <exit+0xe8>
      p->state = RUNNABLE;
801040ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104106:	eb e0                	jmp    801040e8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104108:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010410f:	e8 2c fe ff ff       	call   80103f40 <sched>
  panic("zombie exit");
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	68 5d 83 10 80       	push   $0x8010835d
8010411c:	e8 4f c2 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104121:	83 ec 0c             	sub    $0xc,%esp
80104124:	68 50 83 10 80       	push   $0x80108350
80104129:	e8 42 c2 ff ff       	call   80100370 <panic>
8010412e:	66 90                	xchg   %ax,%ax

80104130 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104137:	68 20 3d 11 80       	push   $0x80113d20
8010413c:	e8 cf 06 00 00       	call   80104810 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104141:	e8 8a 06 00 00       	call   801047d0 <pushcli>
  c = mycpu();
80104146:	e8 d5 f9 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 6a 07 00 00       	call   801048c0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80104156:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010415d:	e8 de fd ff ff       	call   80103f40 <sched>
  release(&ptable.lock);
80104162:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104169:	e8 c2 07 00 00       	call   80104930 <release>
}
8010416e:	83 c4 10             	add    $0x10,%esp
80104171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104174:	c9                   	leave  
80104175:	c3                   	ret    
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	8b 7d 08             	mov    0x8(%ebp),%edi
8010418c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010418f:	e8 3c 06 00 00       	call   801047d0 <pushcli>
  c = mycpu();
80104194:	e8 87 f9 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
80104199:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010419f:	e8 1c 07 00 00       	call   801048c0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
801041a4:	85 db                	test   %ebx,%ebx
801041a6:	0f 84 87 00 00 00    	je     80104233 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
801041ac:	85 f6                	test   %esi,%esi
801041ae:	74 76                	je     80104226 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041b0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801041b6:	74 50                	je     80104208 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	68 20 3d 11 80       	push   $0x80113d20
801041c0:	e8 4b 06 00 00       	call   80104810 <acquire>
    release(lk);
801041c5:	89 34 24             	mov    %esi,(%esp)
801041c8:	e8 63 07 00 00       	call   80104930 <release>
  }
  // Go to sleep.
  p->chan = chan;
801041cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
801041d7:	e8 64 fd ff ff       	call   80103f40 <sched>

  // Tidy up.
  p->chan = 0;
801041dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801041e3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801041ea:	e8 41 07 00 00       	call   80104930 <release>
    acquire(lk);
801041ef:	89 75 08             	mov    %esi,0x8(%ebp)
801041f2:	83 c4 10             	add    $0x10,%esp
  }
}
801041f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f8:	5b                   	pop    %ebx
801041f9:	5e                   	pop    %esi
801041fa:	5f                   	pop    %edi
801041fb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801041fc:	e9 0f 06 00 00       	jmp    80104810 <acquire>
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104208:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010420b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104212:	e8 29 fd ff ff       	call   80103f40 <sched>

  // Tidy up.
  p->chan = 0;
80104217:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010421e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5f                   	pop    %edi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	68 6f 83 10 80       	push   $0x8010836f
8010422e:	e8 3d c1 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104233:	83 ec 0c             	sub    $0xc,%esp
80104236:	68 69 83 10 80       	push   $0x80108369
8010423b:	e8 30 c1 ff ff       	call   80100370 <panic>

80104240 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104245:	e8 86 05 00 00       	call   801047d0 <pushcli>
  c = mycpu();
8010424a:	e8 d1 f8 ff ff       	call   80103b20 <mycpu>
  p = c->proc;
8010424f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104255:	e8 66 06 00 00       	call   801048c0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010425a:	83 ec 0c             	sub    $0xc,%esp
8010425d:	68 20 3d 11 80       	push   $0x80113d20
80104262:	e8 a9 05 00 00       	call   80104810 <acquire>
80104267:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010426a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104271:	eb 13                	jmp    80104286 <wait+0x46>
80104273:	90                   	nop
80104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104278:	81 c3 58 02 00 00    	add    $0x258,%ebx
8010427e:	81 fb 54 d3 11 80    	cmp    $0x8011d354,%ebx
80104284:	74 22                	je     801042a8 <wait+0x68>
      if(p->parent != curproc)
80104286:	39 73 14             	cmp    %esi,0x14(%ebx)
80104289:	75 ed                	jne    80104278 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010428b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010428f:	74 35                	je     801042c6 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104291:	81 c3 58 02 00 00    	add    $0x258,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104297:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010429c:	81 fb 54 d3 11 80    	cmp    $0x8011d354,%ebx
801042a2:	75 e2                	jne    80104286 <wait+0x46>
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801042a8:	85 c0                	test   %eax,%eax
801042aa:	74 70                	je     8010431c <wait+0xdc>
801042ac:	8b 46 24             	mov    0x24(%esi),%eax
801042af:	85 c0                	test   %eax,%eax
801042b1:	75 69                	jne    8010431c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042b3:	83 ec 08             	sub    $0x8,%esp
801042b6:	68 20 3d 11 80       	push   $0x80113d20
801042bb:	56                   	push   %esi
801042bc:	e8 bf fe ff ff       	call   80104180 <sleep>
  }
801042c1:	83 c4 10             	add    $0x10,%esp
801042c4:	eb a4                	jmp    8010426a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801042c6:	83 ec 0c             	sub    $0xc,%esp
801042c9:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801042cc:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042cf:	e8 cc e3 ff ff       	call   801026a0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801042d4:	5a                   	pop    %edx
801042d5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801042d8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042df:	e8 ec 36 00 00       	call   801079d0 <freevm>
        p->pid = 0;
801042e4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042eb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042f2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042f6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042fd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104304:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010430b:	e8 20 06 00 00       	call   80104930 <release>
        return pid;
80104310:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104313:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104316:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104318:	5b                   	pop    %ebx
80104319:	5e                   	pop    %esi
8010431a:	5d                   	pop    %ebp
8010431b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010431c:	83 ec 0c             	sub    $0xc,%esp
8010431f:	68 20 3d 11 80       	push   $0x80113d20
80104324:	e8 07 06 00 00       	call   80104930 <release>
      return -1;
80104329:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010432c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010432f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104334:	5b                   	pop    %ebx
80104335:	5e                   	pop    %esi
80104336:	5d                   	pop    %ebp
80104337:	c3                   	ret    
80104338:	90                   	nop
80104339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104340 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 10             	sub    $0x10,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010434a:	68 20 3d 11 80       	push   $0x80113d20
8010434f:	e8 bc 04 00 00       	call   80104810 <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104357:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010435c:	eb 0e                	jmp    8010436c <wakeup+0x2c>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	05 58 02 00 00       	add    $0x258,%eax
80104365:	3d 54 d3 11 80       	cmp    $0x8011d354,%eax
8010436a:	74 1e                	je     8010438a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010436c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104370:	75 ee                	jne    80104360 <wakeup+0x20>
80104372:	3b 58 20             	cmp    0x20(%eax),%ebx
80104375:	75 e9                	jne    80104360 <wakeup+0x20>
      p->state = RUNNABLE;
80104377:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010437e:	05 58 02 00 00       	add    $0x258,%eax
80104383:	3d 54 d3 11 80       	cmp    $0x8011d354,%eax
80104388:	75 e2                	jne    8010436c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010438a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104394:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104395:	e9 96 05 00 00       	jmp    80104930 <release>
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
801043a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043aa:	68 20 3d 11 80       	push   $0x80113d20
801043af:	e8 5c 04 00 00       	call   80104810 <acquire>
801043b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043b7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801043bc:	eb 0e                	jmp    801043cc <kill+0x2c>
801043be:	66 90                	xchg   %ax,%ax
801043c0:	05 58 02 00 00       	add    $0x258,%eax
801043c5:	3d 54 d3 11 80       	cmp    $0x8011d354,%eax
801043ca:	74 3c                	je     80104408 <kill+0x68>
    if(p->pid == pid){
801043cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801043cf:	75 ef                	jne    801043c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801043d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043dc:	74 1a                	je     801043f8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801043de:	83 ec 0c             	sub    $0xc,%esp
801043e1:	68 20 3d 11 80       	push   $0x80113d20
801043e6:	e8 45 05 00 00       	call   80104930 <release>
      return 0;
801043eb:	83 c4 10             	add    $0x10,%esp
801043ee:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801043f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f3:	c9                   	leave  
801043f4:	c3                   	ret    
801043f5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801043f8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043ff:	eb dd                	jmp    801043de <kill+0x3e>
80104401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104408:	83 ec 0c             	sub    $0xc,%esp
8010440b:	68 20 3d 11 80       	push   $0x80113d20
80104410:	e8 1b 05 00 00       	call   80104930 <release>
  return -1;
80104415:	83 c4 10             	add    $0x10,%esp
80104418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010441d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104420:	c9                   	leave  
80104421:	c3                   	ret    
80104422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104430 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	53                   	push   %ebx
80104436:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104439:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010443e:	83 ec 3c             	sub    $0x3c,%esp
80104441:	eb 27                	jmp    8010446a <procdump+0x3a>
80104443:	90                   	nop
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	68 44 87 10 80       	push   $0x80108744
80104450:	e8 0b c2 ff ff       	call   80100660 <cprintf>
80104455:	83 c4 10             	add    $0x10,%esp
80104458:	81 c3 58 02 00 00    	add    $0x258,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010445e:	81 fb c0 d3 11 80    	cmp    $0x8011d3c0,%ebx
80104464:	0f 84 7e 00 00 00    	je     801044e8 <procdump+0xb8>
    if(p->state == UNUSED)
8010446a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010446d:	85 c0                	test   %eax,%eax
8010446f:	74 e7                	je     80104458 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104471:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104474:	ba 80 83 10 80       	mov    $0x80108380,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104479:	77 11                	ja     8010448c <procdump+0x5c>
8010447b:	8b 14 85 e8 83 10 80 	mov    -0x7fef7c18(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104482:	b8 80 83 10 80       	mov    $0x80108380,%eax
80104487:	85 d2                	test   %edx,%edx
80104489:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010448c:	53                   	push   %ebx
8010448d:	52                   	push   %edx
8010448e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104491:	68 84 83 10 80       	push   $0x80108384
80104496:	e8 c5 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010449b:	83 c4 10             	add    $0x10,%esp
8010449e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801044a2:	75 a4                	jne    80104448 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044a7:	83 ec 08             	sub    $0x8,%esp
801044aa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044ad:	50                   	push   %eax
801044ae:	8b 43 b0             	mov    -0x50(%ebx),%eax
801044b1:	8b 40 0c             	mov    0xc(%eax),%eax
801044b4:	83 c0 08             	add    $0x8,%eax
801044b7:	50                   	push   %eax
801044b8:	e8 73 02 00 00       	call   80104730 <getcallerpcs>
801044bd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044c0:	8b 17                	mov    (%edi),%edx
801044c2:	85 d2                	test   %edx,%edx
801044c4:	74 82                	je     80104448 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044c6:	83 ec 08             	sub    $0x8,%esp
801044c9:	83 c7 04             	add    $0x4,%edi
801044cc:	52                   	push   %edx
801044cd:	68 41 7d 10 80       	push   $0x80107d41
801044d2:	e8 89 c1 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801044d7:	83 c4 10             	add    $0x10,%esp
801044da:	39 f7                	cmp    %esi,%edi
801044dc:	75 e2                	jne    801044c0 <procdump+0x90>
801044de:	e9 65 ff ff ff       	jmp    80104448 <procdump+0x18>
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801044e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044eb:	5b                   	pop    %ebx
801044ec:	5e                   	pop    %esi
801044ed:	5f                   	pop    %edi
801044ee:	5d                   	pop    %ebp
801044ef:	c3                   	ret    

801044f0 <accessesUpdate>:
void 
accessesUpdate() {
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
    struct proc *p;
    pde_t *pde;
    pte_t *pgtab;
    pte_t * pte;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f5:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    cprintf("\n");
  }
}
void 
accessesUpdate() {
  acquire(&ptable.lock);
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	68 20 3d 11 80       	push   $0x80113d20
80104502:	e8 09 03 00 00       	call   80104810 <acquire>
80104507:	83 c4 10             	add    $0x10,%esp
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte_t *pgtab;
    pte_t * pte;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
        if (p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING)
80104510:	8b 43 0c             	mov    0xc(%ebx),%eax
80104513:	83 e8 02             	sub    $0x2,%eax
80104516:	83 f8 02             	cmp    $0x2,%eax
80104519:	77 4f                	ja     8010456a <accessesUpdate+0x7a>
        {
            struct pageLink *currPage=p->pagesHead;
8010451b:	8b 83 50 02 00 00    	mov    0x250(%ebx),%eax
           while (currPage)
80104521:	85 c0                	test   %eax,%eax
80104523:	74 45                	je     8010456a <accessesUpdate+0x7a>
80104525:	8d 76 00             	lea    0x0(%esi),%esi
            {
                pde = &p->pgdir[PDX((char*)currPage->va)];
80104528:	8b 50 04             	mov    0x4(%eax),%edx
                if(*pde & PTE_P){                    
8010452b:	8b 4b 04             	mov    0x4(%ebx),%ecx
8010452e:	89 d6                	mov    %edx,%esi
80104530:	c1 ee 16             	shr    $0x16,%esi
80104533:	8b 0c b1             	mov    (%ecx,%esi,4),%ecx
80104536:	f6 c1 01             	test   $0x1,%cl
80104539:	74 28                	je     80104563 <accessesUpdate+0x73>
                    pgtab = (pte_t*)((PTE_ADDR(*pde)) + KERNBASE);
                    pte = &pgtab[PTX((char*)currPage->va)];
8010453b:	c1 ea 0a             	shr    $0xa,%edx
8010453e:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80104544:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
8010454a:	8d 8c 11 00 00 00 80 	lea    -0x80000000(%ecx,%edx,1),%ecx
                    if ((*pte) & PTE_A){ 
80104551:	8b 11                	mov    (%ecx),%edx
80104553:	f6 c2 20             	test   $0x20,%dl
80104556:	74 06                	je     8010455e <accessesUpdate+0x6e>
                        currPage->accesses++;
80104558:	83 40 08 01          	addl   $0x1,0x8(%eax)
8010455c:	8b 11                	mov    (%ecx),%edx
                    }
                    *pte &= ~PTE_A;  
8010455e:	83 e2 df             	and    $0xffffffdf,%edx
80104561:	89 11                	mov    %edx,(%ecx)
                }      
                currPage = currPage->next;          
80104563:	8b 40 10             	mov    0x10(%eax),%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
        if (p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING)
        {
            struct pageLink *currPage=p->pagesHead;
           while (currPage)
80104566:	85 c0                	test   %eax,%eax
80104568:	75 be                	jne    80104528 <accessesUpdate+0x38>
    struct proc *p;
    pde_t *pde;
    pte_t *pgtab;
    pte_t * pte;

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010456a:	81 c3 58 02 00 00    	add    $0x258,%ebx
80104570:	81 fb 54 d3 11 80    	cmp    $0x8011d354,%ebx
80104576:	75 98                	jne    80104510 <accessesUpdate+0x20>
                }      
                currPage = currPage->next;          
            }
        }
    }
    release(&ptable.lock);
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	68 20 3d 11 80       	push   $0x80113d20
80104580:	e8 ab 03 00 00       	call   80104930 <release>
}
80104585:	83 c4 10             	add    $0x10,%esp
80104588:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010458b:	5b                   	pop    %ebx
8010458c:	5e                   	pop    %esi
8010458d:	5d                   	pop    %ebp
8010458e:	c3                   	ret    
8010458f:	90                   	nop

80104590 <isInitOrShell>:

int isInitOrShell(struct proc * process)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 04             	sub    $0x4,%esp
80104597:	8b 45 08             	mov    0x8(%ebp),%eax
    return (process == 0 || !(namecmp(process->name, "init") && namecmp(process->name, "sh") && namecmp(process->name, "initcode"))); 
8010459a:	85 c0                	test   %eax,%eax
8010459c:	74 18                	je     801045b6 <isInitOrShell+0x26>
8010459e:	8d 58 6c             	lea    0x6c(%eax),%ebx
801045a1:	83 ec 08             	sub    $0x8,%esp
801045a4:	68 8d 83 10 80       	push   $0x8010838d
801045a9:	53                   	push   %ebx
801045aa:	e8 d1 d5 ff ff       	call   80101b80 <namecmp>
801045af:	83 c4 10             	add    $0x10,%esp
801045b2:	85 c0                	test   %eax,%eax
801045b4:	75 0a                	jne    801045c0 <isInitOrShell+0x30>
801045b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801045bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045be:	c9                   	leave  
801045bf:	c3                   	ret    
    release(&ptable.lock);
}

int isInitOrShell(struct proc * process)
{
    return (process == 0 || !(namecmp(process->name, "init") && namecmp(process->name, "sh") && namecmp(process->name, "initcode"))); 
801045c0:	83 ec 08             	sub    $0x8,%esp
801045c3:	68 92 83 10 80       	push   $0x80108392
801045c8:	53                   	push   %ebx
801045c9:	e8 b2 d5 ff ff       	call   80101b80 <namecmp>
801045ce:	83 c4 10             	add    $0x10,%esp
801045d1:	85 c0                	test   %eax,%eax
801045d3:	74 e1                	je     801045b6 <isInitOrShell+0x26>
801045d5:	83 ec 08             	sub    $0x8,%esp
801045d8:	68 05 83 10 80       	push   $0x80108305
801045dd:	53                   	push   %ebx
801045de:	e8 9d d5 ff ff       	call   80101b80 <namecmp>
801045e3:	83 c4 10             	add    $0x10,%esp
801045e6:	85 c0                	test   %eax,%eax
}
801045e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    release(&ptable.lock);
}

int isInitOrShell(struct proc * process)
{
    return (process == 0 || !(namecmp(process->name, "init") && namecmp(process->name, "sh") && namecmp(process->name, "initcode"))); 
801045eb:	0f 94 c0             	sete   %al
}
801045ee:	c9                   	leave  
    release(&ptable.lock);
}

int isInitOrShell(struct proc * process)
{
    return (process == 0 || !(namecmp(process->name, "init") && namecmp(process->name, "sh") && namecmp(process->name, "initcode"))); 
801045ef:	0f b6 c0             	movzbl %al,%eax
}
801045f2:	c3                   	ret    
801045f3:	66 90                	xchg   %ax,%ax
801045f5:	66 90                	xchg   %ax,%ax
801045f7:	66 90                	xchg   %ax,%ax
801045f9:	66 90                	xchg   %ax,%ax
801045fb:	66 90                	xchg   %ax,%ax
801045fd:	66 90                	xchg   %ax,%ax
801045ff:	90                   	nop

80104600 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 0c             	sub    $0xc,%esp
80104607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010460a:	68 00 84 10 80       	push   $0x80108400
8010460f:	8d 43 04             	lea    0x4(%ebx),%eax
80104612:	50                   	push   %eax
80104613:	e8 f8 00 00 00       	call   80104710 <initlock>
  lk->name = name;
80104618:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010461b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104621:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104624:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010462b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010462e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104631:	c9                   	leave  
80104632:	c3                   	ret    
80104633:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	8d 73 04             	lea    0x4(%ebx),%esi
8010464e:	56                   	push   %esi
8010464f:	e8 bc 01 00 00       	call   80104810 <acquire>
  while (lk->locked) {
80104654:	8b 13                	mov    (%ebx),%edx
80104656:	83 c4 10             	add    $0x10,%esp
80104659:	85 d2                	test   %edx,%edx
8010465b:	74 16                	je     80104673 <acquiresleep+0x33>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104660:	83 ec 08             	sub    $0x8,%esp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	e8 16 fb ff ff       	call   80104180 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010466a:	8b 03                	mov    (%ebx),%eax
8010466c:	83 c4 10             	add    $0x10,%esp
8010466f:	85 c0                	test   %eax,%eax
80104671:	75 ed                	jne    80104660 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104673:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104679:	e8 42 f5 ff ff       	call   80103bc0 <myproc>
8010467e:	8b 40 10             	mov    0x10(%eax),%eax
80104681:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104684:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104687:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010468a:	5b                   	pop    %ebx
8010468b:	5e                   	pop    %esi
8010468c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010468d:	e9 9e 02 00 00       	jmp    80104930 <release>
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	8d 73 04             	lea    0x4(%ebx),%esi
801046ae:	56                   	push   %esi
801046af:	e8 5c 01 00 00       	call   80104810 <acquire>
  lk->locked = 0;
801046b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046c1:	89 1c 24             	mov    %ebx,(%esp)
801046c4:	e8 77 fc ff ff       	call   80104340 <wakeup>
  release(&lk->lk);
801046c9:	89 75 08             	mov    %esi,0x8(%ebp)
801046cc:	83 c4 10             	add    $0x10,%esp
}
801046cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d2:	5b                   	pop    %ebx
801046d3:	5e                   	pop    %esi
801046d4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801046d5:	e9 56 02 00 00       	jmp    80104930 <release>
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046e0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	8d 5e 04             	lea    0x4(%esi),%ebx
801046ee:	53                   	push   %ebx
801046ef:	e8 1c 01 00 00       	call   80104810 <acquire>
  r = lk->locked;
801046f4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801046f6:	89 1c 24             	mov    %ebx,(%esp)
801046f9:	e8 32 02 00 00       	call   80104930 <release>
  return r;
}
801046fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104701:	89 f0                	mov    %esi,%eax
80104703:	5b                   	pop    %ebx
80104704:	5e                   	pop    %esi
80104705:	5d                   	pop    %ebp
80104706:	c3                   	ret    
80104707:	66 90                	xchg   %ax,%ax
80104709:	66 90                	xchg   %ax,%ax
8010470b:	66 90                	xchg   %ax,%ax
8010470d:	66 90                	xchg   %ax,%ax
8010470f:	90                   	nop

80104710 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104716:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010471f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104722:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    
8010472b:	90                   	nop
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104734:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104737:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010473a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010473d:	31 c0                	xor    %eax,%eax
8010473f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104740:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104746:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010474c:	77 1a                	ja     80104768 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010474e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104751:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104754:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104757:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104759:	83 f8 0a             	cmp    $0xa,%eax
8010475c:	75 e2                	jne    80104740 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010475e:	5b                   	pop    %ebx
8010475f:	5d                   	pop    %ebp
80104760:	c3                   	ret    
80104761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104768:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010476f:	83 c0 01             	add    $0x1,%eax
80104772:	83 f8 0a             	cmp    $0xa,%eax
80104775:	74 e7                	je     8010475e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104777:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010477e:	83 c0 01             	add    $0x1,%eax
80104781:	83 f8 0a             	cmp    $0xa,%eax
80104784:	75 e2                	jne    80104768 <getcallerpcs+0x38>
80104786:	eb d6                	jmp    8010475e <getcallerpcs+0x2e>
80104788:	90                   	nop
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104790 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 04             	sub    $0x4,%esp
80104797:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010479a:	8b 02                	mov    (%edx),%eax
8010479c:	85 c0                	test   %eax,%eax
8010479e:	75 10                	jne    801047b0 <holding+0x20>
}
801047a0:	83 c4 04             	add    $0x4,%esp
801047a3:	31 c0                	xor    %eax,%eax
801047a5:	5b                   	pop    %ebx
801047a6:	5d                   	pop    %ebp
801047a7:	c3                   	ret    
801047a8:	90                   	nop
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801047b0:	8b 5a 08             	mov    0x8(%edx),%ebx
801047b3:	e8 68 f3 ff ff       	call   80103b20 <mycpu>
801047b8:	39 c3                	cmp    %eax,%ebx
801047ba:	0f 94 c0             	sete   %al
}
801047bd:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801047c0:	0f b6 c0             	movzbl %al,%eax
}
801047c3:	5b                   	pop    %ebx
801047c4:	5d                   	pop    %ebp
801047c5:	c3                   	ret    
801047c6:	8d 76 00             	lea    0x0(%esi),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 04             	sub    $0x4,%esp
801047d7:	9c                   	pushf  
801047d8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801047d9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047da:	e8 41 f3 ff ff       	call   80103b20 <mycpu>
801047df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047e5:	85 c0                	test   %eax,%eax
801047e7:	75 11                	jne    801047fa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801047e9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047ef:	e8 2c f3 ff ff       	call   80103b20 <mycpu>
801047f4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801047fa:	e8 21 f3 ff ff       	call   80103b20 <mycpu>
801047ff:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104806:	83 c4 04             	add    $0x4,%esp
80104809:	5b                   	pop    %ebx
8010480a:	5d                   	pop    %ebp
8010480b:	c3                   	ret    
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104810 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104815:	e8 b6 ff ff ff       	call   801047d0 <pushcli>
  if(holding(lk))
8010481a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010481d:	8b 03                	mov    (%ebx),%eax
8010481f:	85 c0                	test   %eax,%eax
80104821:	75 7d                	jne    801048a0 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104823:	ba 01 00 00 00       	mov    $0x1,%edx
80104828:	eb 09                	jmp    80104833 <acquire+0x23>
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104830:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104833:	89 d0                	mov    %edx,%eax
80104835:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104838:	85 c0                	test   %eax,%eax
8010483a:	75 f4                	jne    80104830 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010483c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104841:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104844:	e8 d7 f2 ff ff       	call   80103b20 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104849:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010484b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010484e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104851:	31 c0                	xor    %eax,%eax
80104853:	90                   	nop
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104858:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010485e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104864:	77 1a                	ja     80104880 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104866:	8b 5a 04             	mov    0x4(%edx),%ebx
80104869:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010486c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010486f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104871:	83 f8 0a             	cmp    $0xa,%eax
80104874:	75 e2                	jne    80104858 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104876:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104879:	5b                   	pop    %ebx
8010487a:	5e                   	pop    %esi
8010487b:	5d                   	pop    %ebp
8010487c:	c3                   	ret    
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104880:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104887:	83 c0 01             	add    $0x1,%eax
8010488a:	83 f8 0a             	cmp    $0xa,%eax
8010488d:	74 e7                	je     80104876 <acquire+0x66>
    pcs[i] = 0;
8010488f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104896:	83 c0 01             	add    $0x1,%eax
80104899:	83 f8 0a             	cmp    $0xa,%eax
8010489c:	75 e2                	jne    80104880 <acquire+0x70>
8010489e:	eb d6                	jmp    80104876 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801048a0:	8b 73 08             	mov    0x8(%ebx),%esi
801048a3:	e8 78 f2 ff ff       	call   80103b20 <mycpu>
801048a8:	39 c6                	cmp    %eax,%esi
801048aa:	0f 85 73 ff ff ff    	jne    80104823 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801048b0:	83 ec 0c             	sub    $0xc,%esp
801048b3:	68 0b 84 10 80       	push   $0x8010840b
801048b8:	e8 b3 ba ff ff       	call   80100370 <panic>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi

801048c0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048c6:	9c                   	pushf  
801048c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048c8:	f6 c4 02             	test   $0x2,%ah
801048cb:	75 52                	jne    8010491f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048cd:	e8 4e f2 ff ff       	call   80103b20 <mycpu>
801048d2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801048d8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801048db:	85 d2                	test   %edx,%edx
801048dd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801048e3:	78 2d                	js     80104912 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048e5:	e8 36 f2 ff ff       	call   80103b20 <mycpu>
801048ea:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048f0:	85 d2                	test   %edx,%edx
801048f2:	74 0c                	je     80104900 <popcli+0x40>
    sti();
}
801048f4:	c9                   	leave  
801048f5:	c3                   	ret    
801048f6:	8d 76 00             	lea    0x0(%esi),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104900:	e8 1b f2 ff ff       	call   80103b20 <mycpu>
80104905:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010490b:	85 c0                	test   %eax,%eax
8010490d:	74 e5                	je     801048f4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010490f:	fb                   	sti    
    sti();
}
80104910:	c9                   	leave  
80104911:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104912:	83 ec 0c             	sub    $0xc,%esp
80104915:	68 2a 84 10 80       	push   $0x8010842a
8010491a:	e8 51 ba ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	68 13 84 10 80       	push   $0x80108413
80104927:	e8 44 ba ff ff       	call   80100370 <panic>
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104930 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
80104935:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104938:	8b 03                	mov    (%ebx),%eax
8010493a:	85 c0                	test   %eax,%eax
8010493c:	75 12                	jne    80104950 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010493e:	83 ec 0c             	sub    $0xc,%esp
80104941:	68 31 84 10 80       	push   $0x80108431
80104946:	e8 25 ba ff ff       	call   80100370 <panic>
8010494b:	90                   	nop
8010494c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104950:	8b 73 08             	mov    0x8(%ebx),%esi
80104953:	e8 c8 f1 ff ff       	call   80103b20 <mycpu>
80104958:	39 c6                	cmp    %eax,%esi
8010495a:	75 e2                	jne    8010493e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
8010495c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104963:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010496a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010496f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104975:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104978:	5b                   	pop    %ebx
80104979:	5e                   	pop    %esi
8010497a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010497b:	e9 40 ff ff ff       	jmp    801048c0 <popcli>

80104980 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	53                   	push   %ebx
80104985:	8b 55 08             	mov    0x8(%ebp),%edx
80104988:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010498b:	f6 c2 03             	test   $0x3,%dl
8010498e:	75 05                	jne    80104995 <memset+0x15>
80104990:	f6 c1 03             	test   $0x3,%cl
80104993:	74 13                	je     801049a8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104995:	89 d7                	mov    %edx,%edi
80104997:	8b 45 0c             	mov    0xc(%ebp),%eax
8010499a:	fc                   	cld    
8010499b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010499d:	5b                   	pop    %ebx
8010499e:	89 d0                	mov    %edx,%eax
801049a0:	5f                   	pop    %edi
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
801049a3:	90                   	nop
801049a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801049a8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801049ac:	c1 e9 02             	shr    $0x2,%ecx
801049af:	89 fb                	mov    %edi,%ebx
801049b1:	89 f8                	mov    %edi,%eax
801049b3:	c1 e3 18             	shl    $0x18,%ebx
801049b6:	c1 e0 10             	shl    $0x10,%eax
801049b9:	09 d8                	or     %ebx,%eax
801049bb:	09 f8                	or     %edi,%eax
801049bd:	c1 e7 08             	shl    $0x8,%edi
801049c0:	09 f8                	or     %edi,%eax
801049c2:	89 d7                	mov    %edx,%edi
801049c4:	fc                   	cld    
801049c5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801049c7:	5b                   	pop    %ebx
801049c8:	89 d0                	mov    %edx,%eax
801049ca:	5f                   	pop    %edi
801049cb:	5d                   	pop    %ebp
801049cc:	c3                   	ret    
801049cd:	8d 76 00             	lea    0x0(%esi),%esi

801049d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	8b 45 10             	mov    0x10(%ebp),%eax
801049d8:	53                   	push   %ebx
801049d9:	8b 75 0c             	mov    0xc(%ebp),%esi
801049dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049df:	85 c0                	test   %eax,%eax
801049e1:	74 29                	je     80104a0c <memcmp+0x3c>
    if(*s1 != *s2)
801049e3:	0f b6 13             	movzbl (%ebx),%edx
801049e6:	0f b6 0e             	movzbl (%esi),%ecx
801049e9:	38 d1                	cmp    %dl,%cl
801049eb:	75 2b                	jne    80104a18 <memcmp+0x48>
801049ed:	8d 78 ff             	lea    -0x1(%eax),%edi
801049f0:	31 c0                	xor    %eax,%eax
801049f2:	eb 14                	jmp    80104a08 <memcmp+0x38>
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049f8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801049fd:	83 c0 01             	add    $0x1,%eax
80104a00:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a04:	38 ca                	cmp    %cl,%dl
80104a06:	75 10                	jne    80104a18 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a08:	39 f8                	cmp    %edi,%eax
80104a0a:	75 ec                	jne    801049f8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104a0c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104a0d:	31 c0                	xor    %eax,%eax
}
80104a0f:	5e                   	pop    %esi
80104a10:	5f                   	pop    %edi
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	90                   	nop
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104a18:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104a1b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104a1c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104a1e:	5e                   	pop    %esi
80104a1f:	5f                   	pop    %edi
80104a20:	5d                   	pop    %ebp
80104a21:	c3                   	ret    
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
80104a35:	8b 45 08             	mov    0x8(%ebp),%eax
80104a38:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a3e:	39 c6                	cmp    %eax,%esi
80104a40:	73 2e                	jae    80104a70 <memmove+0x40>
80104a42:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104a45:	39 c8                	cmp    %ecx,%eax
80104a47:	73 27                	jae    80104a70 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104a49:	85 db                	test   %ebx,%ebx
80104a4b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104a4e:	74 17                	je     80104a67 <memmove+0x37>
      *--d = *--s;
80104a50:	29 d9                	sub    %ebx,%ecx
80104a52:	89 cb                	mov    %ecx,%ebx
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a58:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a5c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104a5f:	83 ea 01             	sub    $0x1,%edx
80104a62:	83 fa ff             	cmp    $0xffffffff,%edx
80104a65:	75 f1                	jne    80104a58 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a67:	5b                   	pop    %ebx
80104a68:	5e                   	pop    %esi
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret    
80104a6b:	90                   	nop
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104a70:	31 d2                	xor    %edx,%edx
80104a72:	85 db                	test   %ebx,%ebx
80104a74:	74 f1                	je     80104a67 <memmove+0x37>
80104a76:	8d 76 00             	lea    0x0(%esi),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104a80:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104a84:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a87:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104a8a:	39 d3                	cmp    %edx,%ebx
80104a8c:	75 f2                	jne    80104a80 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104a8e:	5b                   	pop    %ebx
80104a8f:	5e                   	pop    %esi
80104a90:	5d                   	pop    %ebp
80104a91:	c3                   	ret    
80104a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104aa3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104aa4:	eb 8a                	jmp    80104a30 <memmove>
80104aa6:	8d 76 00             	lea    0x0(%esi),%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ab8:	53                   	push   %ebx
80104ab9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104abc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104abf:	85 c9                	test   %ecx,%ecx
80104ac1:	74 37                	je     80104afa <strncmp+0x4a>
80104ac3:	0f b6 17             	movzbl (%edi),%edx
80104ac6:	0f b6 1e             	movzbl (%esi),%ebx
80104ac9:	84 d2                	test   %dl,%dl
80104acb:	74 3f                	je     80104b0c <strncmp+0x5c>
80104acd:	38 d3                	cmp    %dl,%bl
80104acf:	75 3b                	jne    80104b0c <strncmp+0x5c>
80104ad1:	8d 47 01             	lea    0x1(%edi),%eax
80104ad4:	01 cf                	add    %ecx,%edi
80104ad6:	eb 1b                	jmp    80104af3 <strncmp+0x43>
80104ad8:	90                   	nop
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae0:	0f b6 10             	movzbl (%eax),%edx
80104ae3:	84 d2                	test   %dl,%dl
80104ae5:	74 21                	je     80104b08 <strncmp+0x58>
80104ae7:	0f b6 19             	movzbl (%ecx),%ebx
80104aea:	83 c0 01             	add    $0x1,%eax
80104aed:	89 ce                	mov    %ecx,%esi
80104aef:	38 da                	cmp    %bl,%dl
80104af1:	75 19                	jne    80104b0c <strncmp+0x5c>
80104af3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104af5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104af8:	75 e6                	jne    80104ae0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104afa:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104afb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104afd:	5e                   	pop    %esi
80104afe:	5f                   	pop    %edi
80104aff:	5d                   	pop    %ebp
80104b00:	c3                   	ret    
80104b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b08:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b0c:	0f b6 c2             	movzbl %dl,%eax
80104b0f:	29 d8                	sub    %ebx,%eax
}
80104b11:	5b                   	pop    %ebx
80104b12:	5e                   	pop    %esi
80104b13:	5f                   	pop    %edi
80104b14:	5d                   	pop    %ebp
80104b15:	c3                   	ret    
80104b16:	8d 76 00             	lea    0x0(%esi),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 45 08             	mov    0x8(%ebp),%eax
80104b28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b2e:	89 c2                	mov    %eax,%edx
80104b30:	eb 19                	jmp    80104b4b <strncpy+0x2b>
80104b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b38:	83 c3 01             	add    $0x1,%ebx
80104b3b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b3f:	83 c2 01             	add    $0x1,%edx
80104b42:	84 c9                	test   %cl,%cl
80104b44:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b47:	74 09                	je     80104b52 <strncpy+0x32>
80104b49:	89 f1                	mov    %esi,%ecx
80104b4b:	85 c9                	test   %ecx,%ecx
80104b4d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b50:	7f e6                	jg     80104b38 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b52:	31 c9                	xor    %ecx,%ecx
80104b54:	85 f6                	test   %esi,%esi
80104b56:	7e 17                	jle    80104b6f <strncpy+0x4f>
80104b58:	90                   	nop
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b60:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104b64:	89 f3                	mov    %esi,%ebx
80104b66:	83 c1 01             	add    $0x1,%ecx
80104b69:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104b6b:	85 db                	test   %ebx,%ebx
80104b6d:	7f f1                	jg     80104b60 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104b6f:	5b                   	pop    %ebx
80104b70:	5e                   	pop    %esi
80104b71:	5d                   	pop    %ebp
80104b72:	c3                   	ret    
80104b73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b88:	8b 45 08             	mov    0x8(%ebp),%eax
80104b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b8e:	85 c9                	test   %ecx,%ecx
80104b90:	7e 26                	jle    80104bb8 <safestrcpy+0x38>
80104b92:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b96:	89 c1                	mov    %eax,%ecx
80104b98:	eb 17                	jmp    80104bb1 <safestrcpy+0x31>
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ba0:	83 c2 01             	add    $0x1,%edx
80104ba3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ba7:	83 c1 01             	add    $0x1,%ecx
80104baa:	84 db                	test   %bl,%bl
80104bac:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104baf:	74 04                	je     80104bb5 <safestrcpy+0x35>
80104bb1:	39 f2                	cmp    %esi,%edx
80104bb3:	75 eb                	jne    80104ba0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bb5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104bb8:	5b                   	pop    %ebx
80104bb9:	5e                   	pop    %esi
80104bba:	5d                   	pop    %ebp
80104bbb:	c3                   	ret    
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <strlen>:

int
strlen(const char *s)
{
80104bc0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104bc1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104bc8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bcb:	74 0c                	je     80104bd9 <strlen+0x19>
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
80104bd0:	83 c0 01             	add    $0x1,%eax
80104bd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bd7:	75 f7                	jne    80104bd0 <strlen+0x10>
    ;
  return n;
}
80104bd9:	5d                   	pop    %ebp
80104bda:	c3                   	ret    

80104bdb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bdb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bdf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104be3:	55                   	push   %ebp
  pushl %ebx
80104be4:	53                   	push   %ebx
  pushl %esi
80104be5:	56                   	push   %esi
  pushl %edi
80104be6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104be7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104be9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104beb:	5f                   	pop    %edi
  popl %esi
80104bec:	5e                   	pop    %esi
  popl %ebx
80104bed:	5b                   	pop    %ebx
  popl %ebp
80104bee:	5d                   	pop    %ebp
  ret
80104bef:	c3                   	ret    

80104bf0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
80104bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bfa:	e8 c1 ef ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bff:	8b 00                	mov    (%eax),%eax
80104c01:	39 d8                	cmp    %ebx,%eax
80104c03:	76 1b                	jbe    80104c20 <fetchint+0x30>
80104c05:	8d 53 04             	lea    0x4(%ebx),%edx
80104c08:	39 d0                	cmp    %edx,%eax
80104c0a:	72 14                	jb     80104c20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c0f:	8b 13                	mov    (%ebx),%edx
80104c11:	89 10                	mov    %edx,(%eax)
  return 0;
80104c13:	31 c0                	xor    %eax,%eax
}
80104c15:	83 c4 04             	add    $0x4,%esp
80104c18:	5b                   	pop    %ebx
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    
80104c1b:	90                   	nop
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c25:	eb ee                	jmp    80104c15 <fetchint+0x25>
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
80104c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c3a:	e8 81 ef ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz)
80104c3f:	39 18                	cmp    %ebx,(%eax)
80104c41:	76 29                	jbe    80104c6c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c46:	89 da                	mov    %ebx,%edx
80104c48:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c4a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c4c:	39 c3                	cmp    %eax,%ebx
80104c4e:	73 1c                	jae    80104c6c <fetchstr+0x3c>
    if(*s == 0)
80104c50:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c53:	75 10                	jne    80104c65 <fetchstr+0x35>
80104c55:	eb 29                	jmp    80104c80 <fetchstr+0x50>
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c60:	80 3a 00             	cmpb   $0x0,(%edx)
80104c63:	74 1b                	je     80104c80 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104c65:	83 c2 01             	add    $0x1,%edx
80104c68:	39 d0                	cmp    %edx,%eax
80104c6a:	77 f4                	ja     80104c60 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104c6c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104c6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104c74:	5b                   	pop    %ebx
80104c75:	5d                   	pop    %ebp
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c80:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104c83:	89 d0                	mov    %edx,%eax
80104c85:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c87:	5b                   	pop    %ebx
80104c88:	5d                   	pop    %ebp
80104c89:	c3                   	ret    
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c95:	e8 26 ef ff ff       	call   80103bc0 <myproc>
80104c9a:	8b 40 18             	mov    0x18(%eax),%eax
80104c9d:	8b 55 08             	mov    0x8(%ebp),%edx
80104ca0:	8b 40 44             	mov    0x44(%eax),%eax
80104ca3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104ca6:	e8 15 ef ff ff       	call   80103bc0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cab:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cad:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cb0:	39 c6                	cmp    %eax,%esi
80104cb2:	73 1c                	jae    80104cd0 <argint+0x40>
80104cb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cb7:	39 d0                	cmp    %edx,%eax
80104cb9:	72 15                	jb     80104cd0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cbe:	8b 53 04             	mov    0x4(%ebx),%edx
80104cc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cc3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104cc5:	5b                   	pop    %ebx
80104cc6:	5e                   	pop    %esi
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb ee                	jmp    80104cc5 <argint+0x35>
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	83 ec 10             	sub    $0x10,%esp
80104ce8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ceb:	e8 d0 ee ff ff       	call   80103bc0 <myproc>
80104cf0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104cf2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cf5:	83 ec 08             	sub    $0x8,%esp
80104cf8:	50                   	push   %eax
80104cf9:	ff 75 08             	pushl  0x8(%ebp)
80104cfc:	e8 8f ff ff ff       	call   80104c90 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d01:	c1 e8 1f             	shr    $0x1f,%eax
80104d04:	83 c4 10             	add    $0x10,%esp
80104d07:	84 c0                	test   %al,%al
80104d09:	75 2d                	jne    80104d38 <argptr+0x58>
80104d0b:	89 d8                	mov    %ebx,%eax
80104d0d:	c1 e8 1f             	shr    $0x1f,%eax
80104d10:	84 c0                	test   %al,%al
80104d12:	75 24                	jne    80104d38 <argptr+0x58>
80104d14:	8b 16                	mov    (%esi),%edx
80104d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d19:	39 c2                	cmp    %eax,%edx
80104d1b:	76 1b                	jbe    80104d38 <argptr+0x58>
80104d1d:	01 c3                	add    %eax,%ebx
80104d1f:	39 da                	cmp    %ebx,%edx
80104d21:	72 15                	jb     80104d38 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104d23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d26:	89 02                	mov    %eax,(%edx)
  return 0;
80104d28:	31 c0                	xor    %eax,%eax
}
80104d2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d2d:	5b                   	pop    %ebx
80104d2e:	5e                   	pop    %esi
80104d2f:	5d                   	pop    %ebp
80104d30:	c3                   	ret    
80104d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3d:	eb eb                	jmp    80104d2a <argptr+0x4a>
80104d3f:	90                   	nop

80104d40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d49:	50                   	push   %eax
80104d4a:	ff 75 08             	pushl  0x8(%ebp)
80104d4d:	e8 3e ff ff ff       	call   80104c90 <argint>
80104d52:	83 c4 10             	add    $0x10,%esp
80104d55:	85 c0                	test   %eax,%eax
80104d57:	78 17                	js     80104d70 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d59:	83 ec 08             	sub    $0x8,%esp
80104d5c:	ff 75 0c             	pushl  0xc(%ebp)
80104d5f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d62:	e8 c9 fe ff ff       	call   80104c30 <fetchstr>
80104d67:	83 c4 10             	add    $0x10,%esp
}
80104d6a:	c9                   	leave  
80104d6b:	c3                   	ret    
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104d85:	e8 36 ee ff ff       	call   80103bc0 <myproc>

  num = curproc->tf->eax;
80104d8a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104d8d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d8f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d92:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d95:	83 fa 15             	cmp    $0x15,%edx
80104d98:	77 1e                	ja     80104db8 <syscall+0x38>
80104d9a:	8b 14 85 60 84 10 80 	mov    -0x7fef7ba0(,%eax,4),%edx
80104da1:	85 d2                	test   %edx,%edx
80104da3:	74 13                	je     80104db8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104da5:	ff d2                	call   *%edx
80104da7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dad:	5b                   	pop    %ebx
80104dae:	5e                   	pop    %esi
80104daf:	5d                   	pop    %ebp
80104db0:	c3                   	ret    
80104db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104db8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104db9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104dbc:	50                   	push   %eax
80104dbd:	ff 73 10             	pushl  0x10(%ebx)
80104dc0:	68 39 84 10 80       	push   $0x80108439
80104dc5:	e8 96 b8 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104dca:	8b 43 18             	mov    0x18(%ebx),%eax
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104dd7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dda:	5b                   	pop    %ebx
80104ddb:	5e                   	pop    %esi
80104ddc:	5d                   	pop    %ebp
80104ddd:	c3                   	ret    
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
80104de5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104de7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104dea:	89 d3                	mov    %edx,%ebx
80104dec:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104def:	50                   	push   %eax
80104df0:	6a 00                	push   $0x0
80104df2:	e8 99 fe ff ff       	call   80104c90 <argint>
80104df7:	83 c4 10             	add    $0x10,%esp
80104dfa:	85 c0                	test   %eax,%eax
80104dfc:	78 32                	js     80104e30 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dfe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e02:	77 2c                	ja     80104e30 <argfd.constprop.0+0x50>
80104e04:	e8 b7 ed ff ff       	call   80103bc0 <myproc>
80104e09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e0c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104e10:	85 c0                	test   %eax,%eax
80104e12:	74 1c                	je     80104e30 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104e14:	85 f6                	test   %esi,%esi
80104e16:	74 02                	je     80104e1a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104e18:	89 16                	mov    %edx,(%esi)
  if(pf)
80104e1a:	85 db                	test   %ebx,%ebx
80104e1c:	74 22                	je     80104e40 <argfd.constprop.0+0x60>
    *pf = f;
80104e1e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104e20:	31 c0                	xor    %eax,%eax
}
80104e22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e25:	5b                   	pop    %ebx
80104e26:	5e                   	pop    %esi
80104e27:	5d                   	pop    %ebp
80104e28:	c3                   	ret    
80104e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e30:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104e38:	5b                   	pop    %ebx
80104e39:	5e                   	pop    %esi
80104e3a:	5d                   	pop    %ebp
80104e3b:	c3                   	ret    
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104e40:	31 c0                	xor    %eax,%eax
80104e42:	eb de                	jmp    80104e22 <argfd.constprop.0+0x42>
80104e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e50 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104e50:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104e51:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	56                   	push   %esi
80104e56:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104e57:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104e5a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104e5d:	e8 7e ff ff ff       	call   80104de0 <argfd.constprop.0>
80104e62:	85 c0                	test   %eax,%eax
80104e64:	78 1a                	js     80104e80 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104e66:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104e68:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104e6b:	e8 50 ed ff ff       	call   80103bc0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104e70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e74:	85 d2                	test   %edx,%edx
80104e76:	74 18                	je     80104e90 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104e78:	83 c3 01             	add    $0x1,%ebx
80104e7b:	83 fb 10             	cmp    $0x10,%ebx
80104e7e:	75 f0                	jne    80104e70 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104e80:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104e88:	5b                   	pop    %ebx
80104e89:	5e                   	pop    %esi
80104e8a:	5d                   	pop    %ebp
80104e8b:	c3                   	ret    
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104e90:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	ff 75 f4             	pushl  -0xc(%ebp)
80104e9a:	e8 41 bf ff ff       	call   80100de0 <filedup>
  return fd;
80104e9f:	83 c4 10             	add    $0x10,%esp
}
80104ea2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104ea5:	89 d8                	mov    %ebx,%eax
}
80104ea7:	5b                   	pop    %ebx
80104ea8:	5e                   	pop    %esi
80104ea9:	5d                   	pop    %ebp
80104eaa:	c3                   	ret    
80104eab:	90                   	nop
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <sys_read>:

int
sys_read(void)
{
80104eb0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eb1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104eb3:	89 e5                	mov    %esp,%ebp
80104eb5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ebb:	e8 20 ff ff ff       	call   80104de0 <argfd.constprop.0>
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	78 4c                	js     80104f10 <sys_read+0x60>
80104ec4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ec7:	83 ec 08             	sub    $0x8,%esp
80104eca:	50                   	push   %eax
80104ecb:	6a 02                	push   $0x2
80104ecd:	e8 be fd ff ff       	call   80104c90 <argint>
80104ed2:	83 c4 10             	add    $0x10,%esp
80104ed5:	85 c0                	test   %eax,%eax
80104ed7:	78 37                	js     80104f10 <sys_read+0x60>
80104ed9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104edc:	83 ec 04             	sub    $0x4,%esp
80104edf:	ff 75 f0             	pushl  -0x10(%ebp)
80104ee2:	50                   	push   %eax
80104ee3:	6a 01                	push   $0x1
80104ee5:	e8 f6 fd ff ff       	call   80104ce0 <argptr>
80104eea:	83 c4 10             	add    $0x10,%esp
80104eed:	85 c0                	test   %eax,%eax
80104eef:	78 1f                	js     80104f10 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104ef1:	83 ec 04             	sub    $0x4,%esp
80104ef4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ef7:	ff 75 f4             	pushl  -0xc(%ebp)
80104efa:	ff 75 ec             	pushl  -0x14(%ebp)
80104efd:	e8 4e c0 ff ff       	call   80100f50 <fileread>
80104f02:	83 c4 10             	add    $0x10,%esp
}
80104f05:	c9                   	leave  
80104f06:	c3                   	ret    
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <sys_write>:

int
sys_write(void)
{
80104f20:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f21:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104f23:	89 e5                	mov    %esp,%ebp
80104f25:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f2b:	e8 b0 fe ff ff       	call   80104de0 <argfd.constprop.0>
80104f30:	85 c0                	test   %eax,%eax
80104f32:	78 4c                	js     80104f80 <sys_write+0x60>
80104f34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f37:	83 ec 08             	sub    $0x8,%esp
80104f3a:	50                   	push   %eax
80104f3b:	6a 02                	push   $0x2
80104f3d:	e8 4e fd ff ff       	call   80104c90 <argint>
80104f42:	83 c4 10             	add    $0x10,%esp
80104f45:	85 c0                	test   %eax,%eax
80104f47:	78 37                	js     80104f80 <sys_write+0x60>
80104f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f4c:	83 ec 04             	sub    $0x4,%esp
80104f4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f52:	50                   	push   %eax
80104f53:	6a 01                	push   $0x1
80104f55:	e8 86 fd ff ff       	call   80104ce0 <argptr>
80104f5a:	83 c4 10             	add    $0x10,%esp
80104f5d:	85 c0                	test   %eax,%eax
80104f5f:	78 1f                	js     80104f80 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104f61:	83 ec 04             	sub    $0x4,%esp
80104f64:	ff 75 f0             	pushl  -0x10(%ebp)
80104f67:	ff 75 f4             	pushl  -0xc(%ebp)
80104f6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f6d:	e8 6e c0 ff ff       	call   80100fe0 <filewrite>
80104f72:	83 c4 10             	add    $0x10,%esp
}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f90 <sys_close>:

int
sys_close(void)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104f96:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f9c:	e8 3f fe ff ff       	call   80104de0 <argfd.constprop.0>
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	78 2b                	js     80104fd0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104fa5:	e8 16 ec ff ff       	call   80103bc0 <myproc>
80104faa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104fad:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104fb0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104fb7:	00 
  fileclose(f);
80104fb8:	ff 75 f4             	pushl  -0xc(%ebp)
80104fbb:	e8 70 be ff ff       	call   80100e30 <fileclose>
  return 0;
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	31 c0                	xor    %eax,%eax
}
80104fc5:	c9                   	leave  
80104fc6:	c3                   	ret    
80104fc7:	89 f6                	mov    %esi,%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104fd5:	c9                   	leave  
80104fd6:	c3                   	ret    
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <sys_fstat>:

int
sys_fstat(void)
{
80104fe0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fe1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104fe3:	89 e5                	mov    %esp,%ebp
80104fe5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fe8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104feb:	e8 f0 fd ff ff       	call   80104de0 <argfd.constprop.0>
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	78 2c                	js     80105020 <sys_fstat+0x40>
80104ff4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ff7:	83 ec 04             	sub    $0x4,%esp
80104ffa:	6a 14                	push   $0x14
80104ffc:	50                   	push   %eax
80104ffd:	6a 01                	push   $0x1
80104fff:	e8 dc fc ff ff       	call   80104ce0 <argptr>
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	85 c0                	test   %eax,%eax
80105009:	78 15                	js     80105020 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010500b:	83 ec 08             	sub    $0x8,%esp
8010500e:	ff 75 f4             	pushl  -0xc(%ebp)
80105011:	ff 75 f0             	pushl  -0x10(%ebp)
80105014:	e8 e7 be ff ff       	call   80100f00 <filestat>
80105019:	83 c4 10             	add    $0x10,%esp
}
8010501c:	c9                   	leave  
8010501d:	c3                   	ret    
8010501e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105025:	c9                   	leave  
80105026:	c3                   	ret    
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	57                   	push   %edi
80105034:	56                   	push   %esi
80105035:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105036:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105039:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010503c:	50                   	push   %eax
8010503d:	6a 00                	push   $0x0
8010503f:	e8 fc fc ff ff       	call   80104d40 <argstr>
80105044:	83 c4 10             	add    $0x10,%esp
80105047:	85 c0                	test   %eax,%eax
80105049:	0f 88 fb 00 00 00    	js     8010514a <sys_link+0x11a>
8010504f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105052:	83 ec 08             	sub    $0x8,%esp
80105055:	50                   	push   %eax
80105056:	6a 01                	push   $0x1
80105058:	e8 e3 fc ff ff       	call   80104d40 <argstr>
8010505d:	83 c4 10             	add    $0x10,%esp
80105060:	85 c0                	test   %eax,%eax
80105062:	0f 88 e2 00 00 00    	js     8010514a <sys_link+0x11a>
    return -1;

  begin_op();
80105068:	e8 a3 de ff ff       	call   80102f10 <begin_op>
  if((ip = namei(old)) == 0){
8010506d:	83 ec 0c             	sub    $0xc,%esp
80105070:	ff 75 d4             	pushl  -0x2c(%ebp)
80105073:	e8 48 ce ff ff       	call   80101ec0 <namei>
80105078:	83 c4 10             	add    $0x10,%esp
8010507b:	85 c0                	test   %eax,%eax
8010507d:	89 c3                	mov    %eax,%ebx
8010507f:	0f 84 f3 00 00 00    	je     80105178 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105085:	83 ec 0c             	sub    $0xc,%esp
80105088:	50                   	push   %eax
80105089:	e8 e2 c5 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
8010508e:	83 c4 10             	add    $0x10,%esp
80105091:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105096:	0f 84 c4 00 00 00    	je     80105160 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010509c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801050a1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801050a4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801050a7:	53                   	push   %ebx
801050a8:	e8 13 c5 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
801050ad:	89 1c 24             	mov    %ebx,(%esp)
801050b0:	e8 9b c6 ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801050b5:	58                   	pop    %eax
801050b6:	5a                   	pop    %edx
801050b7:	57                   	push   %edi
801050b8:	ff 75 d0             	pushl  -0x30(%ebp)
801050bb:	e8 20 ce ff ff       	call   80101ee0 <nameiparent>
801050c0:	83 c4 10             	add    $0x10,%esp
801050c3:	85 c0                	test   %eax,%eax
801050c5:	89 c6                	mov    %eax,%esi
801050c7:	74 5b                	je     80105124 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801050c9:	83 ec 0c             	sub    $0xc,%esp
801050cc:	50                   	push   %eax
801050cd:	e8 9e c5 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050d2:	83 c4 10             	add    $0x10,%esp
801050d5:	8b 03                	mov    (%ebx),%eax
801050d7:	39 06                	cmp    %eax,(%esi)
801050d9:	75 3d                	jne    80105118 <sys_link+0xe8>
801050db:	83 ec 04             	sub    $0x4,%esp
801050de:	ff 73 04             	pushl  0x4(%ebx)
801050e1:	57                   	push   %edi
801050e2:	56                   	push   %esi
801050e3:	e8 18 cd ff ff       	call   80101e00 <dirlink>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	85 c0                	test   %eax,%eax
801050ed:	78 29                	js     80105118 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	56                   	push   %esi
801050f3:	e8 08 c8 ff ff       	call   80101900 <iunlockput>
  iput(ip);
801050f8:	89 1c 24             	mov    %ebx,(%esp)
801050fb:	e8 a0 c6 ff ff       	call   801017a0 <iput>

  end_op();
80105100:	e8 7b de ff ff       	call   80102f80 <end_op>

  return 0;
80105105:	83 c4 10             	add    $0x10,%esp
80105108:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010510a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010510d:	5b                   	pop    %ebx
8010510e:	5e                   	pop    %esi
8010510f:	5f                   	pop    %edi
80105110:	5d                   	pop    %ebp
80105111:	c3                   	ret    
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105118:	83 ec 0c             	sub    $0xc,%esp
8010511b:	56                   	push   %esi
8010511c:	e8 df c7 ff ff       	call   80101900 <iunlockput>
    goto bad;
80105121:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105124:	83 ec 0c             	sub    $0xc,%esp
80105127:	53                   	push   %ebx
80105128:	e8 43 c5 ff ff       	call   80101670 <ilock>
  ip->nlink--;
8010512d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105132:	89 1c 24             	mov    %ebx,(%esp)
80105135:	e8 86 c4 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
8010513a:	89 1c 24             	mov    %ebx,(%esp)
8010513d:	e8 be c7 ff ff       	call   80101900 <iunlockput>
  end_op();
80105142:	e8 39 de ff ff       	call   80102f80 <end_op>
  return -1;
80105147:	83 c4 10             	add    $0x10,%esp
}
8010514a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010514d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105152:	5b                   	pop    %ebx
80105153:	5e                   	pop    %esi
80105154:	5f                   	pop    %edi
80105155:	5d                   	pop    %ebp
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	53                   	push   %ebx
80105164:	e8 97 c7 ff ff       	call   80101900 <iunlockput>
    end_op();
80105169:	e8 12 de ff ff       	call   80102f80 <end_op>
    return -1;
8010516e:	83 c4 10             	add    $0x10,%esp
80105171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105176:	eb 92                	jmp    8010510a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105178:	e8 03 de ff ff       	call   80102f80 <end_op>
    return -1;
8010517d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105182:	eb 86                	jmp    8010510a <sys_link+0xda>
80105184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010518a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105190 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
80105195:	53                   	push   %ebx
80105196:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105199:	bb 20 00 00 00       	mov    $0x20,%ebx
8010519e:	83 ec 1c             	sub    $0x1c,%esp
801051a1:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051a4:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801051a8:	77 0e                	ja     801051b8 <isdirempty+0x28>
801051aa:	eb 34                	jmp    801051e0 <isdirempty+0x50>
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051b0:	83 c3 10             	add    $0x10,%ebx
801051b3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801051b6:	76 28                	jbe    801051e0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b8:	6a 10                	push   $0x10
801051ba:	53                   	push   %ebx
801051bb:	57                   	push   %edi
801051bc:	56                   	push   %esi
801051bd:	e8 8e c7 ff ff       	call   80101950 <readi>
801051c2:	83 c4 10             	add    $0x10,%esp
801051c5:	83 f8 10             	cmp    $0x10,%eax
801051c8:	75 23                	jne    801051ed <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801051ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051cf:	74 df                	je     801051b0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801051d1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
801051d4:	31 c0                	xor    %eax,%eax
  }
  return 1;
}
801051d6:	5b                   	pop    %ebx
801051d7:	5e                   	pop    %esi
801051d8:	5f                   	pop    %edi
801051d9:	5d                   	pop    %ebp
801051da:	c3                   	ret    
801051db:	90                   	nop
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801051e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801051e8:	5b                   	pop    %ebx
801051e9:	5e                   	pop    %esi
801051ea:	5f                   	pop    %edi
801051eb:	5d                   	pop    %ebp
801051ec:	c3                   	ret    
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801051ed:	83 ec 0c             	sub    $0xc,%esp
801051f0:	68 bc 84 10 80       	push   $0x801084bc
801051f5:	e8 76 b1 ff ff       	call   80100370 <panic>
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105200 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
80105205:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105206:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105209:	83 ec 44             	sub    $0x44,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 2c fb ff ff       	call   80104d40 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 51 01 00 00    	js     80105370 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010521f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105222:	e8 e9 dc ff ff       	call   80102f10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	53                   	push   %ebx
8010522b:	ff 75 c0             	pushl  -0x40(%ebp)
8010522e:	e8 ad cc ff ff       	call   80101ee0 <nameiparent>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	89 c6                	mov    %eax,%esi
8010523a:	0f 84 37 01 00 00    	je     80105377 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105240:	83 ec 0c             	sub    $0xc,%esp
80105243:	50                   	push   %eax
80105244:	e8 27 c4 ff ff       	call   80101670 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105249:	58                   	pop    %eax
8010524a:	5a                   	pop    %edx
8010524b:	68 7d 7e 10 80       	push   $0x80107e7d
80105250:	53                   	push   %ebx
80105251:	e8 2a c9 ff ff       	call   80101b80 <namecmp>
80105256:	83 c4 10             	add    $0x10,%esp
80105259:	85 c0                	test   %eax,%eax
8010525b:	0f 84 d3 00 00 00    	je     80105334 <sys_unlink+0x134>
80105261:	83 ec 08             	sub    $0x8,%esp
80105264:	68 7c 7e 10 80       	push   $0x80107e7c
80105269:	53                   	push   %ebx
8010526a:	e8 11 c9 ff ff       	call   80101b80 <namecmp>
8010526f:	83 c4 10             	add    $0x10,%esp
80105272:	85 c0                	test   %eax,%eax
80105274:	0f 84 ba 00 00 00    	je     80105334 <sys_unlink+0x134>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010527a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010527d:	83 ec 04             	sub    $0x4,%esp
80105280:	50                   	push   %eax
80105281:	53                   	push   %ebx
80105282:	56                   	push   %esi
80105283:	e8 18 c9 ff ff       	call   80101ba0 <dirlookup>
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	85 c0                	test   %eax,%eax
8010528d:	89 c3                	mov    %eax,%ebx
8010528f:	0f 84 9f 00 00 00    	je     80105334 <sys_unlink+0x134>
    goto bad;
  ilock(ip);
80105295:	83 ec 0c             	sub    $0xc,%esp
80105298:	50                   	push   %eax
80105299:	e8 d2 c3 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052a6:	0f 8e e4 00 00 00    	jle    80105390 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801052ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052b1:	74 65                	je     80105318 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801052b3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052b6:	83 ec 04             	sub    $0x4,%esp
801052b9:	6a 10                	push   $0x10
801052bb:	6a 00                	push   $0x0
801052bd:	57                   	push   %edi
801052be:	e8 bd f6 ff ff       	call   80104980 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052c3:	6a 10                	push   $0x10
801052c5:	ff 75 c4             	pushl  -0x3c(%ebp)
801052c8:	57                   	push   %edi
801052c9:	56                   	push   %esi
801052ca:	e8 81 c7 ff ff       	call   80101a50 <writei>
801052cf:	83 c4 20             	add    $0x20,%esp
801052d2:	83 f8 10             	cmp    $0x10,%eax
801052d5:	0f 85 a8 00 00 00    	jne    80105383 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801052db:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052e0:	74 76                	je     80105358 <sys_unlink+0x158>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801052e2:	83 ec 0c             	sub    $0xc,%esp
801052e5:	56                   	push   %esi
801052e6:	e8 15 c6 ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
801052eb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052f0:	89 1c 24             	mov    %ebx,(%esp)
801052f3:	e8 c8 c2 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
801052f8:	89 1c 24             	mov    %ebx,(%esp)
801052fb:	e8 00 c6 ff ff       	call   80101900 <iunlockput>

  end_op();
80105300:	e8 7b dc ff ff       	call   80102f80 <end_op>

  return 0;
80105305:	83 c4 10             	add    $0x10,%esp
80105308:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010530a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010530d:	5b                   	pop    %ebx
8010530e:	5e                   	pop    %esi
8010530f:	5f                   	pop    %edi
80105310:	5d                   	pop    %ebp
80105311:	c3                   	ret    
80105312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	53                   	push   %ebx
8010531c:	e8 6f fe ff ff       	call   80105190 <isdirempty>
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	85 c0                	test   %eax,%eax
80105326:	75 8b                	jne    801052b3 <sys_unlink+0xb3>
    iunlockput(ip);
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	53                   	push   %ebx
8010532c:	e8 cf c5 ff ff       	call   80101900 <iunlockput>
    goto bad;
80105331:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105334:	83 ec 0c             	sub    $0xc,%esp
80105337:	56                   	push   %esi
80105338:	e8 c3 c5 ff ff       	call   80101900 <iunlockput>
  end_op();
8010533d:	e8 3e dc ff ff       	call   80102f80 <end_op>
  return -1;
80105342:	83 c4 10             	add    $0x10,%esp
}
80105345:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010534d:	5b                   	pop    %ebx
8010534e:	5e                   	pop    %esi
8010534f:	5f                   	pop    %edi
80105350:	5d                   	pop    %ebp
80105351:	c3                   	ret    
80105352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105358:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
8010535d:	83 ec 0c             	sub    $0xc,%esp
80105360:	56                   	push   %esi
80105361:	e8 5a c2 ff ff       	call   801015c0 <iupdate>
80105366:	83 c4 10             	add    $0x10,%esp
80105369:	e9 74 ff ff ff       	jmp    801052e2 <sys_unlink+0xe2>
8010536e:	66 90                	xchg   %ax,%ax
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105375:	eb 93                	jmp    8010530a <sys_unlink+0x10a>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105377:	e8 04 dc ff ff       	call   80102f80 <end_op>
    return -1;
8010537c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105381:	eb 87                	jmp    8010530a <sys_unlink+0x10a>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105383:	83 ec 0c             	sub    $0xc,%esp
80105386:	68 91 7e 10 80       	push   $0x80107e91
8010538b:	e8 e0 af ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	68 7f 7e 10 80       	push   $0x80107e7f
80105398:	e8 d3 af ff ff       	call   80100370 <panic>
8010539d:	8d 76 00             	lea    0x0(%esi),%esi

801053a0 <create>:
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801053a6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801053a9:	83 ec 44             	sub    $0x44,%esp
801053ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801053af:	8b 55 10             	mov    0x10(%ebp),%edx
801053b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801053b5:	56                   	push   %esi
801053b6:	ff 75 08             	pushl  0x8(%ebp)
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801053b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801053bc:	89 55 c0             	mov    %edx,-0x40(%ebp)
801053bf:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801053c2:	e8 19 cb ff ff       	call   80101ee0 <nameiparent>
801053c7:	83 c4 10             	add    $0x10,%esp
801053ca:	85 c0                	test   %eax,%eax
801053cc:	0f 84 ee 00 00 00    	je     801054c0 <create+0x120>
    return 0;
  ilock(dp);
801053d2:	83 ec 0c             	sub    $0xc,%esp
801053d5:	89 c7                	mov    %eax,%edi
801053d7:	50                   	push   %eax
801053d8:	e8 93 c2 ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801053dd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801053e0:	83 c4 0c             	add    $0xc,%esp
801053e3:	50                   	push   %eax
801053e4:	56                   	push   %esi
801053e5:	57                   	push   %edi
801053e6:	e8 b5 c7 ff ff       	call   80101ba0 <dirlookup>
801053eb:	83 c4 10             	add    $0x10,%esp
801053ee:	85 c0                	test   %eax,%eax
801053f0:	89 c3                	mov    %eax,%ebx
801053f2:	74 4c                	je     80105440 <create+0xa0>
    iunlockput(dp);
801053f4:	83 ec 0c             	sub    $0xc,%esp
801053f7:	57                   	push   %edi
801053f8:	e8 03 c5 ff ff       	call   80101900 <iunlockput>
    ilock(ip);
801053fd:	89 1c 24             	mov    %ebx,(%esp)
80105400:	e8 6b c2 ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105405:	83 c4 10             	add    $0x10,%esp
80105408:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010540d:	75 11                	jne    80105420 <create+0x80>
8010540f:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80105414:	89 d8                	mov    %ebx,%eax
80105416:	75 08                	jne    80105420 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105418:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010541b:	5b                   	pop    %ebx
8010541c:	5e                   	pop    %esi
8010541d:	5f                   	pop    %edi
8010541e:	5d                   	pop    %ebp
8010541f:	c3                   	ret    
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	53                   	push   %ebx
80105424:	e8 d7 c4 ff ff       	call   80101900 <iunlockput>
    return 0;
80105429:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010542c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010542f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105431:	5b                   	pop    %ebx
80105432:	5e                   	pop    %esi
80105433:	5f                   	pop    %edi
80105434:	5d                   	pop    %ebp
80105435:	c3                   	ret    
80105436:	8d 76 00             	lea    0x0(%esi),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105440:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105444:	83 ec 08             	sub    $0x8,%esp
80105447:	50                   	push   %eax
80105448:	ff 37                	pushl  (%edi)
8010544a:	e8 b1 c0 ff ff       	call   80101500 <ialloc>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	85 c0                	test   %eax,%eax
80105454:	89 c3                	mov    %eax,%ebx
80105456:	0f 84 cc 00 00 00    	je     80105528 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	50                   	push   %eax
80105460:	e8 0b c2 ff ff       	call   80101670 <ilock>
  ip->major = major;
80105465:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105469:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010546d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105471:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105475:	b8 01 00 00 00       	mov    $0x1,%eax
8010547a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010547e:	89 1c 24             	mov    %ebx,(%esp)
80105481:	e8 3a c1 ff ff       	call   801015c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010548e:	74 40                	je     801054d0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105490:	83 ec 04             	sub    $0x4,%esp
80105493:	ff 73 04             	pushl  0x4(%ebx)
80105496:	56                   	push   %esi
80105497:	57                   	push   %edi
80105498:	e8 63 c9 ff ff       	call   80101e00 <dirlink>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 77                	js     8010551b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801054a4:	83 ec 0c             	sub    $0xc,%esp
801054a7:	57                   	push   %edi
801054a8:	e8 53 c4 ff ff       	call   80101900 <iunlockput>

  return ip;
801054ad:	83 c4 10             	add    $0x10,%esp
}
801054b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801054b3:	89 d8                	mov    %ebx,%eax
}
801054b5:	5b                   	pop    %ebx
801054b6:	5e                   	pop    %esi
801054b7:	5f                   	pop    %edi
801054b8:	5d                   	pop    %ebp
801054b9:	c3                   	ret    
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801054c0:	31 c0                	xor    %eax,%eax
801054c2:	e9 51 ff ff ff       	jmp    80105418 <create+0x78>
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801054d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801054d5:	83 ec 0c             	sub    $0xc,%esp
801054d8:	57                   	push   %edi
801054d9:	e8 e2 c0 ff ff       	call   801015c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801054de:	83 c4 0c             	add    $0xc,%esp
801054e1:	ff 73 04             	pushl  0x4(%ebx)
801054e4:	68 7d 7e 10 80       	push   $0x80107e7d
801054e9:	53                   	push   %ebx
801054ea:	e8 11 c9 ff ff       	call   80101e00 <dirlink>
801054ef:	83 c4 10             	add    $0x10,%esp
801054f2:	85 c0                	test   %eax,%eax
801054f4:	78 18                	js     8010550e <create+0x16e>
801054f6:	83 ec 04             	sub    $0x4,%esp
801054f9:	ff 77 04             	pushl  0x4(%edi)
801054fc:	68 7c 7e 10 80       	push   $0x80107e7c
80105501:	53                   	push   %ebx
80105502:	e8 f9 c8 ff ff       	call   80101e00 <dirlink>
80105507:	83 c4 10             	add    $0x10,%esp
8010550a:	85 c0                	test   %eax,%eax
8010550c:	79 82                	jns    80105490 <create+0xf0>
      panic("create dots");
8010550e:	83 ec 0c             	sub    $0xc,%esp
80105511:	68 dd 84 10 80       	push   $0x801084dd
80105516:	e8 55 ae ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010551b:	83 ec 0c             	sub    $0xc,%esp
8010551e:	68 e9 84 10 80       	push   $0x801084e9
80105523:	e8 48 ae ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105528:	83 ec 0c             	sub    $0xc,%esp
8010552b:	68 ce 84 10 80       	push   $0x801084ce
80105530:	e8 3b ae ff ff       	call   80100370 <panic>
80105535:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
80105545:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105546:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105549:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010554c:	50                   	push   %eax
8010554d:	6a 00                	push   $0x0
8010554f:	e8 ec f7 ff ff       	call   80104d40 <argstr>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	0f 88 9e 00 00 00    	js     801055fd <sys_open+0xbd>
8010555f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105562:	83 ec 08             	sub    $0x8,%esp
80105565:	50                   	push   %eax
80105566:	6a 01                	push   $0x1
80105568:	e8 23 f7 ff ff       	call   80104c90 <argint>
8010556d:	83 c4 10             	add    $0x10,%esp
80105570:	85 c0                	test   %eax,%eax
80105572:	0f 88 85 00 00 00    	js     801055fd <sys_open+0xbd>
    return -1;

  begin_op();
80105578:	e8 93 d9 ff ff       	call   80102f10 <begin_op>

  if(omode & O_CREATE){
8010557d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105581:	0f 85 89 00 00 00    	jne    80105610 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105587:	83 ec 0c             	sub    $0xc,%esp
8010558a:	ff 75 e0             	pushl  -0x20(%ebp)
8010558d:	e8 2e c9 ff ff       	call   80101ec0 <namei>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	89 c6                	mov    %eax,%esi
80105599:	0f 84 88 00 00 00    	je     80105627 <sys_open+0xe7>
      end_op();
      return -1;
    }
    ilock(ip);
8010559f:	83 ec 0c             	sub    $0xc,%esp
801055a2:	50                   	push   %eax
801055a3:	e8 c8 c0 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055b0:	0f 84 ca 00 00 00    	je     80105680 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055b6:	e8 b5 b7 ff ff       	call   80100d70 <filealloc>
801055bb:	85 c0                	test   %eax,%eax
801055bd:	89 c7                	mov    %eax,%edi
801055bf:	74 2b                	je     801055ec <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801055c1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801055c3:	e8 f8 e5 ff ff       	call   80103bc0 <myproc>
801055c8:	90                   	nop
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801055d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055d4:	85 d2                	test   %edx,%edx
801055d6:	74 60                	je     80105638 <sys_open+0xf8>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801055d8:	83 c3 01             	add    $0x1,%ebx
801055db:	83 fb 10             	cmp    $0x10,%ebx
801055de:	75 f0                	jne    801055d0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	57                   	push   %edi
801055e4:	e8 47 b8 ff ff       	call   80100e30 <fileclose>
801055e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	56                   	push   %esi
801055f0:	e8 0b c3 ff ff       	call   80101900 <iunlockput>
    end_op();
801055f5:	e8 86 d9 ff ff       	call   80102f80 <end_op>
    return -1;
801055fa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801055fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105605:	5b                   	pop    %ebx
80105606:	5e                   	pop    %esi
80105607:	5f                   	pop    %edi
80105608:	5d                   	pop    %ebp
80105609:	c3                   	ret    
8010560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105610:	6a 00                	push   $0x0
80105612:	6a 00                	push   $0x0
80105614:	6a 02                	push   $0x2
80105616:	ff 75 e0             	pushl  -0x20(%ebp)
80105619:	e8 82 fd ff ff       	call   801053a0 <create>
    if(ip == 0){
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105623:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105625:	75 8f                	jne    801055b6 <sys_open+0x76>
      end_op();
80105627:	e8 54 d9 ff ff       	call   80102f80 <end_op>
      return -1;
8010562c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105631:	eb 41                	jmp    80105674 <sys_open+0x134>
80105633:	90                   	nop
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105638:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
8010563b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010563f:	56                   	push   %esi
80105640:	e8 0b c1 ff ff       	call   80101750 <iunlock>
  end_op();
80105645:	e8 36 d9 ff ff       	call   80102f80 <end_op>

  f->type = FD_INODE;
8010564a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105650:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105653:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105656:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105659:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105660:	89 d0                	mov    %edx,%eax
80105662:	83 e0 01             	and    $0x1,%eax
80105665:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105668:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010566b:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010566e:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105672:	89 d8                	mov    %ebx,%eax
}
80105674:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105677:	5b                   	pop    %ebx
80105678:	5e                   	pop    %esi
80105679:	5f                   	pop    %edi
8010567a:	5d                   	pop    %ebp
8010567b:	c3                   	ret    
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105680:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105683:	85 c9                	test   %ecx,%ecx
80105685:	0f 84 2b ff ff ff    	je     801055b6 <sys_open+0x76>
8010568b:	e9 5c ff ff ff       	jmp    801055ec <sys_open+0xac>

80105690 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105696:	e8 75 d8 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010569b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010569e:	83 ec 08             	sub    $0x8,%esp
801056a1:	50                   	push   %eax
801056a2:	6a 00                	push   $0x0
801056a4:	e8 97 f6 ff ff       	call   80104d40 <argstr>
801056a9:	83 c4 10             	add    $0x10,%esp
801056ac:	85 c0                	test   %eax,%eax
801056ae:	78 30                	js     801056e0 <sys_mkdir+0x50>
801056b0:	6a 00                	push   $0x0
801056b2:	6a 00                	push   $0x0
801056b4:	6a 01                	push   $0x1
801056b6:	ff 75 f4             	pushl  -0xc(%ebp)
801056b9:	e8 e2 fc ff ff       	call   801053a0 <create>
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	74 1b                	je     801056e0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056c5:	83 ec 0c             	sub    $0xc,%esp
801056c8:	50                   	push   %eax
801056c9:	e8 32 c2 ff ff       	call   80101900 <iunlockput>
  end_op();
801056ce:	e8 ad d8 ff ff       	call   80102f80 <end_op>
  return 0;
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	31 c0                	xor    %eax,%eax
}
801056d8:	c9                   	leave  
801056d9:	c3                   	ret    
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801056e0:	e8 9b d8 ff ff       	call   80102f80 <end_op>
    return -1;
801056e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056f0 <sys_mknod>:

int
sys_mknod(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056f6:	e8 15 d8 ff ff       	call   80102f10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056fe:	83 ec 08             	sub    $0x8,%esp
80105701:	50                   	push   %eax
80105702:	6a 00                	push   $0x0
80105704:	e8 37 f6 ff ff       	call   80104d40 <argstr>
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	85 c0                	test   %eax,%eax
8010570e:	78 60                	js     80105770 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105710:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105713:	83 ec 08             	sub    $0x8,%esp
80105716:	50                   	push   %eax
80105717:	6a 01                	push   $0x1
80105719:	e8 72 f5 ff ff       	call   80104c90 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010571e:	83 c4 10             	add    $0x10,%esp
80105721:	85 c0                	test   %eax,%eax
80105723:	78 4b                	js     80105770 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105725:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105728:	83 ec 08             	sub    $0x8,%esp
8010572b:	50                   	push   %eax
8010572c:	6a 02                	push   $0x2
8010572e:	e8 5d f5 ff ff       	call   80104c90 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	85 c0                	test   %eax,%eax
80105738:	78 36                	js     80105770 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010573a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010573e:	50                   	push   %eax
8010573f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105743:	50                   	push   %eax
80105744:	6a 03                	push   $0x3
80105746:	ff 75 ec             	pushl  -0x14(%ebp)
80105749:	e8 52 fc ff ff       	call   801053a0 <create>
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	85 c0                	test   %eax,%eax
80105753:	74 1b                	je     80105770 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	50                   	push   %eax
80105759:	e8 a2 c1 ff ff       	call   80101900 <iunlockput>
  end_op();
8010575e:	e8 1d d8 ff ff       	call   80102f80 <end_op>
  return 0;
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	31 c0                	xor    %eax,%eax
}
80105768:	c9                   	leave  
80105769:	c3                   	ret    
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105770:	e8 0b d8 ff ff       	call   80102f80 <end_op>
    return -1;
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010577a:	c9                   	leave  
8010577b:	c3                   	ret    
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_chdir>:

int
sys_chdir(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	56                   	push   %esi
80105784:	53                   	push   %ebx
80105785:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105788:	e8 33 e4 ff ff       	call   80103bc0 <myproc>
8010578d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010578f:	e8 7c d7 ff ff       	call   80102f10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105797:	83 ec 08             	sub    $0x8,%esp
8010579a:	50                   	push   %eax
8010579b:	6a 00                	push   $0x0
8010579d:	e8 9e f5 ff ff       	call   80104d40 <argstr>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	78 77                	js     80105820 <sys_chdir+0xa0>
801057a9:	83 ec 0c             	sub    $0xc,%esp
801057ac:	ff 75 f4             	pushl  -0xc(%ebp)
801057af:	e8 0c c7 ff ff       	call   80101ec0 <namei>
801057b4:	83 c4 10             	add    $0x10,%esp
801057b7:	85 c0                	test   %eax,%eax
801057b9:	89 c3                	mov    %eax,%ebx
801057bb:	74 63                	je     80105820 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057bd:	83 ec 0c             	sub    $0xc,%esp
801057c0:	50                   	push   %eax
801057c1:	e8 aa be ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057ce:	75 30                	jne    80105800 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	53                   	push   %ebx
801057d4:	e8 77 bf ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
801057d9:	58                   	pop    %eax
801057da:	ff 76 68             	pushl  0x68(%esi)
801057dd:	e8 be bf ff ff       	call   801017a0 <iput>
  end_op();
801057e2:	e8 99 d7 ff ff       	call   80102f80 <end_op>
  curproc->cwd = ip;
801057e7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	31 c0                	xor    %eax,%eax
}
801057ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057f2:	5b                   	pop    %ebx
801057f3:	5e                   	pop    %esi
801057f4:	5d                   	pop    %ebp
801057f5:	c3                   	ret    
801057f6:	8d 76 00             	lea    0x0(%esi),%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	53                   	push   %ebx
80105804:	e8 f7 c0 ff ff       	call   80101900 <iunlockput>
    end_op();
80105809:	e8 72 d7 ff ff       	call   80102f80 <end_op>
    return -1;
8010580e:	83 c4 10             	add    $0x10,%esp
80105811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105816:	eb d7                	jmp    801057ef <sys_chdir+0x6f>
80105818:	90                   	nop
80105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105820:	e8 5b d7 ff ff       	call   80102f80 <end_op>
    return -1;
80105825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010582a:	eb c3                	jmp    801057ef <sys_chdir+0x6f>
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105830 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
80105835:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105836:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010583c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105842:	50                   	push   %eax
80105843:	6a 00                	push   $0x0
80105845:	e8 f6 f4 ff ff       	call   80104d40 <argstr>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	78 7f                	js     801058d0 <sys_exec+0xa0>
80105851:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105857:	83 ec 08             	sub    $0x8,%esp
8010585a:	50                   	push   %eax
8010585b:	6a 01                	push   $0x1
8010585d:	e8 2e f4 ff ff       	call   80104c90 <argint>
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	85 c0                	test   %eax,%eax
80105867:	78 67                	js     801058d0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105869:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010586f:	83 ec 04             	sub    $0x4,%esp
80105872:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105878:	68 80 00 00 00       	push   $0x80
8010587d:	6a 00                	push   $0x0
8010587f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105885:	50                   	push   %eax
80105886:	31 db                	xor    %ebx,%ebx
80105888:	e8 f3 f0 ff ff       	call   80104980 <memset>
8010588d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105890:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105896:	83 ec 08             	sub    $0x8,%esp
80105899:	57                   	push   %edi
8010589a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010589d:	50                   	push   %eax
8010589e:	e8 4d f3 ff ff       	call   80104bf0 <fetchint>
801058a3:	83 c4 10             	add    $0x10,%esp
801058a6:	85 c0                	test   %eax,%eax
801058a8:	78 26                	js     801058d0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801058aa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058b0:	85 c0                	test   %eax,%eax
801058b2:	74 2c                	je     801058e0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058b4:	83 ec 08             	sub    $0x8,%esp
801058b7:	56                   	push   %esi
801058b8:	50                   	push   %eax
801058b9:	e8 72 f3 ff ff       	call   80104c30 <fetchstr>
801058be:	83 c4 10             	add    $0x10,%esp
801058c1:	85 c0                	test   %eax,%eax
801058c3:	78 0b                	js     801058d0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801058c5:	83 c3 01             	add    $0x1,%ebx
801058c8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801058cb:	83 fb 20             	cmp    $0x20,%ebx
801058ce:	75 c0                	jne    80105890 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801058d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801058d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801058d8:	5b                   	pop    %ebx
801058d9:	5e                   	pop    %esi
801058da:	5f                   	pop    %edi
801058db:	5d                   	pop    %ebp
801058dc:	c3                   	ret    
801058dd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801058e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058e6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801058e9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058f0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801058f4:	50                   	push   %eax
801058f5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058fb:	e8 f0 b0 ff ff       	call   801009f0 <exec>
80105900:	83 c4 10             	add    $0x10,%esp
}
80105903:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105906:	5b                   	pop    %ebx
80105907:	5e                   	pop    %esi
80105908:	5f                   	pop    %edi
80105909:	5d                   	pop    %ebp
8010590a:	c3                   	ret    
8010590b:	90                   	nop
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_pipe>:

int
sys_pipe(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105916:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105919:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010591c:	6a 08                	push   $0x8
8010591e:	50                   	push   %eax
8010591f:	6a 00                	push   $0x0
80105921:	e8 ba f3 ff ff       	call   80104ce0 <argptr>
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	85 c0                	test   %eax,%eax
8010592b:	78 4a                	js     80105977 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010592d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105930:	83 ec 08             	sub    $0x8,%esp
80105933:	50                   	push   %eax
80105934:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105937:	50                   	push   %eax
80105938:	e8 73 dc ff ff       	call   801035b0 <pipealloc>
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	85 c0                	test   %eax,%eax
80105942:	78 33                	js     80105977 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105944:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105946:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105949:	e8 72 e2 ff ff       	call   80103bc0 <myproc>
8010594e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105950:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105954:	85 f6                	test   %esi,%esi
80105956:	74 30                	je     80105988 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105958:	83 c3 01             	add    $0x1,%ebx
8010595b:	83 fb 10             	cmp    $0x10,%ebx
8010595e:	75 f0                	jne    80105950 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	ff 75 e0             	pushl  -0x20(%ebp)
80105966:	e8 c5 b4 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
8010596b:	58                   	pop    %eax
8010596c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010596f:	e8 bc b4 ff ff       	call   80100e30 <fileclose>
    return -1;
80105974:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105977:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010597a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010597f:	5b                   	pop    %ebx
80105980:	5e                   	pop    %esi
80105981:	5f                   	pop    %edi
80105982:	5d                   	pop    %ebp
80105983:	c3                   	ret    
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105988:	8d 73 08             	lea    0x8(%ebx),%esi
8010598b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010598f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105992:	e8 29 e2 ff ff       	call   80103bc0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105997:	31 d2                	xor    %edx,%edx
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059a0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059a4:	85 c9                	test   %ecx,%ecx
801059a6:	74 18                	je     801059c0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801059a8:	83 c2 01             	add    $0x1,%edx
801059ab:	83 fa 10             	cmp    $0x10,%edx
801059ae:	75 f0                	jne    801059a0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801059b0:	e8 0b e2 ff ff       	call   80103bc0 <myproc>
801059b5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059bc:	00 
801059bd:	eb a1                	jmp    80105960 <sys_pipe+0x50>
801059bf:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801059c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801059c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801059c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801059cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801059d2:	31 c0                	xor    %eax,%eax
}
801059d4:	5b                   	pop    %ebx
801059d5:	5e                   	pop    %esi
801059d6:	5f                   	pop    %edi
801059d7:	5d                   	pop    %ebp
801059d8:	c3                   	ret    
801059d9:	66 90                	xchg   %ax,%ax
801059db:	66 90                	xchg   %ax,%ax
801059dd:	66 90                	xchg   %ax,%ax
801059df:	90                   	nop

801059e0 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 08             	sub    $0x8,%esp
  yield(); 
801059e6:	e8 45 e7 ff ff       	call   80104130 <yield>
  return 0;
}
801059eb:	31 c0                	xor    %eax,%eax
801059ed:	c9                   	leave  
801059ee:	c3                   	ret    
801059ef:	90                   	nop

801059f0 <sys_fork>:

int
sys_fork(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059f3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
801059f4:	e9 67 e3 ff ff       	jmp    80103d60 <fork>
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_exit>:
}

int
sys_exit(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a06:	e8 f5 e5 ff ff       	call   80104000 <exit>
  return 0;  // not reached
}
80105a0b:	31 c0                	xor    %eax,%eax
80105a0d:	c9                   	leave  
80105a0e:	c3                   	ret    
80105a0f:	90                   	nop

80105a10 <sys_wait>:

int
sys_wait(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105a13:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105a14:	e9 27 e8 ff ff       	jmp    80104240 <wait>
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_kill>:
}

int
sys_kill(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a29:	50                   	push   %eax
80105a2a:	6a 00                	push   $0x0
80105a2c:	e8 5f f2 ff ff       	call   80104c90 <argint>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	85 c0                	test   %eax,%eax
80105a36:	78 18                	js     80105a50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a3e:	e8 5d e9 ff ff       	call   801043a0 <kill>
80105a43:	83 c4 10             	add    $0x10,%esp
}
80105a46:	c9                   	leave  
80105a47:	c3                   	ret    
80105a48:	90                   	nop
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    
80105a57:	89 f6                	mov    %esi,%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a60 <sys_getpid>:

int
sys_getpid(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a66:	e8 55 e1 ff ff       	call   80103bc0 <myproc>
80105a6b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a6e:	c9                   	leave  
80105a6f:	c3                   	ret    

80105a70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105a77:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a7a:	50                   	push   %eax
80105a7b:	6a 00                	push   $0x0
80105a7d:	e8 0e f2 ff ff       	call   80104c90 <argint>
80105a82:	83 c4 10             	add    $0x10,%esp
80105a85:	85 c0                	test   %eax,%eax
80105a87:	78 27                	js     80105ab0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a89:	e8 32 e1 ff ff       	call   80103bc0 <myproc>
  if(growproc(n) < 0)
80105a8e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105a91:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a93:	ff 75 f4             	pushl  -0xc(%ebp)
80105a96:	e8 45 e2 ff ff       	call   80103ce0 <growproc>
80105a9b:	83 c4 10             	add    $0x10,%esp
80105a9e:	85 c0                	test   %eax,%eax
80105aa0:	78 0e                	js     80105ab0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105aa2:	89 d8                	mov    %ebx,%eax
}
80105aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa7:	c9                   	leave  
80105aa8:	c3                   	ret    
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab5:	eb ed                	jmp    80105aa4 <sys_sbrk+0x34>
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ac0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105ac7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 be f1 ff ff       	call   80104c90 <argint>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	0f 88 8a 00 00 00    	js     80105b67 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	68 60 d3 11 80       	push   $0x8011d360
80105ae5:	e8 26 ed ff ff       	call   80104810 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105aed:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105af0:	8b 1d a0 db 11 80    	mov    0x8011dba0,%ebx
  while(ticks - ticks0 < n){
80105af6:	85 d2                	test   %edx,%edx
80105af8:	75 27                	jne    80105b21 <sys_sleep+0x61>
80105afa:	eb 54                	jmp    80105b50 <sys_sleep+0x90>
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b00:	83 ec 08             	sub    $0x8,%esp
80105b03:	68 60 d3 11 80       	push   $0x8011d360
80105b08:	68 a0 db 11 80       	push   $0x8011dba0
80105b0d:	e8 6e e6 ff ff       	call   80104180 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b12:	a1 a0 db 11 80       	mov    0x8011dba0,%eax
80105b17:	83 c4 10             	add    $0x10,%esp
80105b1a:	29 d8                	sub    %ebx,%eax
80105b1c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b1f:	73 2f                	jae    80105b50 <sys_sleep+0x90>
    if(myproc()->killed){
80105b21:	e8 9a e0 ff ff       	call   80103bc0 <myproc>
80105b26:	8b 40 24             	mov    0x24(%eax),%eax
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	74 d3                	je     80105b00 <sys_sleep+0x40>
      release(&tickslock);
80105b2d:	83 ec 0c             	sub    $0xc,%esp
80105b30:	68 60 d3 11 80       	push   $0x8011d360
80105b35:	e8 f6 ed ff ff       	call   80104930 <release>
      return -1;
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105b42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b45:	c9                   	leave  
80105b46:	c3                   	ret    
80105b47:	89 f6                	mov    %esi,%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105b50:	83 ec 0c             	sub    $0xc,%esp
80105b53:	68 60 d3 11 80       	push   $0x8011d360
80105b58:	e8 d3 ed ff ff       	call   80104930 <release>
  return 0;
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	31 c0                	xor    %eax,%eax
}
80105b62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b65:	c9                   	leave  
80105b66:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6c:	eb d4                	jmp    80105b42 <sys_sleep+0x82>
80105b6e:	66 90                	xchg   %ax,%ax

80105b70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	53                   	push   %ebx
80105b74:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b77:	68 60 d3 11 80       	push   $0x8011d360
80105b7c:	e8 8f ec ff ff       	call   80104810 <acquire>
  xticks = ticks;
80105b81:	8b 1d a0 db 11 80    	mov    0x8011dba0,%ebx
  release(&tickslock);
80105b87:	c7 04 24 60 d3 11 80 	movl   $0x8011d360,(%esp)
80105b8e:	e8 9d ed ff ff       	call   80104930 <release>
  return xticks;
}
80105b93:	89 d8                	mov    %ebx,%eax
80105b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b98:	c9                   	leave  
80105b99:	c3                   	ret    

80105b9a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b9a:	1e                   	push   %ds
  pushl %es
80105b9b:	06                   	push   %es
  pushl %fs
80105b9c:	0f a0                	push   %fs
  pushl %gs
80105b9e:	0f a8                	push   %gs
  pushal
80105ba0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ba1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ba5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ba7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ba9:	54                   	push   %esp
  call trap
80105baa:	e8 e1 00 00 00       	call   80105c90 <trap>
  addl $4, %esp
80105baf:	83 c4 04             	add    $0x4,%esp

80105bb2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bb2:	61                   	popa   
  popl %gs
80105bb3:	0f a9                	pop    %gs
  popl %fs
80105bb5:	0f a1                	pop    %fs
  popl %es
80105bb7:	07                   	pop    %es
  popl %ds
80105bb8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bb9:	83 c4 08             	add    $0x8,%esp
  iret
80105bbc:	cf                   	iret   
80105bbd:	66 90                	xchg   %ax,%ax
80105bbf:	90                   	nop

80105bc0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105bc0:	31 c0                	xor    %eax,%eax
80105bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bc8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105bcf:	b9 08 00 00 00       	mov    $0x8,%ecx
80105bd4:	c6 04 c5 a4 d3 11 80 	movb   $0x0,-0x7fee2c5c(,%eax,8)
80105bdb:	00 
80105bdc:	66 89 0c c5 a2 d3 11 	mov    %cx,-0x7fee2c5e(,%eax,8)
80105be3:	80 
80105be4:	c6 04 c5 a5 d3 11 80 	movb   $0x8e,-0x7fee2c5b(,%eax,8)
80105beb:	8e 
80105bec:	66 89 14 c5 a0 d3 11 	mov    %dx,-0x7fee2c60(,%eax,8)
80105bf3:	80 
80105bf4:	c1 ea 10             	shr    $0x10,%edx
80105bf7:	66 89 14 c5 a6 d3 11 	mov    %dx,-0x7fee2c5a(,%eax,8)
80105bfe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105bff:	83 c0 01             	add    $0x1,%eax
80105c02:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c07:	75 bf                	jne    80105bc8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c09:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c0a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c0f:	89 e5                	mov    %esp,%ebp
80105c11:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c14:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105c19:	68 f9 84 10 80       	push   $0x801084f9
80105c1e:	68 60 d3 11 80       	push   $0x8011d360
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c23:	66 89 15 a2 d5 11 80 	mov    %dx,0x8011d5a2
80105c2a:	c6 05 a4 d5 11 80 00 	movb   $0x0,0x8011d5a4
80105c31:	66 a3 a0 d5 11 80    	mov    %ax,0x8011d5a0
80105c37:	c1 e8 10             	shr    $0x10,%eax
80105c3a:	c6 05 a5 d5 11 80 ef 	movb   $0xef,0x8011d5a5
80105c41:	66 a3 a6 d5 11 80    	mov    %ax,0x8011d5a6

  initlock(&tickslock, "time");
80105c47:	e8 c4 ea ff ff       	call   80104710 <initlock>
}
80105c4c:	83 c4 10             	add    $0x10,%esp
80105c4f:	c9                   	leave  
80105c50:	c3                   	ret    
80105c51:	eb 0d                	jmp    80105c60 <idtinit>
80105c53:	90                   	nop
80105c54:	90                   	nop
80105c55:	90                   	nop
80105c56:	90                   	nop
80105c57:	90                   	nop
80105c58:	90                   	nop
80105c59:	90                   	nop
80105c5a:	90                   	nop
80105c5b:	90                   	nop
80105c5c:	90                   	nop
80105c5d:	90                   	nop
80105c5e:	90                   	nop
80105c5f:	90                   	nop

80105c60 <idtinit>:

void
idtinit(void)
{
80105c60:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105c61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c66:	89 e5                	mov    %esp,%ebp
80105c68:	83 ec 10             	sub    $0x10,%esp
80105c6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c6f:	b8 a0 d3 11 80       	mov    $0x8011d3a0,%eax
80105c74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c78:	c1 e8 10             	shr    $0x10,%eax
80105c7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105c7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c82:	0f 01 18             	lidtl  (%eax)

  lidt(idt, sizeof(idt));
}
80105c85:	c9                   	leave  
80105c86:	c3                   	ret    
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	57                   	push   %edi
80105c94:	56                   	push   %esi
80105c95:	53                   	push   %ebx
80105c96:	83 ec 1c             	sub    $0x1c,%esp
80105c99:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c9c:	8b 47 30             	mov    0x30(%edi),%eax
80105c9f:	83 f8 40             	cmp    $0x40,%eax
80105ca2:	0f 84 a8 01 00 00    	je     80105e50 <trap+0x1c0>
      exit();
    return;
  }

  int address;
  switch(tf->trapno){
80105ca8:	83 e8 0e             	sub    $0xe,%eax
80105cab:	83 f8 31             	cmp    $0x31,%eax
80105cae:	77 2c                	ja     80105cdc <trap+0x4c>
80105cb0:	ff 24 85 a0 85 10 80 	jmp    *-0x7fef7a60(,%eax,4)
80105cb7:	89 f6                	mov    %esi,%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105cc0:	0f 20 d3             	mov    %cr2,%ebx
    break;

   case T_PGFLT: 
    //ASS3 ========== if page fault occures
    address = rcr2(); //determine the faulting address
    if(!isInitOrShell(myproc())){
80105cc3:	e8 f8 de ff ff       	call   80103bc0 <myproc>
80105cc8:	83 ec 0c             	sub    $0xc,%esp
80105ccb:	50                   	push   %eax
80105ccc:	e8 bf e8 ff ff       	call   80104590 <isInitOrShell>
80105cd1:	83 c4 10             	add    $0x10,%esp
80105cd4:	85 c0                	test   %eax,%eax
80105cd6:	0f 84 ac 01 00 00    	je     80105e88 <trap+0x1f8>
	        break;
	    }
	}
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105cdc:	e8 df de ff ff       	call   80103bc0 <myproc>
80105ce1:	85 c0                	test   %eax,%eax
80105ce3:	0f 84 10 02 00 00    	je     80105ef9 <trap+0x269>
80105ce9:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105ced:	0f 84 06 02 00 00    	je     80105ef9 <trap+0x269>
80105cf3:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cf6:	8b 57 38             	mov    0x38(%edi),%edx
80105cf9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105cfc:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105cff:	e8 9c de ff ff       	call   80103ba0 <cpuid>
80105d04:	8b 77 34             	mov    0x34(%edi),%esi
80105d07:	8b 5f 30             	mov    0x30(%edi),%ebx
80105d0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d0d:	e8 ae de ff ff       	call   80103bc0 <myproc>
80105d12:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d15:	e8 a6 de ff ff       	call   80103bc0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d1a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d20:	51                   	push   %ecx
80105d21:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d22:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d25:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d28:	56                   	push   %esi
80105d29:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d2a:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d2d:	52                   	push   %edx
80105d2e:	ff 70 10             	pushl  0x10(%eax)
80105d31:	68 5c 85 10 80       	push   $0x8010855c
80105d36:	e8 25 a9 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d3b:	83 c4 20             	add    $0x20,%esp
80105d3e:	e8 7d de ff ff       	call   80103bc0 <myproc>
80105d43:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d4a:	e8 71 de ff ff       	call   80103bc0 <myproc>
80105d4f:	85 c0                	test   %eax,%eax
80105d51:	74 0c                	je     80105d5f <trap+0xcf>
80105d53:	e8 68 de ff ff       	call   80103bc0 <myproc>
80105d58:	8b 50 24             	mov    0x24(%eax),%edx
80105d5b:	85 d2                	test   %edx,%edx
80105d5d:	75 49                	jne    80105da8 <trap+0x118>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d5f:	e8 5c de ff ff       	call   80103bc0 <myproc>
80105d64:	85 c0                	test   %eax,%eax
80105d66:	74 0b                	je     80105d73 <trap+0xe3>
80105d68:	e8 53 de ff ff       	call   80103bc0 <myproc>
80105d6d:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d71:	74 4d                	je     80105dc0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d73:	e8 48 de ff ff       	call   80103bc0 <myproc>
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	74 1d                	je     80105d99 <trap+0x109>
80105d7c:	e8 3f de ff ff       	call   80103bc0 <myproc>
80105d81:	8b 40 24             	mov    0x24(%eax),%eax
80105d84:	85 c0                	test   %eax,%eax
80105d86:	74 11                	je     80105d99 <trap+0x109>
80105d88:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d8c:	83 e0 03             	and    $0x3,%eax
80105d8f:	66 83 f8 03          	cmp    $0x3,%ax
80105d93:	0f 84 e0 00 00 00    	je     80105e79 <trap+0x1e9>
    exit();
}
80105d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d9c:	5b                   	pop    %ebx
80105d9d:	5e                   	pop    %esi
80105d9e:	5f                   	pop    %edi
80105d9f:	5d                   	pop    %ebp
80105da0:	c3                   	ret    
80105da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da8:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105dac:	83 e0 03             	and    $0x3,%eax
80105daf:	66 83 f8 03          	cmp    $0x3,%ax
80105db3:	75 aa                	jne    80105d5f <trap+0xcf>
    exit();
80105db5:	e8 46 e2 ff ff       	call   80104000 <exit>
80105dba:	eb a3                	jmp    80105d5f <trap+0xcf>
80105dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105dc0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105dc4:	75 ad                	jne    80105d73 <trap+0xe3>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105dc6:	e8 65 e3 ff ff       	call   80104130 <yield>
80105dcb:	eb a6                	jmp    80105d73 <trap+0xe3>
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi
  }

  int address;
  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105dd0:	e8 cb dd ff ff       	call   80103ba0 <cpuid>
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	0f 84 e3 00 00 00    	je     80105ec0 <trap+0x230>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105ddd:	e8 ee cc ff ff       	call   80102ad0 <lapiceoi>
    break;
80105de2:	e9 63 ff ff ff       	jmp    80105d4a <trap+0xba>
80105de7:	89 f6                	mov    %esi,%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105df0:	e8 9b cb ff ff       	call   80102990 <kbdintr>
    lapiceoi();
80105df5:	e8 d6 cc ff ff       	call   80102ad0 <lapiceoi>
    break;
80105dfa:	e9 4b ff ff ff       	jmp    80105d4a <trap+0xba>
80105dff:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105e00:	e8 9b 02 00 00       	call   801060a0 <uartintr>
    lapiceoi();
80105e05:	e8 c6 cc ff ff       	call   80102ad0 <lapiceoi>
    break;
80105e0a:	e9 3b ff ff ff       	jmp    80105d4a <trap+0xba>
80105e0f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e10:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e14:	8b 77 38             	mov    0x38(%edi),%esi
80105e17:	e8 84 dd ff ff       	call   80103ba0 <cpuid>
80105e1c:	56                   	push   %esi
80105e1d:	53                   	push   %ebx
80105e1e:	50                   	push   %eax
80105e1f:	68 04 85 10 80       	push   $0x80108504
80105e24:	e8 37 a8 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105e29:	e8 a2 cc ff ff       	call   80102ad0 <lapiceoi>
    break;
80105e2e:	83 c4 10             	add    $0x10,%esp
80105e31:	e9 14 ff ff ff       	jmp    80105d4a <trap+0xba>
80105e36:	8d 76 00             	lea    0x0(%esi),%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      #endif
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e40:	e8 cb c5 ff ff       	call   80102410 <ideintr>
80105e45:	eb 96                	jmp    80105ddd <trap+0x14d>
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105e50:	e8 6b dd ff ff       	call   80103bc0 <myproc>
80105e55:	8b 58 24             	mov    0x24(%eax),%ebx
80105e58:	85 db                	test   %ebx,%ebx
80105e5a:	75 54                	jne    80105eb0 <trap+0x220>
      exit();
    myproc()->tf = tf;
80105e5c:	e8 5f dd ff ff       	call   80103bc0 <myproc>
80105e61:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e64:	e8 17 ef ff ff       	call   80104d80 <syscall>
    if(myproc()->killed)
80105e69:	e8 52 dd ff ff       	call   80103bc0 <myproc>
80105e6e:	8b 48 24             	mov    0x24(%eax),%ecx
80105e71:	85 c9                	test   %ecx,%ecx
80105e73:	0f 84 20 ff ff ff    	je     80105d99 <trap+0x109>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e7c:	5b                   	pop    %ebx
80105e7d:	5e                   	pop    %esi
80105e7e:	5f                   	pop    %edi
80105e7f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105e80:	e9 7b e1 ff ff       	jmp    80104000 <exit>
80105e85:	8d 76 00             	lea    0x0(%esi),%esi

   case T_PGFLT: 
    //ASS3 ========== if page fault occures
    address = rcr2(); //determine the faulting address
    if(!isInitOrShell(myproc())){
	    if (retrievingPages((void*)address) != 0){ 
80105e88:	83 ec 0c             	sub    $0xc,%esp
80105e8b:	53                   	push   %ebx
80105e8c:	e8 5f 16 00 00       	call   801074f0 <retrievingPages>
80105e91:	83 c4 10             	add    $0x10,%esp
80105e94:	85 c0                	test   %eax,%eax
80105e96:	0f 84 40 fe ff ff    	je     80105cdc <trap+0x4c>
	        myproc()->pageFaultsCount++;
80105e9c:	e8 1f dd ff ff       	call   80103bc0 <myproc>
80105ea1:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
	        break;
80105ea8:	e9 9d fe ff ff       	jmp    80105d4a <trap+0xba>
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105eb0:	e8 4b e1 ff ff       	call   80104000 <exit>
80105eb5:	eb a5                	jmp    80105e5c <trap+0x1cc>
80105eb7:	89 f6                	mov    %esi,%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  int address;
  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105ec0:	83 ec 0c             	sub    $0xc,%esp
80105ec3:	68 60 d3 11 80       	push   $0x8011d360
80105ec8:	e8 43 e9 ff ff       	call   80104810 <acquire>
      ticks++;
      wakeup(&ticks);
80105ecd:	c7 04 24 a0 db 11 80 	movl   $0x8011dba0,(%esp)
  int address;
  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105ed4:	83 05 a0 db 11 80 01 	addl   $0x1,0x8011dba0
      wakeup(&ticks);
80105edb:	e8 60 e4 ff ff       	call   80104340 <wakeup>
      release(&tickslock);
80105ee0:	c7 04 24 60 d3 11 80 	movl   $0x8011d360,(%esp)
80105ee7:	e8 44 ea ff ff       	call   80104930 <release>
      #ifdef LAPA
      	accessesUpdate();
80105eec:	e8 ff e5 ff ff       	call   801044f0 <accessesUpdate>
80105ef1:	83 c4 10             	add    $0x10,%esp
80105ef4:	e9 e4 fe ff ff       	jmp    80105ddd <trap+0x14d>
80105ef9:	0f 20 d6             	mov    %cr2,%esi
	}
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105efc:	8b 5f 38             	mov    0x38(%edi),%ebx
80105eff:	e8 9c dc ff ff       	call   80103ba0 <cpuid>
80105f04:	83 ec 0c             	sub    $0xc,%esp
80105f07:	56                   	push   %esi
80105f08:	53                   	push   %ebx
80105f09:	50                   	push   %eax
80105f0a:	ff 77 30             	pushl  0x30(%edi)
80105f0d:	68 28 85 10 80       	push   $0x80108528
80105f12:	e8 49 a7 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105f17:	83 c4 14             	add    $0x14,%esp
80105f1a:	68 fe 84 10 80       	push   $0x801084fe
80105f1f:	e8 4c a4 ff ff       	call   80100370 <panic>
80105f24:	66 90                	xchg   %ax,%ax
80105f26:	66 90                	xchg   %ax,%ax
80105f28:	66 90                	xchg   %ax,%ax
80105f2a:	66 90                	xchg   %ax,%ax
80105f2c:	66 90                	xchg   %ax,%ax
80105f2e:	66 90                	xchg   %ax,%ax

80105f30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f30:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105f35:	55                   	push   %ebp
80105f36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f38:	85 c0                	test   %eax,%eax
80105f3a:	74 1c                	je     80105f58 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f42:	a8 01                	test   $0x1,%al
80105f44:	74 12                	je     80105f58 <uartgetc+0x28>
80105f46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f4c:	0f b6 c0             	movzbl %al,%eax
}
80105f4f:	5d                   	pop    %ebp
80105f50:	c3                   	ret    
80105f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105f5d:	5d                   	pop    %ebp
80105f5e:	c3                   	ret    
80105f5f:	90                   	nop

80105f60 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	57                   	push   %edi
80105f64:	56                   	push   %esi
80105f65:	53                   	push   %ebx
80105f66:	89 c7                	mov    %eax,%edi
80105f68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f72:	83 ec 0c             	sub    $0xc,%esp
80105f75:	eb 1b                	jmp    80105f92 <uartputc.part.0+0x32>
80105f77:	89 f6                	mov    %esi,%esi
80105f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105f80:	83 ec 0c             	sub    $0xc,%esp
80105f83:	6a 0a                	push   $0xa
80105f85:	e8 66 cb ff ff       	call   80102af0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f8a:	83 c4 10             	add    $0x10,%esp
80105f8d:	83 eb 01             	sub    $0x1,%ebx
80105f90:	74 07                	je     80105f99 <uartputc.part.0+0x39>
80105f92:	89 f2                	mov    %esi,%edx
80105f94:	ec                   	in     (%dx),%al
80105f95:	a8 20                	test   $0x20,%al
80105f97:	74 e7                	je     80105f80 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9e:	89 f8                	mov    %edi,%eax
80105fa0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fa4:	5b                   	pop    %ebx
80105fa5:	5e                   	pop    %esi
80105fa6:	5f                   	pop    %edi
80105fa7:	5d                   	pop    %ebp
80105fa8:	c3                   	ret    
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fb0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	31 c9                	xor    %ecx,%ecx
80105fb3:	89 c8                	mov    %ecx,%eax
80105fb5:	89 e5                	mov    %esp,%ebp
80105fb7:	57                   	push   %edi
80105fb8:	56                   	push   %esi
80105fb9:	53                   	push   %ebx
80105fba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105fbf:	89 da                	mov    %ebx,%edx
80105fc1:	83 ec 0c             	sub    $0xc,%esp
80105fc4:	ee                   	out    %al,(%dx)
80105fc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105fca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105fcf:	89 fa                	mov    %edi,%edx
80105fd1:	ee                   	out    %al,(%dx)
80105fd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105fd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fdc:	ee                   	out    %al,(%dx)
80105fdd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105fe2:	89 c8                	mov    %ecx,%eax
80105fe4:	89 f2                	mov    %esi,%edx
80105fe6:	ee                   	out    %al,(%dx)
80105fe7:	b8 03 00 00 00       	mov    $0x3,%eax
80105fec:	89 fa                	mov    %edi,%edx
80105fee:	ee                   	out    %al,(%dx)
80105fef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ff4:	89 c8                	mov    %ecx,%eax
80105ff6:	ee                   	out    %al,(%dx)
80105ff7:	b8 01 00 00 00       	mov    $0x1,%eax
80105ffc:	89 f2                	mov    %esi,%edx
80105ffe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106004:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106005:	3c ff                	cmp    $0xff,%al
80106007:	74 5a                	je     80106063 <uartinit+0xb3>
    return;
  uart = 1;
80106009:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106010:	00 00 00 
80106013:	89 da                	mov    %ebx,%edx
80106015:	ec                   	in     (%dx),%al
80106016:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010601b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010601c:	83 ec 08             	sub    $0x8,%esp
8010601f:	bb 68 86 10 80       	mov    $0x80108668,%ebx
80106024:	6a 00                	push   $0x0
80106026:	6a 04                	push   $0x4
80106028:	e8 33 c6 ff ff       	call   80102660 <ioapicenable>
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	b8 78 00 00 00       	mov    $0x78,%eax
80106035:	eb 13                	jmp    8010604a <uartinit+0x9a>
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106040:	83 c3 01             	add    $0x1,%ebx
80106043:	0f be 03             	movsbl (%ebx),%eax
80106046:	84 c0                	test   %al,%al
80106048:	74 19                	je     80106063 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010604a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106050:	85 d2                	test   %edx,%edx
80106052:	74 ec                	je     80106040 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106054:	83 c3 01             	add    $0x1,%ebx
80106057:	e8 04 ff ff ff       	call   80105f60 <uartputc.part.0>
8010605c:	0f be 03             	movsbl (%ebx),%eax
8010605f:	84 c0                	test   %al,%al
80106061:	75 e7                	jne    8010604a <uartinit+0x9a>
    uartputc(*p);
}
80106063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106066:	5b                   	pop    %ebx
80106067:	5e                   	pop    %esi
80106068:	5f                   	pop    %edi
80106069:	5d                   	pop    %ebp
8010606a:	c3                   	ret    
8010606b:	90                   	nop
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106070 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106070:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106076:	55                   	push   %ebp
80106077:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106079:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010607b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010607e:	74 10                	je     80106090 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106080:	5d                   	pop    %ebp
80106081:	e9 da fe ff ff       	jmp    80105f60 <uartputc.part.0>
80106086:	8d 76 00             	lea    0x0(%esi),%esi
80106089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106090:	5d                   	pop    %ebp
80106091:	c3                   	ret    
80106092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060a0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060a6:	68 30 5f 10 80       	push   $0x80105f30
801060ab:	e8 40 a7 ff ff       	call   801007f0 <consoleintr>
}
801060b0:	83 c4 10             	add    $0x10,%esp
801060b3:	c9                   	leave  
801060b4:	c3                   	ret    

801060b5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $0
801060b7:	6a 00                	push   $0x0
  jmp alltraps
801060b9:	e9 dc fa ff ff       	jmp    80105b9a <alltraps>

801060be <vector1>:
.globl vector1
vector1:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $1
801060c0:	6a 01                	push   $0x1
  jmp alltraps
801060c2:	e9 d3 fa ff ff       	jmp    80105b9a <alltraps>

801060c7 <vector2>:
.globl vector2
vector2:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $2
801060c9:	6a 02                	push   $0x2
  jmp alltraps
801060cb:	e9 ca fa ff ff       	jmp    80105b9a <alltraps>

801060d0 <vector3>:
.globl vector3
vector3:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $3
801060d2:	6a 03                	push   $0x3
  jmp alltraps
801060d4:	e9 c1 fa ff ff       	jmp    80105b9a <alltraps>

801060d9 <vector4>:
.globl vector4
vector4:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $4
801060db:	6a 04                	push   $0x4
  jmp alltraps
801060dd:	e9 b8 fa ff ff       	jmp    80105b9a <alltraps>

801060e2 <vector5>:
.globl vector5
vector5:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $5
801060e4:	6a 05                	push   $0x5
  jmp alltraps
801060e6:	e9 af fa ff ff       	jmp    80105b9a <alltraps>

801060eb <vector6>:
.globl vector6
vector6:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $6
801060ed:	6a 06                	push   $0x6
  jmp alltraps
801060ef:	e9 a6 fa ff ff       	jmp    80105b9a <alltraps>

801060f4 <vector7>:
.globl vector7
vector7:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $7
801060f6:	6a 07                	push   $0x7
  jmp alltraps
801060f8:	e9 9d fa ff ff       	jmp    80105b9a <alltraps>

801060fd <vector8>:
.globl vector8
vector8:
  pushl $8
801060fd:	6a 08                	push   $0x8
  jmp alltraps
801060ff:	e9 96 fa ff ff       	jmp    80105b9a <alltraps>

80106104 <vector9>:
.globl vector9
vector9:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $9
80106106:	6a 09                	push   $0x9
  jmp alltraps
80106108:	e9 8d fa ff ff       	jmp    80105b9a <alltraps>

8010610d <vector10>:
.globl vector10
vector10:
  pushl $10
8010610d:	6a 0a                	push   $0xa
  jmp alltraps
8010610f:	e9 86 fa ff ff       	jmp    80105b9a <alltraps>

80106114 <vector11>:
.globl vector11
vector11:
  pushl $11
80106114:	6a 0b                	push   $0xb
  jmp alltraps
80106116:	e9 7f fa ff ff       	jmp    80105b9a <alltraps>

8010611b <vector12>:
.globl vector12
vector12:
  pushl $12
8010611b:	6a 0c                	push   $0xc
  jmp alltraps
8010611d:	e9 78 fa ff ff       	jmp    80105b9a <alltraps>

80106122 <vector13>:
.globl vector13
vector13:
  pushl $13
80106122:	6a 0d                	push   $0xd
  jmp alltraps
80106124:	e9 71 fa ff ff       	jmp    80105b9a <alltraps>

80106129 <vector14>:
.globl vector14
vector14:
  pushl $14
80106129:	6a 0e                	push   $0xe
  jmp alltraps
8010612b:	e9 6a fa ff ff       	jmp    80105b9a <alltraps>

80106130 <vector15>:
.globl vector15
vector15:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $15
80106132:	6a 0f                	push   $0xf
  jmp alltraps
80106134:	e9 61 fa ff ff       	jmp    80105b9a <alltraps>

80106139 <vector16>:
.globl vector16
vector16:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $16
8010613b:	6a 10                	push   $0x10
  jmp alltraps
8010613d:	e9 58 fa ff ff       	jmp    80105b9a <alltraps>

80106142 <vector17>:
.globl vector17
vector17:
  pushl $17
80106142:	6a 11                	push   $0x11
  jmp alltraps
80106144:	e9 51 fa ff ff       	jmp    80105b9a <alltraps>

80106149 <vector18>:
.globl vector18
vector18:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $18
8010614b:	6a 12                	push   $0x12
  jmp alltraps
8010614d:	e9 48 fa ff ff       	jmp    80105b9a <alltraps>

80106152 <vector19>:
.globl vector19
vector19:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $19
80106154:	6a 13                	push   $0x13
  jmp alltraps
80106156:	e9 3f fa ff ff       	jmp    80105b9a <alltraps>

8010615b <vector20>:
.globl vector20
vector20:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $20
8010615d:	6a 14                	push   $0x14
  jmp alltraps
8010615f:	e9 36 fa ff ff       	jmp    80105b9a <alltraps>

80106164 <vector21>:
.globl vector21
vector21:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $21
80106166:	6a 15                	push   $0x15
  jmp alltraps
80106168:	e9 2d fa ff ff       	jmp    80105b9a <alltraps>

8010616d <vector22>:
.globl vector22
vector22:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $22
8010616f:	6a 16                	push   $0x16
  jmp alltraps
80106171:	e9 24 fa ff ff       	jmp    80105b9a <alltraps>

80106176 <vector23>:
.globl vector23
vector23:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $23
80106178:	6a 17                	push   $0x17
  jmp alltraps
8010617a:	e9 1b fa ff ff       	jmp    80105b9a <alltraps>

8010617f <vector24>:
.globl vector24
vector24:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $24
80106181:	6a 18                	push   $0x18
  jmp alltraps
80106183:	e9 12 fa ff ff       	jmp    80105b9a <alltraps>

80106188 <vector25>:
.globl vector25
vector25:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $25
8010618a:	6a 19                	push   $0x19
  jmp alltraps
8010618c:	e9 09 fa ff ff       	jmp    80105b9a <alltraps>

80106191 <vector26>:
.globl vector26
vector26:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $26
80106193:	6a 1a                	push   $0x1a
  jmp alltraps
80106195:	e9 00 fa ff ff       	jmp    80105b9a <alltraps>

8010619a <vector27>:
.globl vector27
vector27:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $27
8010619c:	6a 1b                	push   $0x1b
  jmp alltraps
8010619e:	e9 f7 f9 ff ff       	jmp    80105b9a <alltraps>

801061a3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $28
801061a5:	6a 1c                	push   $0x1c
  jmp alltraps
801061a7:	e9 ee f9 ff ff       	jmp    80105b9a <alltraps>

801061ac <vector29>:
.globl vector29
vector29:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $29
801061ae:	6a 1d                	push   $0x1d
  jmp alltraps
801061b0:	e9 e5 f9 ff ff       	jmp    80105b9a <alltraps>

801061b5 <vector30>:
.globl vector30
vector30:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $30
801061b7:	6a 1e                	push   $0x1e
  jmp alltraps
801061b9:	e9 dc f9 ff ff       	jmp    80105b9a <alltraps>

801061be <vector31>:
.globl vector31
vector31:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $31
801061c0:	6a 1f                	push   $0x1f
  jmp alltraps
801061c2:	e9 d3 f9 ff ff       	jmp    80105b9a <alltraps>

801061c7 <vector32>:
.globl vector32
vector32:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $32
801061c9:	6a 20                	push   $0x20
  jmp alltraps
801061cb:	e9 ca f9 ff ff       	jmp    80105b9a <alltraps>

801061d0 <vector33>:
.globl vector33
vector33:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $33
801061d2:	6a 21                	push   $0x21
  jmp alltraps
801061d4:	e9 c1 f9 ff ff       	jmp    80105b9a <alltraps>

801061d9 <vector34>:
.globl vector34
vector34:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $34
801061db:	6a 22                	push   $0x22
  jmp alltraps
801061dd:	e9 b8 f9 ff ff       	jmp    80105b9a <alltraps>

801061e2 <vector35>:
.globl vector35
vector35:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $35
801061e4:	6a 23                	push   $0x23
  jmp alltraps
801061e6:	e9 af f9 ff ff       	jmp    80105b9a <alltraps>

801061eb <vector36>:
.globl vector36
vector36:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $36
801061ed:	6a 24                	push   $0x24
  jmp alltraps
801061ef:	e9 a6 f9 ff ff       	jmp    80105b9a <alltraps>

801061f4 <vector37>:
.globl vector37
vector37:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $37
801061f6:	6a 25                	push   $0x25
  jmp alltraps
801061f8:	e9 9d f9 ff ff       	jmp    80105b9a <alltraps>

801061fd <vector38>:
.globl vector38
vector38:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $38
801061ff:	6a 26                	push   $0x26
  jmp alltraps
80106201:	e9 94 f9 ff ff       	jmp    80105b9a <alltraps>

80106206 <vector39>:
.globl vector39
vector39:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $39
80106208:	6a 27                	push   $0x27
  jmp alltraps
8010620a:	e9 8b f9 ff ff       	jmp    80105b9a <alltraps>

8010620f <vector40>:
.globl vector40
vector40:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $40
80106211:	6a 28                	push   $0x28
  jmp alltraps
80106213:	e9 82 f9 ff ff       	jmp    80105b9a <alltraps>

80106218 <vector41>:
.globl vector41
vector41:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $41
8010621a:	6a 29                	push   $0x29
  jmp alltraps
8010621c:	e9 79 f9 ff ff       	jmp    80105b9a <alltraps>

80106221 <vector42>:
.globl vector42
vector42:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $42
80106223:	6a 2a                	push   $0x2a
  jmp alltraps
80106225:	e9 70 f9 ff ff       	jmp    80105b9a <alltraps>

8010622a <vector43>:
.globl vector43
vector43:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $43
8010622c:	6a 2b                	push   $0x2b
  jmp alltraps
8010622e:	e9 67 f9 ff ff       	jmp    80105b9a <alltraps>

80106233 <vector44>:
.globl vector44
vector44:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $44
80106235:	6a 2c                	push   $0x2c
  jmp alltraps
80106237:	e9 5e f9 ff ff       	jmp    80105b9a <alltraps>

8010623c <vector45>:
.globl vector45
vector45:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $45
8010623e:	6a 2d                	push   $0x2d
  jmp alltraps
80106240:	e9 55 f9 ff ff       	jmp    80105b9a <alltraps>

80106245 <vector46>:
.globl vector46
vector46:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $46
80106247:	6a 2e                	push   $0x2e
  jmp alltraps
80106249:	e9 4c f9 ff ff       	jmp    80105b9a <alltraps>

8010624e <vector47>:
.globl vector47
vector47:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $47
80106250:	6a 2f                	push   $0x2f
  jmp alltraps
80106252:	e9 43 f9 ff ff       	jmp    80105b9a <alltraps>

80106257 <vector48>:
.globl vector48
vector48:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $48
80106259:	6a 30                	push   $0x30
  jmp alltraps
8010625b:	e9 3a f9 ff ff       	jmp    80105b9a <alltraps>

80106260 <vector49>:
.globl vector49
vector49:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $49
80106262:	6a 31                	push   $0x31
  jmp alltraps
80106264:	e9 31 f9 ff ff       	jmp    80105b9a <alltraps>

80106269 <vector50>:
.globl vector50
vector50:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $50
8010626b:	6a 32                	push   $0x32
  jmp alltraps
8010626d:	e9 28 f9 ff ff       	jmp    80105b9a <alltraps>

80106272 <vector51>:
.globl vector51
vector51:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $51
80106274:	6a 33                	push   $0x33
  jmp alltraps
80106276:	e9 1f f9 ff ff       	jmp    80105b9a <alltraps>

8010627b <vector52>:
.globl vector52
vector52:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $52
8010627d:	6a 34                	push   $0x34
  jmp alltraps
8010627f:	e9 16 f9 ff ff       	jmp    80105b9a <alltraps>

80106284 <vector53>:
.globl vector53
vector53:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $53
80106286:	6a 35                	push   $0x35
  jmp alltraps
80106288:	e9 0d f9 ff ff       	jmp    80105b9a <alltraps>

8010628d <vector54>:
.globl vector54
vector54:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $54
8010628f:	6a 36                	push   $0x36
  jmp alltraps
80106291:	e9 04 f9 ff ff       	jmp    80105b9a <alltraps>

80106296 <vector55>:
.globl vector55
vector55:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $55
80106298:	6a 37                	push   $0x37
  jmp alltraps
8010629a:	e9 fb f8 ff ff       	jmp    80105b9a <alltraps>

8010629f <vector56>:
.globl vector56
vector56:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $56
801062a1:	6a 38                	push   $0x38
  jmp alltraps
801062a3:	e9 f2 f8 ff ff       	jmp    80105b9a <alltraps>

801062a8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $57
801062aa:	6a 39                	push   $0x39
  jmp alltraps
801062ac:	e9 e9 f8 ff ff       	jmp    80105b9a <alltraps>

801062b1 <vector58>:
.globl vector58
vector58:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $58
801062b3:	6a 3a                	push   $0x3a
  jmp alltraps
801062b5:	e9 e0 f8 ff ff       	jmp    80105b9a <alltraps>

801062ba <vector59>:
.globl vector59
vector59:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $59
801062bc:	6a 3b                	push   $0x3b
  jmp alltraps
801062be:	e9 d7 f8 ff ff       	jmp    80105b9a <alltraps>

801062c3 <vector60>:
.globl vector60
vector60:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $60
801062c5:	6a 3c                	push   $0x3c
  jmp alltraps
801062c7:	e9 ce f8 ff ff       	jmp    80105b9a <alltraps>

801062cc <vector61>:
.globl vector61
vector61:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $61
801062ce:	6a 3d                	push   $0x3d
  jmp alltraps
801062d0:	e9 c5 f8 ff ff       	jmp    80105b9a <alltraps>

801062d5 <vector62>:
.globl vector62
vector62:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $62
801062d7:	6a 3e                	push   $0x3e
  jmp alltraps
801062d9:	e9 bc f8 ff ff       	jmp    80105b9a <alltraps>

801062de <vector63>:
.globl vector63
vector63:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $63
801062e0:	6a 3f                	push   $0x3f
  jmp alltraps
801062e2:	e9 b3 f8 ff ff       	jmp    80105b9a <alltraps>

801062e7 <vector64>:
.globl vector64
vector64:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $64
801062e9:	6a 40                	push   $0x40
  jmp alltraps
801062eb:	e9 aa f8 ff ff       	jmp    80105b9a <alltraps>

801062f0 <vector65>:
.globl vector65
vector65:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $65
801062f2:	6a 41                	push   $0x41
  jmp alltraps
801062f4:	e9 a1 f8 ff ff       	jmp    80105b9a <alltraps>

801062f9 <vector66>:
.globl vector66
vector66:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $66
801062fb:	6a 42                	push   $0x42
  jmp alltraps
801062fd:	e9 98 f8 ff ff       	jmp    80105b9a <alltraps>

80106302 <vector67>:
.globl vector67
vector67:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $67
80106304:	6a 43                	push   $0x43
  jmp alltraps
80106306:	e9 8f f8 ff ff       	jmp    80105b9a <alltraps>

8010630b <vector68>:
.globl vector68
vector68:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $68
8010630d:	6a 44                	push   $0x44
  jmp alltraps
8010630f:	e9 86 f8 ff ff       	jmp    80105b9a <alltraps>

80106314 <vector69>:
.globl vector69
vector69:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $69
80106316:	6a 45                	push   $0x45
  jmp alltraps
80106318:	e9 7d f8 ff ff       	jmp    80105b9a <alltraps>

8010631d <vector70>:
.globl vector70
vector70:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $70
8010631f:	6a 46                	push   $0x46
  jmp alltraps
80106321:	e9 74 f8 ff ff       	jmp    80105b9a <alltraps>

80106326 <vector71>:
.globl vector71
vector71:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $71
80106328:	6a 47                	push   $0x47
  jmp alltraps
8010632a:	e9 6b f8 ff ff       	jmp    80105b9a <alltraps>

8010632f <vector72>:
.globl vector72
vector72:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $72
80106331:	6a 48                	push   $0x48
  jmp alltraps
80106333:	e9 62 f8 ff ff       	jmp    80105b9a <alltraps>

80106338 <vector73>:
.globl vector73
vector73:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $73
8010633a:	6a 49                	push   $0x49
  jmp alltraps
8010633c:	e9 59 f8 ff ff       	jmp    80105b9a <alltraps>

80106341 <vector74>:
.globl vector74
vector74:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $74
80106343:	6a 4a                	push   $0x4a
  jmp alltraps
80106345:	e9 50 f8 ff ff       	jmp    80105b9a <alltraps>

8010634a <vector75>:
.globl vector75
vector75:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $75
8010634c:	6a 4b                	push   $0x4b
  jmp alltraps
8010634e:	e9 47 f8 ff ff       	jmp    80105b9a <alltraps>

80106353 <vector76>:
.globl vector76
vector76:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $76
80106355:	6a 4c                	push   $0x4c
  jmp alltraps
80106357:	e9 3e f8 ff ff       	jmp    80105b9a <alltraps>

8010635c <vector77>:
.globl vector77
vector77:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $77
8010635e:	6a 4d                	push   $0x4d
  jmp alltraps
80106360:	e9 35 f8 ff ff       	jmp    80105b9a <alltraps>

80106365 <vector78>:
.globl vector78
vector78:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $78
80106367:	6a 4e                	push   $0x4e
  jmp alltraps
80106369:	e9 2c f8 ff ff       	jmp    80105b9a <alltraps>

8010636e <vector79>:
.globl vector79
vector79:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $79
80106370:	6a 4f                	push   $0x4f
  jmp alltraps
80106372:	e9 23 f8 ff ff       	jmp    80105b9a <alltraps>

80106377 <vector80>:
.globl vector80
vector80:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $80
80106379:	6a 50                	push   $0x50
  jmp alltraps
8010637b:	e9 1a f8 ff ff       	jmp    80105b9a <alltraps>

80106380 <vector81>:
.globl vector81
vector81:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $81
80106382:	6a 51                	push   $0x51
  jmp alltraps
80106384:	e9 11 f8 ff ff       	jmp    80105b9a <alltraps>

80106389 <vector82>:
.globl vector82
vector82:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $82
8010638b:	6a 52                	push   $0x52
  jmp alltraps
8010638d:	e9 08 f8 ff ff       	jmp    80105b9a <alltraps>

80106392 <vector83>:
.globl vector83
vector83:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $83
80106394:	6a 53                	push   $0x53
  jmp alltraps
80106396:	e9 ff f7 ff ff       	jmp    80105b9a <alltraps>

8010639b <vector84>:
.globl vector84
vector84:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $84
8010639d:	6a 54                	push   $0x54
  jmp alltraps
8010639f:	e9 f6 f7 ff ff       	jmp    80105b9a <alltraps>

801063a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $85
801063a6:	6a 55                	push   $0x55
  jmp alltraps
801063a8:	e9 ed f7 ff ff       	jmp    80105b9a <alltraps>

801063ad <vector86>:
.globl vector86
vector86:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $86
801063af:	6a 56                	push   $0x56
  jmp alltraps
801063b1:	e9 e4 f7 ff ff       	jmp    80105b9a <alltraps>

801063b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $87
801063b8:	6a 57                	push   $0x57
  jmp alltraps
801063ba:	e9 db f7 ff ff       	jmp    80105b9a <alltraps>

801063bf <vector88>:
.globl vector88
vector88:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $88
801063c1:	6a 58                	push   $0x58
  jmp alltraps
801063c3:	e9 d2 f7 ff ff       	jmp    80105b9a <alltraps>

801063c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $89
801063ca:	6a 59                	push   $0x59
  jmp alltraps
801063cc:	e9 c9 f7 ff ff       	jmp    80105b9a <alltraps>

801063d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $90
801063d3:	6a 5a                	push   $0x5a
  jmp alltraps
801063d5:	e9 c0 f7 ff ff       	jmp    80105b9a <alltraps>

801063da <vector91>:
.globl vector91
vector91:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $91
801063dc:	6a 5b                	push   $0x5b
  jmp alltraps
801063de:	e9 b7 f7 ff ff       	jmp    80105b9a <alltraps>

801063e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $92
801063e5:	6a 5c                	push   $0x5c
  jmp alltraps
801063e7:	e9 ae f7 ff ff       	jmp    80105b9a <alltraps>

801063ec <vector93>:
.globl vector93
vector93:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $93
801063ee:	6a 5d                	push   $0x5d
  jmp alltraps
801063f0:	e9 a5 f7 ff ff       	jmp    80105b9a <alltraps>

801063f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $94
801063f7:	6a 5e                	push   $0x5e
  jmp alltraps
801063f9:	e9 9c f7 ff ff       	jmp    80105b9a <alltraps>

801063fe <vector95>:
.globl vector95
vector95:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $95
80106400:	6a 5f                	push   $0x5f
  jmp alltraps
80106402:	e9 93 f7 ff ff       	jmp    80105b9a <alltraps>

80106407 <vector96>:
.globl vector96
vector96:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $96
80106409:	6a 60                	push   $0x60
  jmp alltraps
8010640b:	e9 8a f7 ff ff       	jmp    80105b9a <alltraps>

80106410 <vector97>:
.globl vector97
vector97:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $97
80106412:	6a 61                	push   $0x61
  jmp alltraps
80106414:	e9 81 f7 ff ff       	jmp    80105b9a <alltraps>

80106419 <vector98>:
.globl vector98
vector98:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $98
8010641b:	6a 62                	push   $0x62
  jmp alltraps
8010641d:	e9 78 f7 ff ff       	jmp    80105b9a <alltraps>

80106422 <vector99>:
.globl vector99
vector99:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $99
80106424:	6a 63                	push   $0x63
  jmp alltraps
80106426:	e9 6f f7 ff ff       	jmp    80105b9a <alltraps>

8010642b <vector100>:
.globl vector100
vector100:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $100
8010642d:	6a 64                	push   $0x64
  jmp alltraps
8010642f:	e9 66 f7 ff ff       	jmp    80105b9a <alltraps>

80106434 <vector101>:
.globl vector101
vector101:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $101
80106436:	6a 65                	push   $0x65
  jmp alltraps
80106438:	e9 5d f7 ff ff       	jmp    80105b9a <alltraps>

8010643d <vector102>:
.globl vector102
vector102:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $102
8010643f:	6a 66                	push   $0x66
  jmp alltraps
80106441:	e9 54 f7 ff ff       	jmp    80105b9a <alltraps>

80106446 <vector103>:
.globl vector103
vector103:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $103
80106448:	6a 67                	push   $0x67
  jmp alltraps
8010644a:	e9 4b f7 ff ff       	jmp    80105b9a <alltraps>

8010644f <vector104>:
.globl vector104
vector104:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $104
80106451:	6a 68                	push   $0x68
  jmp alltraps
80106453:	e9 42 f7 ff ff       	jmp    80105b9a <alltraps>

80106458 <vector105>:
.globl vector105
vector105:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $105
8010645a:	6a 69                	push   $0x69
  jmp alltraps
8010645c:	e9 39 f7 ff ff       	jmp    80105b9a <alltraps>

80106461 <vector106>:
.globl vector106
vector106:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $106
80106463:	6a 6a                	push   $0x6a
  jmp alltraps
80106465:	e9 30 f7 ff ff       	jmp    80105b9a <alltraps>

8010646a <vector107>:
.globl vector107
vector107:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $107
8010646c:	6a 6b                	push   $0x6b
  jmp alltraps
8010646e:	e9 27 f7 ff ff       	jmp    80105b9a <alltraps>

80106473 <vector108>:
.globl vector108
vector108:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $108
80106475:	6a 6c                	push   $0x6c
  jmp alltraps
80106477:	e9 1e f7 ff ff       	jmp    80105b9a <alltraps>

8010647c <vector109>:
.globl vector109
vector109:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $109
8010647e:	6a 6d                	push   $0x6d
  jmp alltraps
80106480:	e9 15 f7 ff ff       	jmp    80105b9a <alltraps>

80106485 <vector110>:
.globl vector110
vector110:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $110
80106487:	6a 6e                	push   $0x6e
  jmp alltraps
80106489:	e9 0c f7 ff ff       	jmp    80105b9a <alltraps>

8010648e <vector111>:
.globl vector111
vector111:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $111
80106490:	6a 6f                	push   $0x6f
  jmp alltraps
80106492:	e9 03 f7 ff ff       	jmp    80105b9a <alltraps>

80106497 <vector112>:
.globl vector112
vector112:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $112
80106499:	6a 70                	push   $0x70
  jmp alltraps
8010649b:	e9 fa f6 ff ff       	jmp    80105b9a <alltraps>

801064a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $113
801064a2:	6a 71                	push   $0x71
  jmp alltraps
801064a4:	e9 f1 f6 ff ff       	jmp    80105b9a <alltraps>

801064a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $114
801064ab:	6a 72                	push   $0x72
  jmp alltraps
801064ad:	e9 e8 f6 ff ff       	jmp    80105b9a <alltraps>

801064b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $115
801064b4:	6a 73                	push   $0x73
  jmp alltraps
801064b6:	e9 df f6 ff ff       	jmp    80105b9a <alltraps>

801064bb <vector116>:
.globl vector116
vector116:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $116
801064bd:	6a 74                	push   $0x74
  jmp alltraps
801064bf:	e9 d6 f6 ff ff       	jmp    80105b9a <alltraps>

801064c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $117
801064c6:	6a 75                	push   $0x75
  jmp alltraps
801064c8:	e9 cd f6 ff ff       	jmp    80105b9a <alltraps>

801064cd <vector118>:
.globl vector118
vector118:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $118
801064cf:	6a 76                	push   $0x76
  jmp alltraps
801064d1:	e9 c4 f6 ff ff       	jmp    80105b9a <alltraps>

801064d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $119
801064d8:	6a 77                	push   $0x77
  jmp alltraps
801064da:	e9 bb f6 ff ff       	jmp    80105b9a <alltraps>

801064df <vector120>:
.globl vector120
vector120:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $120
801064e1:	6a 78                	push   $0x78
  jmp alltraps
801064e3:	e9 b2 f6 ff ff       	jmp    80105b9a <alltraps>

801064e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $121
801064ea:	6a 79                	push   $0x79
  jmp alltraps
801064ec:	e9 a9 f6 ff ff       	jmp    80105b9a <alltraps>

801064f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $122
801064f3:	6a 7a                	push   $0x7a
  jmp alltraps
801064f5:	e9 a0 f6 ff ff       	jmp    80105b9a <alltraps>

801064fa <vector123>:
.globl vector123
vector123:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $123
801064fc:	6a 7b                	push   $0x7b
  jmp alltraps
801064fe:	e9 97 f6 ff ff       	jmp    80105b9a <alltraps>

80106503 <vector124>:
.globl vector124
vector124:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $124
80106505:	6a 7c                	push   $0x7c
  jmp alltraps
80106507:	e9 8e f6 ff ff       	jmp    80105b9a <alltraps>

8010650c <vector125>:
.globl vector125
vector125:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $125
8010650e:	6a 7d                	push   $0x7d
  jmp alltraps
80106510:	e9 85 f6 ff ff       	jmp    80105b9a <alltraps>

80106515 <vector126>:
.globl vector126
vector126:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $126
80106517:	6a 7e                	push   $0x7e
  jmp alltraps
80106519:	e9 7c f6 ff ff       	jmp    80105b9a <alltraps>

8010651e <vector127>:
.globl vector127
vector127:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $127
80106520:	6a 7f                	push   $0x7f
  jmp alltraps
80106522:	e9 73 f6 ff ff       	jmp    80105b9a <alltraps>

80106527 <vector128>:
.globl vector128
vector128:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $128
80106529:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010652e:	e9 67 f6 ff ff       	jmp    80105b9a <alltraps>

80106533 <vector129>:
.globl vector129
vector129:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $129
80106535:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010653a:	e9 5b f6 ff ff       	jmp    80105b9a <alltraps>

8010653f <vector130>:
.globl vector130
vector130:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $130
80106541:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106546:	e9 4f f6 ff ff       	jmp    80105b9a <alltraps>

8010654b <vector131>:
.globl vector131
vector131:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $131
8010654d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106552:	e9 43 f6 ff ff       	jmp    80105b9a <alltraps>

80106557 <vector132>:
.globl vector132
vector132:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $132
80106559:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010655e:	e9 37 f6 ff ff       	jmp    80105b9a <alltraps>

80106563 <vector133>:
.globl vector133
vector133:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $133
80106565:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010656a:	e9 2b f6 ff ff       	jmp    80105b9a <alltraps>

8010656f <vector134>:
.globl vector134
vector134:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $134
80106571:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106576:	e9 1f f6 ff ff       	jmp    80105b9a <alltraps>

8010657b <vector135>:
.globl vector135
vector135:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $135
8010657d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106582:	e9 13 f6 ff ff       	jmp    80105b9a <alltraps>

80106587 <vector136>:
.globl vector136
vector136:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $136
80106589:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010658e:	e9 07 f6 ff ff       	jmp    80105b9a <alltraps>

80106593 <vector137>:
.globl vector137
vector137:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $137
80106595:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010659a:	e9 fb f5 ff ff       	jmp    80105b9a <alltraps>

8010659f <vector138>:
.globl vector138
vector138:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $138
801065a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065a6:	e9 ef f5 ff ff       	jmp    80105b9a <alltraps>

801065ab <vector139>:
.globl vector139
vector139:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $139
801065ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065b2:	e9 e3 f5 ff ff       	jmp    80105b9a <alltraps>

801065b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $140
801065b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065be:	e9 d7 f5 ff ff       	jmp    80105b9a <alltraps>

801065c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $141
801065c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801065ca:	e9 cb f5 ff ff       	jmp    80105b9a <alltraps>

801065cf <vector142>:
.globl vector142
vector142:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $142
801065d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801065d6:	e9 bf f5 ff ff       	jmp    80105b9a <alltraps>

801065db <vector143>:
.globl vector143
vector143:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $143
801065dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801065e2:	e9 b3 f5 ff ff       	jmp    80105b9a <alltraps>

801065e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $144
801065e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801065ee:	e9 a7 f5 ff ff       	jmp    80105b9a <alltraps>

801065f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $145
801065f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801065fa:	e9 9b f5 ff ff       	jmp    80105b9a <alltraps>

801065ff <vector146>:
.globl vector146
vector146:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $146
80106601:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106606:	e9 8f f5 ff ff       	jmp    80105b9a <alltraps>

8010660b <vector147>:
.globl vector147
vector147:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $147
8010660d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106612:	e9 83 f5 ff ff       	jmp    80105b9a <alltraps>

80106617 <vector148>:
.globl vector148
vector148:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $148
80106619:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010661e:	e9 77 f5 ff ff       	jmp    80105b9a <alltraps>

80106623 <vector149>:
.globl vector149
vector149:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $149
80106625:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010662a:	e9 6b f5 ff ff       	jmp    80105b9a <alltraps>

8010662f <vector150>:
.globl vector150
vector150:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $150
80106631:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106636:	e9 5f f5 ff ff       	jmp    80105b9a <alltraps>

8010663b <vector151>:
.globl vector151
vector151:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $151
8010663d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106642:	e9 53 f5 ff ff       	jmp    80105b9a <alltraps>

80106647 <vector152>:
.globl vector152
vector152:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $152
80106649:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010664e:	e9 47 f5 ff ff       	jmp    80105b9a <alltraps>

80106653 <vector153>:
.globl vector153
vector153:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $153
80106655:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010665a:	e9 3b f5 ff ff       	jmp    80105b9a <alltraps>

8010665f <vector154>:
.globl vector154
vector154:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $154
80106661:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106666:	e9 2f f5 ff ff       	jmp    80105b9a <alltraps>

8010666b <vector155>:
.globl vector155
vector155:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $155
8010666d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106672:	e9 23 f5 ff ff       	jmp    80105b9a <alltraps>

80106677 <vector156>:
.globl vector156
vector156:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $156
80106679:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010667e:	e9 17 f5 ff ff       	jmp    80105b9a <alltraps>

80106683 <vector157>:
.globl vector157
vector157:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $157
80106685:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010668a:	e9 0b f5 ff ff       	jmp    80105b9a <alltraps>

8010668f <vector158>:
.globl vector158
vector158:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $158
80106691:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106696:	e9 ff f4 ff ff       	jmp    80105b9a <alltraps>

8010669b <vector159>:
.globl vector159
vector159:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $159
8010669d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066a2:	e9 f3 f4 ff ff       	jmp    80105b9a <alltraps>

801066a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $160
801066a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066ae:	e9 e7 f4 ff ff       	jmp    80105b9a <alltraps>

801066b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $161
801066b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066ba:	e9 db f4 ff ff       	jmp    80105b9a <alltraps>

801066bf <vector162>:
.globl vector162
vector162:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $162
801066c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801066c6:	e9 cf f4 ff ff       	jmp    80105b9a <alltraps>

801066cb <vector163>:
.globl vector163
vector163:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $163
801066cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801066d2:	e9 c3 f4 ff ff       	jmp    80105b9a <alltraps>

801066d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $164
801066d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801066de:	e9 b7 f4 ff ff       	jmp    80105b9a <alltraps>

801066e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $165
801066e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801066ea:	e9 ab f4 ff ff       	jmp    80105b9a <alltraps>

801066ef <vector166>:
.globl vector166
vector166:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $166
801066f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801066f6:	e9 9f f4 ff ff       	jmp    80105b9a <alltraps>

801066fb <vector167>:
.globl vector167
vector167:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $167
801066fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106702:	e9 93 f4 ff ff       	jmp    80105b9a <alltraps>

80106707 <vector168>:
.globl vector168
vector168:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $168
80106709:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010670e:	e9 87 f4 ff ff       	jmp    80105b9a <alltraps>

80106713 <vector169>:
.globl vector169
vector169:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $169
80106715:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010671a:	e9 7b f4 ff ff       	jmp    80105b9a <alltraps>

8010671f <vector170>:
.globl vector170
vector170:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $170
80106721:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106726:	e9 6f f4 ff ff       	jmp    80105b9a <alltraps>

8010672b <vector171>:
.globl vector171
vector171:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $171
8010672d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106732:	e9 63 f4 ff ff       	jmp    80105b9a <alltraps>

80106737 <vector172>:
.globl vector172
vector172:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $172
80106739:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010673e:	e9 57 f4 ff ff       	jmp    80105b9a <alltraps>

80106743 <vector173>:
.globl vector173
vector173:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $173
80106745:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010674a:	e9 4b f4 ff ff       	jmp    80105b9a <alltraps>

8010674f <vector174>:
.globl vector174
vector174:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $174
80106751:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106756:	e9 3f f4 ff ff       	jmp    80105b9a <alltraps>

8010675b <vector175>:
.globl vector175
vector175:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $175
8010675d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106762:	e9 33 f4 ff ff       	jmp    80105b9a <alltraps>

80106767 <vector176>:
.globl vector176
vector176:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $176
80106769:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010676e:	e9 27 f4 ff ff       	jmp    80105b9a <alltraps>

80106773 <vector177>:
.globl vector177
vector177:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $177
80106775:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010677a:	e9 1b f4 ff ff       	jmp    80105b9a <alltraps>

8010677f <vector178>:
.globl vector178
vector178:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $178
80106781:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106786:	e9 0f f4 ff ff       	jmp    80105b9a <alltraps>

8010678b <vector179>:
.globl vector179
vector179:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $179
8010678d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106792:	e9 03 f4 ff ff       	jmp    80105b9a <alltraps>

80106797 <vector180>:
.globl vector180
vector180:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $180
80106799:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010679e:	e9 f7 f3 ff ff       	jmp    80105b9a <alltraps>

801067a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $181
801067a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067aa:	e9 eb f3 ff ff       	jmp    80105b9a <alltraps>

801067af <vector182>:
.globl vector182
vector182:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $182
801067b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067b6:	e9 df f3 ff ff       	jmp    80105b9a <alltraps>

801067bb <vector183>:
.globl vector183
vector183:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $183
801067bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801067c2:	e9 d3 f3 ff ff       	jmp    80105b9a <alltraps>

801067c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $184
801067c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801067ce:	e9 c7 f3 ff ff       	jmp    80105b9a <alltraps>

801067d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $185
801067d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801067da:	e9 bb f3 ff ff       	jmp    80105b9a <alltraps>

801067df <vector186>:
.globl vector186
vector186:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $186
801067e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801067e6:	e9 af f3 ff ff       	jmp    80105b9a <alltraps>

801067eb <vector187>:
.globl vector187
vector187:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $187
801067ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801067f2:	e9 a3 f3 ff ff       	jmp    80105b9a <alltraps>

801067f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $188
801067f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801067fe:	e9 97 f3 ff ff       	jmp    80105b9a <alltraps>

80106803 <vector189>:
.globl vector189
vector189:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $189
80106805:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010680a:	e9 8b f3 ff ff       	jmp    80105b9a <alltraps>

8010680f <vector190>:
.globl vector190
vector190:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $190
80106811:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106816:	e9 7f f3 ff ff       	jmp    80105b9a <alltraps>

8010681b <vector191>:
.globl vector191
vector191:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $191
8010681d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106822:	e9 73 f3 ff ff       	jmp    80105b9a <alltraps>

80106827 <vector192>:
.globl vector192
vector192:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $192
80106829:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010682e:	e9 67 f3 ff ff       	jmp    80105b9a <alltraps>

80106833 <vector193>:
.globl vector193
vector193:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $193
80106835:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010683a:	e9 5b f3 ff ff       	jmp    80105b9a <alltraps>

8010683f <vector194>:
.globl vector194
vector194:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $194
80106841:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106846:	e9 4f f3 ff ff       	jmp    80105b9a <alltraps>

8010684b <vector195>:
.globl vector195
vector195:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $195
8010684d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106852:	e9 43 f3 ff ff       	jmp    80105b9a <alltraps>

80106857 <vector196>:
.globl vector196
vector196:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $196
80106859:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010685e:	e9 37 f3 ff ff       	jmp    80105b9a <alltraps>

80106863 <vector197>:
.globl vector197
vector197:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $197
80106865:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010686a:	e9 2b f3 ff ff       	jmp    80105b9a <alltraps>

8010686f <vector198>:
.globl vector198
vector198:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $198
80106871:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106876:	e9 1f f3 ff ff       	jmp    80105b9a <alltraps>

8010687b <vector199>:
.globl vector199
vector199:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $199
8010687d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106882:	e9 13 f3 ff ff       	jmp    80105b9a <alltraps>

80106887 <vector200>:
.globl vector200
vector200:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $200
80106889:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010688e:	e9 07 f3 ff ff       	jmp    80105b9a <alltraps>

80106893 <vector201>:
.globl vector201
vector201:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $201
80106895:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010689a:	e9 fb f2 ff ff       	jmp    80105b9a <alltraps>

8010689f <vector202>:
.globl vector202
vector202:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $202
801068a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068a6:	e9 ef f2 ff ff       	jmp    80105b9a <alltraps>

801068ab <vector203>:
.globl vector203
vector203:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $203
801068ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068b2:	e9 e3 f2 ff ff       	jmp    80105b9a <alltraps>

801068b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $204
801068b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068be:	e9 d7 f2 ff ff       	jmp    80105b9a <alltraps>

801068c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $205
801068c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801068ca:	e9 cb f2 ff ff       	jmp    80105b9a <alltraps>

801068cf <vector206>:
.globl vector206
vector206:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $206
801068d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801068d6:	e9 bf f2 ff ff       	jmp    80105b9a <alltraps>

801068db <vector207>:
.globl vector207
vector207:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $207
801068dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801068e2:	e9 b3 f2 ff ff       	jmp    80105b9a <alltraps>

801068e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $208
801068e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801068ee:	e9 a7 f2 ff ff       	jmp    80105b9a <alltraps>

801068f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $209
801068f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801068fa:	e9 9b f2 ff ff       	jmp    80105b9a <alltraps>

801068ff <vector210>:
.globl vector210
vector210:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $210
80106901:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106906:	e9 8f f2 ff ff       	jmp    80105b9a <alltraps>

8010690b <vector211>:
.globl vector211
vector211:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $211
8010690d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106912:	e9 83 f2 ff ff       	jmp    80105b9a <alltraps>

80106917 <vector212>:
.globl vector212
vector212:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $212
80106919:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010691e:	e9 77 f2 ff ff       	jmp    80105b9a <alltraps>

80106923 <vector213>:
.globl vector213
vector213:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $213
80106925:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010692a:	e9 6b f2 ff ff       	jmp    80105b9a <alltraps>

8010692f <vector214>:
.globl vector214
vector214:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $214
80106931:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106936:	e9 5f f2 ff ff       	jmp    80105b9a <alltraps>

8010693b <vector215>:
.globl vector215
vector215:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $215
8010693d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106942:	e9 53 f2 ff ff       	jmp    80105b9a <alltraps>

80106947 <vector216>:
.globl vector216
vector216:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $216
80106949:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010694e:	e9 47 f2 ff ff       	jmp    80105b9a <alltraps>

80106953 <vector217>:
.globl vector217
vector217:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $217
80106955:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010695a:	e9 3b f2 ff ff       	jmp    80105b9a <alltraps>

8010695f <vector218>:
.globl vector218
vector218:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $218
80106961:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106966:	e9 2f f2 ff ff       	jmp    80105b9a <alltraps>

8010696b <vector219>:
.globl vector219
vector219:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $219
8010696d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106972:	e9 23 f2 ff ff       	jmp    80105b9a <alltraps>

80106977 <vector220>:
.globl vector220
vector220:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $220
80106979:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010697e:	e9 17 f2 ff ff       	jmp    80105b9a <alltraps>

80106983 <vector221>:
.globl vector221
vector221:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $221
80106985:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010698a:	e9 0b f2 ff ff       	jmp    80105b9a <alltraps>

8010698f <vector222>:
.globl vector222
vector222:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $222
80106991:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106996:	e9 ff f1 ff ff       	jmp    80105b9a <alltraps>

8010699b <vector223>:
.globl vector223
vector223:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $223
8010699d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069a2:	e9 f3 f1 ff ff       	jmp    80105b9a <alltraps>

801069a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $224
801069a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069ae:	e9 e7 f1 ff ff       	jmp    80105b9a <alltraps>

801069b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $225
801069b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069ba:	e9 db f1 ff ff       	jmp    80105b9a <alltraps>

801069bf <vector226>:
.globl vector226
vector226:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $226
801069c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801069c6:	e9 cf f1 ff ff       	jmp    80105b9a <alltraps>

801069cb <vector227>:
.globl vector227
vector227:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $227
801069cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801069d2:	e9 c3 f1 ff ff       	jmp    80105b9a <alltraps>

801069d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $228
801069d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801069de:	e9 b7 f1 ff ff       	jmp    80105b9a <alltraps>

801069e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $229
801069e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801069ea:	e9 ab f1 ff ff       	jmp    80105b9a <alltraps>

801069ef <vector230>:
.globl vector230
vector230:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $230
801069f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801069f6:	e9 9f f1 ff ff       	jmp    80105b9a <alltraps>

801069fb <vector231>:
.globl vector231
vector231:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $231
801069fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a02:	e9 93 f1 ff ff       	jmp    80105b9a <alltraps>

80106a07 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $232
80106a09:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a0e:	e9 87 f1 ff ff       	jmp    80105b9a <alltraps>

80106a13 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $233
80106a15:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a1a:	e9 7b f1 ff ff       	jmp    80105b9a <alltraps>

80106a1f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $234
80106a21:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a26:	e9 6f f1 ff ff       	jmp    80105b9a <alltraps>

80106a2b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $235
80106a2d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a32:	e9 63 f1 ff ff       	jmp    80105b9a <alltraps>

80106a37 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $236
80106a39:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a3e:	e9 57 f1 ff ff       	jmp    80105b9a <alltraps>

80106a43 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $237
80106a45:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a4a:	e9 4b f1 ff ff       	jmp    80105b9a <alltraps>

80106a4f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $238
80106a51:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a56:	e9 3f f1 ff ff       	jmp    80105b9a <alltraps>

80106a5b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $239
80106a5d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a62:	e9 33 f1 ff ff       	jmp    80105b9a <alltraps>

80106a67 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $240
80106a69:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a6e:	e9 27 f1 ff ff       	jmp    80105b9a <alltraps>

80106a73 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $241
80106a75:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a7a:	e9 1b f1 ff ff       	jmp    80105b9a <alltraps>

80106a7f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $242
80106a81:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a86:	e9 0f f1 ff ff       	jmp    80105b9a <alltraps>

80106a8b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $243
80106a8d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a92:	e9 03 f1 ff ff       	jmp    80105b9a <alltraps>

80106a97 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $244
80106a99:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a9e:	e9 f7 f0 ff ff       	jmp    80105b9a <alltraps>

80106aa3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $245
80106aa5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106aaa:	e9 eb f0 ff ff       	jmp    80105b9a <alltraps>

80106aaf <vector246>:
.globl vector246
vector246:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $246
80106ab1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ab6:	e9 df f0 ff ff       	jmp    80105b9a <alltraps>

80106abb <vector247>:
.globl vector247
vector247:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $247
80106abd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ac2:	e9 d3 f0 ff ff       	jmp    80105b9a <alltraps>

80106ac7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $248
80106ac9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ace:	e9 c7 f0 ff ff       	jmp    80105b9a <alltraps>

80106ad3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $249
80106ad5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106ada:	e9 bb f0 ff ff       	jmp    80105b9a <alltraps>

80106adf <vector250>:
.globl vector250
vector250:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $250
80106ae1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ae6:	e9 af f0 ff ff       	jmp    80105b9a <alltraps>

80106aeb <vector251>:
.globl vector251
vector251:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $251
80106aed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106af2:	e9 a3 f0 ff ff       	jmp    80105b9a <alltraps>

80106af7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $252
80106af9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106afe:	e9 97 f0 ff ff       	jmp    80105b9a <alltraps>

80106b03 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $253
80106b05:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b0a:	e9 8b f0 ff ff       	jmp    80105b9a <alltraps>

80106b0f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $254
80106b11:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b16:	e9 7f f0 ff ff       	jmp    80105b9a <alltraps>

80106b1b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $255
80106b1d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b22:	e9 73 f0 ff ff       	jmp    80105b9a <alltraps>
80106b27:	66 90                	xchg   %ax,%ax
80106b29:	66 90                	xchg   %ax,%ax
80106b2b:	66 90                	xchg   %ax,%ax
80106b2d:	66 90                	xchg   %ax,%ax
80106b2f:	90                   	nop

80106b30 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b38:	c1 ea 16             	shr    $0x16,%edx
80106b3b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b3e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106b41:	8b 07                	mov    (%edi),%eax
80106b43:	a8 01                	test   $0x1,%al
80106b45:	74 29                	je     80106b70 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b4c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106b52:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106b55:	c1 eb 0a             	shr    $0xa,%ebx
80106b58:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106b5e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106b61:	5b                   	pop    %ebx
80106b62:	5e                   	pop    %esi
80106b63:	5f                   	pop    %edi
80106b64:	5d                   	pop    %ebp
80106b65:	c3                   	ret    
80106b66:	8d 76 00             	lea    0x0(%esi),%esi
80106b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b70:	85 c9                	test   %ecx,%ecx
80106b72:	74 2c                	je     80106ba0 <walkpgdir+0x70>
80106b74:	e8 d7 bc ff ff       	call   80102850 <kalloc>
80106b79:	85 c0                	test   %eax,%eax
80106b7b:	89 c6                	mov    %eax,%esi
80106b7d:	74 21                	je     80106ba0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106b7f:	83 ec 04             	sub    $0x4,%esp
80106b82:	68 00 10 00 00       	push   $0x1000
80106b87:	6a 00                	push   $0x0
80106b89:	50                   	push   %eax
80106b8a:	e8 f1 dd ff ff       	call   80104980 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b8f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b95:	83 c4 10             	add    $0x10,%esp
80106b98:	83 c8 07             	or     $0x7,%eax
80106b9b:	89 07                	mov    %eax,(%edi)
80106b9d:	eb b3                	jmp    80106b52 <walkpgdir+0x22>
80106b9f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106ba3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bb0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	57                   	push   %edi
80106bb4:	56                   	push   %esi
80106bb5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106bb6:	89 d3                	mov    %edx,%ebx
80106bb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106bbe:	83 ec 1c             	sub    $0x1c,%esp
80106bc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106bc4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106bc8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106bcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bd6:	29 df                	sub    %ebx,%edi
80106bd8:	83 c8 01             	or     $0x1,%eax
80106bdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106bde:	eb 15                	jmp    80106bf5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106be0:	f6 00 01             	testb  $0x1,(%eax)
80106be3:	75 45                	jne    80106c2a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106be5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106be8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106beb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106bed:	74 31                	je     80106c20 <mappages+0x70>
      break;
    a += PGSIZE;
80106bef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bf8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106bfd:	89 da                	mov    %ebx,%edx
80106bff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c02:	e8 29 ff ff ff       	call   80106b30 <walkpgdir>
80106c07:	85 c0                	test   %eax,%eax
80106c09:	75 d5                	jne    80106be0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106c0b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106c13:	5b                   	pop    %ebx
80106c14:	5e                   	pop    %esi
80106c15:	5f                   	pop    %edi
80106c16:	5d                   	pop    %ebp
80106c17:	c3                   	ret    
80106c18:	90                   	nop
80106c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106c23:	31 c0                	xor    %eax,%eax
}
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106c2a:	83 ec 0c             	sub    $0xc,%esp
80106c2d:	68 70 86 10 80       	push   $0x80108670
80106c32:	e8 39 97 ff ff       	call   80100370 <panic>
80106c37:	89 f6                	mov    %esi,%esi
80106c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c40 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c46:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c4c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c4e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c54:	83 ec 1c             	sub    $0x1c,%esp
80106c57:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106c5a:	39 d3                	cmp    %edx,%ebx
80106c5c:	73 66                	jae    80106cc4 <deallocuvm.part.0+0x84>
80106c5e:	89 d6                	mov    %edx,%esi
80106c60:	eb 3d                	jmp    80106c9f <deallocuvm.part.0+0x5f>
80106c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c68:	8b 10                	mov    (%eax),%edx
80106c6a:	f6 c2 01             	test   $0x1,%dl
80106c6d:	74 26                	je     80106c95 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c6f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c75:	74 58                	je     80106ccf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c77:	83 ec 0c             	sub    $0xc,%esp
80106c7a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c83:	52                   	push   %edx
80106c84:	e8 17 ba ff ff       	call   801026a0 <kfree>
      *pte = 0;
80106c89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c8c:	83 c4 10             	add    $0x10,%esp
80106c8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106c95:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c9b:	39 f3                	cmp    %esi,%ebx
80106c9d:	73 25                	jae    80106cc4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106c9f:	31 c9                	xor    %ecx,%ecx
80106ca1:	89 da                	mov    %ebx,%edx
80106ca3:	89 f8                	mov    %edi,%eax
80106ca5:	e8 86 fe ff ff       	call   80106b30 <walkpgdir>
    if(!pte)
80106caa:	85 c0                	test   %eax,%eax
80106cac:	75 ba                	jne    80106c68 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106cb4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106cba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cc0:	39 f3                	cmp    %esi,%ebx
80106cc2:	72 db                	jb     80106c9f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106cc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cca:	5b                   	pop    %ebx
80106ccb:	5e                   	pop    %esi
80106ccc:	5f                   	pop    %edi
80106ccd:	5d                   	pop    %ebp
80106cce:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106ccf:	83 ec 0c             	sub    $0xc,%esp
80106cd2:	68 e6 7f 10 80       	push   $0x80107fe6
80106cd7:	e8 94 96 ff ff       	call   80100370 <panic>
80106cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ce0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106ce6:	e8 b5 ce ff ff       	call   80103ba0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ceb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106cf1:	31 c9                	xor    %ecx,%ecx
80106cf3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106cf8:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
80106cff:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d06:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106d0b:	31 c9                	xor    %ecx,%ecx
80106d0d:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d14:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d19:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d20:	31 c9                	xor    %ecx,%ecx
80106d22:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80106d29:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d30:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106d35:	31 c9                	xor    %ecx,%ecx
80106d37:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d3e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106d45:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d4a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80106d51:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80106d58:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d5f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80106d66:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
80106d6d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80106d74:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d7b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
80106d82:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
80106d89:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
80106d90:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d97:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
80106d9e:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80106da5:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
80106dac:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80106db3:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106dba:	05 f0 37 11 80       	add    $0x801137f0,%eax
80106dbf:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106dc3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106dc7:	c1 e8 10             	shr    $0x10,%eax
80106dca:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106dce:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dd1:	0f 01 10             	lgdtl  (%eax)
}
80106dd4:	c9                   	leave  
80106dd5:	c3                   	ret    
80106dd6:	8d 76 00             	lea    0x0(%esi),%esi
80106dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106de0 <rmPhysicalPage>:
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
int rmPhysicalPage(int virtualAddress) {
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	56                   	push   %esi
80106de4:	53                   	push   %ebx
  //look for a phusycal page with the given virtual adress 
  virtualAddress = PTE_ADDR(virtualAddress);
80106de5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct pageLink* page = myproc()->pagesHead;
80106de8:	e8 d3 cd ff ff       	call   80103bc0 <myproc>
80106ded:	8b 98 50 02 00 00    	mov    0x250(%eax),%ebx

// This table defines the kernel's mappings, which are present in
// every process's page table.
int rmPhysicalPage(int virtualAddress) {
  //look for a phusycal page with the given virtual adress 
  virtualAddress = PTE_ADDR(virtualAddress);
80106df3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  struct pageLink* page = myproc()->pagesHead;
  while (page && page->va != virtualAddress)
80106df9:	85 db                	test   %ebx,%ebx
80106dfb:	75 0a                	jne    80106e07 <rmPhysicalPage+0x27>
80106dfd:	eb 61                	jmp    80106e60 <rmPhysicalPage+0x80>
80106dff:	90                   	nop
    page = page->next;
80106e00:	8b 5b 10             	mov    0x10(%ebx),%ebx
// every process's page table.
int rmPhysicalPage(int virtualAddress) {
  //look for a phusycal page with the given virtual adress 
  virtualAddress = PTE_ADDR(virtualAddress);
  struct pageLink* page = myproc()->pagesHead;
  while (page && page->va != virtualAddress)
80106e03:	85 db                	test   %ebx,%ebx
80106e05:	74 59                	je     80106e60 <rmPhysicalPage+0x80>
80106e07:	3b 73 04             	cmp    0x4(%ebx),%esi
80106e0a:	75 f4                	jne    80106e00 <rmPhysicalPage+0x20>
  
  if (!page)
    return 0;

  //phys page found, remove it
  myproc()->physicalPagesCount--;
80106e0c:	e8 af cd ff ff       	call   80103bc0 <myproc>
80106e11:	83 a8 80 00 00 00 01 	subl   $0x1,0x80(%eax)
  if (page->prev)
80106e18:	8b 43 14             	mov    0x14(%ebx),%eax
80106e1b:	85 c0                	test   %eax,%eax
80106e1d:	74 06                	je     80106e25 <rmPhysicalPage+0x45>
    page->prev->next = page->next;
80106e1f:	8b 53 10             	mov    0x10(%ebx),%edx
80106e22:	89 50 10             	mov    %edx,0x10(%eax)
  if (page->next)
80106e25:	8b 43 10             	mov    0x10(%ebx),%eax
80106e28:	85 c0                	test   %eax,%eax
80106e2a:	74 06                	je     80106e32 <rmPhysicalPage+0x52>
    page->next->prev = page->prev;
80106e2c:	8b 53 14             	mov    0x14(%ebx),%edx
80106e2f:	89 50 14             	mov    %edx,0x14(%eax)
  
  //check if the page was head or tail
  if (page == myproc()->pagesHead)
80106e32:	e8 89 cd ff ff       	call   80103bc0 <myproc>
80106e37:	39 98 50 02 00 00    	cmp    %ebx,0x250(%eax)
80106e3d:	74 27                	je     80106e66 <rmPhysicalPage+0x86>
    myproc()->pagesHead = page->next;
  if (page == myproc()->pagesTail)
80106e3f:	e8 7c cd ff ff       	call   80103bc0 <myproc>
80106e44:	39 98 54 02 00 00    	cmp    %ebx,0x254(%eax)
80106e4a:	74 2a                	je     80106e76 <rmPhysicalPage+0x96>
    myproc()->pagesTail = page->prev;
  
  page->allocated = 0;
80106e4c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  return 1;
80106e52:	b8 01 00 00 00       	mov    $0x1,%eax
    
}
80106e57:	5b                   	pop    %ebx
80106e58:	5e                   	pop    %esi
80106e59:	5d                   	pop    %ebp
80106e5a:	c3                   	ret    
80106e5b:	90                   	nop
80106e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e60:	5b                   	pop    %ebx
  struct pageLink* page = myproc()->pagesHead;
  while (page && page->va != virtualAddress)
    page = page->next;
  
  if (!page)
    return 0;
80106e61:	31 c0                	xor    %eax,%eax
  
  page->allocated = 0;

  return 1;
    
}
80106e63:	5e                   	pop    %esi
80106e64:	5d                   	pop    %ebp
80106e65:	c3                   	ret    
  if (page->next)
    page->next->prev = page->prev;
  
  //check if the page was head or tail
  if (page == myproc()->pagesHead)
    myproc()->pagesHead = page->next;
80106e66:	e8 55 cd ff ff       	call   80103bc0 <myproc>
80106e6b:	8b 53 10             	mov    0x10(%ebx),%edx
80106e6e:	89 90 50 02 00 00    	mov    %edx,0x250(%eax)
80106e74:	eb c9                	jmp    80106e3f <rmPhysicalPage+0x5f>
  if (page == myproc()->pagesTail)
    myproc()->pagesTail = page->prev;
80106e76:	e8 45 cd ff ff       	call   80103bc0 <myproc>
80106e7b:	8b 53 14             	mov    0x14(%ebx),%edx
80106e7e:	89 90 54 02 00 00    	mov    %edx,0x254(%eax)
80106e84:	eb c6                	jmp    80106e4c <rmPhysicalPage+0x6c>
80106e86:	8d 76 00             	lea    0x0(%esi),%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e90 <removePagesHead>:
  return 1;
    
}

void removePagesHead()
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	53                   	push   %ebx
80106e94:	83 ec 04             	sub    $0x4,%esp
    struct pageLink* newHead = myproc()->pagesHead->next;
80106e97:	e8 24 cd ff ff       	call   80103bc0 <myproc>
80106e9c:	8b 80 50 02 00 00    	mov    0x250(%eax),%eax
80106ea2:	8b 58 10             	mov    0x10(%eax),%ebx
    myproc()->pagesHead->va = 0xffffffff; //free the page in the table
80106ea5:	e8 16 cd ff ff       	call   80103bc0 <myproc>
80106eaa:	8b 80 50 02 00 00    	mov    0x250(%eax),%eax
80106eb0:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    myproc()->pagesHead = newHead;
80106eb7:	e8 04 cd ff ff       	call   80103bc0 <myproc>
80106ebc:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
    //proc->pagesInPhysic[proc->physcPageHead].prev = -1;  check how to set prev to null!
}
80106ec2:	83 c4 04             	add    $0x4,%esp
80106ec5:	5b                   	pop    %ebx
80106ec6:	5d                   	pop    %ebp
80106ec7:	c3                   	ret    
80106ec8:	90                   	nop
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <removePagesTail>:

void removePagesTail()
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	53                   	push   %ebx
80106ed4:	83 ec 04             	sub    $0x4,%esp
    struct pageLink* newTale = myproc()->pagesTail->prev;
80106ed7:	e8 e4 cc ff ff       	call   80103bc0 <myproc>
80106edc:	8b 80 54 02 00 00    	mov    0x254(%eax),%eax
80106ee2:	8b 58 14             	mov    0x14(%eax),%ebx
    myproc()->pagesTail->va = 0xffffffff; //free the page in the table
80106ee5:	e8 d6 cc ff ff       	call   80103bc0 <myproc>
80106eea:	8b 80 54 02 00 00    	mov    0x254(%eax),%eax
80106ef0:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    myproc()->pagesTail = newTale;
80106ef7:	e8 c4 cc ff ff       	call   80103bc0 <myproc>
80106efc:	89 98 54 02 00 00    	mov    %ebx,0x254(%eax)
    //proc->pagesInPhysic[proc->physcPageTail].next = -1;
}
80106f02:	83 c4 04             	add    $0x4,%esp
80106f05:	5b                   	pop    %ebx
80106f06:	5d                   	pop    %ebp
80106f07:	c3                   	ret    
80106f08:	90                   	nop
80106f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f10 <popFromNFUA>:


int 
popFromNFUA() {
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
    int min = 0xffffffff; 
    struct pageLink* p = myproc()->pagesHead;
80106f19:	e8 a2 cc ff ff       	call   80103bc0 <myproc>
80106f1e:	8b 98 50 02 00 00    	mov    0x250(%eax),%ebx
    struct pageLink* oldest=p;
    while (p){
80106f24:	85 db                	test   %ebx,%ebx
80106f26:	0f 84 90 00 00 00    	je     80106fbc <popFromNFUA+0xac>
80106f2c:	89 df                	mov    %ebx,%edi
80106f2e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80106f33:	90                   	nop
80106f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      pte_t* pte = walkpgdir(myproc()->pgdir, (void*)p->va, 0);
80106f38:	8b 53 04             	mov    0x4(%ebx),%edx
80106f3b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f3e:	e8 7d cc ff ff       	call   80103bc0 <myproc>
80106f43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f46:	8b 40 04             	mov    0x4(%eax),%eax
80106f49:	31 c9                	xor    %ecx,%ecx
80106f4b:	e8 e0 fb ff ff       	call   80106b30 <walkpgdir>
      p->age >>=1;
80106f50:	8b 53 0c             	mov    0xc(%ebx),%edx
80106f53:	d1 fa                	sar    %edx
80106f55:	89 53 0c             	mov    %edx,0xc(%ebx)
      if(*pte & PTE_A)
80106f58:	f6 00 20             	testb  $0x20,(%eax)
80106f5b:	74 09                	je     80106f66 <popFromNFUA+0x56>
          p->age |=CR0_PG; //0x80000000
80106f5d:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80106f63:	89 53 0c             	mov    %edx,0xc(%ebx)
      if (min > p->age){
80106f66:	39 f2                	cmp    %esi,%edx
80106f68:	7d 04                	jge    80106f6e <popFromNFUA+0x5e>
80106f6a:	89 df                	mov    %ebx,%edi
80106f6c:	89 d6                	mov    %edx,%esi
          min = p->age;
          oldest = p;
      }
      p = p->next;   
80106f6e:	8b 5b 10             	mov    0x10(%ebx),%ebx
int 
popFromNFUA() {
    int min = 0xffffffff; 
    struct pageLink* p = myproc()->pagesHead;
    struct pageLink* oldest=p;
    while (p){
80106f71:	85 db                	test   %ebx,%ebx
80106f73:	75 c3                	jne    80106f38 <popFromNFUA+0x28>
      p = p->next;   
    }
  int va=oldest->va;

  //remove oldest
  if (oldest->prev)
80106f75:	8b 47 14             	mov    0x14(%edi),%eax
          min = p->age;
          oldest = p;
      }
      p = p->next;   
    }
  int va=oldest->va;
80106f78:	8b 5f 04             	mov    0x4(%edi),%ebx

  //remove oldest
  if (oldest->prev)
80106f7b:	85 c0                	test   %eax,%eax
80106f7d:	74 06                	je     80106f85 <popFromNFUA+0x75>
    oldest->prev->next = oldest->next;
80106f7f:	8b 57 10             	mov    0x10(%edi),%edx
80106f82:	89 50 10             	mov    %edx,0x10(%eax)
  if (oldest->next)
80106f85:	8b 47 10             	mov    0x10(%edi),%eax
80106f88:	85 c0                	test   %eax,%eax
80106f8a:	74 06                	je     80106f92 <popFromNFUA+0x82>
    oldest->next->prev = oldest->prev;
80106f8c:	8b 57 14             	mov    0x14(%edi),%edx
80106f8f:	89 50 14             	mov    %edx,0x14(%eax)
  //check if oldest is head or tail
  if (oldest == myproc()->pagesHead)
80106f92:	e8 29 cc ff ff       	call   80103bc0 <myproc>
80106f97:	3b b8 50 02 00 00    	cmp    0x250(%eax),%edi
80106f9d:	74 39                	je     80106fd8 <popFromNFUA+0xc8>
    removePagesHead();
  if (oldest == myproc()->pagesTail)
80106f9f:	e8 1c cc ff ff       	call   80103bc0 <myproc>
80106fa4:	3b b8 54 02 00 00    	cmp    0x254(%eax),%edi
80106faa:	74 17                	je     80106fc3 <popFromNFUA+0xb3>
    removePagesTail();
  
  oldest->allocated = 0;
80106fac:	c7 07 00 00 00 00    	movl   $0x0,(%edi)

  return va;
}
80106fb2:	83 c4 1c             	add    $0x1c,%esp
80106fb5:	89 d8                	mov    %ebx,%eax
80106fb7:	5b                   	pop    %ebx
80106fb8:	5e                   	pop    %esi
80106fb9:	5f                   	pop    %edi
80106fba:	5d                   	pop    %ebp
80106fbb:	c3                   	ret    
          min = p->age;
          oldest = p;
      }
      p = p->next;   
    }
  int va=oldest->va;
80106fbc:	a1 04 00 00 00       	mov    0x4,%eax
80106fc1:	0f 0b                	ud2    
    oldest->next->prev = oldest->prev;
  //check if oldest is head or tail
  if (oldest == myproc()->pagesHead)
    removePagesHead();
  if (oldest == myproc()->pagesTail)
    removePagesTail();
80106fc3:	e8 08 ff ff ff       	call   80106ed0 <removePagesTail>
  
  oldest->allocated = 0;
80106fc8:	c7 07 00 00 00 00    	movl   $0x0,(%edi)

  return va;
}
80106fce:	83 c4 1c             	add    $0x1c,%esp
80106fd1:	89 d8                	mov    %ebx,%eax
80106fd3:	5b                   	pop    %ebx
80106fd4:	5e                   	pop    %esi
80106fd5:	5f                   	pop    %edi
80106fd6:	5d                   	pop    %ebp
80106fd7:	c3                   	ret    
    oldest->prev->next = oldest->next;
  if (oldest->next)
    oldest->next->prev = oldest->prev;
  //check if oldest is head or tail
  if (oldest == myproc()->pagesHead)
    removePagesHead();
80106fd8:	e8 b3 fe ff ff       	call   80106e90 <removePagesHead>
80106fdd:	eb c0                	jmp    80106f9f <popFromNFUA+0x8f>
80106fdf:	90                   	nop

80106fe0 <getNumOfOnes>:

  return va;
}

int
getNumOfOnes(int num){
80106fe0:	55                   	push   %ebp
80106fe1:	ba 20 00 00 00       	mov    $0x20,%edx
  int counter=0;
80106fe6:	31 c0                	xor    %eax,%eax

  return va;
}

int
getNumOfOnes(int num){
80106fe8:	89 e5                	mov    %esp,%ebp
80106fea:	53                   	push   %ebx
80106feb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106fee:	66 90                	xchg   %ax,%ax
  int counter=0;
  int i;
  for (i=0; i<32; i++){
    if(num & 0x00000001)
80106ff0:	89 cb                	mov    %ecx,%ebx
80106ff2:	83 e3 01             	and    $0x1,%ebx
      counter ++;
80106ff5:	83 fb 01             	cmp    $0x1,%ebx
80106ff8:	83 d8 ff             	sbb    $0xffffffff,%eax
    num >>= 1;
80106ffb:	d1 f9                	sar    %ecx

int
getNumOfOnes(int num){
  int counter=0;
  int i;
  for (i=0; i<32; i++){
80106ffd:	83 ea 01             	sub    $0x1,%edx
80107000:	75 ee                	jne    80106ff0 <getNumOfOnes+0x10>
    if(num & 0x00000001)
      counter ++;
    num >>= 1;
  }
  return counter;
}
80107002:	5b                   	pop    %ebx
80107003:	5d                   	pop    %ebp
80107004:	c3                   	ret    
80107005:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107010 <popFromLAPA>:

int 
popFromLAPA() {
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 0c             	sub    $0xc,%esp
    int min = 0xffffffff; 
    struct pageLink* p = myproc()->pagesHead;
80107019:	e8 a2 cb ff ff       	call   80103bc0 <myproc>
8010701e:	8b b0 50 02 00 00    	mov    0x250(%eax),%esi
    struct pageLink* pageToRemove=p;
    while (p){
80107024:	85 f6                	test   %esi,%esi
80107026:	89 f3                	mov    %esi,%ebx
80107028:	74 37                	je     80107061 <popFromLAPA+0x51>
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      pte_t* pte = walkpgdir(myproc()->pgdir, (void*)p->va, 0);
80107030:	8b 7b 04             	mov    0x4(%ebx),%edi
80107033:	e8 88 cb ff ff       	call   80103bc0 <myproc>
80107038:	8b 40 04             	mov    0x4(%eax),%eax
8010703b:	31 c9                	xor    %ecx,%ecx
8010703d:	89 fa                	mov    %edi,%edx
8010703f:	e8 ec fa ff ff       	call   80106b30 <walkpgdir>
      p->age >>=1;
80107044:	8b 53 0c             	mov    0xc(%ebx),%edx
80107047:	d1 fa                	sar    %edx
80107049:	89 53 0c             	mov    %edx,0xc(%ebx)
      if(*pte & PTE_A)
8010704c:	f6 00 20             	testb  $0x20,(%eax)
8010704f:	74 09                	je     8010705a <popFromLAPA+0x4a>
          p->age |=CR0_PG; //0x80000000
80107051:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80107057:	89 53 0c             	mov    %edx,0xc(%ebx)
      if (min > getNumOfOnes(p->age)){
          min = getNumOfOnes(p->age);
          pageToRemove = p;
      }
      p = p->next;    
8010705a:	8b 5b 10             	mov    0x10(%ebx),%ebx
int 
popFromLAPA() {
    int min = 0xffffffff; 
    struct pageLink* p = myproc()->pagesHead;
    struct pageLink* pageToRemove=p;
    while (p){
8010705d:	85 db                	test   %ebx,%ebx
8010705f:	75 cf                	jne    80107030 <popFromLAPA+0x20>
      p = p->next;    
    }
    int va=pageToRemove->va;

    //remove oldest
    if (pageToRemove->prev)
80107061:	8b 46 14             	mov    0x14(%esi),%eax
          min = getNumOfOnes(p->age);
          pageToRemove = p;
      }
      p = p->next;    
    }
    int va=pageToRemove->va;
80107064:	8b 5e 04             	mov    0x4(%esi),%ebx

    //remove oldest
    if (pageToRemove->prev)
80107067:	85 c0                	test   %eax,%eax
80107069:	74 06                	je     80107071 <popFromLAPA+0x61>
      pageToRemove->prev->next = pageToRemove->next;
8010706b:	8b 56 10             	mov    0x10(%esi),%edx
8010706e:	89 50 10             	mov    %edx,0x10(%eax)
    if (pageToRemove->next)
80107071:	8b 46 10             	mov    0x10(%esi),%eax
80107074:	85 c0                	test   %eax,%eax
80107076:	74 06                	je     8010707e <popFromLAPA+0x6e>
      pageToRemove->next->prev = pageToRemove->prev;
80107078:	8b 56 14             	mov    0x14(%esi),%edx
8010707b:	89 50 14             	mov    %edx,0x14(%eax)
    //check if pageToRemove is head or tail
    if (pageToRemove == myproc()->pagesHead)
8010707e:	e8 3d cb ff ff       	call   80103bc0 <myproc>
80107083:	3b b0 50 02 00 00    	cmp    0x250(%eax),%esi
80107089:	74 32                	je     801070bd <popFromLAPA+0xad>
      removePagesHead();
    if (pageToRemove == myproc()->pagesTail)
8010708b:	e8 30 cb ff ff       	call   80103bc0 <myproc>
80107090:	3b b0 54 02 00 00    	cmp    0x254(%eax),%esi
80107096:	74 10                	je     801070a8 <popFromLAPA+0x98>
      removePagesTail();
    
    pageToRemove->allocated = 0;
80107098:	c7 06 00 00 00 00    	movl   $0x0,(%esi)

    return va;
}
8010709e:	83 c4 0c             	add    $0xc,%esp
801070a1:	89 d8                	mov    %ebx,%eax
801070a3:	5b                   	pop    %ebx
801070a4:	5e                   	pop    %esi
801070a5:	5f                   	pop    %edi
801070a6:	5d                   	pop    %ebp
801070a7:	c3                   	ret    
      pageToRemove->next->prev = pageToRemove->prev;
    //check if pageToRemove is head or tail
    if (pageToRemove == myproc()->pagesHead)
      removePagesHead();
    if (pageToRemove == myproc()->pagesTail)
      removePagesTail();
801070a8:	e8 23 fe ff ff       	call   80106ed0 <removePagesTail>
    
    pageToRemove->allocated = 0;
801070ad:	c7 06 00 00 00 00    	movl   $0x0,(%esi)

    return va;
}
801070b3:	83 c4 0c             	add    $0xc,%esp
801070b6:	89 d8                	mov    %ebx,%eax
801070b8:	5b                   	pop    %ebx
801070b9:	5e                   	pop    %esi
801070ba:	5f                   	pop    %edi
801070bb:	5d                   	pop    %ebp
801070bc:	c3                   	ret    
      pageToRemove->prev->next = pageToRemove->next;
    if (pageToRemove->next)
      pageToRemove->next->prev = pageToRemove->prev;
    //check if pageToRemove is head or tail
    if (pageToRemove == myproc()->pagesHead)
      removePagesHead();
801070bd:	e8 ce fd ff ff       	call   80106e90 <removePagesHead>
801070c2:	eb c7                	jmp    8010708b <popFromLAPA+0x7b>
801070c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070d0 <moveHeadToTail>:

    return va;
}

void moveHeadToTail ()
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	56                   	push   %esi
801070d4:	53                   	push   %ebx
    struct pageLink* oldHead = myproc()->pagesHead; 
801070d5:	e8 e6 ca ff ff       	call   80103bc0 <myproc>
801070da:	8b 98 50 02 00 00    	mov    0x250(%eax),%ebx
    struct pageLink* newhead = myproc()->pagesHead->next;
801070e0:	e8 db ca ff ff       	call   80103bc0 <myproc>
801070e5:	8b 80 50 02 00 00    	mov    0x250(%eax),%eax
801070eb:	8b 70 10             	mov    0x10(%eax),%esi
    
    myproc()->pagesHead = newhead;
801070ee:	e8 cd ca ff ff       	call   80103bc0 <myproc>
801070f3:	89 b0 50 02 00 00    	mov    %esi,0x250(%eax)
    //proc->pagesInPhysic[proc->physcPageHead].prev = -1; check how to set prev of newhead to null   
    myproc()->pagesTail->next = oldHead;
801070f9:	e8 c2 ca ff ff       	call   80103bc0 <myproc>
801070fe:	8b 80 54 02 00 00    	mov    0x254(%eax),%eax
80107104:	89 58 10             	mov    %ebx,0x10(%eax)
    //proc->pagesInPhysic[oldHead].next = -1; check how to set head's next to null
    oldHead->prev = myproc()->pagesTail;
80107107:	e8 b4 ca ff ff       	call   80103bc0 <myproc>
8010710c:	8b 80 54 02 00 00    	mov    0x254(%eax),%eax
80107112:	89 43 14             	mov    %eax,0x14(%ebx)
    myproc()->pagesTail = oldHead;
80107115:	e8 a6 ca ff ff       	call   80103bc0 <myproc>
8010711a:	89 98 54 02 00 00    	mov    %ebx,0x254(%eax)
    
}
80107120:	5b                   	pop    %ebx
80107121:	5e                   	pop    %esi
80107122:	5d                   	pop    %ebp
80107123:	c3                   	ret    
80107124:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010712a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107130 <popFromSCFIFO>:

int 
popFromSCFIFO() {
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	56                   	push   %esi
80107134:	53                   	push   %ebx
80107135:	eb 13                	jmp    8010714a <popFromSCFIFO+0x1a>
80107137:	89 f6                	mov    %esi,%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    struct pageLink* pageToRemove=myproc()->pagesHead;
    pte_t* pte = walkpgdir(myproc()->pgdir, (void*)pageToRemove->va, 0);
    int accessed = (*pte) & PTE_A;
    while (accessed){
      *pte &= ~PTE_A;
80107140:	83 e2 df             	and    $0xffffffdf,%edx
80107143:	89 10                	mov    %edx,(%eax)
      moveHeadToTail();
80107145:	e8 86 ff ff ff       	call   801070d0 <moveHeadToTail>
    
}

int 
popFromSCFIFO() {
    struct pageLink* pageToRemove=myproc()->pagesHead;
8010714a:	e8 71 ca ff ff       	call   80103bc0 <myproc>
8010714f:	8b 98 50 02 00 00    	mov    0x250(%eax),%ebx
    pte_t* pte = walkpgdir(myproc()->pgdir, (void*)pageToRemove->va, 0);
80107155:	8b 73 04             	mov    0x4(%ebx),%esi
80107158:	e8 63 ca ff ff       	call   80103bc0 <myproc>
8010715d:	8b 40 04             	mov    0x4(%eax),%eax
80107160:	31 c9                	xor    %ecx,%ecx
80107162:	89 f2                	mov    %esi,%edx
80107164:	e8 c7 f9 ff ff       	call   80106b30 <walkpgdir>
    int accessed = (*pte) & PTE_A;
80107169:	8b 10                	mov    (%eax),%edx
    while (accessed){
8010716b:	f6 c2 20             	test   $0x20,%dl
8010716e:	75 d0                	jne    80107140 <popFromSCFIFO+0x10>
      moveHeadToTail();
      pageToRemove = myproc()->pagesHead;
      pte = walkpgdir(myproc()->pgdir, (void*)pageToRemove->va, 0);
      accessed = (*pte) & PTE_A;
    }
    int va=pageToRemove->va;
80107170:	8b 5b 04             	mov    0x4(%ebx),%ebx
    removePagesHead();
80107173:	e8 18 fd ff ff       	call   80106e90 <removePagesHead>
    return va;   
}
80107178:	89 d8                	mov    %ebx,%eax
8010717a:	5b                   	pop    %ebx
8010717b:	5e                   	pop    %esi
8010717c:	5d                   	pop    %ebp
8010717d:	c3                   	ret    
8010717e:	66 90                	xchg   %ax,%ax

80107180 <popFromAQ>:


int 
popFromAQ() {
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 1c             	sub    $0x1c,%esp
    struct pageLink* p = myproc()->pagesHead;
80107189:	e8 32 ca ff ff       	call   80103bc0 <myproc>
8010718e:	8b 98 50 02 00 00    	mov    0x250(%eax),%ebx
    while (p!=myproc()->pagesTail){
80107194:	eb 0d                	jmp    801071a3 <popFromAQ+0x23>
80107196:	8d 76 00             	lea    0x0(%esi),%esi
80107199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        nextPage->prev = prevPage;
        if (nextPage != myproc()->pagesTail)
          superNextPage->prev = p;

      }
      p = p->next;
801071a0:	8b 5b 10             	mov    0x10(%ebx),%ebx


int 
popFromAQ() {
    struct pageLink* p = myproc()->pagesHead;
    while (p!=myproc()->pagesTail){
801071a3:	e8 18 ca ff ff       	call   80103bc0 <myproc>
801071a8:	3b 98 54 02 00 00    	cmp    0x254(%eax),%ebx
801071ae:	74 60                	je     80107210 <popFromAQ+0x90>
      pte_t* pte = walkpgdir(myproc()->pgdir, (void*)p->va, 0);
801071b0:	8b 73 04             	mov    0x4(%ebx),%esi
801071b3:	e8 08 ca ff ff       	call   80103bc0 <myproc>
801071b8:	8b 40 04             	mov    0x4(%eax),%eax
801071bb:	31 c9                	xor    %ecx,%ecx
801071bd:	89 f2                	mov    %esi,%edx
801071bf:	e8 6c f9 ff ff       	call   80106b30 <walkpgdir>
      if(*pte & PTE_A)
801071c4:	f6 00 20             	testb  $0x20,(%eax)
801071c7:	74 d7                	je     801071a0 <popFromAQ+0x20>
      {
        struct pageLink* nextPage = p->next;
        struct pageLink* prevPage = p->prev;
801071c9:	8b 53 14             	mov    0x14(%ebx),%edx
    struct pageLink* p = myproc()->pagesHead;
    while (p!=myproc()->pagesTail){
      pte_t* pte = walkpgdir(myproc()->pgdir, (void*)p->va, 0);
      if(*pte & PTE_A)
      {
        struct pageLink* nextPage = p->next;
801071cc:	8b 73 10             	mov    0x10(%ebx),%esi
        struct pageLink* prevPage = p->prev;
801071cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        struct pageLink* superNextPage = nextPage->next;
801071d2:	8b 7e 10             	mov    0x10(%esi),%edi
        if (p != myproc()->pagesHead)
801071d5:	e8 e6 c9 ff ff       	call   80103bc0 <myproc>
801071da:	3b 98 50 02 00 00    	cmp    0x250(%eax),%ebx
801071e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071e3:	74 03                	je     801071e8 <popFromAQ+0x68>
          prevPage->next = nextPage;
801071e5:	89 72 10             	mov    %esi,0x10(%edx)
        p->next = superNextPage;
801071e8:	89 7b 10             	mov    %edi,0x10(%ebx)
        p->prev = nextPage;
801071eb:	89 73 14             	mov    %esi,0x14(%ebx)
        nextPage->next = p;
801071ee:	89 5e 10             	mov    %ebx,0x10(%esi)
        nextPage->prev = prevPage;
801071f1:	89 56 14             	mov    %edx,0x14(%esi)
        if (nextPage != myproc()->pagesTail)
801071f4:	e8 c7 c9 ff ff       	call   80103bc0 <myproc>
801071f9:	3b b0 54 02 00 00    	cmp    0x254(%eax),%esi
801071ff:	74 9f                	je     801071a0 <popFromAQ+0x20>
          superNextPage->prev = p;
80107201:	89 5f 14             	mov    %ebx,0x14(%edi)
80107204:	eb 9a                	jmp    801071a0 <popFromAQ+0x20>
80107206:	8d 76 00             	lea    0x0(%esi),%esi
80107209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

      }
      p = p->next;
    }
    int va = myproc()->pagesHead->va;
80107210:	e8 ab c9 ff ff       	call   80103bc0 <myproc>
80107215:	8b 80 50 02 00 00    	mov    0x250(%eax),%eax
8010721b:	8b 58 04             	mov    0x4(%eax),%ebx
    removePagesHead();
8010721e:	e8 6d fc ff ff       	call   80106e90 <removePagesHead>
  return va;
}
80107223:	83 c4 1c             	add    $0x1c,%esp
80107226:	89 d8                	mov    %ebx,%eax
80107228:	5b                   	pop    %ebx
80107229:	5e                   	pop    %esi
8010722a:	5f                   	pop    %edi
8010722b:	5d                   	pop    %ebp
8010722c:	c3                   	ret    
8010722d:	8d 76 00             	lea    0x0(%esi),%esi

80107230 <popPhysicalPage>:

int popPhysicalPage(){
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	53                   	push   %ebx
80107234:	83 ec 04             	sub    $0x4,%esp
  int va = 0;
  #ifdef NFUA
  cprintf("NFUA-------------\n" );
  va = popFromNFUA();
  #elif LAPA
  va = popFromLAPA();
80107237:	e8 d4 fd ff ff       	call   80107010 <popFromLAPA>
8010723c:	89 c3                	mov    %eax,%ebx
  va = popFromSCFIFO();
  #elif AQ
  va = popFromAQ();
  #endif
  
  myproc()->physicalPagesCount--;
8010723e:	e8 7d c9 ff ff       	call   80103bc0 <myproc>
80107243:	83 a8 80 00 00 00 01 	subl   $0x1,0x80(%eax)
  return va;
}
8010724a:	83 c4 04             	add    $0x4,%esp
8010724d:	89 d8                	mov    %ebx,%eax
8010724f:	5b                   	pop    %ebx
80107250:	5d                   	pop    %ebp
80107251:	c3                   	ret    
80107252:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107260 <findFreeSpace>:

int findFreeSpace(){
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	53                   	push   %ebx
  int i=0;
80107264:	31 db                	xor    %ebx,%ebx
  
  myproc()->physicalPagesCount--;
  return va;
}

int findFreeSpace(){
80107266:	83 ec 04             	sub    $0x4,%esp
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int i=0;
  while(i < MAX_PSYC_PAGES){
    if (myproc()->physicalPages[i].allocated == 0)
80107270:	e8 4b c9 ff ff       	call   80103bc0 <myproc>
80107275:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
80107278:	8b 84 d0 d0 00 00 00 	mov    0xd0(%eax,%edx,8),%eax
8010727f:	85 c0                	test   %eax,%eax
80107281:	74 08                	je     8010728b <findFreeSpace+0x2b>
      break;
    i++;
80107283:	83 c3 01             	add    $0x1,%ebx
  return va;
}

int findFreeSpace(){
  int i=0;
  while(i < MAX_PSYC_PAGES){
80107286:	83 fb 10             	cmp    $0x10,%ebx
80107289:	75 e5                	jne    80107270 <findFreeSpace+0x10>
    if (myproc()->physicalPages[i].allocated == 0)
      break;
    i++;
  }
  return i;
}
8010728b:	83 c4 04             	add    $0x4,%esp
8010728e:	89 d8                	mov    %ebx,%eax
80107290:	5b                   	pop    %ebx
80107291:	5d                   	pop    %ebp
80107292:	c3                   	ret    
80107293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072a0 <storingPages>:

void 
storingPages(void* virtualAddress) {
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 1c             	sub    $0x1c,%esp
  int i;
  int virtualPage = PTE_ADDR(virtualAddress);
801072a9:	8b 45 08             	mov    0x8(%ebp),%eax
801072ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072b1:	89 c6                	mov    %eax,%esi
801072b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte_t* pte = walkpgdir(myproc()->pgdir, (void*)virtualPage, 0);
801072b6:	e8 05 c9 ff ff       	call   80103bc0 <myproc>
801072bb:	8b 40 04             	mov    0x4(%eax),%eax
801072be:	31 c9                	xor    %ecx,%ecx
801072c0:	89 f2                	mov    %esi,%edx
801072c2:	e8 69 f8 ff ff       	call   80106b30 <walkpgdir>
  if (pte == 0) 
801072c7:	85 c0                	test   %eax,%eax
801072c9:	0f 84 a9 00 00 00    	je     80107378 <storingPages+0xd8>
801072cf:	89 c3                	mov    %eax,%ebx
      panic("storing pages: page doesn't exist for virutal address");
  
  *pte &= (~PTE_P);
  *pte |= (PTE_PG);
801072d1:	8b 00                	mov    (%eax),%eax
  
  // if ((*pte & PTE_P) != 0)
  //   panic("Flag is up.");
 
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
801072d3:	31 ff                	xor    %edi,%edi
  pte_t* pte = walkpgdir(myproc()->pgdir, (void*)virtualPage, 0);
  if (pte == 0) 
      panic("storing pages: page doesn't exist for virutal address");
  
  *pte &= (~PTE_P);
  *pte |= (PTE_PG);
801072d5:	83 e0 fe             	and    $0xfffffffe,%eax
801072d8:	80 cc 02             	or     $0x2,%ah
801072db:	89 03                	mov    %eax,(%ebx)
801072dd:	8d 76 00             	lea    0x0(%esi),%esi
  
  // if ((*pte & PTE_P) != 0)
  //   panic("Flag is up.");
 
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
    if (myproc()->swappedPages[i] == -1) 
801072e0:	e8 db c8 ff ff       	call   80103bc0 <myproc>
801072e5:	8d 4f 24             	lea    0x24(%edi),%ecx
801072e8:	83 3c 88 ff          	cmpl   $0xffffffff,(%eax,%ecx,4)
801072ec:	74 1a                	je     80107308 <storingPages+0x68>
  *pte |= (PTE_PG);
  
  // if ((*pte & PTE_P) != 0)
  //   panic("Flag is up.");
 
  for (i = 0; i < MAX_PSYC_PAGES; i++) {
801072ee:	83 c7 01             	add    $0x1,%edi
801072f1:	83 ff 10             	cmp    $0x10,%edi
801072f4:	75 ea                	jne    801072e0 <storingPages+0x40>
    if (myproc()->swappedPages[i] == -1) 
      break;
  }
  
  if (i == MAX_PSYC_PAGES)
    panic("storing pages: MAX_PSYC_PAGES exceeded");
801072f6:	83 ec 0c             	sub    $0xc,%esp
801072f9:	68 d0 87 10 80       	push   $0x801087d0
801072fe:	e8 6d 90 ff ff       	call   80100370 <panic>
80107303:	90                   	nop
80107304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

   //write the page to the proccess swap file
  writeToSwapFile(myproc(), (char*)PTE_ADDR((void *) ((*pte) + KERNBASE)), i*PGSIZE, PGSIZE);
80107308:	8b 03                	mov    (%ebx),%eax
8010730a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010730d:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80107313:	e8 a8 c8 ff ff       	call   80103bc0 <myproc>
80107318:	89 fa                	mov    %edi,%edx
8010731a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107320:	68 00 10 00 00       	push   $0x1000
80107325:	c1 e2 0c             	shl    $0xc,%edx
80107328:	52                   	push   %edx
80107329:	56                   	push   %esi
8010732a:	50                   	push   %eax
8010732b:	e8 10 af ff ff       	call   80102240 <writeToSwapFile>
  myproc()->swappedPages[i] = virtualPage;
80107330:	e8 8b c8 ff ff       	call   80103bc0 <myproc>
80107335:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107338:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010733b:	89 14 88             	mov    %edx,(%eax,%ecx,4)
  lcr3(((uint) (myproc()->pgdir))  - KERNBASE); 
8010733e:	e8 7d c8 ff ff       	call   80103bc0 <myproc>
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107343:	8b 40 04             	mov    0x4(%eax),%eax
80107346:	05 00 00 00 80       	add    $0x80000000,%eax
8010734b:	0f 22 d8             	mov    %eax,%cr3
  myproc()->swappedPagesCount += 1;
8010734e:	e8 6d c8 ff ff       	call   80103bc0 <myproc>
80107353:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
  kfree((char*)PTE_ADDR((*pte) + KERNBASE));
8010735a:	83 c4 10             	add    $0x10,%esp
8010735d:	8b 03                	mov    (%ebx),%eax
8010735f:	05 00 00 00 80       	add    $0x80000000,%eax
80107364:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107369:	89 45 08             	mov    %eax,0x8(%ebp)
 
}
8010736c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010736f:	5b                   	pop    %ebx
80107370:	5e                   	pop    %esi
80107371:	5f                   	pop    %edi
80107372:	5d                   	pop    %ebp
   //write the page to the proccess swap file
  writeToSwapFile(myproc(), (char*)PTE_ADDR((void *) ((*pte) + KERNBASE)), i*PGSIZE, PGSIZE);
  myproc()->swappedPages[i] = virtualPage;
  lcr3(((uint) (myproc()->pgdir))  - KERNBASE); 
  myproc()->swappedPagesCount += 1;
  kfree((char*)PTE_ADDR((*pte) + KERNBASE));
80107373:	e9 28 b3 ff ff       	jmp    801026a0 <kfree>
storingPages(void* virtualAddress) {
  int i;
  int virtualPage = PTE_ADDR(virtualAddress);
  pte_t* pte = walkpgdir(myproc()->pgdir, (void*)virtualPage, 0);
  if (pte == 0) 
      panic("storing pages: page doesn't exist for virutal address");
80107378:	83 ec 0c             	sub    $0xc,%esp
8010737b:	68 98 87 10 80       	push   $0x80108798
80107380:	e8 eb 8f ff ff       	call   80100370 <panic>
80107385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107390 <pushPhysicalPage>:
  myproc()->swappedPagesCount += 1;
  kfree((char*)PTE_ADDR((*pte) + KERNBASE));
 
}

void pushPhysicalPage(int virtualAddress) {
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 1c             	sub    $0x1c,%esp
  virtualAddress = PTE_ADDR(virtualAddress);
80107399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("%d: Adding page at %x (%d)\n", myproc()->pid, virtualAddress, myproc()->physicalPagesCount);
8010739c:	e8 1f c8 ff ff       	call   80103bc0 <myproc>
801073a1:	8b b0 80 00 00 00    	mov    0x80(%eax),%esi
  kfree((char*)PTE_ADDR((*pte) + KERNBASE));
 
}

void pushPhysicalPage(int virtualAddress) {
  virtualAddress = PTE_ADDR(virtualAddress);
801073a7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  cprintf("%d: Adding page at %x (%d)\n", myproc()->pid, virtualAddress, myproc()->physicalPagesCount);
801073ad:	e8 0e c8 ff ff       	call   80103bc0 <myproc>
801073b2:	56                   	push   %esi
801073b3:	53                   	push   %ebx
801073b4:	ff 70 10             	pushl  0x10(%eax)
801073b7:	68 76 86 10 80       	push   $0x80108676
801073bc:	e8 9f 92 ff ff       	call   80100660 <cprintf>
  rmPhysicalPage(virtualAddress);
801073c1:	89 1c 24             	mov    %ebx,(%esp)
801073c4:	e8 17 fa ff ff       	call   80106de0 <rmPhysicalPage>

  if (myproc()->physicalPagesCount >= MAX_PSYC_PAGES) {
801073c9:	e8 f2 c7 ff ff       	call   80103bc0 <myproc>
801073ce:	83 c4 10             	add    $0x10,%esp
801073d1:	83 b8 80 00 00 00 0f 	cmpl   $0xf,0x80(%eax)
801073d8:	0f 8f da 00 00 00    	jg     801074b8 <pushPhysicalPage+0x128>
  myproc()->swappedPagesCount += 1;
  kfree((char*)PTE_ADDR((*pte) + KERNBASE));
 
}

void pushPhysicalPage(int virtualAddress) {
801073de:	31 ff                	xor    %edi,%edi
}

int findFreeSpace(){
  int i=0;
  while(i < MAX_PSYC_PAGES){
    if (myproc()->physicalPages[i].allocated == 0)
801073e0:	e8 db c7 ff ff       	call   80103bc0 <myproc>
801073e5:	8d 0c 7f             	lea    (%edi,%edi,2),%ecx
801073e8:	c1 e1 03             	shl    $0x3,%ecx
801073eb:	8b b4 08 d0 00 00 00 	mov    0xd0(%eax,%ecx,1),%esi
801073f2:	85 f6                	test   %esi,%esi
801073f4:	74 1a                	je     80107410 <pushPhysicalPage+0x80>
      break;
    i++;
801073f6:	83 c7 01             	add    $0x1,%edi
  return va;
}

int findFreeSpace(){
  int i=0;
  while(i < MAX_PSYC_PAGES){
801073f9:	83 ff 10             	cmp    $0x10,%edi
801073fc:	75 e2                	jne    801073e0 <pushPhysicalPage+0x50>
  }

  int i=findFreeSpace();
  
  if (i == MAX_PSYC_PAGES) 
    panic("push physcial page: physical pages queue is full");
801073fe:	83 ec 0c             	sub    $0xc,%esp
80107401:	68 f8 87 10 80       	push   $0x801087f8
80107406:	e8 65 8f ff ff       	call   80100370 <panic>
8010740b:	90                   	nop
8010740c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107410:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  struct pageLink* page = &myproc()->physicalPages[i];
80107413:	e8 a8 c7 ff ff       	call   80103bc0 <myproc>
80107418:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010741b:	89 c6                	mov    %eax,%esi
8010741d:	8d 84 08 d0 00 00 00 	lea    0xd0(%eax,%ecx,1),%eax
  page->allocated = 1;
80107424:	01 f1                	add    %esi,%ecx
80107426:	c7 81 d0 00 00 00 01 	movl   $0x1,0xd0(%ecx)
8010742d:	00 00 00 
  page->va = virtualAddress;
80107430:	89 99 d4 00 00 00    	mov    %ebx,0xd4(%ecx)
  page->next = 0;
80107436:	c7 81 e0 00 00 00 00 	movl   $0x0,0xe0(%ecx)
8010743d:	00 00 00 
  int i=findFreeSpace();
  
  if (i == MAX_PSYC_PAGES) 
    panic("push physcial page: physical pages queue is full");

  struct pageLink* page = &myproc()->physicalPages[i];
80107440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  page->allocated = 1;
  page->va = virtualAddress;
  page->next = 0;
  

  if (myproc()->pagesTail)
80107443:	e8 78 c7 ff ff       	call   80103bc0 <myproc>
80107448:	8b 80 54 02 00 00    	mov    0x254(%eax),%eax
8010744e:	85 c0                	test   %eax,%eax
80107450:	74 11                	je     80107463 <pushPhysicalPage+0xd3>
    myproc()->pagesTail->next = page;
80107452:	e8 69 c7 ff ff       	call   80103bc0 <myproc>
80107457:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010745a:	8b 80 54 02 00 00    	mov    0x254(%eax),%eax
80107460:	89 50 10             	mov    %edx,0x10(%eax)
  
  page->prev = myproc()->pagesTail;
80107463:	e8 58 c7 ff ff       	call   80103bc0 <myproc>
80107468:	8b 88 54 02 00 00    	mov    0x254(%eax),%ecx
8010746e:	8d 04 7f             	lea    (%edi,%edi,2),%eax
80107471:	8d 04 c6             	lea    (%esi,%eax,8),%eax
80107474:	89 88 e4 00 00 00    	mov    %ecx,0xe4(%eax)
  page->accesses = 0;
8010747a:	c7 80 d8 00 00 00 00 	movl   $0x0,0xd8(%eax)
80107481:	00 00 00 
  myproc()->pagesTail = page;
80107484:	e8 37 c7 ff ff       	call   80103bc0 <myproc>
80107489:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010748c:	89 90 54 02 00 00    	mov    %edx,0x254(%eax)
 
  if (!myproc()->pagesHead)
80107492:	e8 29 c7 ff ff       	call   80103bc0 <myproc>
80107497:	8b 90 50 02 00 00    	mov    0x250(%eax),%edx
8010749d:	85 d2                	test   %edx,%edx
8010749f:	74 3f                	je     801074e0 <pushPhysicalPage+0x150>
    myproc()->pagesHead = page;

  myproc()->physicalPagesCount++;
801074a1:	e8 1a c7 ff ff       	call   80103bc0 <myproc>
801074a6:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
}
801074ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074b0:	5b                   	pop    %ebx
801074b1:	5e                   	pop    %esi
801074b2:	5f                   	pop    %edi
801074b3:	5d                   	pop    %ebp
801074b4:	c3                   	ret    
801074b5:	8d 76 00             	lea    0x0(%esi),%esi
  virtualAddress = PTE_ADDR(virtualAddress);
  cprintf("%d: Adding page at %x (%d)\n", myproc()->pid, virtualAddress, myproc()->physicalPagesCount);
  rmPhysicalPage(virtualAddress);

  if (myproc()->physicalPagesCount >= MAX_PSYC_PAGES) {
      int virtualAddress = popPhysicalPage();
801074b8:	e8 73 fd ff ff       	call   80107230 <popPhysicalPage>
      storingPages((void*)virtualAddress);
801074bd:	83 ec 0c             	sub    $0xc,%esp
801074c0:	50                   	push   %eax
801074c1:	e8 da fd ff ff       	call   801072a0 <storingPages>
      myproc()->pageOutCount++;
801074c6:	e8 f5 c6 ff ff       	call   80103bc0 <myproc>
801074cb:	83 c4 10             	add    $0x10,%esp
801074ce:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
801074d5:	e9 04 ff ff ff       	jmp    801073de <pushPhysicalPage+0x4e>
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  page->prev = myproc()->pagesTail;
  page->accesses = 0;
  myproc()->pagesTail = page;
 
  if (!myproc()->pagesHead)
    myproc()->pagesHead = page;
801074e0:	e8 db c6 ff ff       	call   80103bc0 <myproc>
801074e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074e8:	89 90 50 02 00 00    	mov    %edx,0x250(%eax)
801074ee:	eb b1                	jmp    801074a1 <pushPhysicalPage+0x111>

801074f0 <retrievingPages>:
  myproc()->physicalPagesCount++;
}


int retrievingPages(void* virtualAddress)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 1c             	sub    $0x1c,%esp
   int virtualPage = PTE_ADDR(virtualAddress);
801074f9:	8b 75 08             	mov    0x8(%ebp),%esi
  //try to page in
  pte_t* pte = walkpgdir(myproc()->pgdir, (char*)virtualPage, 0);
801074fc:	e8 bf c6 ff ff       	call   80103bc0 <myproc>
80107501:	8b 40 04             	mov    0x4(%eax),%eax
80107504:	31 c9                	xor    %ecx,%ecx
}


int retrievingPages(void* virtualAddress)
{
   int virtualPage = PTE_ADDR(virtualAddress);
80107506:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  //try to page in
  pte_t* pte = walkpgdir(myproc()->pgdir, (char*)virtualPage, 0);
8010750c:	89 f2                	mov    %esi,%edx
8010750e:	e8 1d f6 ff ff       	call   80106b30 <walkpgdir>

  if (pte && ((*pte & PTE_PG) != 0)){
80107513:	85 c0                	test   %eax,%eax
80107515:	0f 84 c5 00 00 00    	je     801075e0 <retrievingPages+0xf0>
8010751b:	8b 00                	mov    (%eax),%eax
8010751d:	f6 c4 02             	test   $0x2,%ah
80107520:	0f 84 ba 00 00 00    	je     801075e0 <retrievingPages+0xf0>
80107526:	31 db                	xor    %ebx,%ebx
80107528:	90                   	nop
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    int i = 0;
    while(i < MAX_PSYC_PAGES){
      if (myproc()->swappedPages[i] == virtualPage)
80107530:	8d 7b 24             	lea    0x24(%ebx),%edi
80107533:	e8 88 c6 ff ff       	call   80103bc0 <myproc>
80107538:	3b 34 b8             	cmp    (%eax,%edi,4),%esi
8010753b:	74 1b                	je     80107558 <retrievingPages+0x68>
        break;
      i++;
8010753d:	83 c3 01             	add    $0x1,%ebx
  //try to page in
  pte_t* pte = walkpgdir(myproc()->pgdir, (char*)virtualPage, 0);

  if (pte && ((*pte & PTE_PG) != 0)){
    int i = 0;
    while(i < MAX_PSYC_PAGES){
80107540:	83 fb 10             	cmp    $0x10,%ebx
80107543:	75 eb                	jne    80107530 <retrievingPages+0x40>
        break;
      i++;
    }

    if (i == MAX_PSYC_PAGES) 
      panic("retrieving Pages: page doesn't exist");
80107545:	83 ec 0c             	sub    $0xc,%esp
80107548:	68 74 88 10 80       	push   $0x80108874
8010754d:	e8 1e 8e ff ff       	call   80100370 <panic>
80107552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    char *mem = kalloc();
80107558:	e8 f3 b2 ff ff       	call   80102850 <kalloc>

    if(mem == 0)
8010755d:	85 c0                	test   %eax,%eax
    }

    if (i == MAX_PSYC_PAGES) 
      panic("retrieving Pages: page doesn't exist");

    char *mem = kalloc();
8010755f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    if(mem == 0)
80107562:	0f 84 8f 00 00 00    	je     801075f7 <retrievingPages+0x107>
      panic("retrieving Pages: out of memory");

    //read the page from the swap file
    if (readFromSwapFile(myproc(), mem, i * PGSIZE, PGSIZE) == -1)
80107568:	c1 e3 0c             	shl    $0xc,%ebx
8010756b:	e8 50 c6 ff ff       	call   80103bc0 <myproc>
80107570:	68 00 10 00 00       	push   $0x1000
80107575:	53                   	push   %ebx
80107576:	ff 75 e4             	pushl  -0x1c(%ebp)
80107579:	50                   	push   %eax
8010757a:	e8 11 ad ff ff       	call   80102290 <readFromSwapFile>
8010757f:	83 c4 10             	add    $0x10,%esp
80107582:	83 f8 ff             	cmp    $0xffffffff,%eax
80107585:	74 63                	je     801075ea <retrievingPages+0xfa>
      panic("retrieving pages: error reading page");

    //mark as unswapped
    myproc()->swappedPages[i] = -1;
80107587:	e8 34 c6 ff ff       	call   80103bc0 <myproc>
8010758c:	c7 04 b8 ff ff ff ff 	movl   $0xffffffff,(%eax,%edi,4)

    mappages(myproc()->pgdir, (char*)virtualPage, PGSIZE, (uint) (mem)  - KERNBASE, PTE_W|PTE_U|PTE_P);
80107593:	e8 28 c6 ff ff       	call   80103bc0 <myproc>
80107598:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010759b:	83 ec 08             	sub    $0x8,%esp
8010759e:	8b 40 04             	mov    0x4(%eax),%eax
801075a1:	6a 07                	push   $0x7
801075a3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075a8:	89 f2                	mov    %esi,%edx
801075aa:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801075b0:	57                   	push   %edi
801075b1:	e8 fa f5 ff ff       	call   80106bb0 <mappages>
    pushPhysicalPage(virtualPage);
801075b6:	89 34 24             	mov    %esi,(%esp)
801075b9:	e8 d2 fd ff ff       	call   80107390 <pushPhysicalPage>
    lcr3(((uint) (myproc()->pgdir))  - KERNBASE);
801075be:	e8 fd c5 ff ff       	call   80103bc0 <myproc>
801075c3:	8b 40 04             	mov    0x4(%eax),%eax
801075c6:	05 00 00 00 80       	add    $0x80000000,%eax
801075cb:	0f 22 d8             	mov    %eax,%cr3

    return 1;
801075ce:	83 c4 10             	add    $0x10,%esp
  }

  return 0;
}
801075d1:	8d 65 f4             	lea    -0xc(%ebp),%esp

    mappages(myproc()->pgdir, (char*)virtualPage, PGSIZE, (uint) (mem)  - KERNBASE, PTE_W|PTE_U|PTE_P);
    pushPhysicalPage(virtualPage);
    lcr3(((uint) (myproc()->pgdir))  - KERNBASE);

    return 1;
801075d4:	b8 01 00 00 00       	mov    $0x1,%eax
  }

  return 0;
}
801075d9:	5b                   	pop    %ebx
801075da:	5e                   	pop    %esi
801075db:	5f                   	pop    %edi
801075dc:	5d                   	pop    %ebp
801075dd:	c3                   	ret    
801075de:	66 90                	xchg   %ax,%ax
801075e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    lcr3(((uint) (myproc()->pgdir))  - KERNBASE);

    return 1;
  }

  return 0;
801075e3:	31 c0                	xor    %eax,%eax
}
801075e5:	5b                   	pop    %ebx
801075e6:	5e                   	pop    %esi
801075e7:	5f                   	pop    %edi
801075e8:	5d                   	pop    %ebp
801075e9:	c3                   	ret    
    if(mem == 0)
      panic("retrieving Pages: out of memory");

    //read the page from the swap file
    if (readFromSwapFile(myproc(), mem, i * PGSIZE, PGSIZE) == -1)
      panic("retrieving pages: error reading page");
801075ea:	83 ec 0c             	sub    $0xc,%esp
801075ed:	68 4c 88 10 80       	push   $0x8010884c
801075f2:	e8 79 8d ff ff       	call   80100370 <panic>
      panic("retrieving Pages: page doesn't exist");

    char *mem = kalloc();

    if(mem == 0)
      panic("retrieving Pages: out of memory");
801075f7:	83 ec 0c             	sub    $0xc,%esp
801075fa:	68 2c 88 10 80       	push   $0x8010882c
801075ff:	e8 6c 8d ff ff       	call   80100370 <panic>
80107604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010760a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107610 <switchkvm>:
80107610:	a1 a4 db 11 80       	mov    0x8011dba4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107615:	55                   	push   %ebp
80107616:	89 e5                	mov    %esp,%ebp
80107618:	05 00 00 00 80       	add    $0x80000000,%eax
8010761d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107620:	5d                   	pop    %ebp
80107621:	c3                   	ret    
80107622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107630 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	57                   	push   %edi
80107634:	56                   	push   %esi
80107635:	53                   	push   %ebx
80107636:	83 ec 1c             	sub    $0x1c,%esp
80107639:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010763c:	85 f6                	test   %esi,%esi
8010763e:	0f 84 cd 00 00 00    	je     80107711 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107644:	8b 46 08             	mov    0x8(%esi),%eax
80107647:	85 c0                	test   %eax,%eax
80107649:	0f 84 dc 00 00 00    	je     8010772b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010764f:	8b 7e 04             	mov    0x4(%esi),%edi
80107652:	85 ff                	test   %edi,%edi
80107654:	0f 84 c4 00 00 00    	je     8010771e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010765a:	e8 71 d1 ff ff       	call   801047d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010765f:	e8 bc c4 ff ff       	call   80103b20 <mycpu>
80107664:	89 c3                	mov    %eax,%ebx
80107666:	e8 b5 c4 ff ff       	call   80103b20 <mycpu>
8010766b:	89 c7                	mov    %eax,%edi
8010766d:	e8 ae c4 ff ff       	call   80103b20 <mycpu>
80107672:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107675:	83 c7 08             	add    $0x8,%edi
80107678:	e8 a3 c4 ff ff       	call   80103b20 <mycpu>
8010767d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107680:	83 c0 08             	add    $0x8,%eax
80107683:	ba 67 00 00 00       	mov    $0x67,%edx
80107688:	c1 e8 18             	shr    $0x18,%eax
8010768b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107692:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107699:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801076a0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801076a7:	83 c1 08             	add    $0x8,%ecx
801076aa:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801076b0:	c1 e9 10             	shr    $0x10,%ecx
801076b3:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076b9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801076be:	e8 5d c4 ff ff       	call   80103b20 <mycpu>
801076c3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801076ca:	e8 51 c4 ff ff       	call   80103b20 <mycpu>
801076cf:	b9 10 00 00 00       	mov    $0x10,%ecx
801076d4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801076d8:	e8 43 c4 ff ff       	call   80103b20 <mycpu>
801076dd:	8b 56 08             	mov    0x8(%esi),%edx
801076e0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801076e6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801076e9:	e8 32 c4 ff ff       	call   80103b20 <mycpu>
801076ee:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801076f2:	b8 28 00 00 00       	mov    $0x28,%eax
801076f7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076fa:	8b 46 04             	mov    0x4(%esi),%eax
801076fd:	05 00 00 00 80       	add    $0x80000000,%eax
80107702:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107705:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107708:	5b                   	pop    %ebx
80107709:	5e                   	pop    %esi
8010770a:	5f                   	pop    %edi
8010770b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010770c:	e9 af d1 ff ff       	jmp    801048c0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107711:	83 ec 0c             	sub    $0xc,%esp
80107714:	68 92 86 10 80       	push   $0x80108692
80107719:	e8 52 8c ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010771e:	83 ec 0c             	sub    $0xc,%esp
80107721:	68 bd 86 10 80       	push   $0x801086bd
80107726:	e8 45 8c ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010772b:	83 ec 0c             	sub    $0xc,%esp
8010772e:	68 a8 86 10 80       	push   $0x801086a8
80107733:	e8 38 8c ff ff       	call   80100370 <panic>
80107738:	90                   	nop
80107739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107740 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	57                   	push   %edi
80107744:	56                   	push   %esi
80107745:	53                   	push   %ebx
80107746:	83 ec 1c             	sub    $0x1c,%esp
80107749:	8b 75 10             	mov    0x10(%ebp),%esi
8010774c:	8b 45 08             	mov    0x8(%ebp),%eax
8010774f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107752:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010775b:	77 49                	ja     801077a6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010775d:	e8 ee b0 ff ff       	call   80102850 <kalloc>
  memset(mem, 0, PGSIZE);
80107762:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107765:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107767:	68 00 10 00 00       	push   $0x1000
8010776c:	6a 00                	push   $0x0
8010776e:	50                   	push   %eax
8010776f:	e8 0c d2 ff ff       	call   80104980 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107774:	58                   	pop    %eax
80107775:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010777b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107780:	5a                   	pop    %edx
80107781:	6a 06                	push   $0x6
80107783:	50                   	push   %eax
80107784:	31 d2                	xor    %edx,%edx
80107786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107789:	e8 22 f4 ff ff       	call   80106bb0 <mappages>
  memmove(mem, init, sz);
8010778e:	89 75 10             	mov    %esi,0x10(%ebp)
80107791:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107794:	83 c4 10             	add    $0x10,%esp
80107797:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010779a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010779d:	5b                   	pop    %ebx
8010779e:	5e                   	pop    %esi
8010779f:	5f                   	pop    %edi
801077a0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801077a1:	e9 8a d2 ff ff       	jmp    80104a30 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801077a6:	83 ec 0c             	sub    $0xc,%esp
801077a9:	68 d1 86 10 80       	push   $0x801086d1
801077ae:	e8 bd 8b ff ff       	call   80100370 <panic>
801077b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
801077c6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801077c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801077d0:	0f 85 91 00 00 00    	jne    80107867 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801077d6:	8b 75 18             	mov    0x18(%ebp),%esi
801077d9:	31 db                	xor    %ebx,%ebx
801077db:	85 f6                	test   %esi,%esi
801077dd:	75 1a                	jne    801077f9 <loaduvm+0x39>
801077df:	eb 6f                	jmp    80107850 <loaduvm+0x90>
801077e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801077f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801077f7:	76 57                	jbe    80107850 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801077f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801077fc:	8b 45 08             	mov    0x8(%ebp),%eax
801077ff:	31 c9                	xor    %ecx,%ecx
80107801:	01 da                	add    %ebx,%edx
80107803:	e8 28 f3 ff ff       	call   80106b30 <walkpgdir>
80107808:	85 c0                	test   %eax,%eax
8010780a:	74 4e                	je     8010785a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010780c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010780e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107811:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107816:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010781b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107821:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107824:	01 d9                	add    %ebx,%ecx
80107826:	05 00 00 00 80       	add    $0x80000000,%eax
8010782b:	57                   	push   %edi
8010782c:	51                   	push   %ecx
8010782d:	50                   	push   %eax
8010782e:	ff 75 10             	pushl  0x10(%ebp)
80107831:	e8 1a a1 ff ff       	call   80101950 <readi>
80107836:	83 c4 10             	add    $0x10,%esp
80107839:	39 c7                	cmp    %eax,%edi
8010783b:	74 ab                	je     801077e8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010783d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107845:	5b                   	pop    %ebx
80107846:	5e                   	pop    %esi
80107847:	5f                   	pop    %edi
80107848:	5d                   	pop    %ebp
80107849:	c3                   	ret    
8010784a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107850:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107853:	31 c0                	xor    %eax,%eax
}
80107855:	5b                   	pop    %ebx
80107856:	5e                   	pop    %esi
80107857:	5f                   	pop    %edi
80107858:	5d                   	pop    %ebp
80107859:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010785a:	83 ec 0c             	sub    $0xc,%esp
8010785d:	68 eb 86 10 80       	push   $0x801086eb
80107862:	e8 09 8b ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107867:	83 ec 0c             	sub    $0xc,%esp
8010786a:	68 9c 88 10 80       	push   $0x8010889c
8010786f:	e8 fc 8a ff ff       	call   80100370 <panic>
80107874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010787a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107880 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 0c             	sub    $0xc,%esp
80107889:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010788c:	85 ff                	test   %edi,%edi
8010788e:	0f 88 ea 00 00 00    	js     8010797e <allocuvm+0xfe>
    return 0;
  if(newsz < oldsz)
80107894:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107897:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010789a:	0f 82 9e 00 00 00    	jb     8010793e <allocuvm+0xbe>
    return oldsz;

  a = PGROUNDUP(oldsz);
801078a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801078a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801078ac:	39 df                	cmp    %ebx,%edi
801078ae:	77 47                	ja     801078f7 <allocuvm+0x77>
801078b0:	e9 db 00 00 00       	jmp    80107990 <allocuvm+0x110>
801078b5:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801078b8:	83 ec 04             	sub    $0x4,%esp
801078bb:	68 00 10 00 00       	push   $0x1000
801078c0:	6a 00                	push   $0x0
801078c2:	50                   	push   %eax
801078c3:	e8 b8 d0 ff ff       	call   80104980 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801078c8:	58                   	pop    %eax
801078c9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801078cf:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078d4:	5a                   	pop    %edx
801078d5:	6a 06                	push   $0x6
801078d7:	50                   	push   %eax
801078d8:	89 da                	mov    %ebx,%edx
801078da:	8b 45 08             	mov    0x8(%ebp),%eax
801078dd:	e8 ce f2 ff ff       	call   80106bb0 <mappages>
801078e2:	83 c4 10             	add    $0x10,%esp
801078e5:	85 c0                	test   %eax,%eax
801078e7:	78 67                	js     80107950 <allocuvm+0xd0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801078e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078ef:	39 df                	cmp    %ebx,%edi
801078f1:	0f 86 99 00 00 00    	jbe    80107990 <allocuvm+0x110>
    #ifndef NONE  
      cprintf("hadpasa\n");
801078f7:	83 ec 0c             	sub    $0xc,%esp
801078fa:	68 09 87 10 80       	push   $0x80108709
801078ff:	e8 5c 8d ff ff       	call   80100660 <cprintf>
      pushPhysicalPage(a);
80107904:	89 1c 24             	mov    %ebx,(%esp)
80107907:	e8 84 fa ff ff       	call   80107390 <pushPhysicalPage>
    #endif
    mem = kalloc();
8010790c:	e8 3f af ff ff       	call   80102850 <kalloc>
    if(mem == 0){
80107911:	83 c4 10             	add    $0x10,%esp
80107914:	85 c0                	test   %eax,%eax
  for(; a < newsz; a += PGSIZE){
    #ifndef NONE  
      cprintf("hadpasa\n");
      pushPhysicalPage(a);
    #endif
    mem = kalloc();
80107916:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107918:	75 9e                	jne    801078b8 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010791a:	83 ec 0c             	sub    $0xc,%esp
8010791d:	68 12 87 10 80       	push   $0x80108712
80107922:	e8 39 8d ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107927:	83 c4 10             	add    $0x10,%esp
8010792a:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010792d:	76 4f                	jbe    8010797e <allocuvm+0xfe>
8010792f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107932:	8b 45 08             	mov    0x8(%ebp),%eax
80107935:	89 fa                	mov    %edi,%edx
80107937:	e8 04 f3 ff ff       	call   80106c40 <deallocuvm.part.0>
    #endif
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
8010793c:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
8010793e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107941:	5b                   	pop    %ebx
80107942:	5e                   	pop    %esi
80107943:	5f                   	pop    %edi
80107944:	5d                   	pop    %ebp
80107945:	c3                   	ret    
80107946:	8d 76 00             	lea    0x0(%esi),%esi
80107949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107950:	83 ec 0c             	sub    $0xc,%esp
80107953:	68 2a 87 10 80       	push   $0x8010872a
80107958:	e8 03 8d ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010795d:	83 c4 10             	add    $0x10,%esp
80107960:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107963:	76 0d                	jbe    80107972 <allocuvm+0xf2>
80107965:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107968:	8b 45 08             	mov    0x8(%ebp),%eax
8010796b:	89 fa                	mov    %edi,%edx
8010796d:	e8 ce f2 ff ff       	call   80106c40 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107972:	83 ec 0c             	sub    $0xc,%esp
80107975:	56                   	push   %esi
80107976:	e8 25 ad ff ff       	call   801026a0 <kfree>
      return 0;
8010797b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010797e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107981:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107983:	5b                   	pop    %ebx
80107984:	5e                   	pop    %esi
80107985:	5f                   	pop    %edi
80107986:	5d                   	pop    %ebp
80107987:	c3                   	ret    
80107988:	90                   	nop
80107989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107990:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107993:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107995:	5b                   	pop    %ebx
80107996:	5e                   	pop    %esi
80107997:	5f                   	pop    %edi
80107998:	5d                   	pop    %ebp
80107999:	c3                   	ret    
8010799a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079a0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801079a0:	55                   	push   %ebp
801079a1:	89 e5                	mov    %esp,%ebp
801079a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801079a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801079a9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801079ac:	39 d1                	cmp    %edx,%ecx
801079ae:	73 10                	jae    801079c0 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801079b0:	5d                   	pop    %ebp
801079b1:	e9 8a f2 ff ff       	jmp    80106c40 <deallocuvm.part.0>
801079b6:	8d 76 00             	lea    0x0(%esi),%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801079c0:	89 d0                	mov    %edx,%eax
801079c2:	5d                   	pop    %ebp
801079c3:	c3                   	ret    
801079c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801079d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	57                   	push   %edi
801079d4:	56                   	push   %esi
801079d5:	53                   	push   %ebx
801079d6:	83 ec 0c             	sub    $0xc,%esp
801079d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801079dc:	85 f6                	test   %esi,%esi
801079de:	74 59                	je     80107a39 <freevm+0x69>
801079e0:	31 c9                	xor    %ecx,%ecx
801079e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801079e7:	89 f0                	mov    %esi,%eax
801079e9:	e8 52 f2 ff ff       	call   80106c40 <deallocuvm.part.0>
801079ee:	89 f3                	mov    %esi,%ebx
801079f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801079f6:	eb 0f                	jmp    80107a07 <freevm+0x37>
801079f8:	90                   	nop
801079f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a00:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107a03:	39 fb                	cmp    %edi,%ebx
80107a05:	74 23                	je     80107a2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107a07:	8b 03                	mov    (%ebx),%eax
80107a09:	a8 01                	test   $0x1,%al
80107a0b:	74 f3                	je     80107a00 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80107a0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107a12:	83 ec 0c             	sub    $0xc,%esp
80107a15:	83 c3 04             	add    $0x4,%ebx
80107a18:	05 00 00 00 80       	add    $0x80000000,%eax
80107a1d:	50                   	push   %eax
80107a1e:	e8 7d ac ff ff       	call   801026a0 <kfree>
80107a23:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107a26:	39 fb                	cmp    %edi,%ebx
80107a28:	75 dd                	jne    80107a07 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107a2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107a2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a30:	5b                   	pop    %ebx
80107a31:	5e                   	pop    %esi
80107a32:	5f                   	pop    %edi
80107a33:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107a34:	e9 67 ac ff ff       	jmp    801026a0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107a39:	83 ec 0c             	sub    $0xc,%esp
80107a3c:	68 46 87 10 80       	push   $0x80108746
80107a41:	e8 2a 89 ff ff       	call   80100370 <panic>
80107a46:	8d 76 00             	lea    0x0(%esi),%esi
80107a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a50 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	56                   	push   %esi
80107a54:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107a55:	e8 f6 ad ff ff       	call   80102850 <kalloc>
80107a5a:	85 c0                	test   %eax,%eax
80107a5c:	74 6a                	je     80107ac8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80107a5e:	83 ec 04             	sub    $0x4,%esp
80107a61:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a63:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107a68:	68 00 10 00 00       	push   $0x1000
80107a6d:	6a 00                	push   $0x0
80107a6f:	50                   	push   %eax
80107a70:	e8 0b cf ff ff       	call   80104980 <memset>
80107a75:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107a78:	8b 43 04             	mov    0x4(%ebx),%eax
80107a7b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107a7e:	83 ec 08             	sub    $0x8,%esp
80107a81:	8b 13                	mov    (%ebx),%edx
80107a83:	ff 73 0c             	pushl  0xc(%ebx)
80107a86:	50                   	push   %eax
80107a87:	29 c1                	sub    %eax,%ecx
80107a89:	89 f0                	mov    %esi,%eax
80107a8b:	e8 20 f1 ff ff       	call   80106bb0 <mappages>
80107a90:	83 c4 10             	add    $0x10,%esp
80107a93:	85 c0                	test   %eax,%eax
80107a95:	78 19                	js     80107ab0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a97:	83 c3 10             	add    $0x10,%ebx
80107a9a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107aa0:	75 d6                	jne    80107a78 <setupkvm+0x28>
80107aa2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107aa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107aa7:	5b                   	pop    %ebx
80107aa8:	5e                   	pop    %esi
80107aa9:	5d                   	pop    %ebp
80107aaa:	c3                   	ret    
80107aab:	90                   	nop
80107aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107ab0:	83 ec 0c             	sub    $0xc,%esp
80107ab3:	56                   	push   %esi
80107ab4:	e8 17 ff ff ff       	call   801079d0 <freevm>
      return 0;
80107ab9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80107abc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80107abf:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107ac1:	5b                   	pop    %ebx
80107ac2:	5e                   	pop    %esi
80107ac3:	5d                   	pop    %ebp
80107ac4:	c3                   	ret    
80107ac5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107ac8:	31 c0                	xor    %eax,%eax
80107aca:	eb d8                	jmp    80107aa4 <setupkvm+0x54>
80107acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107ad0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107ad0:	55                   	push   %ebp
80107ad1:	89 e5                	mov    %esp,%ebp
80107ad3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ad6:	e8 75 ff ff ff       	call   80107a50 <setupkvm>
80107adb:	a3 a4 db 11 80       	mov    %eax,0x8011dba4
80107ae0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ae5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107ae8:	c9                   	leave  
80107ae9:	c3                   	ret    
80107aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107af0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107af0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107af1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107af3:	89 e5                	mov    %esp,%ebp
80107af5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107af8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107afb:	8b 45 08             	mov    0x8(%ebp),%eax
80107afe:	e8 2d f0 ff ff       	call   80106b30 <walkpgdir>
  if(pte == 0)
80107b03:	85 c0                	test   %eax,%eax
80107b05:	74 05                	je     80107b0c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107b07:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107b0a:	c9                   	leave  
80107b0b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107b0c:	83 ec 0c             	sub    $0xc,%esp
80107b0f:	68 57 87 10 80       	push   $0x80108757
80107b14:	e8 57 88 ff ff       	call   80100370 <panic>
80107b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b20 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107b20:	55                   	push   %ebp
80107b21:	89 e5                	mov    %esp,%ebp
80107b23:	57                   	push   %edi
80107b24:	56                   	push   %esi
80107b25:	53                   	push   %ebx
80107b26:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107b29:	e8 22 ff ff ff       	call   80107a50 <setupkvm>
80107b2e:	85 c0                	test   %eax,%eax
80107b30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b33:	0f 84 b2 00 00 00    	je     80107beb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107b3c:	85 c9                	test   %ecx,%ecx
80107b3e:	0f 84 9c 00 00 00    	je     80107be0 <copyuvm+0xc0>
80107b44:	31 f6                	xor    %esi,%esi
80107b46:	eb 4a                	jmp    80107b92 <copyuvm+0x72>
80107b48:	90                   	nop
80107b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107b50:	83 ec 04             	sub    $0x4,%esp
80107b53:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107b59:	68 00 10 00 00       	push   $0x1000
80107b5e:	57                   	push   %edi
80107b5f:	50                   	push   %eax
80107b60:	e8 cb ce ff ff       	call   80104a30 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107b65:	58                   	pop    %eax
80107b66:	5a                   	pop    %edx
80107b67:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80107b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107b70:	ff 75 e4             	pushl  -0x1c(%ebp)
80107b73:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b78:	52                   	push   %edx
80107b79:	89 f2                	mov    %esi,%edx
80107b7b:	e8 30 f0 ff ff       	call   80106bb0 <mappages>
80107b80:	83 c4 10             	add    $0x10,%esp
80107b83:	85 c0                	test   %eax,%eax
80107b85:	78 3e                	js     80107bc5 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107b87:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b8d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b90:	76 4e                	jbe    80107be0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107b92:	8b 45 08             	mov    0x8(%ebp),%eax
80107b95:	31 c9                	xor    %ecx,%ecx
80107b97:	89 f2                	mov    %esi,%edx
80107b99:	e8 92 ef ff ff       	call   80106b30 <walkpgdir>
80107b9e:	85 c0                	test   %eax,%eax
80107ba0:	74 5a                	je     80107bfc <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107ba2:	8b 18                	mov    (%eax),%ebx
80107ba4:	f6 c3 01             	test   $0x1,%bl
80107ba7:	74 46                	je     80107bef <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107ba9:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107bab:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107bb1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107bb4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80107bba:	e8 91 ac ff ff       	call   80102850 <kalloc>
80107bbf:	85 c0                	test   %eax,%eax
80107bc1:	89 c3                	mov    %eax,%ebx
80107bc3:	75 8b                	jne    80107b50 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107bc5:	83 ec 0c             	sub    $0xc,%esp
80107bc8:	ff 75 e0             	pushl  -0x20(%ebp)
80107bcb:	e8 00 fe ff ff       	call   801079d0 <freevm>
  return 0;
80107bd0:	83 c4 10             	add    $0x10,%esp
80107bd3:	31 c0                	xor    %eax,%eax
}
80107bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bd8:	5b                   	pop    %ebx
80107bd9:	5e                   	pop    %esi
80107bda:	5f                   	pop    %edi
80107bdb:	5d                   	pop    %ebp
80107bdc:	c3                   	ret    
80107bdd:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107be6:	5b                   	pop    %ebx
80107be7:	5e                   	pop    %esi
80107be8:	5f                   	pop    %edi
80107be9:	5d                   	pop    %ebp
80107bea:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80107beb:	31 c0                	xor    %eax,%eax
80107bed:	eb e6                	jmp    80107bd5 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80107bef:	83 ec 0c             	sub    $0xc,%esp
80107bf2:	68 7b 87 10 80       	push   $0x8010877b
80107bf7:	e8 74 87 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107bfc:	83 ec 0c             	sub    $0xc,%esp
80107bff:	68 61 87 10 80       	push   $0x80108761
80107c04:	e8 67 87 ff ff       	call   80100370 <panic>
80107c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c10:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c11:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107c13:	89 e5                	mov    %esp,%ebp
80107c15:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107c18:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c1b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c1e:	e8 0d ef ff ff       	call   80106b30 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107c23:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107c25:	89 c2                	mov    %eax,%edx
80107c27:	83 e2 05             	and    $0x5,%edx
80107c2a:	83 fa 05             	cmp    $0x5,%edx
80107c2d:	75 11                	jne    80107c40 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107c2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107c34:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107c35:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107c3a:	c3                   	ret    
80107c3b:	90                   	nop
80107c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107c40:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107c42:	c9                   	leave  
80107c43:	c3                   	ret    
80107c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107c50 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107c50:	55                   	push   %ebp
80107c51:	89 e5                	mov    %esp,%ebp
80107c53:	57                   	push   %edi
80107c54:	56                   	push   %esi
80107c55:	53                   	push   %ebx
80107c56:	83 ec 1c             	sub    $0x1c,%esp
80107c59:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107c5c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107c62:	85 db                	test   %ebx,%ebx
80107c64:	75 40                	jne    80107ca6 <copyout+0x56>
80107c66:	eb 70                	jmp    80107cd8 <copyout+0x88>
80107c68:	90                   	nop
80107c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107c70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107c73:	89 f1                	mov    %esi,%ecx
80107c75:	29 d1                	sub    %edx,%ecx
80107c77:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107c7d:	39 d9                	cmp    %ebx,%ecx
80107c7f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107c82:	29 f2                	sub    %esi,%edx
80107c84:	83 ec 04             	sub    $0x4,%esp
80107c87:	01 d0                	add    %edx,%eax
80107c89:	51                   	push   %ecx
80107c8a:	57                   	push   %edi
80107c8b:	50                   	push   %eax
80107c8c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107c8f:	e8 9c cd ff ff       	call   80104a30 <memmove>
    len -= n;
    buf += n;
80107c94:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107c97:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80107c9a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107ca0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ca2:	29 cb                	sub    %ecx,%ebx
80107ca4:	74 32                	je     80107cd8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107ca6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ca8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107cab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107cae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107cb4:	56                   	push   %esi
80107cb5:	ff 75 08             	pushl  0x8(%ebp)
80107cb8:	e8 53 ff ff ff       	call   80107c10 <uva2ka>
    if(pa0 == 0)
80107cbd:	83 c4 10             	add    $0x10,%esp
80107cc0:	85 c0                	test   %eax,%eax
80107cc2:	75 ac                	jne    80107c70 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107cc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107ccc:	5b                   	pop    %ebx
80107ccd:	5e                   	pop    %esi
80107cce:	5f                   	pop    %edi
80107ccf:	5d                   	pop    %ebp
80107cd0:	c3                   	ret    
80107cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107cdb:	31 c0                	xor    %eax,%eax
}
80107cdd:	5b                   	pop    %ebx
80107cde:	5e                   	pop    %esi
80107cdf:	5f                   	pop    %edi
80107ce0:	5d                   	pop    %ebp
80107ce1:	c3                   	ret    
