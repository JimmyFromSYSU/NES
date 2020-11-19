#include "cpu.h"
using namespace std;

//init
cpu::cpu(ppu * p,joystick * j){
	this->p = p;
	this->j = j;
	mem.set_ppu(p->get_mem());
	mem.set_joystick(j);

	ins_dic.load("../data/INS_INTRO.txt");
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
	nmi_cnt = 0;
	init();
}

void cpu::init(){
	mem.set(0x2002,0x80);
	//printf("0x2002 = %X\n",mem.get(0x2002));
	//mem.set(0x2002,0x80);
	reset();	
}


//interuption
void cpu::reset(){
	PC = mem.get(0xFFFD);
	PC*=256;
	PC+= mem.get(0xFFFC);
	SP = 0xFF;
	in_nmi = false;
}

void cpu::nmi(){
	unsigned char t = mem.get(0x2000);
	if( (t>>7) == 0) return;
	t = mem.get(0x2002);
	mem.set(0x2002,t|0x80);
	pushPC();
	PC = mem.get(0xFFFB);
	PC*=256;
	PC+= mem.get(0xFFFA);
//	pushST();
	nmi_cnt++;
	in_nmi = true;
//	printf(""LIGHT_RED"-------------------- interupt --------------------"NONE"\n");
 }

//set status register
void cpu::setSign(unsigned char t){
	Status_S = !((t&(1<<7))==0);
}

void cpu::setZero(unsigned char t){
	Status_Z = (t==0);
}

void cpu::setCarry(unsigned char t){
	Status_C = (t!=0);
}

void cpu::setOverflow(unsigned char t){
	if(t) Status_V = 1;else Status_V=0;
}

void cpu::setPC(unsigned short p){
	PC=p;
}

//print information
void cpu::printM(){
	printf("----- Mem -----\n");
	for(int i = -5;i<5;i++){
		if(i==0){printf(LIGHT_GREEN"");}
		int t = mem.get(PC+i,0);
		printf("%X : %X\n",PC+i,t);
		if(i==0){printf(NONE"");}
	}
}

void cpu::printM(int pos){
	int t = mem.get(pos,0);
	printf("%X : %X\n",pos,t);
}

void cpu::printM16(int pos){
	mem.print16(pos);
	/*
	printf("%4X: ",pos);
	for(int i = 0;i<16;i++){
		int d = mem.get(pos+i,0);
		if(d==0)printf(" . ");
		else printf("%2X ",d);
	}puts("");
	 */
}

void cpu::printI(){
	printf("----- Instruction -----\n");
	printf("execute "LIGHT_RED "%s" NONE"(%Xh):",INS_NAME.c_str(),INS);
	//printHex(INS);printf("h):");
	//ins_dic.printAddrMode(addr_mode);
	ins_dic.print(INS);
}

void cpu::printST(){
	printf("----- Stack bottom-----\n");
	for(int i = -10;i<10;i++){ 
		if(SP+i>=0 && SP+i<0x8000){
			printf("%X : %X",0x100  + SP+i,mem.get(0x100 + SP+i) );
			if(i==0) printf(" <--- SP\n");
			else puts("");
		}
	}
}

void cpu::printR(){
	printf("----- Register -----\n");
	printf("ACC=%X  ",ACC);
	printf("X=%X  ",X);
	printf("Y=%X  ",Y);
	//printf("SP=%d(",SP);printHex(SP);printf("h) ");
	//printf("PC=%d(",PC);printHex(PC);printf("h) ");
	printf("SP=%Xh ",SP);
	printf("PC=%Xh ",PC);

	printf("Data=%d ",Data);
	printBin(Data);
	printf(" %X\n",Data);
	//printHex(Data);
	//puts("");

	printf("Carry=%s  ",Status_C?"Yes":"No");
	printf("Zero=%s  ",Status_Z?"Yes":"No");
	printf("Interrupt=%s  ",Status_I?"Disable":"Enable");
	printf("Decimal=%s  ",Status_D?"Yes":"No");
	printf("B=%d  ",Status_B);
	printf("Overflow=%s  ",Status_V?"Yes":"No");
	printf("Sign=%s\n",Status_S?"Negative":"Postive");
	printf("ST = %d%d%d%d%d%d%d%d\n",	Status_S,Status_V,0,Status_B,
										Status_D,Status_I,Status_Z,Status_C);
	printf("ST= %X\n",(Status_S<<7)+(Status_V<<6)+
			(Status_B << 4) + (Status_D<<3) + (Status_I<<2) 
			+ (Status_Z<<1) + (Status_C));
}

//stack operation
void cpu::push(unsigned char t){
	mem.set((0x100+(SP)),t);
	SP--;
}

unsigned char cpu::pop(){
	unsigned char d =  mem.get(0x100 + (++SP));
	//mem.set(SP+1,0);
	return d;
}

	void cpu::pushPC(){
	push((PC >> 8) & 0xff);
	push(PC & 0xff);
}

void cpu::popPC(){
	int t1 = pop();
	int t2 = pop();
	next_PC=t2*256+t1;
}

void cpu::pushST(){
	unsigned char t = 0;
	t |= (1<<0)*Status_C;
	t |= (1<<1)*Status_Z;
	t |= (1<<2)*Status_I;
	t |= (1<<3)*Status_D;
	t |= (1<<4)*Status_B;
	t |= (1<<6)*Status_V;
	t |= (1<<7)*Status_S;
	push(t);
}

void cpu::popST(){
	unsigned char t = pop();
	Status_C = !((t&(1<<0))==0);
	Status_Z = !((t&(1<<1))==0);
	Status_I = !((t&(1<<2))==0);
	Status_D = !((t&(1<<3))==0);
	Status_B = !((t&(1<<4))==0);
	Status_V = !((t&(1<<6))==0);
	Status_S = !((t&(1<<7))==0);
}

//address operation
int cpu::absolute(int pc){
	int tmp1 = mem.get(pc+2);
	int tmp2 = mem.get(pc+1);
	return tmp1 * 256 + tmp2;
}

int cpu::indirect(int pc){
	pc = absolute(pc)-1;
	return absolute(pc);
}

int cpu::relative(int pc){
	unsigned char d = mem.get(pc+1);
	pc+=2;
	if((d&0x80)==0) pc+=d;
	else {
		pc+= 0xFF00+d;
	}
	return pc;
}

// One Step
bool cpu::oneStep(bool f){
	ins_cnt++;
	inf_flag = f;
	
	fetch();
	//hook	
/*	if(addr_mode == 6) inf_flag = 1;// z_y
	//if(addr_mode == 8) inf_flag = 1;// a_y
	if(addr_mode == 10) inf_flag = 1;// in
	if(addr_mode == 11) inf_flag = 1;//in_x

//	if(INS_NAME == "SBC") inf_flag = 1; 
	if(INS_NAME == "ROL") inf_flag = 1; 
//	if(INS_NAME == "CPY") inf_flag = 1; 
	if(INS_NAME == "BCS") inf_flag = 1; 
	if(INS_NAME == "BVC") inf_flag = 1; 
	if(INS_NAME == "BVS") inf_flag = 1; 
	if(INS_NAME == "CLI") inf_flag = 1; 
	if(INS_NAME == "CLV") inf_flag = 1; 
	if(INS_NAME == "SED") inf_flag = 1; 
//	if(INS_NAME == "SEC") inf_flag = 1; 
	if(INS_NAME == "TSX") inf_flag = 1; 
	//
//	if(INS == 108){//jmp indirect
//		inf_flag = 1;
//	}
*/
 	if (check_jmp() == false){
		address();
		if(addr == 0x2006 || addr == 0x2007){
			inf_flag = 1;
		}
		if(analysis()==false)return false;
 	}   
	if(inf_flag) printI();

	update();
 	if(inf_flag){
	//	printM();
		printR();
		printf("++++++++++++++++++++++++++++++++++ end %d\n",ins_cnt);
	}

	
	 if(INS==0x40){
		printf(""LIGHT_RED"-------------------- RTI -------------------- step %d"NONE"\n",ins_cnt);
	}

	return true;
}

//calc PC
 bool cpu::check_jmp(){
	if(INS == 108){//jmp indirect
		next_PC = indirect(PC);
	}
	else if(INS == 76){//jmp absolute
		next_PC = absolute(PC);
	}
	else if(INS == 32)//jsr
	{
		next_PC = absolute(PC);
		PC+=2;
		pushPC();
		PC-=2;
	}
	else if(INS == 144){//BCC
		next_PC = Status_C?PC+2:relative(PC);
	}
	else if(INS == 176){//BCS
		next_PC = Status_C?relative(PC):PC+2;
	}
	else if(INS == 240){//BEQ
		next_PC = Status_Z?relative(PC):PC+2;
	}
	else if(INS == 48){//BMI
		next_PC = Status_S?relative(PC):PC+2;
	}
	else if(INS == 208){//BNE
		next_PC = Status_Z?PC+2:relative(PC);
	}
	else if(INS == 16){//BPL
		next_PC = Status_S?PC+2:relative(PC);
	}
	else if(INS == 0){//BRK (interrupt)
		PC++;
		pushPC();
		PC--;
		Status_B = 1;
		pushST();
		Status_I = 1;
		int tmp1 = mem.get(0xFFFF);
		int tmp2 = mem.get(0xFFFE);
		next_PC = tmp1*256+tmp2;
	}
	else if(INS == 80){//BVC
		next_PC = Status_V?PC+2:relative(PC);
	}
	else if(INS == 112){//BVS
		next_PC = Status_V?relative(PC):PC+2;
	
	}
	else if(INS_NAME == "RTI"){
	//	popST();
		popPC();
		in_nmi = false;
 	}
	else if(INS_NAME == "RTS"){
		popPC();
		next_PC++;
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
		next_PC = PC + 2;
	}
	else if(addr_mode == 4){
		addr = mem.get(PC+1);
		next_PC = PC + 2;
	}
	else if(addr_mode == 5){
		addr = mem.get(PC+1)+X;
		next_PC = PC + 2;
	}
	else if(addr_mode == 6){
		addr = mem.get(PC+1)+Y;
		next_PC = PC + 2;
	}
	else if(addr_mode == 7){
		addr = mem.get(PC+2);
		addr *=256;
		addr += mem.get(PC+1);
		addr += X;
		next_PC = PC + 3;
	}
	else if(addr_mode == 8){
		addr = mem.get(PC+2);
		addr *=256;
		addr += mem.get(PC+1);
		addr += Y;
		next_PC = PC + 3;
	}
	else if(addr_mode == 9){
		addr = absolute(PC);
		next_PC = PC + 3;
	}
	//else if(addr_mode == 10){
	//	addr = mem.get(PC+2);
	//	addr *=256;
	//	addr += mem.get(PC+1);
	//	next_PC =PC + 3;
	//}
	else if(addr_mode == 11){
		addr = mem.get(PC+1);
		addr+=X;
		int tmp1 = mem.get(addr+1);
		int tmp2 = mem.get(addr);
		addr = tmp1*256+tmp2;
		next_PC =PC + 2;
	}
	else if(addr_mode == 12){
		addr = mem.get(PC+1);
		int tmp1 = mem.get(addr+1);
		int tmp2 = mem.get(addr);
		addr = tmp1*256+tmp2+Y;
		next_PC = PC + 2;
	}
	else{
		next_PC = PC + 1;
	}
} 


// Load and Store mem
void cpu::check_addr(int a){
	// GREEN	Data
	// BLUE		Addr
	// RED		Ctrl
	// PURPLE	Status
	if(a == 0x2000){printf(" <--- "LIGHT_RED"PPU Ctrl reg"NONE);}
	else if(a == 0x2001){printf(" <--- "LIGHT_RED"PPU Mask reg"NONE);}
	else if(a == 0x2002){printf(" <--- "LIGHT_PURPLE"PPU Status reg"NONE);}
	else if(a == 0x2003){printf(" <--- "LIGHT_BLUE"PPU SPR-RAM(OAM) Addr reg"NONE);}
	else if(a == 0x2004){printf(" <--- "LIGHT_GREEN"PPU SPR-RAM(OAM) Data reg"NONE);}
	else if(a == 0x2005){printf(" <--- "LIGHT_RED"PPU SCROLL reg"NONE);}
	else if(a == 0x2006){printf(" <--- "LIGHT_BLUE"PPU VRAM Addr reg"NONE);}
	else if(a == 0x2007){printf(" <--- "LIGHT_GREEN"PPU VRAM Data reg"NONE);}
	else if(a == 0x4014){printf(" <--- "LIGHT_BLUE"SPRITE(OAM) DMA reg"NONE);}
	else if(a >= 0x4000 && a <=0x4013)
						{printf(" <--- "YELLOW"APU reg"NONE);}
	else if(a == 0x4015){printf(" <--- "YELLOW"Sound Channel reg"NONE);}
	else if(a == 0x4016){printf(" <--- "YELLOW"Joystick reg 1"NONE);}
	else if(a == 0x4017){printf(" <--- "YELLOW"Joystick reg 2"NONE);}
	else if(a>=0x200 && a<= 0x2FF)	
						{printf(" <--- "LIGHT_GREEN"SPRITE data(send to OAM)"NONE);}
}

void cpu::check_addr(){
	check_addr(addr);
}

void cpu::load_mem(){
	if(addr>=0 ){
		Data = mem.get(addr);
		if(inf_flag){
		//	printf("----- Mem IO get -----\n");
			printf("get mem[%X] = %X",addr,Data);
			check_addr();
			printf("\n");
		}
	}
}

void cpu::store_mem(){
	if(addr>=0){
		//if(in_nmi == false && addr == 0x2007){}// return;
		//else
		mem.set(addr,Data);
		if(inf_flag){
		//	printf("----- Mem IO set -----\n");
			printf("set mem[%X] = %X",addr,Data);
			check_addr();
			printf("\n");
		}
	}
}

void cpu::set_mem(int a,unsigned char d){
	mem.set(a,d);
	printf("set mem[%Xh] = %Xh",a,d);
	check_addr(a);
	puts("");
}

//
void cpu::update(){
//	store_mem();
	PC = next_PC;
}

void cpu::fetch(){
	INS =  mem.get(PC,0);
	assert(PC>=0x8000);
	addr_mode = ins_dic.getAddrMode(INS);	
	INS_NAME = ins_dic.getName(INS);
	if(addr_mode == 0){
		printf("INS_ID : %X\n",INS);
		printf("INS_NAME : %s\n",INS_NAME.c_str());
	}
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
//		setSign(X);
//		setZero(X);
	}
	else if(INS_NAME=="TAY"){
		Y = ACC;
//		setSign(Y);
//		setZero(Y);
	}
	else if(INS_NAME=="TSX"){
		X = SP;
		//setSign(X);
		//setZero(X);
	}
	else if(INS_NAME=="TXA"){
		ACC = X;
		//setSign(ACC);
		//setZero(ACC);
	}
	else if(INS_NAME=="TXS"){
		SP = X;
	}
	else if(INS_NAME=="TYA"){
		ACC = Y;
//		setSign(ACC);
//		setZero(ACC);
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
	//EXPAND 
/*	
	else if(INS_NAME == "DCP"){ // DEC + CMP
		//printf("hello %X\n",addr);
		load_mem();
		Data--;
		unsigned int tmp = ACC-Data;
		setSign(tmp);
		setZero(tmp & 0xFF);
		setCarry(tmp < 0x100);
		store_mem(); //???
		//printf("end\n");
	}
	else if(INS_NAME == "ALR"){ // AND + LSR
		load_mem();
		ACC = ACC & Data;
		setCarry(ACC & 0x01);
		ACC >>= 1;
		setSign(ACC);
		setZero(ACC);
		//store_mem(); //???
	}
	else if(INS_NAME == "RLA") { //Rotate Left then And
		load_mem();
		bool c = Status_C;
		setCarry((Data) & 0x80);
		Data <<= 1;
		Data |= c;
		ACC = ACC & Data;
		setSign(ACC);
		setZero(ACC);
		//setSign(Data);
		//setZero(Data);
		store_mem();  //???
		
	}
	else if(INS_NAME == "TAS") {
		SP = ACC & X;
		Data = SP & ((addr >> 8) + 1);
		store_mem();
	}
	else if(INS_NAME == "XAA"){///???
		load_mem();
		unsigned char result = (ACC & X & Data);
	    setSign(result);
		setZero(result);
		ACC = result;
		//ACC &= X & (Data | 0xEF); ??
	}
	else if(INS_NAME == "SHY"){
		Data = Y & ((addr >> 8) + 1);
		store_mem();
	}
	//else if(INS_NAME == "SAX"){}
	//else if(INS_NAME == "ANC"){}
	else if(INS_NAME == "SLO"){
		load_mem();
		setCarry(Data & 0x80);
		Data <<= 1;
		ACC |= Data;
		setZero(ACC);
		setSign(ACC);
		store_mem();
	}
	//else if(INS_NAME == "SRE"){}
	//else if(INS_NAME == "RRA"){}
	//else if(INS_NAME == "AHX"){}
	else if(INS_NAME == "LAX"){
		load_mem();
		ACC = X = Data;
		setSign(ACC);
		setZero(ACC);
	}
	else if(INS_NAME == "LAS"){
		load_mem();
		ACC = X = (SP &= Data);
		setSign(ACC);
		setZero(ACC);
	}
	//else if(INS_NAME == "AXS"){}
	//else if(INS_NAME == "ISC"){}
*/
	else{
		printf("" YELLOW "Not impliment %s" NONE"\n",INS_NAME.c_str());
		return false;
	}

	return true;
 } 
 

