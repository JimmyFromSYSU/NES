#include "tool.h"
#include "cpu.h"
#include "joystick.h"
joystick j;
ppu p;
cpu c(&p,&j);
int run_cnt=0;
int cnt = 0;
//int pos = 0xC070;
int pos = -1;

bool one(bool f = true){
	cnt++;
	if(f)printf("\n || step %d ||\n",cnt);
	if(c.oneStep(f)==false){
		printf(YELLOW"Step %d error"NONE"\n",cnt);
		c.printM();
		c.printI();
		c.printR();
		return false;
	}
	return true;
}

void print_memory(){
	char buffer[64];
	char cmd;
	printf("1 cpu memory\n");
	printf("2 ppu OAM\n");
	printf("3 ppu Palette\n");
	printf("4 ppu VRAM\n");
	printf("5 ppu VROM\n");
	printf("6 ppu screen\n");
	printf("7 save screen(coe)\n");
	printf("What you want to print? ");
	cmd = getch();
	puts("");
	if(cmd=='1'){
		printf("show memory at (pos offset): ");
		scanf("%s",buffer);
		int n = hex2int(buffer);
		scanf("%s",buffer);
		int a = hex2int(buffer);
		if(a<=16){
			for(int i = n;i< n+a;i++){
				c.printM(i);
			}
		}
		else{
			printf("      00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F\n");
			for(int i = n - n%16;i < n+a;i+=16){
				c.printM16(i);
			}
		}
	}
	//printf("2 ppu VROM\n");
	//printf("3 ppu Palette\n");
	//printf("4 ppu VRAM\n");
	//printf("5 ppu OAM\n");
	else if(cmd=='2'){p.printOAM();}
	else if(cmd=='3'){p.printPalette();}
	else if(cmd=='4'){p.printVRAM();}
	else if(cmd=='5'){p.printVROM();}
	else if(cmd=='6'){
		printf("Which name table: ");
		cmd = getch();
		puts("");
		if(cmd<'0' || cmd > '3') return;
		int t = cmd - '0';
		p.showNameTable(t);
		printf("ok\n");
		p.printBuffer();
	}
	else if(cmd =='7') {
		p.saveImgCoe();
		c.saveMem();
	}
 }

void set_memory(){
	char buffer[64];
	int a,d;
	printf("set memory (pos value(hex)): ");
	scanf("%s",buffer);
	if(buffer[0]=='-') return;
	a = hex2int(buffer);
	scanf("%s",buffer);
	d = hex2int(buffer);
	c.set_mem(a,d);
}

void set_joystick(){
	printf("0 NO, 1 A, 2 B, 3 SELECT, 4 START, 5 UP, 6 DOWN, 7 LEFT, 8 RIGHT\n");
	printf("Choice: ");
	char c = getch();puts("");
	if(c>='0' && c<='8'){
		int b = c-'0';
		j.setButton((JOYSTICK_BUTTON)b,0);
	}
}

void run_silent(int t){
	while(t>1){
		assert(one(false));
		t--;
 	}
	if(t==1) assert(one());
} 

void run(){
	printf("run: ");
	int t;
	scanf("%d",&t);
	run_silent(t);
}

void solve( ){
	if(pos>=0x8000 && pos<=0xFFFF){
		c.setPC(pos);
		printf("start from %X ... ",pos);	
	}
	run_silent(run_cnt);

	while(1){ 
		char t = getch();
		int cmd;
		if(t=='\n')continue;
		if(t=='q')break;
		else if(t=='s'){c.printST();}
//		else if(t=='f'){}
		else if(t>='0' && t<='8'){
			printf("joystick %c\n",t);
			j.setButton((JOYSTICK_BUTTON)(t-'0'),0);
		}
		else if(t=='m'){set_memory();}
		else if(t=='p'){print_memory();}
		else if(t=='i'){c.nmi();puts("Interruption occur!");}
		else if(t=='j'){set_joystick();}
		else if(t=='r'){run();}
		else if(t=='a'){
			c.nmi();puts("Interruption occur!");
			run_silent(100000);
		}
		else if(t=='t'){printf("run to: ");scanf("%d",&cmd);run_silent(cmd-cnt);}
		else if(t=='h'){
			printf("q: quit\n");
			printf("s: show statck\n");
			printf("m: set mem\n");
			printf("p: print mem\n");
			printf("i: interrupt nmi\n");
		}
		else{printf("\n");assert(one());} 
	}
}

int dealOpts(int argc,char ** argv){
	int c;	
	while((c = getopt(argc, argv,"r:s:")) != -1) 
	{
		switch(c) {
			case 'r':
				run_cnt = atoi(optarg);
				break;
			case 's':
				pos = hex2int(optarg);
				break;
			default:
				return false;
				break;
 		}
 	}
	return true;
 }

int main(int argc, char ** argv)
{
	if(! dealOpts(argc, argv))
		return 0;
	solve();
	return 0;
}

