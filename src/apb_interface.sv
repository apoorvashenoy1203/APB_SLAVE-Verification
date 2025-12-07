`include "defines.sv"
interface apb_inf(input bit PCLK, input bit PRESETn);
  //Signals
  logic PWRITE;
  logic PSEL;
  logic PENABLE;
  logic [`ADDR_WIDTH-1:0] PADDR;
  logic [`DATA_WIDTH-1:0] PWDATA;
  logic [`DATA_WIDTH-1:0] PRDATA;
  logic PREADY;
  logic PSLVERR;
  logic [`STRB_WIDTH-1:0]PSTRB;

  //Driver clocking block
  clocking drv_cb @(posedge PCLK);
    default input #0 output #0;
    output PWRITE, PENABLE, PADDR, PWDATA,PSTRB, PSEL;
    input PREADY;
  endclocking

  //Monitor clocking block
  clocking mon_cb @(posedge PCLK);
    default input #0 output #0;
    input PREADY, PRDATA, PSLVERR, PSTRB;
  endclocking

endinterface

