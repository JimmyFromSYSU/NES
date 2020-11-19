#include "memory_manager.h"

CPU_MEMORY_MANAGER::CPU_MEMORY_MANAGER(){
	inter_RAM.init(0x0800);
	apu_reg.init(0x0014);
	DMA_reg.init(1);
	channel_sw_reg.init(1);
	sram.init(0x2000,0xFF);
	prom.load("data/rom/rom.bin");
}  

void CPU_MEMORY_MANAGER::set_ppu(PPU_MEMORY_MANAGER * p){
	ppu_mem = p;
}

void CPU_MEMORY_MANAGER::set_joystick(joystick * j){
	jstick = j;
}


///////////////// slow
int CPU_MEMORY_MANAGER::getMemBank(unsigned int index,MEMORY*& m){
	if(index >0xFFFF) {
		printf("%d, out of cpu memory!",index);
		return -1;
	} 
	if(index<0x2000){
		m = &inter_RAM;
		assert(index!=0x2004);
		return index % (0x0800);
	}
	else if(index<0x4000){
		ppu_mem->getRegister(m);
		return index % 8;
		//m = &ppu_reg;
		//if(flag)printf("ppu register\n");
	
		//return (index-0x2000) % (0x0008);
 	}
	else if(index<0x4014){
		m = &apu_reg;
		//////////////
		return (index - 0x4000) ;
	}
	else if(index<0x4015){
		m = &DMA_reg;
		return (index - 0x4014);
	}
	else if(index<0x4016){
		m = &channel_sw_reg;
		return (index - 0x4015);
	}
	else if(index<0x4018){
		m = jstick->getRegister();
		//m = &joystick_reg;
		return (index - 0x4016);
	}
	else if(index<0x6000){
		m = NULL;
		return 0;
	}
	else if(index<0x8000){
		m = &sram;
		return (index - 0x6000);
	}
	else{
		m = &prom;
		return (index - 0x8000);
	} 
}

///////////////// slow
void CPU_MEMORY_MANAGER::set(unsigned int index,DATA d){
	//assert(index!=0x2002);
	//assert(index!=0x4017);
	if(index == 0x4014){//DMA
		int s = d * 0x100;	
		for(int i = 0;i<=0xFF;i++){
			ppu_mem->setOAM(i,get(s+i));		
	 	}
	}
	else  if(index == 0x4016){
		jstick->access(index,d,0);
 	}
	MEMORY_MANAGER::set(index,d);

	if(index>=0x2000 && index<0x2008) ppu_mem->accessRegister(index,d,0);
} 
///////////////// slow
DATA CPU_MEMORY_MANAGER::get(unsigned int index){
	/*
	assert(index<0x4000 || index > 0x4015);
	//assert(index!=0x4016);
	
	//assert(index!=0x2000);
	assert(index!=0x2001);
	assert(index!=0x2003);
	assert(index!=0x2004);
	assert(index!=0x2005);
	assert(index!=0x2006);
	//assert(index!=0x2007);
	*/
	 
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
	return MEMORY_MANAGER::get(index);
} 

////////PPU

PPU_MEMORY_MANAGER::PPU_MEMORY_MANAGER(){
	ppu_reg.init(8);
	VROM.load("data/rom/vrom.bin");
	
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

void PPU_MEMORY_MANAGER::accessRegister(int index,DATA& d,bool read){
	ppu->access(index,d,read);
}

int PPU_MEMORY_MANAGER::getMemBank(unsigned int index, MEMORY*& m){
	if(index >0x3FFF) {
		return -1;
	} 
	if(index<0x2000){
		m = &VROM;
		return index;
	}
	else if(index<=0x3EFF){
		m = &VRAM;
		return (index - 0x2000);//%0x1000;
 	}
	else if(index<=0x3F1F){
		m = &Palette;
		return index - 0x3F00;
	}
	m = NULL;
	return 0;
}


