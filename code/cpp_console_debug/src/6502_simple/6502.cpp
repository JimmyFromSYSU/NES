#include "config.h"

////Register
DATA A				= 0;
DATA X				= 0;
DATA Y				= 0;
DATA SP				= 0;
DATA SR				= 0;
ADDR PC				= 0;

///MEMORY
DATA CPU_MEMORY		[CPU_MEMORY_SIZE] = {0};
DATA PPU_MEMORY		[PPU_MEMORY_SIZE] = {0};

///PPU Register
DATA& PPU_CTRL		= CPU_MEMORY[0x2000];
DATA& PPU_MASK		= CPU_MEMORY[0x2001];
DATA& PPU_STATUS	= CPU_MEMORY[0x2002];

DATA& PPU_OAM_ADDR	= CPU_MEMORY[0x2003];	//access op
DATA& PPU_OAM_DATA	= CPU_MEMORY[0x2004];	//access op

DATA& PPU_SCROLL	= CPU_MEMORY[0x2005];

DATA& PPU_VRAM_ADDR	= CPU_MEMORY[0x2006];	//access op
DATA& PPU_VRAM_DATA	= CPU_MEMORY[0x2007];	//access op

///DMA Register
DATA DMA_ADDR		= 0;					//access op

///Joystick
DATA JS[2]			= {0};					//access op

///APU Register

////Memory
DATA* STACK		=		CPU_MEMORY + 0x100;
//DATA VROM;
DATA* VRAM		=		PPU_MEMORY + VROM_SIZE;
DATA OAM				[OAM_SIZE]			=		{0};
DATA* PALETTE	=		PPU_MEMORY + 0x3F00;

/*
enum ADDR_MODE {
	None,										//0			0
	Immediate, Relative,						//1			1, 2
	DirectX, DirectY, Direct,					//1			3, 4, 5
	IndirectX, IndirectY,						//1			6, 7
	Indirect, AbsoluteX, AbsoluteY,Absolute		//2			8, 9, 10, 11
};
*/

///Instruction
unsigned char INSTRUCTION_ADDR_MODE	[INSTRUCTION_SET_SIZE]=
{
	 0 ,6,1,6,5,5,5,5,0,1,0,1,11,11,11,11,2,7,0,7,3,3,3,3,0,10,0,10,9,9, 9, 9, 
	 11,6,1,6,5,5,5,5,0,1,0,1,11,11,11,11,2,7,0,7,3,3,3,3,0,10,0,10,9,9, 9, 9, 
	 0 ,6,1,6,5,5,5,5,0,1,0,1,11,11,11,11,2,7,0,7,3,3,3,3,0,10,0,10,9,9, 9, 9, 
	 0 ,6,1,6,5,5,5,5,0,1,0,1, 8,11,11,11,2,7,0,7,3,3,3,3,0,10,0,10,9,9, 9, 9, 
	 1 ,6,1,6,5,5,5,5,0,1,0,1,11,11,11,11,2,7,0,7,3,3,4,4,0,10,0,10,9,9,10,10, 
	 1 ,6,1,6,5,5,5,5,0,1,0,1,11,11,11,11,2,7,0,7,3,3,4,4,0,10,0,10,9,9,10,10, 
	 1 ,6,1,6,5,5,5,5,0,1,0,1,11,11,11,11,2,7,0,7,3,3,3,3,0,10,0,10,9,9, 9, 9, 
	 1 ,6,1,6,5,5,5,5,0,1,0,1,11,11,11,11,2,7,0,7,3,3,3,3,0,10,0,10,9,9, 9, 9, 
};

/// Instruction ID
enum INSTUCTION_NAME {
	NOP,
	PHP,PLP,PHA,PLA,
	BRK,JSR,JMP,BIT,RTI,RTS,
	BPL,BMI,BVC,BVS,BCC,BCSBNE,BEQ,
	SEC,SEI,SED,CLC,CLI,LV,CLD,
	LDA,LDX,LDY,STA,STX,STY,
	AND,EOR,ORA,
	CMP,CPX,CPY,
};

////Operation
///PC 
inline void get_PC_From_CPU_MEMORY(const ADDR Addr){
	PC = (CPU_MEMORY[Addr+1]<<4)|CPU_MEMORY[Addr];
}

//BRK, JSR, PHA, PLA
inline void push(const DATA data){STACK[SP--] = data;} 
//RTI, RTS, PLA, PLP
inline void pop(DATA& data){ data = STACK[++SP];}
inline void push_PC(){push(PC>>8);push(PC&0xff);}
inline void pop_PC(){PC = STACK[SP--];PC|=(STACK[SP--]<<8);}

////Register Access Operation
void draw_Screen(){
}

void inline reset_CPU(){
	SP = 0xFF;
	PPU_STATUS = 0x80;
	get_PC_From_CPU_MEMORY(0xFFFC);
}

void inline nim_CPU(){
	if(PPU_CTRL&0x80){
		PPU_STATUS |= 0x80;
		push_PC();
	}
}

void run_CPU_One_Time(){
	DATA instruction = CPU_MEMORY[PC++];

}

void run_CPU(const int Time = CPU_TIMES_PER_SCREEN){
	for(int i = 0;i<Time;i++){
		run_CPU_One_Time();
	}
}

int main()
{
	reset_CPU();
	while(true){
		draw_Screen();
		run_CPU();
	}
	return 0;
}

