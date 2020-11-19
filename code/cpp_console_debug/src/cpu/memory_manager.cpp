#include "memory_manager.h"

CPU_MEMORY_MANAGER::CPU_MEMORY_MANAGER(){
	inter_RAM.init(0x0800);
//	ppu_reg.init(8);
	apu_reg.init(0x0014);
	DMA_reg.init(1);
	channel_sw_reg.init(1);
//	joystick_reg.init(2);
	sram.init(0x2000,0xFF);
	prom.load("../data/rom/rom.bin");
}  

void CPU_MEMORY_MANAGER::set_ppu(PPU_MEMORY_MANAGER * p){
	ppu_mem = p;
}

void CPU_MEMORY_MANAGER::set_joystick(joystick * j){
	jstick = j;
}

int CPU_MEMORY_MANAGER::getMemBank(unsigned int index,MEMORY*& m,bool flag){
	if(index >0xFFFF) {
		printf("%d, out of cpu memory!",index);
		return -1;
	} 
	if(index<0x2000){
		m = &inter_RAM;
		if(flag){
			if(index<0x0800)printf("zero page\n");
			else printf("zero page mirror %d\n",(index-0x800)%0x800);
		}
		assert(index!=0x2004);
		return index % (0x0800);
	}
	else if(index<0x4000){
		ppu_mem->getRegister(m,flag);
		return index % 8;
		//m = &ppu_reg;
		//if(flag)printf("ppu register\n");
	
		//return (index-0x2000) % (0x0008);
 	}
	else if(index<0x4014){
		m = &apu_reg;
		if(flag)printf("apu register\n");
		//////////////
		return (index - 0x4000) ;
	}
	else if(index<0x4015){
		m = &DMA_reg;
		if(flag)printf("dma register\n");
		return (index - 0x4014);
	}
	else if(index<0x4016){
		m = &channel_sw_reg;
		if(flag)printf("channel switch register\n");
		return (index - 0x4015);
	}
	else if(index<0x4018){
		m = jstick->getRegister();
		//m = &joystick_reg;
		if(flag){
			printf("joystick register ");
			if(index == 0x4016)puts("1");
			else puts("2");
		}
		return (index - 0x4016);
	}
	else if(index<0x6000){
		m = NULL;
		if(flag)printf("no define memory area\n");
		//assert(index<0x4018 || index>=0x6000);
		return 0;
	}
	else if(index<0x8000){
		m = &sram;
		if(flag)printf("sram\n");
		return (index - 0x6000);
	}
	else{
		m = &prom;
		if(flag)printf("program rom\n");
		return (index - 0x8000);
	} 
} 

void CPU_MEMORY_MANAGER::set(unsigned int index,DATA d,bool flag){
	if(index == 0x4014){//DMA
		int s = d * 0x100;	
		for(int i = 0;i<0xFF;i++){
			ppu_mem->setOAM(i,get(s+i,0));		
 		 }
	}
	else  if(index == 0x4016){
		jstick->access(index,d,0);
 	}
	MEMORY_MANAGER::set(index,d,flag);

	if(index>=0x2000 && index<0x2008) ppu_mem->accessRegister(index,d,0);
} 

DATA CPU_MEMORY_MANAGER::get(unsigned int index,bool flag ){
	if(index==0x4016 || index==0x4017){
		DATA d;
		jstick->access(index,d,1);
		return d;
 	}
	else if(index == 0x2002 || index == 0x2007){
		DATA d;
		ppu_mem->accessRegister(index,d,1);
		return d;
	}
	return MEMORY_MANAGER::get(index,flag);
} 

void CPU_MEMORY_MANAGER::saveMem(){
	inter_RAM.saveCoe("output/PRAM.coe");
}
////////PPU

 PPU_MEMORY_MANAGER::PPU_MEMORY_MANAGER(){
	ppu_reg.init(8);
	VROM.load("../data/rom/vrom.bin");
	
	VRAM.init(0x1000);
	Palette.init(0x0020);

	OAM.init(256);
}

void PPU_MEMORY_MANAGER::setOAM(int index,unsigned char d){
	OAM.set(index,d);
}

void PPU_MEMORY_MANAGER::set_ppu(MEM_HOOK* ppu){
	this->ppu = ppu;
}

void PPU_MEMORY_MANAGER::getRegister(MEMORY*& m,int flag){
	m =  &ppu_reg;
 }

void PPU_MEMORY_MANAGER::accessRegister(int index,DATA& d,bool read){
	ppu->access(index,d,read);
}

int PPU_MEMORY_MANAGER::getMemBank(unsigned int index, MEMORY*& m,bool flag){
	if(index >0x3FFF) {
		printf("%d, out of ppu memory!",index);
		return -1;
	} 
	if(index<0x2000){
		m = &VROM;
		if(flag){
			if(index<0x1000)printf("pattern table 1\n");
			else printf("pattern table 2\n");
		}
		return index;
	}
	else if(index<=0x3EFF){
		m = &VRAM;
		return (index - 0x2000);//%0x1000;
 	}
	else{
		m = &Palette;
		return index - 0x3F00;
	}
}

void PPU_MEMORY_MANAGER::getVROM(MEMORY*& m,int flag){
	m = & VROM;
}

void PPU_MEMORY_MANAGER::getOAM(MEMORY*& m,int flag){
	m = & OAM;
}

void PPU_MEMORY_MANAGER::getPalette(MEMORY*& m,int flag){
	m = & Palette;
 }

void PPU_MEMORY_MANAGER::saveImgCoe(){
	//OAM,VRAM,Palette,VROM;
	OAM.saveCoe("output/OAM.coe");	
	VRAM.saveCoe("output/VRAM.coe");	
	Palette.saveCoe("output/Palette.coe");	
	VROM.saveCoe("output/VROM.coe");	
}
