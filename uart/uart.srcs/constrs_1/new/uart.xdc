set_property PACKAGE_PIN H16 [get_ports { Clk }]
set_property IOSTANDARD LVCMOS33 [get_ports { Clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 5} [get_ports { Clk }];

set_property PACKAGE_PIN D19 [get_ports Reset_p]
set_property IOSTANDARD LVCMOS33 [get_ports Reset_p]

# set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports Data[0]];
# set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports Data[1]];
# set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports Data[2]];
# set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports Data[3]];
# set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports Data[4]];
# set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33 } [get_ports Data[5]];
# set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33 } [get_ports Data[6]];
# set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports Data[7]];

set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33 } [get_ports Rx_Data[0]];
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports Rx_Data[1]];
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33 } [get_ports Rx_Data[2]];
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports Rx_Data[3]];
set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS33 } [get_ports Rx_Data[4]];
set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33 } [get_ports Rx_Data[5]];
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS33 } [get_ports Rx_Data[6]];
set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33 } [get_ports Rx_Data[7]];

set_property PACKAGE_PIN G17 [get_ports Led]
set_property IOSTANDARD LVCMOS33 [get_ports Led]

#  set_property -dict {PACKAGE_PIN U10 IOSTANDARD LVCMOS33 } [get_ports Uart_tx];
 set_property -dict {PACKAGE_PIN Y11 IOSTANDARD LVCMOS33 } [get_ports uart_rx];
