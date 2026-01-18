class axi4_lite_monitor extends uvm_monitor;
    `uvm_component_utils(axi4_lite_monitor)

    // TLM port
    uvm_analysis_port #(axi4_lite_transaction) ap;

    virtual axi4_lite_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual axi4_lite_if)::get(this, "", "dut_vif", vif))
        `uvm_fatal("MONITOR", "Cannot get axi4_lite_if")
    endfunction
	
          
    task run_phase(uvm_phase phase);
      	axi4_lite_transaction tr;

    forever begin
      @(posedge vif.ACLK);
      
      tr = axi4_lite_transaction::type_id::create("tr");
      
      // ===== RAW HANDSHAKE =====
      tr.ARVALID = vif.ARVALID;
      tr.ARREADY = vif.ARREADY;
      tr.RVALID  = vif.RVALID;
      tr.RREADY  = vif.RREADY;

      tr.AWVALID = vif.AWVALID;
      tr.AWREADY = vif.AWREADY;
      tr.WVALID  = vif.WVALID;
      tr.WREADY  = vif.WREADY;
      tr.BVALID  = vif.BVALID;
      tr.BREADY  = vif.BREADY;

      // ===== ADDRESS & DATA =====
      tr.araddr = vif.ARADDR;
      tr.awaddr = vif.AWADDR;

      tr.wdata  = vif.WDATA;
      tr.wstrb  = vif.WSTRB;

      tr.rdata  = vif.RDATA;

      // ===== RESP =====
      tr.rresp  = vif.RRESP;
      tr.bresp  = vif.BRESP;
      
      if (vif.ARVALID && vif.ARREADY) begin
        `uvm_info("MONITOR", $sformatf("araddr=0x%08h", tr.araddr), UVM_MEDIUM)
      end else
      if (vif.RVALID && vif.RREADY) begin
        `uvm_info("MONITOR", $sformatf("rdata=0x%08h", tr.rdata), UVM_MEDIUM)
      end
      ap.write(tr);
        
    end
    endtask
endclass


