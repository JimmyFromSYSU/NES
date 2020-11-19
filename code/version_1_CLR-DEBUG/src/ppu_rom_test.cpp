#include "tool.h"
#include "memory_map.h"
ROM r;
char buffer[1024];
void printP(unsigned char a,unsigned char b){
	if(a==0 && b==0){
		printf(". ");
	}
	else if(a!=0 && b==0){
		printf(LIGHT_RED"# "NONE);
	}
	else if(a==0 && b!=0){
		printf(LIGHT_GREEN"# "NONE);
	}
	else{
		printf(LIGHT_BLUE"# "NONE);
		//printf("# ");
	}

}

void printLine(unsigned char a,unsigned char b,unsigned char c,unsigned char d){	
	for(int i = 7;i>=0;i--){
		printP(a&(1<<i),b&(1<<i));
	}
	for(int i = 7;i>=0;i--){
		printP(c&(1<<i),d&(1<<i));
	}
	puts("");
}

void print(int pos){
	pos*=64;
	for(int i = 0;i<8;i++){
		printLine(r.get(pos+i),r.get(pos+i+8),
				r.get(pos+i+32),r.get(pos+i+32+8));
	}
	for(int i = 0;i<8;i++){
		printLine(r.get(pos+i+16),r.get(pos+i+16+8),
				r.get(pos+i+48),r.get(pos+i+48+8));
	}
}

 void solve(){
	r.load("../data/rom/vrom.bin");
 /*	for(int i =0;i<200;i++){
		if(i*64 >= 0x2000)break;
		printf("fig %d\n",i);
		print(i);
		//puts("");
	}*/

	do{
		printf(">> ");
		//scanf("%[^\n]s",buffer);
		int c ;
		scanf("%d",&c);
		if(c<0) break;
		if(c*64 >= 0x2000){
			printf("Out of index!\n");
			continue;
		}
		print(c);
		//char c;scanf("%c",&c);
		//if(strcmp(buffer,"q")==0){break;}
		//int d = r.get(hex2int(buffer));
		//printf("%X\n",d);
		
	}while(1);
}


int main()
{ 
	solve();
	return 0;
}


