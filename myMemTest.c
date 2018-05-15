#include "types.h"
#include "user.h"
#include "fcntl.h"

int
main(void)
{
	int array [1048576];
	array[0]=4;
	array[8000]=21;
	array[400000]=array[0]+array[8000];
	exit();
}