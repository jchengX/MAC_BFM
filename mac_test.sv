class crc7_test extends uvm_test;
  `uvm_component_utils(crc7_test)
  
  crc7_env c7_env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c7_env = crc7_env::type_id::create(.name("c7_env"), .parent(this));
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    crc7_sequence c7_seq;
    
    phase.raise_objection(.obj(this));
      c7_seq = crc7_sequence::type_id::create(.name("c7_seq"), .contxt(get_full_name()));
      assert(c7_seq.randomize());
      c7_seq.start(c7_env.c7_agent.c7_seqr);
    phase.drop_objection(.obj(this));
  endtask: run_phase
endclass: crc7_test
      