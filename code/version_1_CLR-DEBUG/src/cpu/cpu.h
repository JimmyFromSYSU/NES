#ifndef FPGA_90TANK_CPU_CPU
#define FPGA_90TANK_CPU_CPU
#include "instruction.h"
#include "memory_map.h"
#include "memory_manager.h"
#include "ppu.h"
#include "joystick.h"

class cpu{
	private:
		int nmi_cnt;
		int ins_cnt;
		INS_DIC ins_dic;
		CPU_MEMORY_MANAGER mem;
		ppu * p;
		joystick * j;	
		bool in_nmi;
	protected:
		bool inf_flag ;
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
		unsigned short next_PC;
	public:
		cpu(ppu * p, joystick * j);
		void setPC(unsigned short p);
		
		void reset();
		void nmi();

		void init();

		void push(unsigned char t);
		unsigned char pop();
		void pushPC();
		void popPC();
		void pushST();
		void popST();

		void setSign(unsigned char t);
		void setZero(unsigned char t);
		void setCarry(unsigned char t);
		void setOverflow(unsigned char t);
		void fetch();
		bool analysis();
		void update();
		bool oneStep(bool f = true);
		bool check_jmp();
		void address();

		int absolute(int pc);
		int indirect(int pc);
		int relative(int pc);

		void check_addr();
		void check_addr(int a);
		void load_mem();
		void store_mem();
		void set_mem(int a,unsigned char d);

		void printST();
		void printR();
		void printM();
		void printI();
		void printM(int pos);
		void printM16(int pos);
		void saveMem(){mem.saveMem();}
};


#endif
