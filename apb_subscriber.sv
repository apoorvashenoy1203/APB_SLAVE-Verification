`uvm_analysis_imp_decl(_mon_act_cg)

class apb_subscriber extends uvm_subscriber #(apb_seq_item);

  `uvm_component_utils(apb_subscriber)

  uvm_analysis_imp_mon_act_cg#(apb_seq_item, apb_subscriber) mon_act_cg_port;
  uvm_analysis_imp#(apb_seq_item, apb_subscriber) mon_pass_cg_port;


  apb_seq_item act_item;
  apb_seq_item pas_item;

  real active_cov, passive_cov;

  covergroup act_mon_cov;
    PWRITE_CP : coverpoint act_item.PWRITE {
      bins write = {1};
      bins read  = {0};
    }

    PADDR_CP : coverpoint act_item.PADDR {
      bins addr_low  = {[0:63]};
      bins addr_mid  = {[64:127]};
      bins addr_high = {[128:255]};
    }

    PWDATA_CP : coverpoint act_item.PWDATA {
      bins wdata_low  = {[32'h0000_0000 : 32'h0FFF_FFFF]};
      bins wdata_mid  = {[32'h1000_0000 : 32'hEFFF_FFFF]};
      bins wdata_high = {[32'hF000_0000 : 32'hFFFF_FFFF]};
    }

    PSTRB_CP : coverpoint act_item.PSTRB {
      bins s0 = {4'b0001};
      bins s1 = {4'b0011};
      bins s2 = {4'b1111};
      bins s3[] = {[1:15]} with (!(item inside {4'b0001,4'b0011,4'b1111}));
    }
  endgroup

  covergroup pas_mon_cov;
    PSLVERR_CP : coverpoint pas_item.PSLVERR {
      bins low  = {0};
      bins high = {1};
    }

    PRDATA_CP : coverpoint pas_item.PRDATA {
      bins rdata_low  = {[32'h0000_0000 : 32'h0FFF_FFFF]};
      bins rdata_mid  = {[32'h1000_0000 : 32'hEFFF_FFFF]};
      bins rdata_high = {[32'hF000_0000 : 32'hFFFF_FFFF]};
    }

    PREADY_CP : coverpoint pas_item.PREADY {
      bins low  = {0};
      bins high = {1};
    }
  endgroup

  function new(string name="apb_subscriber", uvm_component parent); 
    super.new(name, parent);
    act_mon_cov = new();
    pas_mon_cov = new();
    mon_pass_cg_port = new("mon_pass_cg_port", this);
    mon_act_cg_port = new("mon_act_cg_port", this);
  endfunction

  function void write_mon_act_cg(apb_seq_item t);
    act_item = t;
    act_mon_cov.sample();
  endfunction

  function void write(apb_seq_item t);
    pas_item = t;
    pas_mon_cov.sample();
  endfunction 

  function void extract_phase(uvm_phase phase);
    active_cov  = act_mon_cov.get_coverage();
    passive_cov = pas_mon_cov.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),$sformatf("[INPUT]  Coverage = %0.2f%%", active_cov),UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("[OUTPUT] Coverage = %0.2f%%", passive_cov),UVM_MEDIUM)
  endfunction

endclass
   
