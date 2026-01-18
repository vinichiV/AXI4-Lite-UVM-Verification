`include "axi4_lite_master.sv"
`include "axi4_lite_slave.sv"

interface axi4_lite_if #(
  parameter ADDRESS_WIDTH = 32,
  parameter DATA_WIDTH    = 32
);
	logic ACLK;
    logic ARESETN;
  	logic ARREADY, RVALID, ARVALID, RREADY, AWREADY, BVALID, AWVALID, BREADY, WVALID, WREADY;
  	logic [ADDRESS_WIDTH-1 : 0] ARADDR;
  	logic [ADDRESS_WIDTH-1 : 0] AWADDR;
  	logic [DATA_WIDTH-1:0] WDATA;
  	logic [DATA_WIDTH-1:0] RDATA;
  	logic [DATA_WIDTH/8-1:0] WSTRB;
  	logic [1:0] RRESP, BRESP;

endinterface

interface axi4_lite_ctrl_if #(
  parameter ADDRESS_WIDTH = 32,
  parameter DATA_WIDTH    = 32
);
  	logic clk;
  	logic read_start;
  	logic write_start;
  	logic [ADDRESS_WIDTH-1:0] address;
  	logic [DATA_WIDTH-1:0] W_data;
  
endinterface

module axi4_lite_top#(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 32
    )(
        axi4_lite_if dut_if,
  		axi4_lite_ctrl_if ctrl_if
    );

    axi4_lite_master u_axi4_lite_master0
    (
        .ACLK(dut_if.ACLK),
        .ARESETN(dut_if.ARESETN),
        .START_READ(ctrl_if.read_start),
        .address(ctrl_if.address),
        .W_data(ctrl_if.W_data),
        .M_ARREADY(dut_if.ARREADY),
        .M_RDATA(dut_if.RDATA),
        .M_RRESP(dut_if.RRESP),
        .M_RVALID(dut_if.RVALID),
        .M_ARADDR(dut_if.ARADDR),
        .M_ARVALID(dut_if.ARVALID),
        .M_RREADY(dut_if.RREADY),
        .START_WRITE(ctrl_if.write_start),
        .M_AWREADY(dut_if.AWREADY),
        .M_WVALID(dut_if.WVALID),
        .M_WREADY(dut_if.WREADY),
        .M_BRESP(dut_if.BRESP),
        .M_BVALID(dut_if.BVALID),
        .M_AWADDR(dut_if.AWADDR),
        .M_AWVALID(dut_if.AWVALID),
        .M_WDATA(dut_if.WDATA),
        .M_WSTRB(dut_if.WSTRB),
        .M_BREADY(dut_if.BREADY)
    );

    axi4_lite_slave u_axi4_lite_slave0
    (
        .ACLK(dut_if.ACLK),
        .ARESETN(dut_if.ARESETN),
        .S_ARREADY(dut_if.ARREADY),
        .S_RDATA(dut_if.RDATA),
        .S_RRESP(dut_if.RRESP),
        .S_RVALID(dut_if.RVALID),
        .S_ARADDR(dut_if.ARADDR),
        .S_ARVALID(dut_if.ARVALID),
        .S_RREADY(dut_if.RREADY),
        .S_AWREADY(dut_if.AWREADY),
        .S_WVALID(dut_if.WVALID),
        .S_WREADY(dut_if.WREADY),
        .S_BRESP(dut_if.BRESP),
        .S_BVALID(dut_if.BVALID),
        .S_AWADDR(dut_if.AWADDR),
        .S_AWVALID(dut_if.AWVALID),
        .S_WDATA(dut_if.WDATA),
        .S_WSTRB(dut_if.WSTRB),
        .S_BREADY(dut_if.BREADY)
    );
endmodule
