# wifi
Build a bfm to simulation WIFI station basic behavior at mac level, and build a monitor to collect tx/rx packet. And build a scoreboard to compare the packets from bfm and monitor. 
1.	Interface 
a.	clk
b.	tx: tx_frame/tx_valid[3:0]/tx_data[31:0] (output)
c.	rx: rx_frame/rx_valid[3:0]/rx_data[31:0](input)
Note: 
•	tx_frame indicate the tx start, tx_valid indicate valid byte of tx_data, tx_data include tx packet data.
•	rx_frame indicate the rx start, rx_valid indicate valid byte of rx_data, rx_data include rx packet data.
•	Clk: 80M

2.	Protocol
a.	Tx a unicast data packet, wait for rx ack in sifs
b.	Tx a broadcast data(beacon) packet, no need wait any ack in sifs
c.	Tx an aggregate data packet, wait rx block ack in sifs
d.	Rx a unicast data packet, tx ack in sifs
e.	Rx a broadcast data packet, no need tx ack in sifs
f.	Rx an aggregate data packet,tx block ack in sifs

3.	Coding requirement
a.	Use uvm class to modeling data packet/beacon packet/aggregate packet
b.	Uvm driver, monitor, scoreboard are needed

4.	Reference doc
To search wifi protocol on google. Key words: 802.11n, sifs, beacon, packet structure. 
