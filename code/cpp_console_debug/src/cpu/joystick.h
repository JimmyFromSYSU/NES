#ifndef FPGA_90TANK_CPU_JOYSTICK
#define FPGA_90TANK_CPU_JOYSTICK

#include "memory_map.h"

enum JOYSTICK_BUTTON {NO,A,B,SELECT,START,UP,DOWN,LEFT,RIGHT};

class joystick:public MEM_HOOK{
	private:
		RAM joystick_reg;
		int pos[2];

		unsigned char st[2];
	public:
		joystick();
		virtual void access(int index,DATA& d,bool read = 0) ;
		void setButton(JOYSTICK_BUTTON b,int jid);
		MEMORY* getRegister();
};

#endif
