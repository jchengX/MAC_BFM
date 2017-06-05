////////////////////////////////////////////////
//File:mac_tb_top
//Data:2017/06/03
//Description:mac test bench
///////////////////////////////////////////////

`timescale 1ps/1fs

`include "uvm_pkg.sv"
`include "mac_pkg.sv"

module mac_tb_top;
	import uvm_pkg::*;
	import mac_pkg::*;
	
	logic clk;
	logic rst;
	
	parameter clk_cycle = 12_500;//clk_cycle=12.5ns
  
	//interface declaration
	mac_if mac_if(.rst(rst),.clk(clk));
  
	//connect the interface to the DUT
	dut u_dut(.clk(clk),
		  .rst(rst),
		  .tx_frame(mac_if.tx_frame),
	   	  .tx_valid(mac_if.tx_valid),
	  	  .tx_data(mac_if.tx_data),
	  	  .rx_frame(mac_if.rx_frame),
		  .rx_valid(mac_if.rx_valid)
		  );
	  
	initial
	    begin
	    uvm_config_db#(virtual mac_if)::set(uvm_root::get(),"*","vif",drv_if);
	    run_test();
	end
	
	initial 
	    begin
	    clk = 1'b1;
	    forever begin
		clk = #(clk_cycle/2) ~clk;
	    end
	end	
	
	initial
	    begin
	    rst = 1'b1;
	    #(100ns) rst = 1'b0;
	end
endmodule
