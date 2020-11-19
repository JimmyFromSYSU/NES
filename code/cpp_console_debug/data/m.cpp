#include <stdio.h>

int main()
{
	for(int i = 0;i<0xFFFF;i++){
		printf("%04X: \n",i);
	}
	return 0;
}
