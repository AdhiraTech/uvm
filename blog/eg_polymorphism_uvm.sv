// Author   : Admin (www.chipverify.com)
// Purpose  : To resolve the error
//-------------------------------------------------------

`include "uvm_macros.svh"
import uvm_pkg::*;

//--------------------------------------------------------------------
//                         Original Testbench
//--------------------------------------------------------------------

class base_env extends uvm_env;
   `uvm_component_utils (base_env)
   function new (string name = "base_env", uvm_component parent=null);
      super.new(name, parent);
   endfunction
endclass

// This test only instantiates the environment
class base_test extends uvm_test;
   `uvm_component_utils (base_test)
   function new (string name = "base_test", uvm_component parent=null);
      super.new (name, parent);
   endfunction

   base_env    m_base_env;

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_base_env = base_env::type_id::create ("m_base_env", this); 
   endfunction
endclass

//-----------------------------------------------------------------
//                     New Testbench
//-----------------------------------------------------------------

// New component developed with display() function
class comp extends uvm_component;
   `uvm_component_utils (comp)
   function new (string name = "comp", uvm_component parent=null);
      super.new(name, parent);
   endfunction

   function display ();
      `uvm_info ("COMP", "Hello there !", UVM_MEDIUM)
   endfunction
endclass


// The component defined above will be used in this environment which
// is a derivative of the older environment
class derived_env extends base_env;
   `uvm_component_utils (derived_env)
   function new (string name = "derived_env", uvm_component parent=null);
      super.new (name, parent);
   endfunction
   
   comp m_comp;

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_comp = comp::type_id::create ("m_comp", this);
   endfunction
   
endclass


// The new derivative env is used in the new test and a hierarchical reference
// is made to the new component used in the new env. We'll be overriding the 
// older environment with the new one
class derived_test extends base_test;
   `uvm_component_utils (derived_test)
   function new (string name = "derived_test", uvm_component parent=null);
      super.new (name, parent);
   endfunction

`ifdef NOCMPERR
   derived_env    m_derived_env;
`endif

   virtual function void build_phase (uvm_phase phase);
      set_type_override_by_type (base_env::get_type(), derived_env::get_type());
      super.build_phase (phase);
   endfunction

   virtual function void end_of_elaboration_phase (uvm_phase phase);
      super.end_of_elaboration_phase (phase);
      uvm_top.print_topology();
   endfunction

   virtual task run_phase (uvm_phase phase);
`ifdef NOCMPERR
      $cast (m_derived_env, m_base_env);
      m_derived_env.m_comp.display();
`else
      m_base_env.m_comp.display (); 
`endif
   endtask
   
endclass


module top;
   import uvm_pkg::*;
   
   initial 
      run_test ("base_test");
endmodule
