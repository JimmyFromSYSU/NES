#include "tool.h"
#include <stdio.h>
//#include <termios.h>
//#include <unistd.h>
//#include <stdarg.h>
#include <ctype.h>

//char getch(){
//	struct termios oldt,newt;
//	int ch;
//	tcgetattr( STDIN_FILENO, &oldt );
//	newt = oldt;
//	newt.c_lflag &= ~( ICANON | ECHO );
//	tcsetattr( STDIN_FILENO, TCSANOW, &newt );
//	ch = getchar();
//	tcsetattr( STDIN_FILENO, TCSANOW, &oldt );
//	return ch;
//}
//
//char getche(){
//	char c = getch();
//	printf("%c",c);
//	return c;
//}

int hex2int(char * t){
	int ret = 0;
	for(int i = 0;t[i]!='\0';i++){
		t[i] = toupper(t[i]);
		ret *= 16;
		if(t[i] >= '0' && t[i] <= '9'){
			ret += t[i] - '0';
		}
		else{
			ret += t[i] - 'A' + 10;
		}
	}
	return ret;
}

void printHex(int  t, int min_size)
{
	char b[32]={0};
	int cnt = 0;
	int h;
	while(t){
		h = t%16;
		t/=16;
		if(h>=10) b[cnt++] = 'A' + h - 10;
		else b[cnt++] = '0' + h;
	}
	if(cnt < min_size){
		cnt = min_size;
	}
	if(cnt==0)printf("0");
	else{
		for(int i = 0;i<cnt;i++){
			printf("%c",b[cnt-1-i]);
		}
	}
}



void printBin(int t,int min_size){
	char b[32];
	for(int i = 0;i<32;i++) b[i] = '0';
	int cnt = 0;
	int h;
	while(t){
		b[cnt++] =  t%2+'0';
		t/=2;
	}
	if(cnt < min_size){
		cnt = min_size;
	} 
	//printf("(%d)",cnt);
	if(cnt==0)printf("0");
	else{
		for(int i = 0;i<cnt;i++){
			printf("%c",b[cnt-1-i]);
	 	}
	} 
}

//void Red(const char *msg, ...){
//	char Buffer[1024];
//	va_list ArgList;
//	va_start (ArgList, msg);
//	vsprintf (Buffer, msg, ArgList);
//	va_end (ArgList);
//	printf("" LIGHT_RED"");
//	printf ("%s", Buffer);
//	printf(NONE "\n");
//}
//
//void Green(const char *msg, ...){
//	char Buffer[1024];
//	va_list ArgList;
//	va_start (ArgList, msg);
//	vsprintf (Buffer, msg, ArgList);
//	va_end (ArgList);
//	printf("" LIGHT_GREEN"");
//	printf ("%s", Buffer);
//	printf(NONE "\n");
//}
//
//void Blue(const char *msg, ...){
//	char Buffer[1024];
//	va_list ArgList;
//	va_start (ArgList, msg);
//	vsprintf (Buffer, msg, ArgList);
//	va_end (ArgList);
//	printf("" LIGHT_BLUE"");
//	printf ("%s", Buffer);
//	printf(NONE "\n");
//}
//



