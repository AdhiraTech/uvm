-incdir $UVM_HOME
-incdir ./tb
+UVM_NO_RELNOTES
-uvm -sv
./tb/apb_agent.sv
./tb/wb_agent.sv
./tb/spi_agent.sv
./tb/my_pkg.sv
./tb/tb_top.sv
