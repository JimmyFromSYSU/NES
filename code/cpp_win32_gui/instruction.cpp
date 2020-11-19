#include "instruction.h"
#include "tool.h"
#include <iostream>

using namespace std;

void INS_DIC::load(const char * file){
	FILE * fp = fopen(file,"r");
	int addr_id,bit_num;
	string name,inf;
	addr_function.resize(INS_SIZE);
	addr_bitnum.resize(INS_SIZE);
	char buffer [1024];
	
	while(fscanf(fp,"%d",&addr_id), addr_id>=0){
		fscanf(fp,"%s %d",buffer,&bit_num);
		name = buffer;
		fscanf(fp,"%s",buffer);
		inf = buffer;


		string blank = "\t";
		
		this->addr_function[addr_id] =  name ;
		this->addr_bitnum[addr_id] = bit_num;
	}

//	puts("Loading instruction's id and address mode information");
	int ins_id;
	while(fscanf(fp,"%s",buffer)){
		if(strcmp(buffer,"END")==0)break;
		name = buffer;

		fscanf(fp,"%d %d",&ins_id,&addr_id);

		ins[ins_id].addr_mode = addr_id;
		ins[ins_id].name = name;
	}

//	puts("Loading instruction function information");
	while(fscanf(fp,"%s",buffer)!=EOF){
		name = buffer;
		fscanf(fp,"%[^\n]s",buffer);
		inf = buffer;
		ins_function[name] = inf;
	}
	fclose(fp);
} 

int INS_DIC::getAddrMode(int ins_id){
	return ins[ins_id].addr_mode;
}

string INS_DIC::getName(int ins_id){
	return ins[ins_id].name.c_str();
}
