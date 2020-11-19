#ifndef FPGA_90TANK_TOOL_TOOL
#define FPGA_90TANK_TOOL_TOOL
#include <unistd.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <time.h>
#include <algorithm>
#include <set>
#include <string>
#include <map>
#include <vector>
#include <queue>
#include <stack>
#include <iostream>
#include <assert.h>
#include <conio.h>
#include<process.h> 
//#include <ncurses.h>
#include "file_io.h"

typedef std::map<std::string, std::string> DIC;
typedef unsigned char DATA;


// change hex to int
int hex2int(char * t);

// print a int in hex format
//void printHex(int t, int min_size = 0);

// print a int in bin format
void printBin(int t,int min_size = 8);

//char getch();
//char getche();

#define NONE         "\033[m"
#define RED          "\033[0;32;31m"
#define LIGHT_RED    "\033[1;31m"
#define GREEN        "\033[0;32;32m"
#define LIGHT_GREEN  "\033[1;32m"
#define BLUE         "\033[0;32;34m"
#define LIGHT_BLUE   "\033[1;34m"
#define DARY_GRAY    "\033[1;30m"
#define CYAN         "\033[0;36m"
#define LIGHT_CYAN   "\033[1;36m"
#define PURPLE       "\033[0;35m"
#define LIGHT_PURPLE "\033[1;35m"
#define BROWN        "\033[0;33m"
#define YELLOW       "\033[1;33m"
#define LIGHT_GRAY   "\033[0;37m"
#define WHITE        "\033[1;37m"

#define RED_BACK "\033[7;31m"
#define GREEN_BACK "\033[7;32m"
#define BLUE_BACK "\033[7;34m"

#define NONE_BACK "\033[0m"

#define CLC "\33[2J"
#define SAVE_C_POS "\33[s"
#define LOAD_C_POS "\33[u"
#endif

