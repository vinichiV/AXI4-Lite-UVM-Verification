class axi4_lite_ctrl_sequence extends uvm_sequence#(axi4_lite_ctrl_transaction);

  `uvm_object_utils(axi4_lite_ctrl_sequence)
  
  int unsigned num_trans = 100;

  function new(string name = "");
    super.new(name);
  endfunction
  
  bit [31:0] written_addr_q[$];

  task body();
    repeat (num_trans) begin
      req = axi4_lite_ctrl_transaction::type_id::create("req");

      // Handshake driver
      start_item(req);

      if (!req.randomize()) begin
        `uvm_error("SEQUENCE", "Randomize failed")
      end else begin
        `uvm_info("SEQ", $sformatf("RND: op=%0d addr=0x%08h wdata=0x%08h", req.op, req.address, req.w_data), UVM_LOW);
      end
      
      if (req.op == axi4_lite_ctrl_transaction::READ && written_addr_q.size() > 0) begin
        req.address = written_addr_q[$urandom_range(0, written_addr_q.size()-1)];
      end
      
      if (req.op == axi4_lite_ctrl_transaction::WRITE) begin
        written_addr_q.push_back(req.address);
      end

      finish_item(req);
      
    end
  endtask : body

endclass: axi4_lite_ctrl_sequence


