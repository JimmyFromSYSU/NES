# 
# Synthesis run script generated by Vivado
# 

set_param gui.test TreeTableDev
set_param xicom.use_bs_reader 1
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

create_project -in_memory -part xc7a100tcsg324-1
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.cache/wt [current_project]
set_property parent.project_path C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_ip C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM.xci
set_property used_in_implementation false [get_files -all c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM.dcp]
set_property is_locked true [get_files C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM.xci]

catch { write_hwdef -file VRAM.hwdef }
synth_design -top VRAM -part xc7a100tcsg324-1 -mode out_of_context
rename_ref -prefix_all VRAM_
write_checkpoint -noxdef VRAM.dcp
catch { report_utilization -file VRAM_utilization_synth.rpt -pb VRAM_utilization_synth.pb }
if { [catch {
  file copy -force C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/VRAM_synth_1/VRAM.dcp C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM.dcp
} _RESULT ] } { 
  error "ERROR: Unable to successfully create or copy the sub-design checkpoint file."
}
if { [catch {
  write_verilog -force -mode synth_stub C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM_stub.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a Verilog synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode synth_stub C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM_stub.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create a VHDL synthesis stub for the sub-design. This may lead to errors in top level synthesis of the design. Error reported: $_RESULT"
}
if { [catch {
  write_verilog -force -mode funcsim C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM_funcsim.v
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the Verilog functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}
if { [catch {
  write_vhdl -force -mode funcsim C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM_funcsim.vhdl
} _RESULT ] } { 
  puts "CRITICAL WARNING: Unable to successfully create the VHDL functional simulation sub-design file. Post-Synthesis Functional Simulation with this file may not be possible or may give incorrect results. Error reported: $_RESULT"
}
