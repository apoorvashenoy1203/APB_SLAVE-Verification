class apb_test extends uvm_test;
  `uvm_component_utils(apb_test);

  apb_env env;
  apb_sequence seq;

  function new(string name = "apb_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = apb_sequence::type_id::create("seq");
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask: run_phase
  
endclass: apb_test


class simple_write_test extends apb_test;
  `uvm_component_utils(simple_write_test)
  simple_write seq;
  function new(string name = "simple_write_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq =simple_write::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask 
endclass 


class simple_read_test extends apb_test;
  `uvm_component_utils(simple_read_test)
  simple_read seq;
  function new(string name = "simple_read_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq =simple_read::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask 
endclass 



class write_read_test extends apb_test;
  `uvm_component_utils(write_read_test)
  write_followed_read seq;
  function new(string name = "write_read_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq =write_followed_read::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask 
endclass 


class back_back_write_test extends apb_test;
  `uvm_component_utils(back_back_write_test)
  back_back_write seq;
  function new(string name = "back_back_write_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq =back_back_write::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask 
endclass 

class back_back_read_test extends apb_test;
  `uvm_component_utils(back_back_read_test)
  back_back_read seq;
  function new(string name = "back_back_read_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq =back_back_read::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask 
endclass 



class write_error_seq_test extends apb_test;
  `uvm_component_utils(write_error_seq_test)
  write_error_seq seq;
  function new(string name = "write_error_seq_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq =write_error_seq::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask 
endclass 

class strobe_check_seq_test extends apb_test;
  `uvm_component_utils(strobe_check_seq_test)
  strobe_check_seq seq;
  function new(string name = "strobe_check_seq_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq =strobe_check_seq::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask 
endclass 

  


class regression_test extends apb_test;
  `uvm_component_utils(regression_test)
  regression_seq seq;
  function new(string name = "regression_test",
               uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq =regression_seq::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask 
endclass 

