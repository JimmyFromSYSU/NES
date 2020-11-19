#include "joystick.h"

joystick::joystick(){
	joystick_reg.init(2);
	pos[0] = pos[1] = 0;
	//st[0] = 0xFF;
	st[0] = st[1] = 0x00;
}

void joystick::access(int index,DATA& d,bool read){
	if(read == false){

		if(index==0x4016 && d==0 && (joystick_reg.get(0)==1)){
			pos[0] = pos[1] = 0;
		}
	}
	else{
		if(index==0x4016){
			if( ((st[0]>>pos[0])&1) == 0){d = 0x40;}else{d = 0x41;}
			pos[0]++;
		}	
		else if(index==0x4017){
			if( ((st[1]>>pos[1])&1) == 0){d = 0x40;}else{d = 0x41;}
			pos[1]++;
		}

		joystick_reg.set(index-0x4016,d);
		//if(pos[0]==8) st[0] = 0;
		//if(pos[1]==8) st[1] = 0;
	}
}

void joystick::setButton(JOYSTICK_BUTTON b,int jid){
	if(b==JS_NO){st[jid] = 0;}
	else{st[jid] = 1<<(b-1);}
}

MEMORY* joystick::getRegister(){
	return &joystick_reg;
}

