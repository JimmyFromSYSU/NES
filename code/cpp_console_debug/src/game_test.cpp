#include <pthread.h>
#include "tool.h"
#include "cpu.h"
#include "joystick.h"
//#include  <boost/python.hpp>
//#include <gtk/gtk.h>
joystick j;
ppu p;
cpu c(&p,&j);
int f_cnt = 0;


void printInf(){
} 

bool one(bool f = true){
	if(c.oneStep(false) == false){
		printInf();
		return false;
 	}
	return true;
}

void set_joystick(){
	printf("0 NO, 1 A, 2 B, 3 SELECT, 4 START, 5 UP, 6 DOWN, 7 LEFT, 8 RIGHT\n");
	printf("Choice: ");
	char c = getche();puts("");
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
	if(t==1) assert(one(false));
}

void* run_thread(void* arg)
{	
	c.nmi();
	run_silent(70000);
	f_cnt++;
	return 0;
}

void* scanf_thread(void* arg)
{
	while(true){
		char cmd = getch();
		int b = cmd-'0';

		j.setButton( (JOYSTICK_BUTTON)b , 0);
		sleep(1);
		j.setButton( (JOYSTICK_BUTTON)0 , 0);
	}
	return 0;
}

void solve( ){
	pthread_t tid;	
	pthread_t sid;

	pthread_create(&sid,NULL,scanf_thread,NULL);

	while(true){ 
		//j.setButton((JOYSTICK_BUTTON)4,0);
		c.nmi();
		run_silent(70000);
		f_cnt++;
	//	pthread_create(&tid,NULL,run_thread,NULL);
		if(f_cnt%5==0){
			p.showNameTable(-1);
			p.printBuffer();
		}
			//		}sleep(1);
	}
}

int dealOpts(int argc,char ** argv){
	int c;	
	while((c = getopt(argc, argv,"r:s:")) != -1) 
	{
		switch(c) {
			case 'r':
				//run_cnt = atoi(optarg);
				break;
			case 's':
				//pos = hex2int(optarg);
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

