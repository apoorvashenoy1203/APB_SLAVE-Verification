class apb_driver extends uvm_driver #(apb_seq_item);
  virtual apb_inf vif;
  apb_seq_item req;
  `uvm_component_utils(apb_driver)
  
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_inf)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF"," Virtual interface not found")
  endfunction
      
        
    task run_phase(uvm_phase phase);
       forever begin
         seq_item_port.get_next_item(req);
         drive();
         seq_item_port.item_done();
         end
    endtask
    
    task drive();
     // @(posedge vif.PCLK);
      vif.PSEL<=1;
      vif.PENABLE<=0;
      vif.PADDR <=req.PADDR;
      vif.PWRITE<=req.PWRITE;
      vif.PWDATA<=req.PWDATA;
      vif.PSTRB<=req.PSTRB;
  
      
      @(posedge vif.PCLK);
      vif.PENABLE<=1;
      @(posedge vif.PCLK);
    
      `uvm_info("DRV", $sformatf("DRIVER WRITE OPERATION: PWRITE=%0b | ADDR=%0d | WDATA=%0d | PSTRB = %d",
    req.PWRITE, req.PADDR, req.PWDATA, req.PSTRB
  ), UVM_LOW);
      while(vif.PREADY==0)
      
      @(posedge vif.PCLK);
      vif.PSEL<=0;
      vif.PENABLE<=0;
      
      
    endtask
    

    endclass
    
      
      
