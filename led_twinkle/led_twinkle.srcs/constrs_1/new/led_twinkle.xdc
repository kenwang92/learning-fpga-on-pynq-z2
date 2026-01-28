set_property PACKAGE_PIN H16 [get_ports { Clk }]
set_property IOSTANDARD LVCMOS33 [get_ports { Clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 5} [get_ports { Clk }];

set_property PACKAGE_PIN D19 [get_ports Reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports Reset_n]

set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports SW[0]];
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports SW[1]];
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports SW[2]];
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports SW[3]];
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports SW[4]];
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports SW[5]];
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports SW[6]];
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports SW[7]];

set_property PACKAGE_PIN R14 [get_ports Led]
set_property IOSTANDARD LVCMOS33 [get_ports Led]

#set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports Cycle];
 set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 } [get_ports Counter[0]];
 set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 } [get_ports Counter[1]];
 set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33 } [get_ports Counter[2]];
 set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33 } [get_ports Counter[3]];
 set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33 } [get_ports Counter[4]];
 set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports Counter[5]];
 set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports Counter[6]];
 set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports Counter[7]];
