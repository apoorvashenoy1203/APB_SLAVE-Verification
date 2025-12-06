
`include "apb_interface.sv"
//`include "apb_pkg.sv"
`include "design.sv"

module top;
  
  import uvm_pkg::*;
  import apb_pkg::*;
    
  bit PCLK;
  bit PRESETn;
  
  initial begin
    
    PCLK=0;PRESETn=0;
#30; PRESETn=1;
#10;PRESETn=0;
#10;PRESETn=1;
  end
  
      always #5PCLK=~PCLK;

  
  apb_inf vif(PCLK, PRESETn);
  
  apb_slave#(.ADDR_WIDTH(`ADDR_WIDTH), .DATA_WIDTH(`DATA_WIDTH), .MEM_DEPTH(`DEPTH)) DUT(.PCLK(PCLK), 
                .PRESETn(PRESETn),
                .PSEL(vif.PSEL),
          .PENABLE(vif.PENABLE),
          .PWRITE(vif.PWRITE),
          .PADDR(vif.PADDR),
		  .PWDATA(vif.PWDATA),
		  .PSLVERR(vif.PSLVERR),
          .PRDATA(vif.PRDATA),
          .PSTRB(vif.PSTRB),
          .PREADY(vif.PREADY)
	);  
  
//   initial begin
//     PRESETn=0;
//     #5 PRESETn=1;
//   end
  
  initial begin

		$dumpfile("dump.vcd");
		$dumpvars;
    uvm_config_db#(virtual apb_inf)::set(null, "*", "vif", vif);
    run_test("write_error_seq_test");
    
  end
endmodule
