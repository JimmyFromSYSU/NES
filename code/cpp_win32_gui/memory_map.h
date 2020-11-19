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
	virtual void set(unsigned int index,DATA d){
		MEMORY* m;
		unsigned int nid = getMemBank(index,m);
		assert(m);
		if(m==NULL)return;
		m->set(nid,d);
	}
	

	virtual DATA get(unsigned int index){
		MEMORY* m;
		unsigned int nid = getMemBank(index,m);
		assert(m);
		if(m==NULL) return 0;
		DATA d = m->get(nid);
		return d;
	}

	virtual int getMemBank(unsigned int index,MEMORY*& m)=0;
};

class MEM_HOOK{
public:
	virtual void access(int index, DATA& d,bool read = 0)=0;	
};

#endif
