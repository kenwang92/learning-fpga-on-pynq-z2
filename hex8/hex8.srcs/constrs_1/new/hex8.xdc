set_property PACKAGE_PIN H16 [get_ports { Clk }]
set_property IOSTANDARD LVCMOS33 [get_ports { Clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 5} [get_ports { Clk }];

set_property PACKAGE_PIN D19 [get_ports Reset_p]
set_property IOSTANDARD LVCMOS33 [get_ports Reset_p]

# set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33 } [get_ports SW[0]];
# set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33 } [get_ports SW[1]];

 set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports SEG[0]];
 set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports SEG[1]];
 set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports SEG[2]];
 set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports SEG[3]];
 set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports SEG[4]];
 set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports SEG[5]];
 set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports SEG[6]];
 set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports SEG[7]];

 set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports SEL[0]];
 set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports SEL[1]];
 set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports SEL[2]];
 set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports SEL[3]];
 set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports SEL[4]];
 set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports SEL[5]];
 set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports SEL[6]];
 set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports SEL[7]];
 
 set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS33 } [get_ports SRCLK];
 set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33 } [get_ports RCLK];
 set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33 } [get_ports DIO];