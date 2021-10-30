// Module to convert the AXI-Lite interface into AXI-4

module cl_axil_to_axi(
  /* Master Interface (AXI-L) */
  // Write address
  input  logic        m_sh_bar1_awvalid,
  input  logic [31:0] m_sh_bar1_awaddr,
  output logic        m_bar1_sh_awready,
                                                                                                                              
  // Write data                                                                                                                
  input  logic        m_sh_bar1_wvalid,
  input  logic [31:0] m_sh_bar1_wdata,
  input  logic [ 3:0] m_sh_bar1_wstrb,
  output logic        m_bar1_sh_wready,
                                                                                                                              
  // Write response                                                                                                            
  output logic        m_bar1_sh_bvalid,
  output logic [1:0]  m_bar1_sh_bresp,
  input  logic        m_sh_bar1_bready,
                                                                                                                              
  // Read address                                                                                                              
  input               m_sh_bar1_arvalid,
  input  logic [31:0] m_sh_bar1_araddr,
  output logic        m_bar1_sh_arready,
                                                                                                                              
  // Read data/response                                                                                                        
  output logic        m_bar1_sh_rvalid,
  output logic [31:0] m_bar1_sh_rdata,
  output logic [ 1:0] m_bar1_sh_rresp,                                                                                                                            
  input  logic        m_sh_bar1_rready,

  /* Slave Interface (AXI-4) */
  input  logic        rsta_busy,
  input  logic        rstb_busy,

  // Write address
  output logic [ 3:0] s_axi_awid, 
  output logic [31:0] s_axi_awaddr,
  output logic [ 7:0] s_axi_awlen,
  output logic [ 2:0] s_axi_awsize,
  output logic [ 1:0] s_axi_awburst,
  output logic        s_axi_awvalid,
  input  logic        s_axi_awready,

  // Write data
  output logic [63:0] s_axi_wdata,
  output logic [ 7:0] s_axi_wstrb,
  output logic        s_axi_wlast,  
  output logic        s_axi_wvalid,
  input  logic        s_axi_wready,

  // Write response
  input  logic [ 3:0] s_axi_bid,
  input  logic [ 1:0] s_axi_bresp,
  input  logic        s_axi_bvalid,
  output logic        s_axi_bready,

  // Read address
  output logic [ 3:0] s_axi_arid,
  output logic [31:0] s_axi_araddr,
  output logic [ 7:0] s_axi_arlen,
  output logic [ 2:0] s_axi_arsize,
  output logic [ 1:0] s_axi_arburst,
  output logic        s_axi_arvalid,
  input  logic        s_axi_arready,

  // Read data/response
  input  logic [ 3:0] s_axi_rid,
  input  logic [63:0] s_axi_rdata,
  input  logic [ 1:0] s_axi_rresp,
  input  logic        s_axi_rlast,
  input  logic        s_axi_rvalid,
  output logic        s_axi_rready
);

  logic        un_used_bid;
  logic [31:0] un_used_rdata;
  logic        un_used_rid;
  logic        un_used_rlast;

  always_comb begin
    if (!rsta_busy || !rstb_busy) begin
      // Write address
      s_axi_awid        = 4'b0001;
      s_axi_awaddr      = m_sh_bar1_awaddr;
      s_axi_awlen       = 8'h01;  // one transaction
      s_axi_awsize      = 3'b010; // 4 bytes
      s_axi_awburst     = 2'b00;
      s_axi_awvalid     = m_sh_bar1_awvalid;
      m_bar1_sh_awready = s_axi_awready;

      // Write data
      s_axi_wdata       = {32'h00000000, m_sh_bar1_wdata};
      s_axi_wstrb       = {4'b0000, m_sh_bar1_wstrb};
      s_axi_wlast       = 1'b1;
      s_axi_wvalid      = m_sh_bar1_wvalid;
      m_bar1_sh_wready  = s_axi_wready;

      // Write response
      un_used_bid       = &{1'b0, s_axi_bid};
      m_bar1_sh_bvalid  = s_axi_bvalid;
      m_bar1_sh_bresp   = s_axi_bresp;
      s_axi_bready      = m_sh_bar1_bready;

      // Read address
      s_axi_arid        = 4'b0011;
      s_axi_araddr      = m_sh_bar1_araddr;
      s_axi_arlen       = 8'h01;
      s_axi_arsize      = 3'b010;
      s_axi_arburst     = 2'b00;
      s_axi_arvalid     = m_sh_bar1_arvalid;
      m_bar1_sh_arready = s_axi_arready;

      // Read data/response
      un_used_rid                      = &{1'b0, s_axi_rid};
      {un_used_rdata, m_bar1_sh_rdata} = s_axi_rdata;
      m_bar1_sh_rresp                  = s_axi_rresp;
      un_used_rlast                    = s_axi_rlast;
      s_axi_rready                     = m_sh_bar1_rready;
      m_sh_bar1_rready                 = s_axi_rready;
    end
  end

endmodule