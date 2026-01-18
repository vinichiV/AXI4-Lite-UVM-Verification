`timescale 1ns/1ps

`include "uvm_macros.svh"
`include "my_pkg.svh"

module top;
  import uvm_pkg::*;
  import my_pkg::*;
  
  axi4_lite_if dut_if();
  axi4_lite_ctrl_if ctrl_if();
  
  axi4_lite_top dut(.dut_if(dut_if), .ctrl_if(ctrl_if));
  
  initial begin
    dut_if.ACLK = 0;
    dut_if.ARESETN = 1;
    #5 dut_if.ARESETN = ~dut_if.ARESETN;
    #5 dut_if.ARESETN = ~dut_if.ARESETN;
    forever begin 
      #5 dut_if.ACLK = ~dut_if.ACLK;
      ctrl_if.clk = dut_if.ACLK;
    end
  end
  
  initial begin
    uvm_config_db #(virtual axi4_lite_if)::set(null, "*", "dut_vif", dut_if);
    uvm_config_db #(virtual axi4_lite_ctrl_if)::set(null, "*", "ctrl_vif", ctrl_if);
    
    run_test("my_test");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end
  
endmodule

