`timescale 1ns/1ps
// Testbench to verify bud design

module cl_bud_tb;

  logic clk;
  logic sync_rst_n;

  /* Master Interface (AXI-L) */
  // Write address
  logic        sh_bar1_awvalid;
  logic [31:0] sh_bar1_awaddr;
  logic        bar1_sh_awready;
                                                                                                               
  // Write data                                                                                        
  logic        sh_bar1_wvalid;
  logic [31:0] sh_bar1_wdata;
  logic [ 3:0] sh_bar1_wstrb;
  logic        bar1_sh_wready;
                                                                                                                              
  // Write response                                                                                                            
  logic        bar1_sh_bvalid;
  logic [1:0]  bar1_sh_bresp;
  logic        sh_bar1_bready;
                                                                                                                              
  // Read address                                                                                                              
  logic        sh_bar1_arvalid;
  logic [31:0] sh_bar1_araddr;
  logic        bar1_sh_arready;
                                                                                                                              
  // Read data/response                                                                                                        
  logic        bar1_sh_rvalid;
  logic [31:0] bar1_sh_rdata;
  logic [ 1:0] bar1_sh_rresp;                                                                                                                           
  logic        sh_bar1_rready;

  /* Slave Interface (AXI-4) */
  logic        rsta_busy;
  logic        rstb_busy;

  // Write address
  logic [ 3:0] s_axi_awid;
  logic [31:0] s_axi_awaddr;
  logic [ 7:0] s_axi_awlen;
  logic [ 2:0] s_axi_awsize;
  logic [ 1:0] s_axi_awburst;
  logic        s_axi_awvalid;
  logic        s_axi_awready;
 
  // Write data
  logic [63:0] s_axi_wdata;
  logic [ 7:0] s_axi_wstrb;
  logic        s_axi_wlast; 
  logic        s_axi_wvalid;
  logic        s_axi_wready;
 
  // Write response
  logic [ 3:0] s_axi_bid;
  logic [ 1:0] s_axi_bresp;
  logic        s_axi_bvalid;
  logic        s_axi_bready;
 
  // Read address
  logic [ 3:0] s_axi_arid;
  logic [31:0] s_axi_araddr;
  logic [ 7:0] s_axi_arlen;
  logic [ 2:0] s_axi_arsize;
  logic [ 1:0] s_axi_arburst;
  logic        s_axi_arvalid;
  logic        s_axi_arready;
 
  // Read data/response
  logic [ 3:0] s_axi_rid;
  logic [63:0] s_axi_rdata;
  logic [ 1:0] s_axi_rresp;
  logic        s_axi_rlast;
  logic        s_axi_rvalid;
  logic        s_axi_rready;

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
    .s_axi_awid        ( s_axi_awid      ), 
    .s_axi_awaddr      ( s_axi_awaddr    ),
    .s_axi_awlen       ( s_axi_awlen     ),
    .s_axi_awsize      ( s_axi_awsize    ),
    .s_axi_awburst     ( s_axi_awburst   ),
    .s_axi_awvalid     ( s_axi_awvalid   ),
    .s_axi_awready     ( s_axi_awready   ),
  
    // Write data
    .s_axi_wdata       ( s_axi_wdata     ),
    .s_axi_wstrb       ( s_axi_wstrb     ),
    .s_axi_wlast       ( s_axi_wlast     ),  
    .s_axi_wvalid      ( s_axi_wvalid    ),
    .s_axi_wready      ( s_axi_wready    ),
  
    // Write response
    .s_axi_bid         ( s_axi_bid       ),
    .s_axi_bresp       ( s_axi_bresp     ),
    .s_axi_bvalid      ( s_axi_bvalid    ),
    .s_axi_bready      ( s_axi_bready    ),
  
    // Read address
    .s_axi_arid        ( s_axi_arid      ), 
    .s_axi_araddr      ( s_axi_araddr    ),
    .s_axi_arlen       ( s_axi_arlen     ),
    .s_axi_arsize      ( s_axi_arsize    ),
    .s_axi_arburst     ( s_axi_arburst   ),
    .s_axi_arvalid     ( s_axi_arvalid   ),
    .s_axi_arready     ( s_axi_arready   ),
  
    // Read data/response
    .s_axi_rid         ( s_axi_rid       ),
    .s_axi_rdata       ( s_axi_rdata     ),
    .s_axi_rresp       ( s_axi_rresp     ),
    .s_axi_rlast       ( s_axi_rlast     ),
    .s_axi_rvalid      ( s_axi_rvalid    ),
    .s_axi_rready      ( s_axi_rready    )
  );
   
  blk_mem_gen_0 SMEM (
    .rsta_busy         ( rsta_busy       ),
    .rstb_busy         ( rstb_busy       ),
  
    .s_aclk            ( clk             ),
    .s_aresetn         ( sync_rst_n      ),
  
    // Write address
    .s_axi_awid        ( s_axi_awid      ), 
    .s_axi_awaddr      ( s_axi_awaddr    ),
    .s_axi_awlen       ( s_axi_awlen     ),
    .s_axi_awsize      ( s_axi_awsize    ),
    .s_axi_awburst     ( s_axi_awburst   ),
    .s_axi_awvalid     ( s_axi_awvalid   ),
    .s_axi_awready     ( s_axi_awready   ),
  
    // Write data
    .s_axi_wdata       ( s_axi_wdata     ),
    .s_axi_wstrb       ( s_axi_wstrb     ),
    .s_axi_wlast       ( s_axi_wlast     ),  
    .s_axi_wvalid      ( s_axi_wvalid    ),
    .s_axi_wready      ( s_axi_wready    ),
  
    // Write response
    .s_axi_bid         ( s_axi_bid       ),
    .s_axi_bresp       ( s_axi_bresp     ),
    .s_axi_bvalid      ( s_axi_bvalid    ),
    .s_axi_bready      ( s_axi_bready    ),
  
    // Read address
    .s_axi_arid        ( s_axi_arid      ), 
    .s_axi_araddr      ( s_axi_araddr    ),
    .s_axi_arlen       ( s_axi_arlen     ),
    .s_axi_arsize      ( s_axi_arsize    ),
    .s_axi_arburst     ( s_axi_arburst   ),
    .s_axi_arvalid     ( s_axi_arvalid   ),
    .s_axi_arready     ( s_axi_arready   ),
  
    // Read data/response
    .s_axi_rid         ( s_axi_rid       ),
    .s_axi_rdata       ( s_axi_rdata     ),
    .s_axi_rresp       ( s_axi_rresp     ),
    .s_axi_rlast       ( s_axi_rlast     ),
    .s_axi_rvalid      ( s_axi_rvalid    ),
    .s_axi_rready      ( s_axi_rready    )
  );

  initial begin
    clk = 0;
    sync_rst_n = 0;
    
    sh_bar1_awvalid = 0;
    sh_bar1_awaddr  = 0;                                                                                                                          
    // Write data                                                                                                                
    sh_bar1_wvalid  = 0;
    sh_bar1_wdata   = 0;
    sh_bar1_wstrb   = 0;
                                                                                                                              
    // Write response
    sh_bar1_bready  = 0;
                                                                                                                              
    // Read address                                                                                                              
    sh_bar1_arvalid = 0;
    sh_bar1_araddr  = 0;
                                                                                                                              
    // Read data/response                                                                                                                         
    sh_bar1_rready  = 0;

    #6;
    sync_rst_n = 1;

    /* First transaction (Write)*/
    sh_bar1_awaddr  = 32'h00000010;
    sh_bar1_awvalid = 1'b1;

    sh_bar1_wdata   = 32'h000ABACA;
    sh_bar1_wvalid  = 1'b1;
    sh_bar1_wstrb   = 4'b1111;

    sh_bar1_bready  = 1'b1;
    #10;

    /* Read transaction */
    sh_bar1_araddr   = 32'h00000010;
    sh_bar1_arvalid  = 1'b1;

    sh_bar1_rready = 1'b1;
  end

  always #2 clk <= ~clk;

endmodule