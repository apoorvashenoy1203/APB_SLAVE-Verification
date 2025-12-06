class apb_active_agent extends uvm_agent;
  `uvm_component_utils(apb_active_agent)
  apb_driver drv;
  apb_monitor_active mon_act;
  apb_sequencer seqr;
  
  function new(string name = "apb_active_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"", "is_active", is_active))
	  `uvm_error(get_full_name, $sformatf(" ERROR IN ACTIVE AGENT "))
  
  if(get_is_active ==	UVM_ACTIVE)begin
      drv=apb_driver::type_id::create("drv", this);
      seqr = apb_sequencer::type_id::create("seqr", this);
    end
    mon_act=apb_monitor_active::type_id::create("mon_act", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
  
  class apb_passive_agent extends uvm_agent;
    `uvm_component_utils(apb_passive_agent)
    apb_driver drv;
    apb_monitor_passive mon_pass;
    apb_sequencer seqr;
    
    function new(string name="apb_passive_agent", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"", "is_active", is_active))
	  `uvm_error(get_full_name(), $sformatf(" ERROR IN PASSIVE AGENT "))
  
      
      if(get_is_active ==UVM_ACTIVE)begin
        drv=apb_driver::type_id::create("drv", this);
        seqr=apb_sequencer::type_id::create("seqr", this);
      end
      mon_pass=apb_monitor_passive::type_id::create("mon_pass", this);
    endfunction
  endclass
  
