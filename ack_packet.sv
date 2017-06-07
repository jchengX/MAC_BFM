class ack_packet extends packet;
	logic [47:0] RA;

	//function new();
	//endfunction
	
	function agent_ack_packet();//14byte
	type = 2'b01;
	sub_type = 4'b1101;
	agt_ack_packet = {frame_control,duration,RA,fcs};
	endfunction

endclas
