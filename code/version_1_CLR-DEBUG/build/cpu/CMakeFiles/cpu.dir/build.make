# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.0

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.0.1/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.0.1/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build

# Include any dependencies generated for this target.
include cpu/CMakeFiles/cpu.dir/depend.make

# Include the progress variables for this target.
include cpu/CMakeFiles/cpu.dir/progress.make

# Include the compile flags for this target's objects.
include cpu/CMakeFiles/cpu.dir/flags.make

cpu/CMakeFiles/cpu.dir/cpu.cpp.o: cpu/CMakeFiles/cpu.dir/flags.make
cpu/CMakeFiles/cpu.dir/cpu.cpp.o: /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/cpu.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object cpu/CMakeFiles/cpu.dir/cpu.cpp.o"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/cpu.dir/cpu.cpp.o -c /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/cpu.cpp

cpu/CMakeFiles/cpu.dir/cpu.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/cpu.dir/cpu.cpp.i"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/cpu.cpp > CMakeFiles/cpu.dir/cpu.cpp.i

cpu/CMakeFiles/cpu.dir/cpu.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/cpu.dir/cpu.cpp.s"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/cpu.cpp -o CMakeFiles/cpu.dir/cpu.cpp.s

cpu/CMakeFiles/cpu.dir/cpu.cpp.o.requires:
.PHONY : cpu/CMakeFiles/cpu.dir/cpu.cpp.o.requires

cpu/CMakeFiles/cpu.dir/cpu.cpp.o.provides: cpu/CMakeFiles/cpu.dir/cpu.cpp.o.requires
	$(MAKE) -f cpu/CMakeFiles/cpu.dir/build.make cpu/CMakeFiles/cpu.dir/cpu.cpp.o.provides.build
.PHONY : cpu/CMakeFiles/cpu.dir/cpu.cpp.o.provides

cpu/CMakeFiles/cpu.dir/cpu.cpp.o.provides.build: cpu/CMakeFiles/cpu.dir/cpu.cpp.o

cpu/CMakeFiles/cpu.dir/joystick.cpp.o: cpu/CMakeFiles/cpu.dir/flags.make
cpu/CMakeFiles/cpu.dir/joystick.cpp.o: /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/joystick.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/CMakeFiles $(CMAKE_PROGRESS_2)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object cpu/CMakeFiles/cpu.dir/joystick.cpp.o"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/cpu.dir/joystick.cpp.o -c /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/joystick.cpp

cpu/CMakeFiles/cpu.dir/joystick.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/cpu.dir/joystick.cpp.i"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/joystick.cpp > CMakeFiles/cpu.dir/joystick.cpp.i

cpu/CMakeFiles/cpu.dir/joystick.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/cpu.dir/joystick.cpp.s"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/joystick.cpp -o CMakeFiles/cpu.dir/joystick.cpp.s

cpu/CMakeFiles/cpu.dir/joystick.cpp.o.requires:
.PHONY : cpu/CMakeFiles/cpu.dir/joystick.cpp.o.requires

cpu/CMakeFiles/cpu.dir/joystick.cpp.o.provides: cpu/CMakeFiles/cpu.dir/joystick.cpp.o.requires
	$(MAKE) -f cpu/CMakeFiles/cpu.dir/build.make cpu/CMakeFiles/cpu.dir/joystick.cpp.o.provides.build
.PHONY : cpu/CMakeFiles/cpu.dir/joystick.cpp.o.provides

cpu/CMakeFiles/cpu.dir/joystick.cpp.o.provides.build: cpu/CMakeFiles/cpu.dir/joystick.cpp.o

cpu/CMakeFiles/cpu.dir/ppu.cpp.o: cpu/CMakeFiles/cpu.dir/flags.make
cpu/CMakeFiles/cpu.dir/ppu.cpp.o: /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/ppu.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/CMakeFiles $(CMAKE_PROGRESS_3)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object cpu/CMakeFiles/cpu.dir/ppu.cpp.o"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/cpu.dir/ppu.cpp.o -c /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/ppu.cpp

cpu/CMakeFiles/cpu.dir/ppu.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/cpu.dir/ppu.cpp.i"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/ppu.cpp > CMakeFiles/cpu.dir/ppu.cpp.i

cpu/CMakeFiles/cpu.dir/ppu.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/cpu.dir/ppu.cpp.s"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/ppu.cpp -o CMakeFiles/cpu.dir/ppu.cpp.s

cpu/CMakeFiles/cpu.dir/ppu.cpp.o.requires:
.PHONY : cpu/CMakeFiles/cpu.dir/ppu.cpp.o.requires

cpu/CMakeFiles/cpu.dir/ppu.cpp.o.provides: cpu/CMakeFiles/cpu.dir/ppu.cpp.o.requires
	$(MAKE) -f cpu/CMakeFiles/cpu.dir/build.make cpu/CMakeFiles/cpu.dir/ppu.cpp.o.provides.build
.PHONY : cpu/CMakeFiles/cpu.dir/ppu.cpp.o.provides

cpu/CMakeFiles/cpu.dir/ppu.cpp.o.provides.build: cpu/CMakeFiles/cpu.dir/ppu.cpp.o

cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o: cpu/CMakeFiles/cpu.dir/flags.make
cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o: /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/memory_manager.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/CMakeFiles $(CMAKE_PROGRESS_4)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/cpu.dir/memory_manager.cpp.o -c /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/memory_manager.cpp

cpu/CMakeFiles/cpu.dir/memory_manager.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/cpu.dir/memory_manager.cpp.i"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/memory_manager.cpp > CMakeFiles/cpu.dir/memory_manager.cpp.i

cpu/CMakeFiles/cpu.dir/memory_manager.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/cpu.dir/memory_manager.cpp.s"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/memory_manager.cpp -o CMakeFiles/cpu.dir/memory_manager.cpp.s

cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o.requires:
.PHONY : cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o.requires

cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o.provides: cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o.requires
	$(MAKE) -f cpu/CMakeFiles/cpu.dir/build.make cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o.provides.build
.PHONY : cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o.provides

cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o.provides.build: cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o

cpu/CMakeFiles/cpu.dir/instruction.cpp.o: cpu/CMakeFiles/cpu.dir/flags.make
cpu/CMakeFiles/cpu.dir/instruction.cpp.o: /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/instruction.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/CMakeFiles $(CMAKE_PROGRESS_5)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object cpu/CMakeFiles/cpu.dir/instruction.cpp.o"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/cpu.dir/instruction.cpp.o -c /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/instruction.cpp

cpu/CMakeFiles/cpu.dir/instruction.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/cpu.dir/instruction.cpp.i"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/instruction.cpp > CMakeFiles/cpu.dir/instruction.cpp.i

cpu/CMakeFiles/cpu.dir/instruction.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/cpu.dir/instruction.cpp.s"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu/instruction.cpp -o CMakeFiles/cpu.dir/instruction.cpp.s

cpu/CMakeFiles/cpu.dir/instruction.cpp.o.requires:
.PHONY : cpu/CMakeFiles/cpu.dir/instruction.cpp.o.requires

cpu/CMakeFiles/cpu.dir/instruction.cpp.o.provides: cpu/CMakeFiles/cpu.dir/instruction.cpp.o.requires
	$(MAKE) -f cpu/CMakeFiles/cpu.dir/build.make cpu/CMakeFiles/cpu.dir/instruction.cpp.o.provides.build
.PHONY : cpu/CMakeFiles/cpu.dir/instruction.cpp.o.provides

cpu/CMakeFiles/cpu.dir/instruction.cpp.o.provides.build: cpu/CMakeFiles/cpu.dir/instruction.cpp.o

# Object files for target cpu
cpu_OBJECTS = \
"CMakeFiles/cpu.dir/cpu.cpp.o" \
"CMakeFiles/cpu.dir/joystick.cpp.o" \
"CMakeFiles/cpu.dir/ppu.cpp.o" \
"CMakeFiles/cpu.dir/memory_manager.cpp.o" \
"CMakeFiles/cpu.dir/instruction.cpp.o"

# External object files for target cpu
cpu_EXTERNAL_OBJECTS =

cpu/libcpu.a: cpu/CMakeFiles/cpu.dir/cpu.cpp.o
cpu/libcpu.a: cpu/CMakeFiles/cpu.dir/joystick.cpp.o
cpu/libcpu.a: cpu/CMakeFiles/cpu.dir/ppu.cpp.o
cpu/libcpu.a: cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o
cpu/libcpu.a: cpu/CMakeFiles/cpu.dir/instruction.cpp.o
cpu/libcpu.a: cpu/CMakeFiles/cpu.dir/build.make
cpu/libcpu.a: cpu/CMakeFiles/cpu.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX static library libcpu.a"
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && $(CMAKE_COMMAND) -P CMakeFiles/cpu.dir/cmake_clean_target.cmake
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/cpu.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
cpu/CMakeFiles/cpu.dir/build: cpu/libcpu.a
.PHONY : cpu/CMakeFiles/cpu.dir/build

cpu/CMakeFiles/cpu.dir/requires: cpu/CMakeFiles/cpu.dir/cpu.cpp.o.requires
cpu/CMakeFiles/cpu.dir/requires: cpu/CMakeFiles/cpu.dir/joystick.cpp.o.requires
cpu/CMakeFiles/cpu.dir/requires: cpu/CMakeFiles/cpu.dir/ppu.cpp.o.requires
cpu/CMakeFiles/cpu.dir/requires: cpu/CMakeFiles/cpu.dir/memory_manager.cpp.o.requires
cpu/CMakeFiles/cpu.dir/requires: cpu/CMakeFiles/cpu.dir/instruction.cpp.o.requires
.PHONY : cpu/CMakeFiles/cpu.dir/requires

cpu/CMakeFiles/cpu.dir/clean:
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu && $(CMAKE_COMMAND) -P CMakeFiles/cpu.dir/cmake_clean.cmake
.PHONY : cpu/CMakeFiles/cpu.dir/clean

cpu/CMakeFiles/cpu.dir/depend:
	cd /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/src/cpu /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu /Users/admin/百度云同步盘/MyBook/Hardware/code/version_1_CLR-DEBUG/build/cpu/CMakeFiles/cpu.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : cpu/CMakeFiles/cpu.dir/depend

