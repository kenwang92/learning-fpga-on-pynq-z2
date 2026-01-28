set_property PACKAGE_PIN H16 [get_ports { Clk }]
set_property IOSTANDARD LVCMOS33 [get_ports { Clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 5} [get_ports { Clk }];

set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33 } [get_ports Reset_p];
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports i2c_sclk];
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports i2c_sdat];