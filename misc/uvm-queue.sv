//-----------------------------------------------------------------------------
// Author   :  Admin    (www.chipverify.com)
// Purpose  :  Example of how to create and use some basic functions of UVM Q
//-----------------------------------------------------------------------------

`timescale 1ns/1ns

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_data extends uvm_sequence_item;
   rand bit [31:0]   addr;
   rand bit [31:0]   data;

   `uvm_object_utils_begin (my_data)
      `uvm_field_int (addr, UVM_ALL_ON)
      `uvm_field_int (data, UVM_ALL_ON)
   `uvm_object_utils_end

   function new (string name="my_data");
      super.new (name);
   endfunction

endclass

class base_test extends uvm_test;

   `uvm_component_utils (base_test)

   uvm_queue #(my_data)    my_q;

   function new (string name, uvm_component parent = null);
      super.new (name, parent);
   endfunction : new

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      my_q = new ("my_q");
   endfunction
   
   virtual task main_phase (uvm_phase phase);
      super.main_phase (phase);

      for (int i = 0; i < 5; i++) begin
         my_data tmp = my_data::type_id::create ("tmp");
         tmp.randomize ();
         tmp.print();
         my_q.push_back (tmp);
      end
      
      for (int i = 0; i < my_q.size(); i++) begin
         my_data obj = my_q.get(i);
         `uvm_info ("QUEUE", $sformatf ("Element[%0d] addr=0x%0h data=0x%0h", i, obj.addr, obj.data), UVM_MEDIUM)
      end
         
   endtask
endclass 


module top;
   import uvm_pkg::*;
   
   initial 
      run_test ("base_test");
endmodule
