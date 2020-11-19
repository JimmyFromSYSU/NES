#ifndef FPGA_90TANK_CPU_PPU
#define FPGA_90TANK_CPU_PPU
#include "memory_map.h"
#include "memory_manager.h"
#include "tool.h"

typedef unsigned char COLOR;

class ppu:public MEM_HOOK{
	private:
		PPU_MEMORY_MANAGER ppu_mem;
		unsigned short PC;
		COLOR buffer[240][256];
	public:
		ppu();
		void saveImgCoe(){ppu_mem.saveImgCoe();}
		void printBuffer();
		virtual void access(int index,DATA& d,bool read = 0);
		PPU_MEMORY_MANAGER *  get_mem();
		void printOAM(){ppu_mem.printOAM();}
		void printVROM(){ppu_mem.printVROM();}
		void printVRAM(){ppu_mem.printVRAM();}
		void printPalette(){ppu_mem.printPalette();}
		void showNameTable(int tid);
		void showSprites();
		void showOneSprite(unsigned int x,unsigned int y,int mode8_8,int pattern_st,int tid);
};

#endif

