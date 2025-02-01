module d_flip_flop(
  input data,
  input clock,
  output current_state,
  output current_not_state
);

wire notData, notClock;
not(notData, data);
not(notClock, clock);

// Master latch (triggered when clock is low)
wire master_out, master_not_out;
wire master_top_gate, master_bottom_gate;
nand(master_top_gate, data, clock);
nand(master_bottom_gate, notData, clock);
nand(master_out, master_top_gate, master_not_out);
nand(master_not_out, master_bottom_gate, master_out);

// Slave latch (triggered when clock is high)
wire slave_top_gate, slave_bottom_gate;
nand(slave_top_gate, master_out, notClock);
nand(slave_bottom_gate, master_not_out, notClock);
nand(current_state, slave_top_gate, current_not_state);
nand(current_not_state, slave_bottom_gate, current_state);

endmodule 

module store_8_bits (
  input [7:0] data,
  input clock,
  output [7:0] out
);

wire [7:0] unused_not_state; // Add wire for unused not_state outputs

d_flip_flop dff_0(data[0], clock, out[0], unused_not_state[0]);
d_flip_flop dff_1(data[1], clock, out[1], unused_not_state[1]);
d_flip_flop dff_2(data[2], clock, out[2], unused_not_state[2]);
d_flip_flop dff_3(data[3], clock, out[3], unused_not_state[3]);
d_flip_flop dff_4(data[4], clock, out[4], unused_not_state[4]);
d_flip_flop dff_5(data[5], clock, out[5], unused_not_state[5]);
d_flip_flop dff_6(data[6], clock, out[6], unused_not_state[6]);
d_flip_flop dff_7(data[7], clock, out[7], unused_not_state[7]);

endmodule