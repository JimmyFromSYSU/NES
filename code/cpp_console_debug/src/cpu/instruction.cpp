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
//	puts("Loading address mode information");
	while(fscanf(fp,"%d",&addr_id), addr_id>=0){
		fscanf(fp,"%s %d",buffer,&bit_num);
		name = buffer;
		fscanf(fp,"%s",buffer);
		inf = buffer;

		//cout << bit_num <<" "<< name << " " << addr_id <<" "<< inf<< endl;
		//cin >> name >> bit_num >> inf;
		string blank = "\t";
		//this->addr_function[addr_id] =  name +blank+ inf;
		this->addr_function[addr_id] =  name ;
		this->addr_bitnum[addr_id] = bit_num;
	}

//	puts("Loading instruction's id and address mode information");
	int ins_id;
	while(fscanf(fp,"%s",buffer)){
		if(strcmp(buffer,"END")==0)break;
		name = buffer;
		//cin >> ins_id >> addr_id;
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

void INS_DIC::print(int id){
	if(id>INS_SIZE || id < 0){
		printf("%d, out of index, should < %d and  > 0\n",id,INS_SIZE);
		return;
	}

	string ins_str  = ins[id].name;

	//printHex(id);
	//printf("h-%-3d ",id);
	
	cout << ins_str << ": ";
	cout << ins_function[ins_str] << ". ";
	
	int aid = ins[id].addr_mode;
	printAddrMode(aid);puts("");
} 

void INS_DIC::printAddrMode(int id){
	//printf("(%2d) ",id);
	printf(LIGHT_RED" %d"NONE" byte ins ",addr_bitnum[id]+1);	
	cout << "(" << addr_function[id] << " "<< id << ").";
}

void INS_DIC::print(const char *  name){
	string a_str = name;
	if(ins_function.count(a_str)){
		string state = ins_function[a_str];
		printf("%s: ",name);
		cout << state << endl;
		for(int i = 0;i<INS_SIZE;i++){
			if(strcmp(ins[i].name.c_str() , name) == 0){
				printf("%X:",i);
				printAddrMode(ins[i].addr_mode);puts("");
			}
		}
	}
	else{
		puts("No such command");
	}
}


int INS_DIC::getAddrMode(int ins_id){
	return ins[ins_id].addr_mode;
}

string INS_DIC::getName(int ins_id){
	return ins[ins_id].name.c_str();
}
