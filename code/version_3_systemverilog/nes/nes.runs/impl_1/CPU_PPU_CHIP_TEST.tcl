proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config  -id {Vivado 12-172}  -suppress 
set_msg_config  -id {Wavedata 42-52}  -suppress 

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param gui.test TreeTableDev
  set_param xicom.use_bs_reader 1
  debug::add_scope template.lib 1
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.cache/wt [current_project]
  set_property parent.project_path C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.xpr [current_project]
  set_property ip_repo_paths c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.cache/ip [current_project]
  set_property ip_output_repo c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.cache/ip [current_project]
  add_files -quiet C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/synth_1/CPU_PPU_CHIP_TEST.dcp
  add_files -quiet C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/PROM_synth_1/PROM.dcp
  set_property netlist_only true [get_files C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/PROM_synth_1/PROM.dcp]
  add_files -quiet C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/PRAM_synth_1/PRAM.dcp
  set_property netlist_only true [get_files C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/PRAM_synth_1/PRAM.dcp]
  add_files -quiet C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/VROM_synth_1/VROM.dcp
  set_property netlist_only true [get_files C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/VROM_synth_1/VROM.dcp]
  add_files -quiet C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/OAM_synth_1/OAM.dcp
  set_property netlist_only true [get_files C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/OAM_synth_1/OAM.dcp]
  add_files -quiet C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/Palette_synth_1/Palette.dcp
  set_property netlist_only true [get_files C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/Palette_synth_1/Palette.dcp]
  add_files -quiet C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/COLOR_TABLE_synth_1/COLOR_TABLE.dcp
  set_property netlist_only true [get_files C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/COLOR_TABLE_synth_1/COLOR_TABLE.dcp]
  add_files -quiet C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/VRAM_synth_1/VRAM.dcp
  set_property netlist_only true [get_files C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/VRAM_synth_1/VRAM.dcp]
  read_xdc -mode out_of_context -ref PROM c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/PROM/PROM_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/PROM/PROM_ooc.xdc]
  read_xdc -mode out_of_context -ref PRAM -cells U0 c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/PRAM/PRAM_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/PRAM/PRAM_ooc.xdc]
  read_xdc -mode out_of_context -ref VROM c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VROM/VROM_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VROM/VROM_ooc.xdc]
  read_xdc -mode out_of_context -ref OAM c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/OAM/OAM_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/OAM/OAM_ooc.xdc]
  read_xdc -mode out_of_context -ref Palette c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/Palette/Palette_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/Palette/Palette_ooc.xdc]
  read_xdc -mode out_of_context -ref COLOR_TABLE c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/COLOR_TABLE/COLOR_TABLE_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/COLOR_TABLE/COLOR_TABLE_ooc.xdc]
  read_xdc -mode out_of_context -ref VRAM c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/sources_1/ip/VRAM/VRAM_ooc.xdc]
  read_xdc C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.srcs/constrs_1/imports/Doc/Nexys4_Master.xdc
  link_design -top CPU_PPU_CHIP_TEST -part xc7a100tcsg324-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force CPU_PPU_CHIP_TEST_opt.dcp
  catch {report_drc -file CPU_PPU_CHIP_TEST_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  place_design 
  write_checkpoint -force CPU_PPU_CHIP_TEST_placed.dcp
  catch { report_io -file CPU_PPU_CHIP_TEST_io_placed.rpt }
  catch { report_clock_utilization -file CPU_PPU_CHIP_TEST_clock_utilization_placed.rpt }
  catch { report_utilization -file CPU_PPU_CHIP_TEST_utilization_placed.rpt -pb CPU_PPU_CHIP_TEST_utilization_placed.pb }
  catch { report_control_sets -verbose -file CPU_PPU_CHIP_TEST_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force CPU_PPU_CHIP_TEST_routed.dcp
  catch { report_drc -file CPU_PPU_CHIP_TEST_drc_routed.rpt -pb CPU_PPU_CHIP_TEST_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file CPU_PPU_CHIP_TEST_timing_summary_routed.rpt -rpx CPU_PPU_CHIP_TEST_timing_summary_routed.rpx }
  catch { report_power -file CPU_PPU_CHIP_TEST_power_routed.rpt -pb CPU_PPU_CHIP_TEST_power_summary_routed.pb }
  catch { report_route_status -file CPU_PPU_CHIP_TEST_route_status.rpt -pb CPU_PPU_CHIP_TEST_route_status.pb }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force CPU_PPU_CHIP_TEST.bit 
  if { [file exists C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/synth_1/CPU_PPU_CHIP_TEST.hwdef] } {
    catch { write_sysdef -hwdef C:/Users/nfxz/Desktop/Project/FPGA/nes/nes.runs/synth_1/CPU_PPU_CHIP_TEST.hwdef -bitfile CPU_PPU_CHIP_TEST.bit -meminfo CPU_PPU_CHIP_TEST.mmi -file CPU_PPU_CHIP_TEST.sysdef }
  }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

