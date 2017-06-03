////////////////////////////////////////
//file:mac
//data:2017/06/03
//description:mac interface
///////////////////////////////////////

interface mac_if(input rst,input clk);//define interface

	logic 	     tx_frame;
	logic [3:0]  tx_valid;
	logic [31:0] tx_data;
  
	logic	     rx_frame;
	logic [3:0]  rx_valid;
	logic [31:0] rx_data;
	
	modport slave(
			input  tx_frame,
			input  tx_valid,
			input  tx_data, 
			output rx_frame,
			output rx_valid,
			output rx_data
			);

	modport master(
			output tx_frame,
			output tx_valid,
			output tx_data,
			input  rx_frame,
			input  rx_valid,
			input  rx_data
			);
`ifdef SIMULATION

	default clocking cb_drv@(posedge clk);
		output tx_frame,tx_valid,tx_data;
		input  rx_frame,rx_valid,rx_data;
	endclock:cb_drv
	
	clocking cb_mon@(posedge clk);
		input tx_frame,tx_valid,tx_data,rx_frame,rx_valid,rx_data;
	endclocking:cb_mon 

	clocking cb_recv@(posedge clk);
		input  tx_frame,tx_valid,tx_data;
		output rx_frame,rx_valid,rx_data;
	endclocking:cb_recv
	
	modport driver(
		input rst,clk,
		input cb_drv
		);
	modport monitor(
		input rst,clk,
		input cb_mon
		);
	modport reciver(
		input rst,clk,
		input cb_recv
		);

endinterface: mac_if
