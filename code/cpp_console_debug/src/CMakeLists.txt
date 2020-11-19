cmake_minimum_required(VERSION 3.0)

project(FPGA_90_TANK)

include_directories(cpu)
include_directories(tool)

add_subdirectory (cpu) 
add_subdirectory (tool) 

################################################### tank
add_executable(tank 6502_simple/6502.cpp)
#target_link_libraries (mif2bin tool)

################################################### mif2bin
add_executable(mif2bin format/mif2bin.cpp)
target_link_libraries (mif2bin tool)

################################################### cputest
add_executable(game_test game_test.cpp)
target_link_libraries (game_test cpu)
target_link_libraries (game_test tool)

################################################### cputest
add_executable(cpu_test cpu_test.cpp)
target_link_libraries (cpu_test cpu)
target_link_libraries (cpu_test tool)


################################################### instest
add_executable(ins_test ins_test.cpp)
target_link_libraries (ins_test cpu)
target_link_libraries (ins_test tool)

################################################### memtest
add_executable(mem_test mem_test.cpp)
target_link_libraries (mem_test cpu)
target_link_libraries (mem_test tool)

################################################### ppu_rom_test
add_executable(ppu_rom_test ppu_rom_test.cpp)
target_link_libraries (ppu_rom_test cpu)
target_link_libraries (ppu_rom_test tool)


################################################### nes2bin
add_executable(nes2bin format/nes2bin.cpp)
#target_link_libraries (mif2bin tool)
