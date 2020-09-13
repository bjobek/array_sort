connect -url tcp:127.0.0.1:3121
source /home/bjorn/Desktop/Lekekasse/Array_Sorting/bubble_sort_sw/design_1_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo 210279A42E56A"} -index 0
loadhw -hw /home/bjorn/Desktop/Lekekasse/Array_Sorting/bubble_sort_sw/design_1_wrapper_hw_platform_0/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zybo 210279A42E56A"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo 210279A42E56A"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo 210279A42E56A"} -index 0
dow /home/bjorn/Desktop/Lekekasse/Array_Sorting/bubble_sort_sw/bubble_sort_sw/Debug/bubble_sort_sw.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zybo 210279A42E56A"} -index 0
con
