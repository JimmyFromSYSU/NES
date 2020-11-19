#ifndef FPGA_90TANK_CPU_MEMORY
#define FPGA_90TANK_CPU_MEMORY

#include "tool.h"
//#include "joystick.h"

const int MEM_TREE_SIZE = 256;
class MEMORY{
	protected:
		unsigned int size;
		DATA * data;
	public:
		MEMORY(){data = NULL; size = 0;}
		~MEMORY(){if(data)delete data;data = NULL;}
		void saveCoe(const char * fn){
			FILE * fp = fopen(fn,"w");
			assert(fp);
			fprintf(fp,"memory_initialization_radix=16;\n");
			fprintf(fp,"memory_initialization_vector=\n");
			for(int i = 0;i<size-1;i++){
				fprintf(fp,"%2X,",data[i]);
				if(i%16==15)fprintf(fp,"\n");
			}
			fprintf(fp,"%2X;\n",data[size-1]);
			fclose(fp);
		}
		void print(){
			for(int i = 0;i<size;i+=16){
				if( (i/0x400)%2==1 )printf(LIGHT_GREEN""); 
				printf("%4X: ",i);
				for(int j = 0;j<16 && i+j<size;j++){
					DATA d = data[i+j];
					if(d==0)printf(" . ");
					else printf("%2X ",d);
				}
				if( (i/0x400)%2==1 )printf(NONE""); 
				puts("");
			}
		}
		//initial !!
		void init(unsigned int  s,unsigned char v = 0){
			size = s;
			if(data)delete data;data = NULL;
			data = new DATA[size];
			memset(data,v,sizeof(unsigned char)*size);
		}

		virtual DATA get(unsigned int index){
			assert(index<size);
			return data[index];
		}
		virtual void set(unsigned int index, DATA d){
			data[index] = d;
		}
};

class ROM:public MEMORY{
	public:
		void load(const char * fn){
			FILE * fp = fopen(fn,"rb");
			fread(&size,sizeof(unsigned int),1,fp);
			init(size);
			fread(data,sizeof(unsigned char),size,fp);
			fclose(fp);
		}
		void set(int index,DATA d){
			puts("Readonly memory!");
		}
};

typedef MEMORY RAM;

class MEMORY_MANAGER{
	public :
	virtual void set(unsigned int index,DATA d,bool flag = 0){
		MEMORY* m;
		unsigned int nid = getMemBank(index,m, flag);
		assert(m);
		if(m==NULL)return;
		m->set(nid,d);
		if(flag){
			printf("set %-3d ",d);
			printBin(d);
			printf("(b) %X(h)\n",d);
		}
	}
	
	void print16(int pos){
		printf("%04X: ",pos);
		int d;
		for(int i = 0;i<16;i++){
			d = get(pos+i,0);
			if(d==0)printf(" . ");
			else printf("%02X ",d);
		}puts("");
	}

	virtual DATA get(unsigned int index,bool flag = 0){
		MEMORY* m;
		unsigned int nid = getMemBank(index,m,flag);
		assert(m);
		if(m==NULL) return 0;
		DATA d = m->get(nid);
		if(flag){
			printf("get %-3d ",d);
			printBin(d);
			printf("(b) %X(h)\n",d);
		}
		return d;
	}

	virtual int getMemBank(unsigned int index,MEMORY*& m,bool flag = 1)=0;
};

class MEM_HOOK{
public:
	virtual void access(int index, DATA& d,bool read = 0)=0;	
};
/*
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
		void printOAM(){OAM.print();}
		void printPalette(){Palette.print();}
		void printVROM(){VROM.print();}
		void printVRAM(){VRAM.print();}

		void set_ppu(MEM_HOOK* ppu);
		void getRegister(MEMORY*& m,int flag=0);
		void getVROM(MEMORY*& m,int flag=0);
		void accessRegister(int index,DATA d);//0x20XX
		int getMemBank(unsigned int index,MEMORY*& m,bool flag = 1);
};

class CPU_MEMORY_MANAGER:public MEMORY_MANAGER{
	private:
		RAM inter_RAM;
		//RAM ppu_reg;
		RAM apu_reg;
		RAM DMA_reg;
		RAM channel_sw_reg;
	//	RAM joystick_reg;
		RAM sram;
		ROM prom;
		
		PPU_MEMORY_MANAGER * ppu_mem;
		joystick * jstick;

	public:
		void set_ppu(PPU_MEMORY_MANAGER * p);		i
		void set_joystick(joystick * j);
		virtual void set(unsigned int index,DATA d,bool flag = 0);
		virtual DATA get(unsigned int index,bool flag = 0);
		CPU_MEMORY_MANAGER();
		int getMemBank(unsigned int index,MEMORY*& m,bool flag = 1);
};  

*/
#endif
