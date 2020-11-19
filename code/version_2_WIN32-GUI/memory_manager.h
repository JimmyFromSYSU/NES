#ifndef FPGA_90TANK_CPU_MEMMANAGER
#define FPGA_90TANK_CPU_MEMMANAGER
#include "joystick.h"
#include "memory_map.h"


class PPU_MEMORY_MANAGER:public MEMORY_MANAGER{
    private:
        RAM OAM;
        RAM VRAM;
        RAM Palette;
        ROM VROM;
        RAM ppu_reg;
        MEM_HOOK* ppu;


    public:
        PPU_MEMORY_MANAGER();
        void setOAM(int index,unsigned char d);

        void set_ppu(MEM_HOOK* ppu);
        void getRegister(MEMORY*& m){m = & ppu_reg;}
        void getVROM(MEMORY*& m){m = & VROM;}
        void getOAM(MEMORY*& m){m = & OAM;}
        void getPalette(MEMORY*& m){m = & Palette;}
        void accessRegister(int index,DATA& d,bool read = 0);//0x20XX
        int getMemBank(unsigned int index,MEMORY*& m);
};

class CPU_MEMORY_MANAGER:public MEMORY_MANAGER{
    private:
        RAM inter_RAM;
        //RAM ppu_reg;
        RAM apu_reg;
        RAM DMA_reg;
        RAM channel_sw_reg;
    //  RAM joystick_reg;
        RAM sram;
        ROM prom;

        PPU_MEMORY_MANAGER * ppu_mem;
        joystick * jstick;

    public:
        void set_ppu(PPU_MEMORY_MANAGER * p);       
        void set_joystick(joystick * j);
        virtual void set(unsigned int index,DATA d);
        virtual DATA get(unsigned int index);
        CPU_MEMORY_MANAGER();
        int getMemBank(unsigned int index,MEMORY*& m);
};


#endif
		
		
