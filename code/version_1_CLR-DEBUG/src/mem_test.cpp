#include "tool.h"
#include "memory_manager.h"


CPU_MEMORY_MANAGER cpu_mem;


void solve(){
	char buffer [1024];
	do{
		printf(">> ");
		scanf("%[^\n]s",buffer);
		char c; scanf("%c",&c);
		if(strcmp(buffer,"exit")==0)break;
		for(int i =0;buffer[i]!='\0';i++)buffer[i] = toupper(buffer[i]);
		int pos = hex2int(buffer);
		printf("mem[%d]=%d\n",pos,cpu_mem.get(pos,1));
	}
	while(1);
}

int main()
{
	solve();
	return 0;
}
