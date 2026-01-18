class axi4_lite_ctrl_driver extends uvm_driver #(axi4_lite_ctrl_transaction);

  `uvm_component_utils(axi4_lite_ctrl_driver)

  virtual axi4_lite_ctrl_if ctrl_vif;
  virtual axi4_lite_if      axi_vif;
  
  task reset();
    
  endtask: reset
  
  task drive_item(axi4_lite_ctrl_transaction tr);
    // Default
    ctrl_vif.read_start  <= 0;
    ctrl_vif.write_start <= 0;

    // Drive address & data
    ctrl_vif.address <= tr.address;
    ctrl_vif.W_data  <= tr.w_data;

    @(posedge ctrl_vif.clk);

    // Pulse start
    if (tr.op == axi4_lite_ctrl_transaction::WRITE)
      ctrl_vif.write_start <= 1;
    else
      ctrl_vif.read_start <= 1;

    @(posedge ctrl_vif.clk);

    // Deassert
    ctrl_vif.read_start  <= 0;
    ctrl_vif.write_start <= 0;
    
    if (tr.op == axi4_lite_ctrl_transaction::WRITE) begin
      wait (axi_vif.BVALID && axi_vif.BREADY);
    end
    else begin
      wait (axi_vif.RVALID && axi_vif.RREADY);
    end

  	@(posedge ctrl_vif.clk);

//     `uvm_info("CTRL_DRV",
//       $sformatf("Driven %s addr=0x%08h data=0x%08h",
//                 tr.op.name(), tr.address, tr.wdata),
//       UVM_MEDIUM)
  endtask

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Get interface reference from config database
    if(!uvm_config_db#(virtual axi4_lite_ctrl_if)::get(this, "", "ctrl_vif", ctrl_vif))
      `uvm_fatal("DRIVER", "Virtual control interface not set")
      
      if(!uvm_config_db#(virtual axi4_lite_if)::get(this, "", "dut_vif", axi_vif))
      `uvm_fatal("DRIVER", "Virtual axi4 lite interface not set")
      
  endfunction
      

  task run_phase(uvm_phase phase);

    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
    
  endtask

endclass: axi4_lite_ctrl_driver
