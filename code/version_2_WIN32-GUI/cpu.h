#ifndef FPGA_90TANK_CPU_CPU
#define FPGA_90TANK_CPU_CPU
#include "instruction.h"
#include "memory_map.h"
#include "memory_manager.h"
#include "ppu.h"
#include "joystick.h"

class cpu{
	private:
		int ins_cnt;
		INS_DIC ins_dic;
		CPU_MEMORY_MANAGER mem;
		//DATA cpu_mem[0x10000];
		ppu * p;
		joystick * j;	
	protected:
		unsigned char X,Y;
		unsigned short PC;
		unsigned char ACC;
		unsigned char SP;
		unsigned char Data;
		unsigned char INS;

		bool Status_C;
		bool Status_Z;
		bool Status_I;
		bool Status_D;
		bool Status_B;
		bool Status_V;
		bool Status_S;
		
	private:
		std::string INS_NAME;

		int addr;
		int addr_mode;
		//unsigned short next_PC;
	public:
		cpu(ppu * p, joystick * j);
		

		inline void reset(){
			PC = mem.get(0xFFFD);
			PC<<=8;
			PC+= mem.get(0xFFFC);
			//SP = 0xFF;
		}

		inline void init(){mem.set(0x2002,0x80);reset();}
		
		inline void nmi(){
			unsigned char t = mem.get(0x2000);
			if( (t>>7) == 0) return;
			t = mem.get(0x2002);
			//mem.set(0x2002,t|0x80);
			pushPC();
			PC = mem.get(0xFFFB);
			PC*=256;
			PC+= mem.get(0xFFFA);
			//pushST();
		}
	
		//set status register
		inline void setSign(unsigned char t){
			Status_S = (t&(1<<7));
		}
		
		inline void setZero(unsigned char t){
			Status_Z = (t==0);
		}
		
		inline void setCarry(unsigned char t){
			Status_C = (t!=0);
		}
		
		inline void setOverflow(unsigned char t){
			if(t) Status_V = 1;else Status_V=0;
		}
		
		inline void setPC(unsigned short p){
			PC=p;
		}
		
		//stack operation
		inline void push(unsigned char t){
			mem.set((0x100+(SP)),t);
			SP--;
		}
		
		inline unsigned char pop(){
			return  mem.get(0x100 + (++SP));
		}
		
		inline void pushPC(){
			push((PC >> 8) & 0xff);
			push(PC & 0xff);
		}
		
		inline void popPC(){
			int t1 = pop();
			int t2 = pop();
			PC=t2*256+t1;
		}
		
		inline void pushST(){
			unsigned char t = 0;
			t |= ((1&Status_C)<<0);
			t |= ((1&Status_Z)<<1);
			t |= ((1&Status_I)<<2);
			t |= ((1&Status_D)<<3);
			t |= ((1&Status_B)<<4);
			t |= ((1&Status_V)<<6);
			t |= ((1&Status_V)<<7);
			push(t);
		}
		
		inline void popST(){
			unsigned char t = pop();
			Status_C = ((t&(1<<0)));
			Status_Z = ((t&(1<<1)));
			Status_I = ((t&(1<<2)));
			Status_D = ((t&(1<<3)));
			Status_B = ((t&(1<<4)));
			Status_V = ((t&(1<<6)));
			Status_S = ((t&(1<<7)));
		}
		
		//address operation
		inline int absolute(int pc){
			int tmp1 = mem.get(pc+2);
			int tmp2 = mem.get(pc+1);
			return tmp1 * 256 + tmp2;
		}
		
		inline int indirect(int pc){
			pc = absolute(pc)-1;
			return absolute(pc);
		}
		
		inline int relative(int pc){
			unsigned char d = mem.get(pc+1);
			pc+=2;
			if((d&0x80)==0) pc+=d;
			else {
				pc+= 0xFF00+d;
			}
			return pc;
		}


		void fetch();
		bool analysis();
		bool oneStep();
		bool check_jmp();
		void address();

		void load_mem();
		void store_mem();
		
		void set_mem(int a,unsigned char d);
		
		void prepareImage(){
			p->showNameTable(-1);
		}
		
		unsigned int * getColorData (){
			return p->getBuffer();
		}; 
};


#endif
