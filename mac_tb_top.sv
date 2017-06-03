////////////////////////////////////////////////
//File:mac_tb_top
//Data:2017/06/03
//Description:mac test bench
///////////////////////////////////////////////

`timescale 1ps/1fs

`include "uvm_pkg.sv"
`include "mac_pkg.sv"
`include "mac.v"
`include "mac_if.sv"

module mac_tb_top;
	import uvm_pkg::*;
	import mac_pkg::*;
  
	//interface declaration
	mac_if vif(.rst(rst),.clk(clk));
  
	//connect the interface to the DUT
	dut u_dut(.(vif.sig_clk),
	   	  .(vif.sig_rst),
	  	  .(vif.sig_data),
	  	  .(vif.sig_crc)
		  );
	  
	initial
	  begin
	  uvm_config_db#(virtual mac_if)::set
	  run_test("mac_test");
	end

	initial begin
	   clk = 1'b1;
	   rst = 1'b1;
	   #(100ns) rst = 1'b0;	
	end
	always #6250 clk = ~clk;//80MHz

endmodule
