 class apb_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_sequence)

  function new(string name = "apb_sequence");
    super.new(name);
  endfunction: new

  task body();
    repeat(10) begin
      req = apb_seq_item::type_id::create("req");
      wait_for_grant();
      assert(req.randomize());
     // req.PADDR=550;
      send_request(req);
      wait_for_item_done();
    end
  endtask: body
endclass: apb_sequence

class simple_write extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(simple_write)

  function new(string name="simple_write");
    super.new(name);
  endfunction
  virtual task body();
    $display("seq 1");

      `uvm_do_with(req, {req.PWRITE == 1;});
    
 endtask
endclass


class simple_read extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(simple_read)

  function new(string name="simple_read");
    super.new(name);
  endfunction
  virtual task body();
repeat(2)begin
    //$display("seq 2");

      `uvm_do_with(req, {req.PWRITE == 0;});
end
 endtask
endclass


class write_followed_read extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(write_followed_read)

  function new(string name="write_followed_read");
    super.new(name);
  endfunction
  virtual task body();
    int addr;
    repeat(3)begin
      $display("seq 3");

      `uvm_do_with(req, {req.PWRITE == 1; req.PWDATA inside{[1:100]};});
      addr=req.PADDR;
      `uvm_do_with(req, {req.PWRITE ==0; req.PADDR==addr;});
    end
 endtask
endclass

class back_back_write extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(back_back_write)

  function new(string name="back_back_write");
    super.new(name);
  endfunction
  virtual task body();
    repeat(10)begin
      $display("seq 4");

      `uvm_do_with(req, {req.PWRITE == 1;});
    end
 endtask
endclass

class back_back_read extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(back_back_read)

  function new(string name="back_back_read");
    super.new(name);
  endfunction
  virtual task body();
    repeat(10)begin
      $display("seq 5");

      `uvm_do_with(req, {req.PWRITE == 0;});
    end
 endtask
endclass

class write_error_seq extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(write_error_seq)

  function new(string name="write_error_seq");
    super.new(name);
  endfunction
  virtual task body();
        int addr;

    repeat(2)begin
      $display("seq 6");
//       `uvm_do_with(req, {req.PWRITE == 1; req.PWDATA inside{[0:1000]};});
      `uvm_do_with(req, {req.PWRITE == 1;req.PADDR >255;});

 addr=req.PADDR;
      `uvm_do_with(req, {req.PWRITE ==0; req.PADDR==addr;});    end
 endtask
endclass

 class strobe_check_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(strobe_check_seq)

  function new(string name = "strobe_check_seq");
  super.new(name);
 endfunction

 virtual task body();
   int hold_addr;
   repeat(10)begin
     begin
       `uvm_do_with(req, {req.PWRITE == 1;req.PSTRB == 4'b0001;});
       hold_addr = req.PADDR;
       `uvm_do_with(req, {req.PWRITE == 0;req.PADDR == hold_addr;});
     end
     begin
       `uvm_do_with(req, {req.PWRITE == 1;req.PSTRB == 4'b0011;});
       hold_addr = req.PADDR;
       `uvm_do_with(req, {req.PWRITE == 0;req.PADDR == hold_addr;});
     end
     begin
       `uvm_do_with(req, {req.PWRITE == 1;req.PSTRB == 4'b1100;});
       hold_addr = req.PADDR;
       `uvm_do_with(req, {req.PWRITE == 0;req.PADDR == hold_addr;});
     end
     begin
       `uvm_do_with(req, {req.PWRITE == 1;req.PSTRB == 4'b1111;});
       hold_addr = req.PADDR;
       `uvm_do_with(req, {req.PWRITE == 0;req.PADDR == hold_addr;});
     end
     begin
       `uvm_do_with(req, {req.PWRITE == 1;});
       hold_addr = req.PADDR;
       `uvm_do_with(req, {req.PWRITE == 0;req.PADDR == hold_addr;});
     end
     begin
       `uvm_do_with(req, {req.PWRITE == 1; req.PSTRB == 4'b0010;});
      hold_addr = req.PADDR;
       `uvm_do_with(req, {req.PWRITE == 0; req.PADDR == hold_addr;});
   end
end
 endtask
endclass


class pready extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(pready)

  function new(string name="pready");
    super.new(name);
  endfunction
  virtual task body();

      `uvm_do_with(req, { req.PWRITE == 0;      // read
        req.PADDR  == 32'd260;});
 endtask
endclass




class regression_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(regression_seq)
  
 // rand_seq s1;
  simple_write s1;
  simple_read s2;
  write_followed_read s3;
  back_back_write s4;
  back_back_read s5;
//  strobe_check_seq s7;
  write_error_seq s6;
  strobe_check_seq s7;
pready s8;
  function new(string name = "regression_seq");
  super.new(name);
 endfunction

 virtual task body();
   repeat(1)begin
     `uvm_do(s1);
     `uvm_do(s2);
     `uvm_do(s3);
     `uvm_do(s4);
     `uvm_do(s5);
     `uvm_do(s6);
     `uvm_do(s7);
     `uvm_do(s8);
     
   end
 endtask
endclass

