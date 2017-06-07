class unicast_packet extends packet;

  function agent_unicast_packet(output logic [PACKET_LEN-1:0] agt_unicast_packet);
	  type = 2'b10;
	  sub_type = 4'b0000;
	  agent_packet(agt_unicast_packet);
  endfunction
  endclass
