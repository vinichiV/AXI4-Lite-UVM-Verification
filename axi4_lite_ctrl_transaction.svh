class axi4_lite_ctrl_transaction extends uvm_sequence_item;
  
  localparam ADDRESS_WIDTH = 32;
  localparam DATA_WIDTH = 32;

  typedef enum {READ, WRITE} axi_op_e;

  rand axi_op_e              op;
  rand logic [ADDRESS_WIDTH-1:0] address;
  rand logic [DATA_WIDTH-1:0]    w_data;

  `uvm_object_utils(axi4_lite_ctrl_transaction)

  function new(string name = "axi4_lite_ctrl_transaction");
    super.new(name);
  endfunction

  // ------------------
  // Constraints
  // ------------------
  constraint c_addr_align {
    address[1:0] == 2'b00;
  }

  constraint c_valid {
    (op == READ)  -> (w_data == '0);
  }
  
  constraint op_dist {
    op dist { READ := 1, WRITE := 1 };
  }
endclass: axi4_lite_ctrl_transaction

