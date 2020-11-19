#include "ppu.h"

ppu::ppu(){
	this->ppu_mem.set_ppu(this);
} 

void ppu::access(int index,DATA& d,bool read){
	if(read == 1){
		if(index == 0x2002){
			MEMORY * m;
			ppu_mem.getRegister(m);
			d = m->get(2);
		}
		
		else if(index == 0x2007){	
			MEMORY * m;
			ppu_mem.getRegister(m);
			DATA t = m->get(0);	
			
			d=ppu_mem.get(PC);
			
			if((t&0x04)==0){
				PC++;
				m->set(6,PC&0xFF);
			}
		}
	}
	else{// data trans
		assert(index!=0x2004);
		/*if(index == 0x2005){
			Scroll <<= 8;
			Scroll |= d;
		}
		else*/
		 if(index == 0x2006){
			PC <<= 8;
			PC += d;
		}
		else if(index == 0x2007){
			MEMORY * m;
			ppu_mem.getRegister(m);
			DATA t = m->get(0);	
			
			ppu_mem.set(PC,d);
			if((t&0x04)==0){
				PC++;
				m->set(6,PC&0xFF);
			}
		}
	}
}

PPU_MEMORY_MANAGER *  ppu::get_mem() {
	return &ppu_mem;
}



void ppu::printBuffer(){
	///*
	char output[256*240*30];
	output[0] = '\0';
//	strcat(output,""CLC"");
	for(int r = 0;r<240;r++){
		for(int c = 0;c<256;c++){
			if(buffer[r][c] == 0){
				//printf("    ");
				strcat(output,"    ");
			}
			else if(buffer[r][c] == 1) {
				//printf(LIGHT_RED"#   "NONE);
				strcat(output,LIGHT_RED"#   "NONE);
			}
			else if(buffer[r][c] == 2){
				//printf(LIGHT_BLUE"#   "NONE);
				strcat(output,LIGHT_BLUE"#   "NONE);
			}
			else if(buffer[r][c] == 3) {
				//printf(LIGHT_GREEN"#   "NONE)
				strcat(output,LIGHT_GREEN"#   "NONE);
			};
		}
		//printf("\n");
		strcat(output,"\n");
	}

	printf("%s",output);
	//*/
}

void ppu::showNameTable(int tid){
	
	MEMORY * m;
	ppu_mem.getRegister(m);
	unsigned char r2000 = m->get(0);

	if(tid < 0 ){
		tid = (r2000 & 0x03);	
	}

	int namet_st = tid * 0x400 + 0x2000;
	
	int bg_patternt_st = ( (r2000 & 0x10) == 0)?0:0x1000;
	
	for(int r = 0;r<30;r++){
		for(int c = 0;c<32;c++){
			
			unsigned int title_index = ppu_mem.get(namet_st+r*32+c);

			showOneSprite(c*8, r*8, 1,bg_patternt_st,title_index);
			
		}
	}
	showSprites();
}

void ppu::showSprites(){
	MEMORY * m;
	MEMORY *OAM;
	ppu_mem.getOAM(OAM);
	ppu_mem.getRegister(m);
	unsigned char conf  = m->get(0);
	int mode8_8 = ((conf & 0x20)==0);
	for(int i = 0;i<64;i++){
		int y = OAM->get(i*4+0);
		int index = OAM->get(i*4+1);
		int x = OAM->get(i*4+3);
		showOneSprite(x,y,mode8_8,0,index);
	}
}

void ppu::showOneSprite(unsigned int x,unsigned int  y,int mode8_8,int pattern_st,int tid){
	MEMORY *m;
	ppu_mem.getVROM(m);
	if(mode8_8){
		pattern_st += tid*16;
		for(int i = 0;i<8;i++){	
			unsigned char t1 = m->get(pattern_st + i);
			unsigned char t2 = m->get(pattern_st + i + 8);
			for(int j=0;j<8;j++){
				int r = y+i;
				int c = x + 7 - j;
				if(r<0xF0 && c<0xFF){
					buffer[r][c] = (((t1>>j)&1)<<1)+((t2>>j)&1);
				}
			}
		}
	}
	else{
		if(tid&1)pattern_st = 0x1000;
		//pattern_st += (tid>>1)*0x1F;
		showOneSprite(x,y,1,pattern_st,(tid>>1)*2);
		showOneSprite(x,y+8,1,pattern_st,(tid>>1)*2+1);
	}
}

