//-----------------------------------------------------------------------------
// Author      :  Admin
// Email       :  contact@chipverify.com
// Description :  Top Level module to hold Test and Environment Objects  
//-----------------------------------------------------------------------------

`include "timescale.v"

module top;
   import uvm_pkg::*;
   import test_pkg::*;

   // Start the test using global task "run_test()"
   initial begin
      run_test ("base_test");
   end
endmodule
