#ifndef FPGA_90TANK_CPU_INS
#define FPGA_90TANK_CPU_INS
#include "tool.h"


struct INS
{
	std::string name;
	int addr_mode;
};

const int INS_SIZE = 256;

class INS_DIC{
	private:
		DIC ins_function;
		std::vector<std::string> addr_function;
		std::vector<int> addr_bitnum;
		INS ins[INS_SIZE];
	public:
		
		void load(const char * file);
		int getAddrMode(int ins_id);
		std::string getName(int ins_id);
};


#endif

