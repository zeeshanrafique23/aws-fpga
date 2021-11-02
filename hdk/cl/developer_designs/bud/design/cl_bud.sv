// Amazon FPGA Hardware Development Kit
//
// Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License"). You may not use
// this file except in compliance with the License. A copy of the License is
// located at
//
//    http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
// implied. See the License for the specific language governing permissions and
// limitations under the License.

module cl_bud #(parameter NUM_PCIE=1, parameter NUM_DDR=4, parameter NUM_HMC=4, parameter NUM_GTY = 4) 

(
   `include "cl_ports.vh" // Fixed port definition

);

   `include "cl_common_defines.vh"      // CL Defines for all examples

   // Stubed Out
   //--------------------------------------------0
   // Start with Tie-Off of Unused Interfaces
   //---------------------------------------------
   // the developer should use the next set of `include
   // to properly tie-off any unused interface
   // The list is put in the top of the module
   // to avoid cases where developer may forget to
   // remove it from the end of the file

   // `include "unused_flr_template.inc"
   // `include "unused_ddr_a_b_d_template.inc"
   // `include "unused_ddr_c_template.inc"
   // `include "unused_pcim_template.inc"
   // `include "unused_dma_pcis_template.inc"
   // `include "unused_cl_sda_template.inc"
   // `include "unused_apppf_irq_template.inc"
   // `include "unused_sh_ocl_template.inc"

   localparam NUM_CFG_STGS_INT_TST = 4;
   localparam NUM_CFG_STGS_HMC_ATG = 4;
   localparam NUM_CFG_STGS_CL_DDR_ATG = 4;
   localparam NUM_CFG_STGS_SH_DDR_ATG = 4;
   localparam NUM_CFG_STGS_PCIE_ATG = 4;
   localparam NUM_CFG_STGS_AURORA_ATG = 4;
   localparam NUM_CFG_STGS_XDCFG = 4;
   localparam NUM_CFG_STGS_XDMA = 4;
   
`ifdef SIM
   localparam DDR_SCRB_MAX_ADDR = 64'h1FFF;
   localparam HMC_SCRB_MAX_ADDR = 64'h7FF;
`else   
   localparam DDR_SCRB_MAX_ADDR = 64'h3FFFFFFFF; //16GB 
   localparam HMC_SCRB_MAX_ADDR = 64'h7FFFFFFF;  // 2GB
`endif
   localparam DDR_SCRB_BURST_LEN_MINUS1 = 15;
   localparam HMC_SCRB_BURST_LEN_MINUS1 = 3;

//-------------------------------------------------
// Reset Synchronization
//-------------------------------------------------
logic pre_sync_rst_n;
logic sync_rst_n;
   
always_ff @(negedge rst_main_n or posedge clk)
   if (!rst_main_n)
   begin
      pre_sync_rst_n <= 0;
      sync_rst_n <= 0;
   end
   else
   begin
      pre_sync_rst_n <= 1;
      sync_rst_n <= pre_sync_rst_n;
   end
/*
//----------------------------------------- 
// DDR controller instantiation   
//----------------------------------------- 
// All designs should instantiate the sh_ddr module even if not utilizing the
// DDR controllers. It must be instantiated in order to prevent build errors
// related to DDR pin constraints.

// Only the DDR pins are connected. The AXI and stats interfaces are tied-off.

sh_ddr #(.DDR_A_PRESENT(0),
         .DDR_B_PRESENT(0),
         .DDR_D_PRESENT(0)) SH_DDR
   (
   .clk(clk),
   .rst_n(sync_rst_n),

   .stat_clk(clk),
   .stat_rst_n(sync_rst_n),


   .CLK_300M_DIMM0_DP(CLK_300M_DIMM0_DP),
   .CLK_300M_DIMM0_DN(CLK_300M_DIMM0_DN),
   .M_A_ACT_N(M_A_ACT_N),
   .M_A_MA(M_A_MA),
   .M_A_BA(M_A_BA),
   .M_A_BG(M_A_BG),
   .M_A_CKE(M_A_CKE),
   .M_A_ODT(M_A_ODT),
   .M_A_CS_N(M_A_CS_N),
   .M_A_CLK_DN(M_A_CLK_DN),
   .M_A_CLK_DP(M_A_CLK_DP),
   .M_A_PAR(M_A_PAR),
   .M_A_DQ(M_A_DQ),
   .M_A_ECC(M_A_ECC),
   .M_A_DQS_DP(M_A_DQS_DP),
   .M_A_DQS_DN(M_A_DQS_DN),
   .cl_RST_DIMM_A_N(RST_DIMM_A_N),

   
   .CLK_300M_DIMM1_DP(CLK_300M_DIMM1_DP),
   .CLK_300M_DIMM1_DN(CLK_300M_DIMM1_DN),
   .M_B_ACT_N(M_B_ACT_N),
   .M_B_MA(M_B_MA),
   .M_B_BA(M_B_BA),
   .M_B_BG(M_B_BG),
   .M_B_CKE(M_B_CKE),
   .M_B_ODT(M_B_ODT),
   .M_B_CS_N(M_B_CS_N),
   .M_B_CLK_DN(M_B_CLK_DN),
   .M_B_CLK_DP(M_B_CLK_DP),
   .M_B_PAR(M_B_PAR),
   .M_B_DQ(M_B_DQ),
   .M_B_ECC(M_B_ECC),
   .M_B_DQS_DP(M_B_DQS_DP),
   .M_B_DQS_DN(M_B_DQS_DN),
   .cl_RST_DIMM_B_N(RST_DIMM_B_N),

   .CLK_300M_DIMM3_DP(CLK_300M_DIMM3_DP),
   .CLK_300M_DIMM3_DN(CLK_300M_DIMM3_DN),
   .M_D_ACT_N(M_D_ACT_N),
   .M_D_MA(M_D_MA),
   .M_D_BA(M_D_BA),
   .M_D_BG(M_D_BG),
   .M_D_CKE(M_D_CKE),
   .M_D_ODT(M_D_ODT),
   .M_D_CS_N(M_D_CS_N),
   .M_D_CLK_DN(M_D_CLK_DN),
   .M_D_CLK_DP(M_D_CLK_DP),
   .M_D_PAR(M_D_PAR),
   .M_D_DQ(M_D_DQ),
   .M_D_ECC(M_D_ECC),
   .M_D_DQS_DP(M_D_DQS_DP),
   .M_D_DQS_DN(M_D_DQS_DN),
   .cl_RST_DIMM_D_N(RST_DIMM_D_N),

   //------------------------------------------------------
   // DDR-4 Interface from CL (AXI-4)
   //------------------------------------------------------
   .cl_sh_ddr_awid     (tie_zero_id),
   .cl_sh_ddr_awaddr   (tie_zero_addr),
   .cl_sh_ddr_awlen    (tie_zero_len),
   .cl_sh_ddr_awsize   (tie_zero),
   .cl_sh_ddr_awvalid  (tie_zero),
   .cl_sh_ddr_awburst  (tie_zero),
   .sh_cl_ddr_awready  (),

   .cl_sh_ddr_wid      (tie_zero_id),
   .cl_sh_ddr_wdata    (tie_zero_data),
   .cl_sh_ddr_wstrb    (tie_zero_strb),
   .cl_sh_ddr_wlast    (3'b0),
   .cl_sh_ddr_wvalid   (3'b0),
   .sh_cl_ddr_wready   (),

   .sh_cl_ddr_bid      (),
   .sh_cl_ddr_bresp    (),
   .sh_cl_ddr_bvalid   (),
   .cl_sh_ddr_bready   (3'b0),

   .cl_sh_ddr_arid     (tie_zero_id),
   .cl_sh_ddr_araddr   (tie_zero_addr),
   .cl_sh_ddr_arlen    (tie_zero_len),
   .cl_sh_ddr_arsize   (tie_zero),
   .cl_sh_ddr_arvalid  (3'b0),
   .cl_sh_ddr_arburst  (tie_zero),
   .sh_cl_ddr_arready  (),

   .sh_cl_ddr_rid      (),
   .sh_cl_ddr_rdata    (),
   .sh_cl_ddr_rresp    (),
   .sh_cl_ddr_rlast    (),
   .sh_cl_ddr_rvalid   (),
   .cl_sh_ddr_rready   (3'b0),

   .sh_cl_ddr_is_ready (),

   .sh_ddr_stat_addr0   (tie_zero_stat_addr),
   .sh_ddr_stat_wr0     (3'b0), 
   .sh_ddr_stat_rd0     (3'b0), 
   .sh_ddr_stat_wdata0  (tie_zero_stat_data),
   .ddr_sh_stat_ack0    (),
   .ddr_sh_stat_rdata0  (),
   .ddr_sh_stat_int0    (),

   .sh_ddr_stat_addr1  (tie_zero_stat_addr) ,
   .sh_ddr_stat_wr1    (3'b0) , 
   .sh_ddr_stat_rd1    (3'b0) , 
   .sh_ddr_stat_wdata1 (tie_zero_stat_data) , 
   .ddr_sh_stat_ack1   () ,
   .ddr_sh_stat_rdata1 (),
   .ddr_sh_stat_int1   (),

   .sh_ddr_stat_addr2  (tie_zero_stat_addr) ,
   .sh_ddr_stat_wr2    (3'b0) , 
   .sh_ddr_stat_rd2    (3'b0) , 
   .sh_ddr_stat_wdata2 (tie_zero_stat_data) , 
   .ddr_sh_stat_ack2   () ,
   .ddr_sh_stat_rdata2 (),
   .ddr_sh_stat_int2   () 
   );

//-------------------------------------------
// Tie-Off Global Signals
//-------------------------------------------
`ifndef CL_VERSION
   `define CL_VERSION 32'hee_ee_ee_00
`endif  

   assign cl_sh_flr_done        = 1'b0;
   assign cl_sh_id0[31:0]       = 32'h0000_0000;
   assign cl_sh_id1[31:0]       = 32'h0000_0000;
   assign cl_sh_status0[31:0]   = 32'h0000_0000;
   assign cl_sh_status1[31:0]   = `CL_VERSION;

//------------------------------------
// Tie-Off Unused AXI Interfaces
//------------------------------------

   // PCIe Interface from SH to CL
   assign cl_sh_pcis_awready[0] =   1'b0;
                                    
   assign cl_sh_pcis_wready[0]  =   1'b0;
                                    
   assign cl_sh_pcis_bresp[0]   =   2'b0;
   assign cl_sh_pcis_bid[0]     =   5'b0;
   assign cl_sh_pcis_bvalid[0]  =   1'b0;
                                    
   assign cl_sh_pcis_arready[0] =   1'b0;

   assign cl_sh_pcis_rdata[0]   = 512'b0;
   assign cl_sh_pcis_rresp[0]   =   2'b0;
   assign cl_sh_pcis_rid[0]     =   5'b0;
   assign cl_sh_pcis_rlast[0]   =   1'b0;
   assign cl_sh_pcis_rvalid[0]  =   1'b0;

   // PCIe Interface from CL to SH
   assign cl_sh_pcim_awid[0]    =   5'b0;
   assign cl_sh_pcim_awaddr[0]  =  64'b0;
   assign cl_sh_pcim_awlen[0]   =   8'b0;
   assign cl_sh_pcim_awuser[0]  =  19'b0;
   assign cl_sh_pcim_awvalid[0] =   1'b0;
                                   
   assign cl_sh_pcim_wdata[0]   = 512'b0;
   assign cl_sh_pcim_wstrb[0]   =  64'b0;
   assign cl_sh_pcim_wlast[0]   =   1'b0;
   assign cl_sh_pcim_wvalid[0]  =   1'b0;
                                    
   assign cl_sh_pcim_bready[0]  =   1'b0;
                                    
   assign cl_sh_pcim_arid[0]    =   5'b0;
   assign cl_sh_pcim_araddr[0]  =  64'b0;
   assign cl_sh_pcim_arlen[0]   =   8'b0;
   assign cl_sh_pcim_aruser[0]  =  19'b0;
   assign cl_sh_pcim_arvalid[0] =   1'b0;
                                    
   assign cl_sh_pcim_rready[0]  =   1'b0;

   // DDRC Interface from CL to SH
   assign ddr_sh_stat_ack[2:0]  =   3'b111; // Needed in order not to hang the interface
   assign ddr_sh_stat_rdata[2]  =  32'b0;
   assign ddr_sh_stat_rdata[1]  =  32'b0;
   assign ddr_sh_stat_rdata[0]  =  32'b0;
   assign ddr_sh_stat_int[2]    =   8'b0;
   assign ddr_sh_stat_int[1]    =   8'b0;
   assign ddr_sh_stat_int[0]    =   8'b0;
                                   
   assign cl_sh_ddr_awid        =   6'b0;
   assign cl_sh_ddr_awaddr      =  64'b0;
   assign cl_sh_ddr_awlen       =   8'b0;
   assign cl_sh_ddr_awvalid     =   1'b0;
                                
   assign cl_sh_ddr_wid         =   6'b0;
   assign cl_sh_ddr_wdata       = 512'b0;
   assign cl_sh_ddr_wstrb       =  64'b0;
   assign cl_sh_ddr_wlast       =   1'b0;
   assign cl_sh_ddr_wvalid      =   1'b0;
                                
   assign cl_sh_ddr_bready      =   1'b0;
                                
   assign cl_sh_ddr_arid        =   6'b0;
   assign cl_sh_ddr_araddr      =  64'b0;
   assign cl_sh_ddr_arlen       =   8'b0;
   assign cl_sh_ddr_arvalid     =   1'b0;
                                
   assign cl_sh_ddr_rready      =   1'b0;

  // Tie-off AXI interfaces to sh_ddr module
  assign tie_zero[2]      = 1'b0;
  assign tie_zero[1]      = 1'b0;
  assign tie_zero[0]      = 1'b0;
                          
  assign tie_zero_id[2]   = 6'b0;
  assign tie_zero_id[1]   = 6'b0;
  assign tie_zero_id[0]   = 6'b0;

  assign tie_zero_addr[2] = 64'b0;
  assign tie_zero_addr[1] = 64'b0;
  assign tie_zero_addr[0] = 64'b0;

  assign tie_zero_len[2]  = 8'b0;
  assign tie_zero_len[1]  = 8'b0;
  assign tie_zero_len[0]  = 8'b0;

  assign tie_zero_data[2] = 512'b0;
  assign tie_zero_data[1] = 512'b0;
  assign tie_zero_data[0] = 512'b0;

  assign tie_zero_strb[2] = 64'b0;
  assign tie_zero_strb[1] = 64'b0;
  assign tie_zero_strb[0] = 64'b0;

//------------------------------------
// Tie-Off HMC Interfaces
//------------------------------------

   assign hmc_iic_scl_o            =  1'b0;
   assign hmc_iic_scl_t            =  1'b0;
   assign hmc_iic_sda_o            =  1'b0;
   assign hmc_iic_sda_t            =  1'b0;

   assign hmc_sh_stat_ack          =  1'b0;
   assign hmc_sh_stat_rdata[31:0]  = 32'b0;

   assign hmc_sh_stat_int[7:0]     =  8'b0;

//------------------------------------
// Tie-Off Aurora Interfaces
//------------------------------------
   assign aurora_sh_stat_ack   =  1'b0;
   assign aurora_sh_stat_rdata = 32'b0;
   assign aurora_sh_stat_int   =  8'b0;
*/
//------------------------------------
// CL BUD logic
//------------------------------------
   // Write address
   logic [ 3:0] m0_axi_awid;
   logic [31:0] m0_axi_awaddr;
   logic [ 7:0] m0_axi_awlen;
   logic [ 2:0] m0_axi_awsize;
   logic [ 1:0] m0_axi_awburst;
   logic        m0_axi_awvalid;
   logic        m0_axi_awready;
 
   // Write data
   logic [63:0] m0_axi_wdata;
   logic [ 7:0] m0_axi_wstrb;
   logic        m0_axi_wlast; 
   logic        m0_axi_wvalid;
   logic        m0_axi_wready;
 
   // Write response
   logic [ 3:0] m0_axi_bid;
   logic [ 1:0] m0_axi_bresp;
   logic        m0_axi_bvalid;
   logic        m0_axi_bready;
 
   // Read address
   logic [ 3:0] m0_axi_arid;
   logic [31:0] m0_axi_araddr;
   logic [ 7:0] m0_axi_arlen;
   logic [ 2:0] m0_axi_arsize;
   logic [ 1:0] m0_axi_arburst;
   logic        m0_axi_arvalid;
   logic        m0_axi_arready;
 
   // Read data/response
   logic [ 3:0] m0_axi_rid;
   logic [63:0] m0_axi_rdata;
   logic [ 1:0] m0_axi_rresp;
   logic        m0_axi_rlast;
   logic        m0_axi_rvalid;
   logic        m0_axi_rready;

   /* Memory signals */
   logic        rsta_busy;
   logic        rstb_busy;

   // Write address
   logic [ 3:0] s0_axi_awid;
   logic [31:0] s0_axi_awaddr;
   logic [ 7:0] s0_axi_awlen;
   logic [ 2:0] s0_axi_awsize;
   logic [ 1:0] s0_axi_awburst;
   logic        s0_axi_awvalid;
   logic        s0_axi_awready;
 
   // Write data
   logic [63:0] s0_axi_wdata;
   logic [ 7:0] s0_axi_wstrb;
   logic        s0_axi_wlast; 
   logic        s0_axi_wvalid;
   logic        s0_axi_wready;
 
   // Write response
   logic [ 3:0] s0_axi_bid;
   logic [ 1:0] s0_axi_bresp;
   logic        s0_axi_bvalid;
   logic        s0_axi_bready;
 
   // Read address
   logic [ 3:0] s0_axi_arid;
   logic [31:0] s0_axi_araddr;
   logic [ 7:0] s0_axi_arlen;
   logic [ 2:0] s0_axi_arsize;
   logic [ 1:0] s0_axi_arburst;
   logic        s0_axi_arvalid;
   logic        s0_axi_arready;
 
   // Read data/response
   logic [ 3:0] s0_axi_rid;
   logic [63:0] s0_axi_rdata;
   logic [ 1:0] s0_axi_rresp;
   logic        s0_axi_rlast;
   logic        s0_axi_rvalid;
   logic        s0_axi_rready;

   // Master 1 //
   logic [31:0] m1_axi_awaddr;
   logic [ 7:0] m1_axi_awlen;
   logic [ 2:0] m1_axi_awsize;
   logic [ 1:0] m1_axi_awburst;
   logic        m1_axi_awvalid;
   logic        m1_axi_awready;
   logic [63:0] m1_axi_wdata;
   logic [ 7:0] m1_axi_wstrb;
   logic        m1_axi_wlast;
   logic        m1_axi_wvalid;
   logic        m1_axi_wready;
   logic [ 1:0] m1_axi_bresp;
   logic        m1_axi_bvalid;
   logic        m1_axi_bready;
   logic [31:0] m1_axi_araddr;
   logic [ 7:0] m1_axi_arlen;
   logic [ 2:0] m1_axi_arsize;
   logic [ 1:0] m1_axi_arburst;
   logic        m1_axi_arvalid;
   logic        m1_axi_arready;
   logic [63:0] m1_axi_rdata;
   logic [1:0]  m1_axi_rresp;
   logic        m1_axi_rlast;
   logic        m1_axi_rvalid;
   logic        m1_axi_rready;

   // Slave 1 //
   logic [31:0] s1_axi_awaddr;
   logic [ 7:0] s1_axi_awlen;
   logic [ 2:0] s1_axi_awsize;
   logic [ 1:0] s1_axi_awburst;
   logic        s1_axi_awvalid;
   logic        s1_axi_awready;
   logic [63:0] s1_axi_wdata;
   logic [ 7:0] s1_axi_wstrb;
   logic        s1_axi_wlast;
   logic        s1_axi_wvalid;
   logic        s1_axi_wready;
   logic [ 1:0] s1_axi_bresp;
   logic        s1_axi_bvalid;
   logic        s1_axi_bready;
   logic [31:0] s1_axi_araddr;
   logic [ 7:0] s1_axi_arlen;
   logic [ 2:0] s1_axi_arsize;
   logic [ 1:0] s1_axi_arburst;
   logic        s1_axi_arvalid;
   logic        s1_axi_arready;
   logic [63:0] s1_axi_rdata;
   logic [1:0]  s1_axi_rresp;
   logic        s1_axi_rlast;
   logic        s1_axi_rvalid;
   logic        s1_axi_rready;

   cl_axil_to_axi bud_bridge(
     /* Master Interface (AXI-L) */
     // Write address
     .m_sh_bar1_awvalid ( sh_bar1_awvalid ),
     .m_sh_bar1_awaddr  ( sh_bar1_awaddr  ),
     .m_bar1_sh_awready ( bar1_sh_awready ),
                                                                                                                                 
     // Write data                                                                                                                
     .m_sh_bar1_wvalid  ( sh_bar1_wvalid  ),
     .m_sh_bar1_wdata   ( sh_bar1_wdata   ),
     .m_sh_bar1_wstrb   ( sh_bar1_wstrb   ),
     .m_bar1_sh_wready  ( bar1_sh_wready  ),
                                                                                                                                 
     // Write response                                                                                                            
     .m_bar1_sh_bvalid  ( bar1_sh_bvalid  ),
     .m_bar1_sh_bresp   ( bar1_sh_bresp   ),
     .m_sh_bar1_bready  ( sh_bar1_bready  ),
                                                                                                                                 
     // Read address                                                                                                              
     .m_sh_bar1_arvalid ( sh_bar1_arvalid ),
     .m_sh_bar1_araddr  ( sh_bar1_araddr  ),
     .m_bar1_sh_arready ( bar1_sh_arready ),
                                                                                                                                 
     // Read data/response                                                                                                        
     .m_bar1_sh_rvalid  ( bar1_sh_rvalid  ),
     .m_bar1_sh_rdata   ( bar1_sh_rdata   ),
     .m_bar1_sh_rresp   ( bar1_sh_rresp   ),                                                                                                                            
     .m_sh_bar1_rready  ( sh_bar1_rready  ),
   
     /* Slave Interface (AXI-4) */
     .rsta_busy         ( rsta_busy       ),
     .rstb_busy         ( rstb_busy       ),
   
     // Write address
     .m_axi_awid        ( m0_axi_awid      ), 
     .m_axi_awaddr      ( m0_axi_awaddr    ),
     .m_axi_awlen       ( m0_axi_awlen     ),
     .m_axi_awsize      ( m0_axi_awsize    ),
     .m_axi_awburst     ( m0_axi_awburst   ),
     .m_axi_awvalid     ( m0_axi_awvalid   ),
     .m_axi_awready     ( m0_axi_awready   ),
   
     // Write data
     .m_axi_wdata       ( m0_axi_wdata     ),
     .m_axi_wstrb       ( m0_axi_wstrb     ),
     .m_axi_wlast       ( m0_axi_wlast     ),  
     .m_axi_wvalid      ( m0_axi_wvalid    ),
     .m_axi_wready      ( m0_axi_wready    ),
   
     // Write response
     .m_axi_bid         ( m0_axi_bid       ),
     .m_axi_bresp       ( m0_axi_bresp     ),
     .m_axi_bvalid      ( m0_axi_bvalid    ),
     .m_axi_bready      ( m0_axi_bready    ),
   
     // Read address
     .m_axi_arid        ( m0_axi_arid      ), 
     .m_axi_araddr      ( m0_axi_araddr    ),
     .m_axi_arlen       ( m0_axi_arlen     ),
     .m_axi_arsize      ( m0_axi_arsize    ),
     .m_axi_arburst     ( m0_axi_arburst   ),
     .m_axi_arvalid     ( m0_axi_arvalid   ),
     .m_axi_arready     ( m0_axi_arready   ),
   
     // Read data/response
     .m_axi_rid         ( m0_axi_rid       ),
     .m_axi_rdata       ( m0_axi_rdata     ),
     .m_axi_rresp       ( m0_axi_rresp     ),
     .m_axi_rlast       ( m0_axi_rlast     ),
     .m_axi_rvalid      ( m0_axi_rvalid    ),
     .m_axi_rready      ( m0_axi_rready    )
   );

   axi_crossbar_0 crossbar(
     .aclk(clk),
     .aresetn(sync_rst_n),
     .s_axi_awid    ({ s1_axi_awid   , s0_axi_awid    }),
     .s_axi_awaddr  ({ s1_axi_awaddr , s0_axi_awaddr  }),
     .s_axi_awlen   ({ s1_axi_awlen  , s0_axi_awlen   }),
     .s_axi_awsize  ({ s1_axi_awsize , s0_axi_awsize  }),
     .s_axi_awburst ({ s1_axi_awburst, s0_axi_awburst }),
     .s_axi_awlock  ('0),
     .s_axi_awcache ('0),
     .s_axi_awprot  ('0),
     .s_axi_awqos   ('0),
     .s_axi_awvalid ({ s1_axi_awvalid, s0_axi_awvalid }),
     .s_axi_awready ({ s1_axi_awready, s0_axi_awready }),
     .s_axi_wdata   ({ s1_axi_wdata  , s0_axi_wdata   }),
     .s_axi_wstrb   ({ s1_axi_wstrb  , s0_axi_wstrb   }),
     .s_axi_wlast   ({ s1_axi_wlast  , s0_axi_wlast   }),
     .s_axi_wvalid  ({ s1_axi_wvalid , s0_axi_wvalid  }),
     .s_axi_wready  ({ s1_axi_wready , s0_axi_wready  }),
     .s_axi_bid     ({ s1_axi_bid    , s0_axi_bid     }),
     .s_axi_bresp   ({ s1_axi_bresp  , s0_axi_bresp   }),
     .s_axi_bvalid  ({ s1_axi_bvalid , s0_axi_bvalid  }),
     .s_axi_bready  ({ s1_axi_bready , s0_axi_bready  }),
     .s_axi_arid    ({ s1_axi_arid   , s0_axi_arid    }),
     .s_axi_araddr  ({ s1_axi_araddr , s0_axi_araddr  }),
     .s_axi_arlen   ({ s1_axi_arlen  , s0_axi_arlen   }),
     .s_axi_arsize  ({ s1_axi_arsize , s0_axi_arsize  }),
     .s_axi_arburst ({ s1_axi_arburst, s0_axi_arburst }),
     .s_axi_arlock  ('0),
     .s_axi_arcache ('0),
     .s_axi_arprot  ('0),
     .s_axi_arqos   ('0),
     .s_axi_arvalid ({ s1_axi_arvalid, s0_axi_arvalid }),
     .s_axi_arready ({ s1_axi_arready, s0_axi_arready }),
     .s_axi_rid     ({ s1_axi_rid    , s0_axi_rid     }),
     .s_axi_rdata   ({ s1_axi_rdata  , s0_axi_rdata   }),
     .s_axi_rresp   ({ s1_axi_rresp  , s0_axi_rresp   }),
     .s_axi_rlast   ({ s1_axi_rlast  , s0_axi_rlast   }),
     .s_axi_rvalid  ({ s1_axi_rvalid , s0_axi_rvalid  }),
     .s_axi_rready  ({ s1_axi_rready , s0_axi_rready  }),

     .m_axi_awid    ({ m1_axi_awid   , m0_axi_awid    }),
     .m_axi_awaddr  ({ m1_axi_awaddr , m0_axi_awaddr  }),
     .m_axi_awlen   ({ m1_axi_awlen  , m0_axi_awlen   }),
     .m_axi_awsize  ({ m1_axi_awsize , m0_axi_awsize  }),
     .m_axi_awburst ({ m1_axi_awburst, m0_axi_awburst }),
     .m_axi_awlock  ('0),
     .m_axi_awcache ('0),
     .m_axi_awprot  ('0),
     .m_axi_awregion('0),
     .m_axi_awqos   ('0),
     .m_axi_awvalid ({ m1_axi_awvalid, m0_axi_awvalid }),
     .m_axi_awready ({ m1_axi_awready, m0_axi_awready }),
     .m_axi_wdata   ({ m1_axi_wdata  , m0_axi_wdata   }),
     .m_axi_wstrb   ({ m1_axi_wstrb  , m0_axi_wstrb   }),
     .m_axi_wlast   ({ m1_axi_wlast  , m0_axi_wlast   }),
     .m_axi_wvalid  ({ m1_axi_wvalid , m0_axi_wvalid  }),
     .m_axi_wready  ({ m1_axi_wready , m0_axi_wready  }),
     .m_axi_bid     ({ m1_axi_bid    , m0_axi_bid     }),
     .m_axi_bresp   ({ m1_axi_bresp  , m0_axi_bresp   }),
     .m_axi_bvalid  ({ m1_axi_bvalid , m0_axi_bvalid  }),
     .m_axi_bready  ({ m1_axi_bready , m0_axi_bready  }),
     .m_axi_arid    ({ m1_axi_arid   , m0_axi_arid    }),
     .m_axi_araddr  ({ m1_axi_araddr , m0_axi_araddr  }),
     .m_axi_arlen   ({ m1_axi_arlen  , m0_axi_arlen   }),
     .m_axi_arsize  ({ m1_axi_arsize , m0_axi_arsize  }),
     .m_axi_arburst ({ m1_axi_arburst, m0_axi_arburst }),
     .m_axi_arlock  ('0),
     .m_axi_arcache ('0),
     .m_axi_arprot  ('0),
     .m_axi_arregion('0),
     .m_axi_arqos   ('0),
     .m_axi_arvalid ({ m1_axi_arvalid, m0_axi_arvalid }),
     .m_axi_arready ({ m1_axi_arready, m0_axi_arready }),
     .m_axi_rid     ({ m1_axi_rid    , m0_axi_rid     }),
     .m_axi_rdata   ({ m1_axi_rdata  , m0_axi_rdata   }),
     .m_axi_rresp   ({ m1_axi_rresp  , m0_axi_rresp   }),
     .m_axi_rlast   ({ m1_axi_rlast  , m0_axi_rlast   }),
     .m_axi_rvalid  ({ m1_axi_rvalid , m0_axi_rvalid  }),
     .m_axi_rready  ({ m1_axi_rready , m0_axi_rready  })
   );

   axi_vip_master dut_master (
      .aclk          ( clk         ),
      .aresetn       ( sync_rst_n  ),
      .m_axi_awaddr  (m1_axi_awaddr),
      .m_axi_awlen   (m1_axi_awlen),
      .m_axi_awsize  (m1_axi_awsize),
      .m_axi_awburst (m1_axi_awburst),
      .m_axi_awlock  ('0),
      .m_axi_awcache ('0),
      .m_axi_awprot  ('0),
      .m_axi_awregion('0),
      .m_axi_awqos   ('0),
      .m_axi_awuser  ('0),
      .m_axi_awvalid (m1_axi_awvalid),
      .m_axi_awready (m1_axi_awready),
      .m_axi_wdata   (m1_axi_wdata),
      .m_axi_wstrb   (m1_axi_wstrb),
      .m_axi_wlast   (m1_axi_wlast),
      .m_axi_wuser   ('0),
      .m_axi_wvalid  (m1_axi_wvalid),
      .m_axi_wready  (m1_axi_wready),
      .m_axi_bresp   (m1_axi_bresp),
      .m_axi_buser   ('0),
      .m_axi_bvalid  (m1_axi_bvalid),
      .m_axi_bready  (m1_axi_bready),
      .m_axi_araddr  (m1_axi_araddr),
      .m_axi_arlen   (m1_axi_arlen),
      .m_axi_arsize  (m1_axi_arsize),
      .m_axi_arburst (m1_axi_arburst),
      .m_axi_arlock  ('0),
      .m_axi_arcache ('0),
      .m_axi_arprot  ('0),
      .m_axi_arregion('0),
      .m_axi_arqos   ('0),
      .m_axi_aruser  ('0),
      .m_axi_arvalid (m1_axi_arvalid),
      .m_axi_arready (m1_axi_arready),
      .m_axi_rdata   (m1_axi_rdata),
      .m_axi_rresp   (m1_axi_rresp),
      .m_axi_rlast   (m1_axi_rlast),
      .m_axi_ruser   ('0),
      .m_axi_rvalid  (m1_axi_rvalid),
      .m_axi_rready  (m1_axi_rready)
   );

   axi_vip_slave dut_slave (
      .aclk          ( clk         ),
      .aresetn       ( sync_rst_n  ),
      .s_axi_awaddr  (s1_axi_awaddr),
      .s_axi_awlen   (s1_axi_awlen),
      .s_axi_awsize  (s1_axi_awsize),
      .s_axi_awburst (s1_axi_awburst),
      .s_axi_awlock  ('0),
      .s_axi_awcache ('0),
      .s_axi_awprot  ('0),
      .s_axi_awregion('0),
      .s_axi_awqos   ('0),
      .s_axi_awuser  ('0),
      .s_axi_awvalid (s1_axi_awvalid),
      .s_axi_awready (s1_axi_awready),
      .s_axi_wdata   (s1_axi_wdata),
      .s_axi_wstrb   (s1_axi_wstrb),
      .s_axi_wlast   (s1_axi_wlast),
      .s_axi_wuser   ('0),
      .s_axi_wvalid  (s1_axi_wvalid),
      .s_axi_wready  (s1_axi_wready),
      .s_axi_bresp   (s1_axi_bresp),
      .s_axi_buser   ('0),
      .s_axi_bvalid  (s1_axi_bvalid),
      .s_axi_bready  (s1_axi_bready),
      .s_axi_araddr  (s1_axi_araddr),
      .s_axi_arlen   (s1_axi_arlen),
      .s_axi_arsize  (s1_axi_arsize),
      .s_axi_arburst (s1_axi_arburst),
      .s_axi_arlock  ('0),
      .s_axi_arcache ('0),
      .s_axi_arprot  ('0),
      .s_axi_arregion('0),
      .s_axi_arqos   ('0),
      .s_axi_aruser  ('0),
      .s_axi_arvalid (s1_axi_arvalid),
      .s_axi_arready (s1_axi_arready),
      .s_axi_rdata   (s1_axi_rdata),
      .s_axi_rresp   (s1_axi_rresp),
      .s_axi_rlast   (s1_axi_rlast),
      .s_axi_ruser   ('0),
      .s_axi_rvalid  (s1_axi_rvalid),
      .s_axi_rready  (s1_axi_rready)
   );
   
   blk_mem_gen_0 SMEM (
     .rsta_busy         ( rsta_busy       ),
     .rstb_busy         ( rstb_busy       ),
   
     .s_aclk            ( clk             ),
     .s_aresetn         ( sync_rst_n      ),
   
     // Write address
     .s_axi_awid        ( s0_axi_awid      ), 
     .s_axi_awaddr      ( s0_axi_awaddr    ),
     .s_axi_awlen       ( s0_axi_awlen     ),
     .s_axi_awsize      ( s0_axi_awsize    ),
     .s_axi_awburst     ( s0_axi_awburst   ),
     .s_axi_awvalid     ( s0_axi_awvalid   ),
     .s_axi_awready     ( s0_axi_awready   ),
   
     // Write data
     .s_axi_wdata       ( s0_axi_wdata     ),
     .s_axi_wstrb       ( s0_axi_wstrb     ),
     .s_axi_wlast       ( s0_axi_wlast     ),  
     .s_axi_wvalid      ( s0_axi_wvalid    ),
     .s_axi_wready      ( s0_axi_wready    ),
   
     // Write response
     .s_axi_bid         ( s0_axi_bid       ),
     .s_axi_bresp       ( s0_axi_bresp     ),
     .s_axi_bvalid      ( s0_axi_bvalid    ),
     .s_axi_bready      ( s0_axi_bready    ),
   
     // Read address
     .s_axi_arid        ( s0_axi_arid      ), 
     .s_axi_araddr      ( s0_axi_araddr    ),
     .s_axi_arlen       ( s0_axi_arlen     ),
     .s_axi_arsize      ( s0_axi_arsize    ),
     .s_axi_arburst     ( s0_axi_arburst   ),
     .s_axi_arvalid     ( s0_axi_arvalid   ),
     .s_axi_arready     ( s0_axi_arready   ),
   
     // Read data/response
     .s_axi_rid         ( s0_axi_rid       ),
     .s_axi_rdata       ( s0_axi_rdata     ),
     .s_axi_rresp       ( s0_axi_rresp     ),
     .s_axi_rlast       ( s0_axi_rlast     ),
     .s_axi_rvalid      ( s0_axi_rvalid    ),
     .s_axi_rready      ( s0_axi_rready    )
   );

endmodule





