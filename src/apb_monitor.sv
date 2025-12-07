class apb_monitor_active extends uvm_monitor;
  `uvm_component_utils(apb_monitor_active)
  
  virtual apb_inf vif;
  uvm_analysis_port#(apb_seq_item)mon_act_port;
  apb_seq_item inp_item;
  
  function new(string name="apb_monitor_active", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_act_port = new("mon_act_port", this);
    if(!uvm_config_db#(virtual apb_inf)::get(this, "", "vif", vif))
      `uvm_fatal("no_vif","no virtual interface was set");
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.PCLK);
      if(vif.PSEL && vif.PENABLE && vif.PREADY)begin
      inp_item=apb_seq_item::type_id::create("inp_item");
        
        inp_item.PWRITE = vif.PWRITE;
        inp_item.PADDR = vif.PADDR;
        inp_item.PWDATA = vif.PWDATA;
        inp_item.PSTRB = vif.PSTRB;
         `uvm_info("MON_ACT", $sformatf(
          "MONITOR ACTIVE: PWRITE=%0b | ADDR=%0d | WDATA=%0d | STRB=%0b",
          inp_item.PWRITE, inp_item.PADDR, inp_item.PWDATA, inp_item.PSTRB
        ), UVM_LOW);
        
        
        mon_act_port.write(inp_item);
        
      end
    end
  endtask
endclass

      

class apb_monitor_passive extends uvm_monitor;
  `uvm_component_utils(apb_monitor_passive)
  
  virtual apb_inf vif;
  uvm_analysis_port#(apb_seq_item)mon_pass_port;
  apb_seq_item out_item;
  
  function new(string name="apb_monitor_passive", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_pass_port = new("mon_pass_port", this);
    if(!uvm_config_db#(virtual apb_inf)::get(this, "", "vif", vif))
      `uvm_fatal("no_vif","no virtual interface was set");
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
 @(posedge vif.PCLK);
      if(vif.PSEL && vif.PENABLE && vif.PREADY)begin
      out_item=apb_seq_item::type_id::create("out_item");
       out_item.PSLVERR = vif.PSLVERR;

        @(posedge vif.PCLK);

        out_item.PRDATA = vif.PRDATA;
        out_item.PADDR = vif.PADDR;
        out_item.PREADY = vif.PREADY;
        
          `uvm_info("MON_PASS", $sformatf(
          "MONITOR PASSIVE: PREADY=%0b | PSLVERR=%0b | ADDR=%0d | RDATA=%0d",
          out_item.PREADY, out_item.PSLVERR, out_item.PADDR, out_item.PRDATA
        ), UVM_LOW);
        mon_pass_port.write(out_item);
        
      end
     end
  endtask
endclass






