#include "cpu.h"

using namespace std;

#include<map>
#include<iostream>
using namespace std;

bool chekIns(int id){

	if(id == 0)return false;
	//if(id == 0x2C)return false;
	return true;
}


//init
cpu::cpu(ppu * p,joystick * j){
	this->p = p;
	this->j = j;
	mem.set_ppu(p->get_mem());
	mem.set_joystick(j);
	ins_dic.load("data/INS_INTRO.txt");
	
	ins_cnt = 0;
	Status_C = 0;
	Status_Z = 0;
	Status_I = 0;
	Status_D = 0;
	Status_B = 0;
	Status_V = 0;
	Status_S = 0;
	
	INS = 0;
	Data = 0;
	SP = 0;
	ACC =0;
	PC =0;
	X=Y=0;
	PC=0;
	init();
}

// One Step
bool cpu::oneStep(){
	ins_cnt++;
	fetch();
	if (check_jmp() == false){
		address();
		if(analysis()==false)return false;
 	} 
	return true;
}

//calc PC
bool cpu::check_jmp(){
	if(INS == 108){//jmp indirect
		PC = indirect(PC);
	}
	else if(INS == 76){//jmp absolute
		PC = absolute(PC);
	}
	else if(INS == 32)//jsr
	{
		PC+=2;
		pushPC();
		PC-=2;
		PC = absolute(PC);
	}
	else if(INS == 144){//BCC
		PC = Status_C?PC+2:relative(PC);
	}
	else if(INS == 176){//BCS
		PC = Status_C?relative(PC):PC+2;
	}
	else if(INS == 240){//BEQ
		PC = Status_Z?relative(PC):PC+2;
	}
	else if(INS == 48){//BMI
		PC = Status_S?relative(PC):PC+2;
	}
	else if(INS == 208){//BNE
		PC = Status_Z?PC+2:relative(PC);
	}
	else if(INS == 16){//BPL
		PC = Status_S?PC+2:relative(PC);
	}
	else if(INS == 0){//BRK (interrupt)
		PC++;
		pushPC();
		Status_B = 1;
		pushST();
		Status_I = 1;
		
		int tmp1 = mem.get(0xFFFF);
		int tmp2 = mem.get(0xFFFE);
		PC = tmp1*256+tmp2;
	}
	else if(INS == 80){//BVC
		PC = Status_V?PC+2:relative(PC);
	}
	else if(INS == 112){//BVS
		PC = Status_V?relative(PC):PC+2;
	}
	else if(INS_NAME == "RTI"){
		//popST();
		popPC();
	}
	else if(INS_NAME == "RTS"){
		popPC();
		PC++;
	}
	else{
		return false;
	}
	addr = -1;
	return true;
}

//calc Data
void cpu::address(){
	addr = -1;

	if(addr_mode == 3){
		addr = PC+1; 
		PC = PC + 2;
	}
	else if(addr_mode == 4){
		addr = mem.get(PC+1);
		PC = PC + 2;
	}
	else if(addr_mode == 5){
		addr = mem.get(PC+1)+X;
		PC = PC + 2;
	}
	else if(addr_mode == 6){
		addr = mem.get(PC+1)+Y;
		PC = PC + 2;
	}
	else if(addr_mode == 7){
		addr = mem.get(PC+2);
		addr *=256;
		addr += mem.get(PC+1);
		addr += X;
		PC = PC + 3;
	}
	else if(addr_mode == 8){
		addr = mem.get(PC+2);
		addr *=256;
		addr += mem.get(PC+1);
		addr += Y;
		PC = PC + 3;
	}
	else if(addr_mode == 9){
		addr = absolute(PC);
		PC = PC + 3;
	}

	else if(addr_mode == 11){
		addr = mem.get(PC+1);
		addr+=X;
		int tmp1 = mem.get(addr+1);
		int tmp2 = mem.get(addr);
		addr = tmp1*256+tmp2;
		PC =PC + 2;
	}
	else if(addr_mode == 12){
		addr = mem.get(PC+1);
		int tmp1 = mem.get(addr+1);
		int tmp2 = mem.get(addr);
		addr = tmp1*256+tmp2+Y;
		PC = PC + 2;
	}
	else{
		PC = PC + 1;
	}
}


void cpu::load_mem(){
	if(addr>=0 ){
		Data = mem.get(addr);
	}
}

void cpu::store_mem(){
	if(addr>=0){
		mem.set(addr,Data);
	}
}

void cpu::set_mem(int a,unsigned char d){
	mem.set(a,d);
}

void cpu::fetch(){
	INS =  mem.get(PC);
	assert(PC>=0x8000);
	assert(chekIns(INS)); 
	addr_mode = ins_dic.getAddrMode(INS);	
	INS_NAME = ins_dic.getName(INS);
	assert(addr_mode != 0);
}

bool cpu::analysis(){
	//oprate
	if(INS_NAME == "ADC"){
		load_mem();
	    unsigned int temp = Data + ACC + (Status_C ? 1 : 0);
    	setZero(temp & 0xff);	/* This is not valid in decimal mode */
		assert(Status_D==false);
		if (Status_D) {
			if (((ACC & 0xf) + (Data & 0xf) + (Status_C ? 1 : 0)) > 9) temp += 6;
			setSign(temp);
			setOverflow(!((ACC ^ Data) & 0x80) && ((ACC ^ temp) & 0x80));
			if (temp > 0x99) temp += 96;
			setCarry(temp > 0x99);
		} else {
			setSign(temp);
			setOverflow(!((ACC ^ Data) & 0x80) && ((ACC ^ temp) & 0x80));
			setCarry(temp > 0xff);
		}
		ACC = ( temp & 0xFF);
	}
	else if(INS_NAME == "SBC"){
		load_mem();
	    unsigned int temp = ACC - Data - (Status_C ? 0 : 1);
		setSign(temp);
		setZero(temp & 0xff);	/* Sign and Zero are invalid in decimal mode */
		setOverflow(((ACC ^ temp) & 0x80) && ((ACC ^ Data) & 0x80));
		assert(Status_D==false);
		if (Status_D) {
			if ( ((ACC & 0xf) - (Status_C ? 0 : 1)) < (Data & 0xf))  temp -= 6;
			if (temp > 0x99) temp -= 0x60;
		}
		setCarry(temp < 0x100);
		ACC = (temp & 0xff);
	}
	else if(INS_NAME == "BIT"){
		load_mem();
		setSign(Data);
	    setOverflow(0x40 & Data);	/* Copy bit 6 to OVERFLOW flag. */
	    setZero(Data & ACC);
	}
	//BIN
 	else if(INS_NAME=="AND"){
		load_mem();
		ACC = ACC & Data;
		setSign(ACC);
		setZero(ACC);
	} 
	else if(INS_NAME == "EOR"){
		load_mem();
		ACC =ACC ^ Data;
		setSign(ACC);
		setZero(ACC);
	}
	else  if(INS_NAME == "ORA"){
		load_mem();
		ACC = ACC | Data;
		setSign(ACC);
		setZero(ACC);
	}
	else if(INS_NAME == "ASL"){
		load_mem();
		unsigned char * op;
		if(addr_mode == 2)op = &ACC;
		else op = &Data;
		setCarry((*op) & 0x80);
		(*op) <<= 1;
		setSign(*op);
		setZero(*op);
		store_mem();
	} 
	else if(INS_NAME == "LSR"){
		load_mem();
		unsigned char * op;
		if(addr_mode == 2)op = &ACC;
		else op = &Data;
		setCarry((*op) & 0x01);
		(*op) >>= 1;
		setSign(*op);
		setZero(*op);
		store_mem();
	}
	else  if(INS_NAME == "ROL"){
		load_mem();
		bool c = Status_C;
		unsigned char * op;
		if(addr_mode == 2)op = &ACC;
		else op = &Data;
		setCarry((*op) & 0x80);
		(*op) <<= 1;
		(*op) |= c;
		setSign(*op);
		setZero(*op);
		store_mem();
	}
	else if(INS_NAME == "ROR"){
		load_mem();
		bool c = Status_C;
		unsigned char * op;
		if(addr_mode == 2)op = &ACC;
		else op = &Data;
		setCarry((*op) & 0x01);
		(*op) >>= 1;
		(*op) |= c*0x80;
		setSign(*op);
		setZero(*op);
		store_mem();
	}
	//*/
	
	//IN DE
	else if(INS_NAME=="DEC"){
		load_mem();
		Data--;
		setSign(Data);
		setZero(Data);
		store_mem();
	}
	else if(INS_NAME=="DEX"){
		X--;
		setSign(X);
		setZero(X);
	}
	else if(INS_NAME=="DEY"){
		Y--;
		setSign(Y);
		setZero(Y);
	}
	else if(INS_NAME=="INC"){
		load_mem();
		Data++;
		setSign(Data);
		setZero(Data);
		store_mem();
	}
	else if(INS_NAME=="INX"){
		X++;
		setSign(X);
		setZero(X);
	}
	else if(INS_NAME=="INY"){
		Y++;
		setSign(Y);
		setZero(Y);
	}
	//stack
	else if(INS_NAME=="PHP"){pushST();}
	else if(INS_NAME=="PHA"){push(ACC);}
	else if(INS_NAME=="PLP"){popST();}
	else if(INS_NAME=="PLA"){ACC=pop();}
	//flag
	else if(INS_NAME=="SEI"){
		Status_I = 1;
	}
	else if(INS_NAME=="SED"){
		Status_D = 1;
	}
	else if(INS_NAME=="SEC"){
		Status_C = 1;
	}
	else if(INS_NAME=="CLD"){
		Status_D = 0;
	}
	else if(INS_NAME=="CLI"){
		Status_I = 0;
	}
	else if(INS_NAME=="CLC"){
		Status_C = 0;
	}
	else if(INS_NAME=="CLV"){
		Status_V = 0;
	}
	//trans
	else if(INS_NAME=="LDA"){
		load_mem();
		setZero(Data);
		setSign(Data);
		ACC = Data;
	}
	else if(INS_NAME=="LDX"){
		load_mem();
		setZero(Data);
		setSign(Data);
		X = Data;
	}
	else if(INS_NAME=="LDY"){
		load_mem();
		setZero(Data);
		setSign(Data);
		Y = Data;
	}
	else if(INS_NAME=="STA"){
		Data = ACC;
		store_mem();
	}
	else if(INS_NAME=="STX"){
		Data = X;
		store_mem();
	}
	else if(INS_NAME=="STY"){
		Data = Y;
		store_mem();
	}
	else if(INS_NAME=="TAX"){
		X = ACC;
	//	setSign(X);
	//	setZero(X);
	}
	else if(INS_NAME=="TAY"){
		Y = ACC;
	//	setSign(Y);
	//	setZero(Y);
	}
	else if(INS_NAME=="TSX"){
		X = SP;
	//	setSign(X);
	//	setZero(X);
	}
	else if(INS_NAME=="TXA"){
		ACC = X;
	//	setSign(ACC);
	//	setZero(ACC);
	}
	else if(INS_NAME=="TXS"){
		SP = X;
	}
	else if(INS_NAME=="TYA"){
		ACC = Y;
	//	setSign(ACC);
	//	setZero(ACC);
	}
	//CMP
	else if (INS_NAME == "CMP"){//
		load_mem();
		unsigned int tmp = ACC-Data;
		setSign(tmp);
		setZero(tmp & 0xFF);
		setCarry(tmp < 0x100);
	}
	else if (INS_NAME == "CPX"){
		load_mem();
		unsigned int tmp = X-Data;
		setSign(tmp);
		setZero(tmp & 0xFF);
		setCarry(tmp < 0x100);
	}
	else if (INS_NAME == "CPY"){
		load_mem();
		unsigned int tmp = Y-Data;
		setSign(tmp);
		setZero(tmp & 0xFF);
		setCarry(tmp < 0x100);
	}
	else if(INS_NAME == "NOP"){}
	else{
		printf("" YELLOW "Not impliment %s" NONE"\n",INS_NAME.c_str());
		return false;
	}

	return true;
} 
 

