class axi4_lite_transaction extends uvm_sequence_item;
  
  localparam ADDRESS_WIDTH = 32;
  localparam DATA_WIDTH = 32;

  `uvm_object_utils(axi4_lite_transaction)
  
  typedef enum bit {AXI_READ, AXI_WRITE} axi_cmd_e;
  axi_cmd_e cmd;
  
  function new(string name = "axi4_lite_transaction");
    super.new(name);
  endfunction
  
  bit ARREADY, RVALID, ARVALID, RREADY, AWREADY, BVALID, AWVALID, BREADY, WVALID, WREADY;
  
  bit [ADDRESS_WIDTH-1:0] araddr;
  bit [ADDRESS_WIDTH-1:0] awaddr;

  bit [DATA_WIDTH-1:0] wdata;
  bit [DATA_WIDTH-1:0] rdata;
  
  bit [DATA_WIDTH/8-1:0]  wstrb;

  bit [1:0]  rresp;
  bit [1:0]  bresp;
  
endclass: axi4_lite_transaction

