//Debug switch
#define TESTING

//Data Type
typedef unsigned char DATA; // Data width in memory
typedef unsigned short ADDR; // Addr width

//Config
const int STACK_SIZE				=	0x0100;
const int PRAM_SIZE					=	0x800;
const int PROM_SIZE					=	0x8000;

const int CPU_MEMORY_SIZE			=	0x10000;
const int PPU_MEMORY_SIZE			=	0x4000;

const int OAM_SIZE					=	0x100;	
const int VRAM_SIZE					=	0x1000;
const int VROM_SIZE					=	0x2000;	
const int PALETTE_SIZE				=	0x0020;

const int INSTRUCTION_SET_SIZE		=	256;

const int CPU_TIMES_PER_SCREEN		=	70000;



//OPERATION
