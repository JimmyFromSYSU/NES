#include "ppu.h"

ppu::ppu(){
	this->ppu_mem.set_ppu(this);
} 

PPU_MEMORY_MANAGER *  ppu::get_mem() {
	return &ppu_mem;
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
			
			d=ppu_mem.get(PC-1);
			//first time don't add
			if((t&0x04)==0){
				PC++;
				m->set(6,PC&0xFF);
				
			}
			
		}
	}
	else{// data trans
		assert(index!=0x2004);
		if(index == 0x2005){
			Scroll <<= 8;
       		Scroll |= d;
       		//if(Scroll)printf("%X\n",Scroll);
		}
		else if(index == 0x2006){
			PC <<= 8;
			PC += d;
		}
		else if(index == 0x2007){
			MEMORY * m;
			ppu_mem.getRegister(m);
			DATA t = m->get(0);	
			
			ppu_mem.set(PC,d);
			//if((t&0x04)==0){
				m->set(6,PC&0xFF);
				PC++;
			//}
		}
	}
}


void ppu::showNameTable(int tid){
	
	MEMORY * m;
	ppu_mem.getRegister(m);
	unsigned char r2000 = m->get(0);
	int bg_patternt_st = ( (r2000 & 0x10) == 0)?0:0x1000;
	
	if(tid < 0 ){tid = (r2000 & 0x03);}

	int namet_st = tid * 0x400 + 0x2000;
	int attr_st = tid * 0x400 + 0x23c0;
	int attr_index;
	int attr_inner_index;
	for(int r = 0;r<30;r++){
		for(int c = 0;c<32;c++){
			attr_index = r/4*8 + c/4;
			attr_inner_index = (r%4/2) *2+ (c%4/2);
			
			unsigned int title_index = ppu_mem.get(namet_st+r*32+c);
			unsigned int color = ppu_mem.get(attr_st+attr_index);
			showOneSprite(c*8, r*8, 1,bg_patternt_st,title_index,0x03&(color >> (2*attr_inner_index)),0,1);
		}
	}

	if(tid<2){
		tid+=2;
		int namet_st = tid * 0x400 + 0x2000;
		for(int r = 0;r<30;r++){
			for(int c = 0;c<32;c++){
				attr_index = r/4*8 + c/4;
				attr_inner_index = (r%4/2) *2+ (c%4/2);
				
				unsigned int title_index = ppu_mem.get(namet_st+r*32+c);
				unsigned int color = ppu_mem.get(attr_st+attr_index);
				showOneSprite(c*8, (r+30)*8, 1,bg_patternt_st,title_index,0x03&(color >> (2*attr_inner_index)),0,1);
			}
		}
	}
	//printf("\n-------\n");
	//getch();
	showSprites();
}
//void ppu::showOneSprite( int x, int  y,int mode8_8,int pattern_st,int tid,int pid,int behind_bg,bool is_bg)
void ppu::showSprites(){
	MEMORY * m;
	MEMORY *OAM;
	ppu_mem.getOAM(OAM);
	ppu_mem.getRegister(m);
	unsigned char conf  = m->get(0);
	//unsigned char img_inf  = m->get(2);
	
	int mode8_8 = ((conf & 0x20)==0);
	for(int i = 0;i<64;i++){
		unsigned int y = OAM->get(i*4+0);
		unsigned int index = OAM->get(i*4+1); // 
		unsigned int x = OAM->get(i*4+3);
		unsigned int attr = OAM->get(i*4+2);
		showOneSprite(x,y,mode8_8,0,index,attr&0x03, attr&0x20,0);
	}
}
#include <windows.h>
const int colorTable [0x40]= {
RGB(127,127,127),RGB(32,0,176),RGB(40,0,184),RGB(96,16,160),
RGB(152,32,120),RGB(176,16,48),RGB(160,48,0),RGB(120,64,0),
RGB(72,88,0),RGB(56,104,0),RGB(56,108,0),RGB(48,96,64),
RGB(48,80,128),RGB(0,0,0),RGB(0,0,0),RGB(0,0,0),

RGB(188,188,188),RGB(64,96,248),RGB(64,64,255),RGB(144,64,240),
RGB(216,64,192),RGB(216,64,96),RGB(224,80,0),RGB(192,112,0),
RGB(136,136,0),RGB(80,160,0),RGB(72,168,16),RGB(72,160,104),
RGB(64,144,192),RGB(0,0,0),RGB(0,0,0),RGB(0,0,0),

RGB(255,255,255),RGB(96,160,255),RGB(80,128,255),RGB(160,112,255),
RGB(240,96,255),RGB(255,96,176),RGB(255,120,48),RGB(255,160,0),
RGB(232,208,32),RGB(152,232,0),RGB(112,240,64),RGB(112,224,144),
RGB(96,208,224),RGB(96,96,96),RGB(0,0,0),RGB(0,0,0),

RGB(255,255,255),RGB(144,208,255),RGB(160,184,255),RGB(192,176,255),
RGB(224,176,255),RGB(255,184,232),RGB(255,200,184),RGB(255,216,160),
RGB(255,240,144),RGB(200,240,128),RGB(160,240,160),RGB(160,255,200),
RGB(160,255,240),RGB(160,160,160),RGB(0,0,0),RGB(0,0,0)
};

void ppu::showOneSprite( int x, int  y,int mode8_8,int pattern_st,int tid,int pid,int behind_bg,bool is_bg){
	MEMORY *m;
	ppu_mem.getVROM(m);
	MEMORY* p;
	ppu_mem.getPalette(p);
	
	if(mode8_8){
//		printf("Scroll %X\n",Scroll);
		//tid >>=1; 
		
		if(is_bg){
			if(Scroll){
				x-=(Scroll>>8);
				y-=(Scroll&0xFF);
				//printf("%d %d ,",x,y);
			}		
		}
		
		
		pattern_st += tid*16;
		
		for(int i = 0;i<8;i++){
			
			unsigned char t1 = m->get(pattern_st + i);
			unsigned char t2 = m->get(pattern_st + i + 8);
			
			for(int j=0;j<8;j++){
				int r = y+i;
				int c = x + 7 - j;
				int color_id = (((t2>>j)&1)<<1)|((t1>>j)&1) ;
				//int color = (((t1>>j)&1)<<1)+((t2>>j)&1);
				int color=0;
				//if(color_id>0 && !is_bg) color = colorTable[p->get(4*pid+color_id)];
				
				if(is_bg )color = colorTable[p->get(4*pid+color_id)];
				else if(color_id!=0) color = colorTable[p->get(4*pid+color_id+0x10)];
				
				//if(is_bg )color = color_id;
				//else color = colorTable[p->get(0x11+4*pid+color_id)];
				if(r>=0 && r<0xF0 && c>=0 && c<0xFF){
					if(is_bg)	buffer[r*256+c] = color;
					else if(color == 0)continue;
					else if((behind_bg == 0) || (buffer[r*256+c] == 0)) buffer[r*256+c] = color;
				}
			}
		}
		
/*
		pattern_st += tid*16;
		for(int i = 0;i<8;i++){	
			unsigned char t1 = m->get(pattern_st + i);
			unsigned char t2 = m->get(pattern_st + i + 8);
			for(int j=0;j<8;j++){
				int r = y+i;
				int c = x + 7 - j;
				int color = (((t1>>j)&1)<<1)+((t2>>j)&1);
				if(r<0xF0 && c<0xFF && (is_bg || (behind_bg == 0 || buffer[r*256+c] == 0))){
					
					buffer[r*256+c] = color;
				}
			}
		}*/
	}
	else{
		if(tid&1)pattern_st = 0x1000;
		//pattern_st += (tid>>1)*0x1F;
		//showOneSprite(x,y,1,pattern_st,(tid>>1)*2,behind_bg);
		//showOneSprite(x,y+8,1,pattern_st,(tid>>1)*2+1,behind_bg);
		
		showOneSprite(x,y,1,pattern_st,(tid>>1)*2,pid,behind_bg,is_bg);
		showOneSprite(x,y+8,1,pattern_st,(tid>>1)*2+1,pid,behind_bg,is_bg);
	}
}
