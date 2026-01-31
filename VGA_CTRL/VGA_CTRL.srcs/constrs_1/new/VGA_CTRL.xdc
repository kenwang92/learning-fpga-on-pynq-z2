set_property PACKAGE_PIN H16 [get_ports { Clk }]
set_property IOSTANDARD LVCMOS33 [get_ports { Clk }]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { Clk }];

set_property PACKAGE_PIN D19 [get_ports Reset_p]
set_property IOSTANDARD LVCMOS33 [get_ports Reset_p]

#  set_property -dict { PACKAGE_PIN L17   IOSTANDARD TMDS_33  } [get_ports { hdmi_clk_n }]; #IO_L11N_T1_SRCC_35 Sch=hdmi_tx_clk_n
#  set_property -dict { PACKAGE_PIN L16   IOSTANDARD TMDS_33  } [get_ports { hdmi_clk_p }]; #IO_L11P_T1_SRCC_35 Sch=hdmi_tx_clk_p
#  set_property -dict { PACKAGE_PIN K18   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_n[0] }]; #IO_L12N_T1_MRCC_35 Sch=hdmi_tx_d_n[0]
#  set_property -dict { PACKAGE_PIN K17   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_p[0] }]; #IO_L12P_T1_MRCC_35 Sch=hdmi_tx_d_p[0]
#  set_property -dict { PACKAGE_PIN J19   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_n[1] }]; #IO_L10N_T1_AD11N_35 Sch=hdmi_tx_d_n[1]
#  set_property -dict { PACKAGE_PIN K19   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_p[1] }]; #IO_L10P_T1_AD11P_35 Sch=hdmi_tx_d_p[1]
#  set_property -dict { PACKAGE_PIN H18   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_n[2] }]; #IO_L14N_T2_AD4N_SRCC_35 Sch=hdmi_tx_d_n[2]
#  set_property -dict { PACKAGE_PIN J18   IOSTANDARD TMDS_33  } [get_ports { hdmi_tx_p[2] }]; #IO_L14P_T2_AD4P_SRCC_35 Sch=hdmi_tx_d_p[2]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33  } [get_ports { disp_red[0] }];
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33  } [get_ports { disp_red[1] }];
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33  } [get_ports { disp_red[2] }];
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33  } [get_ports { disp_red[3] }];

set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33  } [get_ports { disp_green[0] }];
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33  } [get_ports { disp_green[1] }];
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33  } [get_ports { disp_green[2] }];
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33  } [get_ports { disp_green[3] }];

set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33  } [get_ports { disp_blue[0] }];
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33  } [get_ports { disp_blue[1] }];
set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33  } [get_ports { disp_blue[2] }];
set_property -dict { PACKAGE_PIN Y17   IOSTANDARD LVCMOS33  } [get_ports { disp_blue[3] }];
set_property -dict { PACKAGE_PIN T11  IOSTANDARD LVCMOS33  } [get_ports { DISP_HS }];
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33  } [get_ports { DISP_VS }];

#set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33 } [get_ports Key[0]];
#set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33 } [get_ports Key[1]];

#  set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33 } [get_ports SW[0]];
#  set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33 } [get_ports SW[1]];
#  set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports SW[2]];
#  set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports SW[3]];
#  set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports SW[4]];
#  set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports SW[5]];
#  set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports SW[6]];
#  set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports SW[7]];