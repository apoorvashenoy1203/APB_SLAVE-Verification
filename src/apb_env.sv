class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_active_agent agt_act;
  apb_passive_agent agt_pass;
  apb_scoreboard scb;
  apb_subscriber cov;
  
  
  function new(string name = "apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt_act = apb_active_agent::type_id::create("agt_act", this);
    agt_pass = apb_passive_agent::type_id::create("agt_pass", this);
    scb = apb_scoreboard::type_id::create("scb", this);
   cov = apb_subscriber::type_id::create("cov", this);
    
    uvm_config_db#(uvm_active_passive_enum)::set(this, "agt_act", "is_active", UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "agt_pass", "is_active", UVM_PASSIVE);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    agt_act.mon_act.mon_act_port.connect(scb.item_act);
    agt_pass.mon_pass.mon_pass_port.connect(scb.item_pass);
    
     agt_act.mon_act.mon_act_port.connect(cov.mon_act_cg_port);
    agt_pass.mon_pass.mon_pass_port.connect(cov.mon_pass_cg_port);
  endfunction
endclass

    
