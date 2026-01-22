class axi4_lite_scoreboard extends uvm_component;
  
  localparam ADDRESS_WIDTH = 32;
  localparam DATA_WIDTH = 32;
  localparam NO_OF_REGISTERS = 32;
  localparam int BYTE_OFFSET = $clog2(DATA_WIDTH/8);
  localparam int ADDR_IDX_WIDTH = $clog2(NO_OF_REGISTERS);
  
  `uvm_component_utils(axi4_lite_scoreboard)

  // analysis imp
  uvm_analysis_imp #(axi4_lite_transaction, axi4_lite_scoreboard) analysis_imp;
  
  // simple model memory: indexed by register index
  bit [DATA_WIDTH-1:0] model_mem [NO_OF_REGISTERS-1:0];

  // pending address queues for AW->W and AR->R matching
  logic [ADDRESS_WIDTH-1:0] pending_awaddr[$];
  logic [ADDRESS_WIDTH-1:0] pending_araddr[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_imp = new("analysis_imp", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // initialize model memory to zero
    for (int i=0; i<NO_OF_REGISTERS; i++) model_mem[i] = '0;
  endfunction

  // analysis_imp calls this when monitor.ap.write(tr) is executed
  function void write(axi4_lite_transaction tr);
    logic [ADDRESS_WIDTH-1:0] addr;
    int idx;
    bit [DATA_WIDTH-1:0] expected;

    // AW handshake observed -> queue AW address
    if (tr.AWVALID && tr.AWREADY) begin
      pending_awaddr.push_back(tr.awaddr);
      `uvm_info("SCOREBOARD", $sformatf("AW observed addr=0x%0h", tr.awaddr), UVM_LOW)
    end

    // W handshake observed -> consume AW + apply WSTRB to model_mem
    if (tr.WVALID && tr.WREADY) begin
      // prefer AW provided in same transaction sample
      if (tr.AWVALID && tr.AWREADY) begin
        addr = tr.awaddr;
      end else if (pending_awaddr.size() > 0) begin
        addr = pending_awaddr.pop_front();
      end else begin
        `uvm_error("SCOREBOARD", $sformatf("W with no pending AW. wdata=0x%0h", tr.wdata))
        return;
      end

      idx = addr[BYTE_OFFSET +: ADDR_IDX_WIDTH];
      // apply write strobes per byte (works for any DATA_WIDTH multiple of 8)
      for (int b = 0; b < (DATA_WIDTH/8); b++) begin
        if (tr.wstrb[b]) begin
          model_mem[idx][b*8 +: 8] = tr.wdata[b*8 +: 8];
        end
      end
      `uvm_info("SCOREBOARD", $sformatf("WRITE model @ idx=%0d addr=0x%0h data=0x%0h wstrb=0x%0h",
                     idx, addr, tr.wdata, tr.wstrb), UVM_LOW)
    end

    // AR handshake observed -> queue AR address
    if (tr.ARVALID && tr.ARREADY) begin
      pending_araddr.push_back(tr.araddr);
      `uvm_info("SCOREBOARD", $sformatf("AR observed addr=0x%0h", tr.araddr), UVM_LOW)
    end

    // R response observed -> compare against model_mem
    if (tr.RVALID && tr.RREADY) begin
      if (pending_araddr.size() > 0) begin
        addr = pending_araddr.pop_front();
      end 

      idx = addr[BYTE_OFFSET +: ADDR_IDX_WIDTH];
      expected = model_mem[idx];

      if (tr.rdata !== expected) begin
        `uvm_error("SCOREBOARD", $sformatf("READ MISMATCH idx=%0d addr=0x%0h expected=0x%0h got=0x%0h",
                           idx, addr, expected, tr.rdata))
      end else begin
        `uvm_info("SCOREBOARD", $sformatf("READ OK idx=%0d addr=0x%0h data=0x%0h",
                           idx, addr, tr.rdata), UVM_LOW)
      end
    end
  endfunction

endclass

