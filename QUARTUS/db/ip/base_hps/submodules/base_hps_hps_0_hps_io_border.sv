// (C) 2001-2018 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


module base_hps_hps_0_hps_io_border(
// memory
  output wire [15 - 1 : 0 ] mem_a
 ,output wire [3 - 1 : 0 ] mem_ba
 ,output wire [1 - 1 : 0 ] mem_ck
 ,output wire [1 - 1 : 0 ] mem_ck_n
 ,output wire [1 - 1 : 0 ] mem_cke
 ,output wire [1 - 1 : 0 ] mem_cs_n
 ,output wire [1 - 1 : 0 ] mem_ras_n
 ,output wire [1 - 1 : 0 ] mem_cas_n
 ,output wire [1 - 1 : 0 ] mem_we_n
 ,output wire [1 - 1 : 0 ] mem_reset_n
 ,inout wire [32 - 1 : 0 ] mem_dq
 ,inout wire [4 - 1 : 0 ] mem_dqs
 ,inout wire [4 - 1 : 0 ] mem_dqs_n
 ,output wire [1 - 1 : 0 ] mem_odt
 ,output wire [4 - 1 : 0 ] mem_dm
 ,input wire [1 - 1 : 0 ] oct_rzqin
// hps_io
 ,output wire [1 - 1 : 0 ] hps_io_emac0_inst_TX_CLK
 ,output wire [1 - 1 : 0 ] hps_io_emac0_inst_TXD0
 ,output wire [1 - 1 : 0 ] hps_io_emac0_inst_TXD1
 ,output wire [1 - 1 : 0 ] hps_io_emac0_inst_TXD2
 ,output wire [1 - 1 : 0 ] hps_io_emac0_inst_TXD3
 ,input wire [1 - 1 : 0 ] hps_io_emac0_inst_RXD0
 ,inout wire [1 - 1 : 0 ] hps_io_emac0_inst_MDIO
 ,output wire [1 - 1 : 0 ] hps_io_emac0_inst_MDC
 ,input wire [1 - 1 : 0 ] hps_io_emac0_inst_RX_CTL
 ,output wire [1 - 1 : 0 ] hps_io_emac0_inst_TX_CTL
 ,input wire [1 - 1 : 0 ] hps_io_emac0_inst_RX_CLK
 ,input wire [1 - 1 : 0 ] hps_io_emac0_inst_RXD1
 ,input wire [1 - 1 : 0 ] hps_io_emac0_inst_RXD2
 ,input wire [1 - 1 : 0 ] hps_io_emac0_inst_RXD3
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_CMD
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_D0
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_D1
 ,output wire [1 - 1 : 0 ] hps_io_sdio_inst_CLK
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_D2
 ,inout wire [1 - 1 : 0 ] hps_io_sdio_inst_D3
 ,input wire [1 - 1 : 0 ] hps_io_uart0_inst_RX
 ,output wire [1 - 1 : 0 ] hps_io_uart0_inst_TX
);

assign hps_io_emac0_inst_MDIO = intermediate[1] ? intermediate[0] : 'z;
assign hps_io_sdio_inst_CMD = intermediate[3] ? intermediate[2] : 'z;
assign hps_io_sdio_inst_D0 = intermediate[5] ? intermediate[4] : 'z;
assign hps_io_sdio_inst_D1 = intermediate[7] ? intermediate[6] : 'z;
assign hps_io_sdio_inst_D2 = intermediate[9] ? intermediate[8] : 'z;
assign hps_io_sdio_inst_D3 = intermediate[11] ? intermediate[10] : 'z;

wire [12 - 1 : 0] intermediate;

cyclonev_hps_peripheral_emac emac0_inst(
 .EMAC_GMII_MDO_I({
    hps_io_emac0_inst_MDIO[0:0] // 0:0
  })
,.EMAC_GMII_MDO_OE({
    intermediate[1:1] // 0:0
  })
,.EMAC_PHY_TXD({
    hps_io_emac0_inst_TXD3[0:0] // 3:3
   ,hps_io_emac0_inst_TXD2[0:0] // 2:2
   ,hps_io_emac0_inst_TXD1[0:0] // 1:1
   ,hps_io_emac0_inst_TXD0[0:0] // 0:0
  })
,.EMAC_CLK_TX({
    hps_io_emac0_inst_TX_CLK[0:0] // 0:0
  })
,.EMAC_PHY_RXDV({
    hps_io_emac0_inst_RX_CTL[0:0] // 0:0
  })
,.EMAC_PHY_RXD({
    hps_io_emac0_inst_RXD3[0:0] // 3:3
   ,hps_io_emac0_inst_RXD2[0:0] // 2:2
   ,hps_io_emac0_inst_RXD1[0:0] // 1:1
   ,hps_io_emac0_inst_RXD0[0:0] // 0:0
  })
,.EMAC_GMII_MDO_O({
    intermediate[0:0] // 0:0
  })
,.EMAC_GMII_MDC({
    hps_io_emac0_inst_MDC[0:0] // 0:0
  })
,.EMAC_PHY_TX_OE({
    hps_io_emac0_inst_TX_CTL[0:0] // 0:0
  })
,.EMAC_CLK_RX({
    hps_io_emac0_inst_RX_CLK[0:0] // 0:0
  })
);


cyclonev_hps_peripheral_sdmmc sdio_inst(
 .SDMMC_DATA_I({
    hps_io_sdio_inst_D3[0:0] // 3:3
   ,hps_io_sdio_inst_D2[0:0] // 2:2
   ,hps_io_sdio_inst_D1[0:0] // 1:1
   ,hps_io_sdio_inst_D0[0:0] // 0:0
  })
,.SDMMC_CMD_O({
    intermediate[2:2] // 0:0
  })
,.SDMMC_CCLK({
    hps_io_sdio_inst_CLK[0:0] // 0:0
  })
,.SDMMC_DATA_O({
    intermediate[10:10] // 3:3
   ,intermediate[8:8] // 2:2
   ,intermediate[6:6] // 1:1
   ,intermediate[4:4] // 0:0
  })
,.SDMMC_CMD_OE({
    intermediate[3:3] // 0:0
  })
,.SDMMC_CMD_I({
    hps_io_sdio_inst_CMD[0:0] // 0:0
  })
,.SDMMC_DATA_OE({
    intermediate[11:11] // 3:3
   ,intermediate[9:9] // 2:2
   ,intermediate[7:7] // 1:1
   ,intermediate[5:5] // 0:0
  })
);


cyclonev_hps_peripheral_uart uart0_inst(
 .UART_RXD({
    hps_io_uart0_inst_RX[0:0] // 0:0
  })
,.UART_TXD({
    hps_io_uart0_inst_TX[0:0] // 0:0
  })
);


hps_sdram hps_sdram_inst(
 .mem_dq({
    mem_dq[31:0] // 31:0
  })
,.mem_odt({
    mem_odt[0:0] // 0:0
  })
,.mem_ras_n({
    mem_ras_n[0:0] // 0:0
  })
,.mem_dqs_n({
    mem_dqs_n[3:0] // 3:0
  })
,.mem_dqs({
    mem_dqs[3:0] // 3:0
  })
,.mem_dm({
    mem_dm[3:0] // 3:0
  })
,.mem_we_n({
    mem_we_n[0:0] // 0:0
  })
,.mem_cas_n({
    mem_cas_n[0:0] // 0:0
  })
,.mem_ba({
    mem_ba[2:0] // 2:0
  })
,.mem_a({
    mem_a[14:0] // 14:0
  })
,.mem_cs_n({
    mem_cs_n[0:0] // 0:0
  })
,.mem_ck({
    mem_ck[0:0] // 0:0
  })
,.mem_cke({
    mem_cke[0:0] // 0:0
  })
,.oct_rzqin({
    oct_rzqin[0:0] // 0:0
  })
,.mem_reset_n({
    mem_reset_n[0:0] // 0:0
  })
,.mem_ck_n({
    mem_ck_n[0:0] // 0:0
  })
);

endmodule

