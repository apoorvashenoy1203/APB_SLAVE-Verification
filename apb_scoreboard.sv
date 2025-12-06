`include "defines.sv"

`uvm_analysis_imp_decl(_mon_pass)
`uvm_analysis_imp_decl(_mon_act)

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_imp_mon_pass#(apb_seq_item,apb_scoreboard)item_pass;
  uvm_analysis_imp_mon_act#(apb_seq_item, apb_scoreboard)item_act;
  
                            
  apb_seq_item inp_packet[$];
  apb_seq_item out_packet[$];
  
  virtual apb_inf vif;
  bit[`DATA_WIDTH-1:0]wmem[`DEPTH];
  
  int MATCH;
  int MISMATCH;
  
  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual apb_inf)::get(this, "","vif", vif))
      `uvm_fatal("NO_VIF", "virtual interface get failed");
    item_act = new("item_act", this);
    item_pass = new("item_pass", this);
  endfunction 
  
  virtual function void write_mon_act(apb_seq_item pkt);
    `uvm_info(get_type_name(), "received input packet", UVM_LOW)
    inp_packet.push_back(pkt);
    
  endfunction
  
  virtual function void write_mon_pass(apb_seq_item pkt);
    `uvm_info(get_type_name(),"received output packet", UVM_LOW)
    out_packet.push_back(pkt);
  //  $display("rdata=%d", pkt.PRDATA);
  endfunction
 /* 
  virtual task run_phase(uvm_phase phase);
    apb_seq_item act_item;
    apb_seq_item pass_item;
    apb_seq_item exp_item;

    forever begin
if(vif.PRESETn==0)
begin
`uvm_info(get_type_name(),"=======PRESETn==0====",UVM_LOW)
foreach(wmem[i])
wmem[i]='0;
end
else
begin
      
          wait((inp_packet.size()>0) && (out_packet.size()>0));
          act_item = inp_packet.pop_front();
          pass_item = out_packet.pop_front();
      
      
    exp_item =apb_seq_item::type_id::create("exp_item");
      
      reference_model(act_item, exp_item);
      compare(exp_item, pass_item);
      
    end
end
  endtask
  */
 virtual task run_phase(uvm_phase phase);
    apb_seq_item act_item;
    apb_seq_item pass_item;
    apb_seq_item exp_item;
    forever begin
      fork
        begin
          wait(inp_packet.size()>0);
          act_item = inp_packet.pop_front();
        end
        begin
          wait(out_packet.size()>0);
          pass_item = out_packet.pop_front();
        end
      join
      
    exp_item =apb_seq_item::type_id::create("exp_item");
      
      reference_model(act_item, exp_item);
      compare(exp_item, pass_item);
      
    end
  endtask
  
  task reference_model(input apb_seq_item act_item, ref apb_seq_item exp_item);

    if(act_item.PWRITE) begin
      if(act_item.PADDR <`DEPTH)begin
        exp_item.PSLVERR = 0;
        for(int i=0; i<`STRB_WIDTH; i++)
          if(act_item.PSTRB[i]) wmem[act_item.PADDR][8*i +:8] = act_item.PWDATA[8*i+:8];
      end
    else exp_item.PSLVERR=1;
    end
    else begin
      if(act_item.PADDR <`DEPTH)begin
        exp_item.PSLVERR =0;
        exp_item.PRDATA = wmem[act_item.PADDR];
      end
      else exp_item.PSLVERR=1;
    end
  endtask
  
  task compare(apb_seq_item exp_item, apb_seq_item pass_item);
 if(pass_item.PWRITE)begin
          if (pass_item.PSLVERR === exp_item.PSLVERR) begin
             MATCH++;
$display("=================PSLVERR MATCH====================");
            // `uvm_info("SB", "MATCH", UVM_LOW)
             `uvm_info("SB", $sformatf("ACTUAL PSLVERR = %0d", pass_item.PSLVERR), UVM_LOW)
             `uvm_info("SB", $sformatf("EXPECTED PSLVERR = %0d", exp_item.PSLVERR), UVM_LOW)
          end else begin
           	 MISMATCH++;
 $display("=================PSLVERR MISMATCH====================");      
           	 //`uvm_info("SB", "MISMATCH", UVM_LOW)
             `uvm_info("SB", $sformatf("ACTUAL PSLVERR = %0d", pass_item.PSLVERR), UVM_LOW)
             `uvm_info("SB", $sformatf("EXPECTED PSLVERR = %0d", exp_item.PSLVERR), UVM_LOW)
          end
      end
      else begin
        if(pass_item.PSLVERR)begin
          if (pass_item.PSLVERR === exp_item.PSLVERR) begin
             MATCH++;
             `uvm_info("SB", "MATCH", UVM_LOW)
            `uvm_info("SB", $sformatf("ACTUAL RDATA = %0d PSLVERR = %0d", pass_item.PRDATA, pass_item.PSLVERR), UVM_LOW)
             `uvm_info("SB", $sformatf("EXPECTED RDATA = %0d PSLVERR = %0d", exp_item.PRDATA, exp_item.PSLVERR), UVM_LOW)
          end else begin
             MISMATCH++;
             `uvm_info("SB", "MISMATCH", UVM_LOW)
             `uvm_info("SB", $sformatf("ACTUAL RDATA = %0d PSLVERR = %0d", pass_item.PRDATA, pass_item.PSLVERR), UVM_LOW)
             `uvm_info("SB", $sformatf("EXPECTED RDATA = %0d PSLVERR = %0d", exp_item.PRDATA, exp_item.PSLVERR), UVM_LOW)
          end
        end
        else begin
          if ({pass_item.PSLVERR, pass_item.PRDATA} === {exp_item.PSLVERR, exp_item.PRDATA}) begin
             MATCH++;

            // `uvm_info("SB", "MATCH", UVM_LOW)
            `uvm_info("SB", $sformatf("ACTUAL RDATA = %0d PSLVERR = %0d", pass_item.PRDATA, pass_item.PSLVERR), UVM_LOW)
             `uvm_info("SB", $sformatf("EXPECTED RDATA = %0d PSLVERR = %0d", exp_item.PRDATA, exp_item.PSLVERR), UVM_LOW)
$display("=================PSLVERR and PRDATA MATCH====================");
          end else begin
             MISMATCH++;

             //`uvm_info("SB", "MISMATCH", UVM_LOW)
             `uvm_info("SB", $sformatf("ACTUAL RDATA = %0d PSLVERR = %0d", pass_item.PRDATA, pass_item.PSLVERR), UVM_LOW)
             `uvm_info("SB", $sformatf("EXPECTED RDATA = %0d PSLVERR = %0d", exp_item.PRDATA, exp_item.PSLVERR), UVM_LOW)
$display("=================PSLVERR and PRDATA  MISMATCH====================");
          end
        end
      end

  endtask




















/*
      `uvm_info("SCB_COMPARE", $sformatf(
      "COMPARE: Expected PSLVERR=%0b, RDATA=%0d | Observed PSLVERR=%0b, RDATA=%0d | ADDR=%0d",
      exp_item.PSLVERR, exp_item.PRDATA, pass_item.PSLVERR, pass_item.PRDATA, exp_item.PADDR
    ), UVM_LOW);
    if(pass_item.PSLVERR == exp_item.PSLVERR)
      begin
        MATCH++;
        `uvm_info("scb", "MATCH",UVM_LOW)
      end 
    else begin
      MISMATCH++;
      `uvm_info("scb", "MISMATCH", UVM_LOW)
    end
    if(pass_item.PRDATA === exp_item.PRDATA)
      begin
        MATCH++;
        `uvm_info("scb", "MATCH", UVM_LOW)
      end
    else
      begin
        MISMATCH++;
        `uvm_info("scb", "MISMATCH", UVM_LOW);
      end
*/

  

        

















  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("MATCH = %0d, MISMATCH=%0d", MATCH, MISMATCH),UVM_LOW)
  endfunction
endclass
