set_property PACKAGE_PIN H16 [get_ports { Clk }]
set_property IOSTANDARD LVCMOS33 [get_ports { Clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 5} [get_ports { Clk }];

set_property PACKAGE_PIN D19 [get_ports Reset_p]
set_property IOSTANDARD LVCMOS33 [get_ports Reset_p]

set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS33 } [get_ports ADC_SCLK];
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33 } [get_ports ADC_DIN];
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33 } [get_ports ADC_CS_N];
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33 } [get_ports ADC_DOUT];

set_property PACKAGE_PIN R14 [get_ports Led]
set_property IOSTANDARD LVCMOS33 [get_ports Led]

 set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33 } [get_ports SW[0]];
 set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33 } [get_ports SW[1]];

 set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33 } [get_ports Key];
 set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports Uart_tx];
