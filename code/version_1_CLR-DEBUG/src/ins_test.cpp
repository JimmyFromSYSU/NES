#include "instruction.h"

void solve(const char * fn){
	INS_DIC ins_dic;
	ins_dic.load(fn);
	char buffer[10];
	do{
		printf(">> ");
		scanf("%[^\n]s",buffer);
		char c;scanf("%c",&c);
		if(strcmp(buffer,"exit")==0) break;
		if(strlen(buffer) == 3){
			for(int i = 0;i<3;i++) buffer[i] = toupper(buffer[i]);
			ins_dic.print(buffer);
		}

		else if(strlen(buffer) == 2){
			for(int i = 0;i<2;i++) buffer[i] = toupper(buffer[i]);
			int id = hex2int(buffer);
			ins_dic.print(id);
		}
		else{
			puts("Do nothing");
		}
	}while(1);
}

int main(int argc, char ** argv)
{
	if(argc == 3 && strcmp(argv[1],"-f")==0 ){
		solve(argv[2]);
	}
	else{
		solve("../data/INS_INTRO.txt");
		//printf("usage: %s -f INSRUCTION_DATA_FILE\n",argv[0]);
	}
	return 0;
}
