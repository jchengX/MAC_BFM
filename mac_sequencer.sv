class crc7_transaction extends uvm_sequence_item;
  bit[6:0] crc;
  
  function new(string name = "");
    super.new(name);
  endfunction: new
  
  `uvm_object_utils_begin(crc7_transaction)
    `uvm_field_int(crc, UVM_ALL_ON)
  `uvm_object_utils_end
endclass: crc7_transaction

class crc7_sequence extends uvm_sequence#(crc7_transaction);
  `uvm_object_utils(crc7_sequence)
  
  function new(string name = "");
    super.new(name);
  endfunction: new
  
  task body();
    crc7_transaction c7_tx;
    
    repeat (1) begin
      c7_tx = crc7_transaction::type_id::create(.name("c7_tx"), .contxt(get_full_name()));

      start_item(c7_tx);
      assert(c7_tx.randomize());
      finish_item(c7_tx);
      //c7_tx.end_event.wait_on();
    end
  endtask: body
endclass: crc7_sequence

typedef uvm_sequencer#(crc7_transaction) crc7_sequencer;
  
  