package my_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "axi4_lite_transaction.svh"
    `include "axi4_lite_ctrl_transaction.svh"
    `include "axi4_lite_ctrl_sequence.svh"
    `include "axi4_lite_ctrl_driver.svh"
    `include "axi4_lite_monitor.svh"
    `include "axi4_lite_scoreboard.svh"

    class my_agent extends uvm_agent;

      `uvm_component_utils(my_agent)

        axi4_lite_ctrl_driver driver;
      	uvm_sequencer#(axi4_lite_ctrl_transaction) sequencer;
      	axi4_lite_monitor monitor;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
          
          	monitor = axi4_lite_monitor::type_id::create("monitor", this);

            if (is_active == UVM_ACTIVE) begin
              	driver    = axi4_lite_ctrl_driver::type_id::create("driver", this);
              	sequencer = uvm_sequencer#(axi4_lite_ctrl_transaction)::type_id::create("sequencer", this);
            end
        endfunction

        function void connect_phase(uvm_phase phase);
              super.connect_phase(phase);
              if (is_active == UVM_ACTIVE) begin
                driver.seq_item_port.connect(sequencer.seq_item_export);
              end
        endfunction

    endclass

    class my_env extends uvm_env;

        `uvm_component_utils(my_env)

        my_agent agent;
      	axi4_lite_scoreboard scoreboard;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = my_agent::type_id::create("agent", this);
          	scoreboard = axi4_lite_scoreboard::type_id::create("scoreboard", this);
        endfunction
      
        function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
          agent.monitor.ap.connect(scoreboard.analysis_imp);
    	endfunction
      
    endclass

    class my_test extends uvm_test;

        `uvm_component_utils(my_test)

        my_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = my_env::type_id::create("env", this);
        endfunction

        task run_phase(uvm_phase phase);
            axi4_lite_ctrl_sequence seq;

            phase.raise_objection(this);

            // Create and start sequence
            seq = axi4_lite_ctrl_sequence::type_id::create("seq");
            seq.start(env.agent.sequencer);

            phase.drop_objection(this);
        endtask

    endclass

endpackage


