#ifndef FPGA_90TANK_CPU_PPU
#define FPGA_90TANK_CPU_PPU
#include "memory_map.h"
#include "memory_manager.h"
#include "tool.h"

typedef unsigned int COLOR;

class ppu:public MEM_HOOK{
	private:
		PPU_MEMORY_MANAGER ppu_mem;
		unsigned short PC;
		COLOR buffer[240*256];
		unsigned short Scroll;
	public:
		ppu();
		//void printBuffer();
		virtual void access(int index,DATA& d,bool read = 0);
		PPU_MEMORY_MANAGER *  get_mem();

		void showNameTable(int tid);
		void showSprites();
		void showOneSprite( int x, int y,int mode8_8,int pattern_st,int tid,int pid,int behind_bg,bool is_bg = false);
		unsigned int * getBuffer(){return buffer;}
		MEMORY * getPalette(){
			MEMORY * m;
		 	ppu_mem.getPalette(m);
		 	return  m;
		} 
		
		
		//unsigned char * getBgColorSet(){}
};

#endif

