module microinstruction_counter(
  input clock,
  input reset,
  output [7:0] microinstruction_stage
);

wire not_reset;
not(not_reset, reset);

wire resettable_mi0;
or(resettable_mi0, reset, microinstruction_stage[7]);
d_flip_flop mi0(
  .data(resettable_mi0),
  .clock(clock),
  .current_state(microinstruction_stage[0])
);

wire resettable_mi1;
and(resettable_mi1, not_reset, microinstruction_stage[0]);
d_flip_flop mi1(
  .data(resettable_mi1),
  .clock(clock),
  .current_state(microinstruction_stage[1])
);

wire resettable_mi2;
and(resettable_mi2, not_reset, microinstruction_stage[1]);
d_flip_flop mi2(
  .data(resettable_mi2),
  .clock(clock),
  .current_state(microinstruction_stage[2])
);

wire resettable_mi3;
and(resettable_mi3, not_reset, microinstruction_stage[2]);
d_flip_flop mi3(
  .data(resettable_mi3),
  .clock(clock),
  .current_state(microinstruction_stage[3])
);

wire resettable_mi4;
and(resettable_mi4, not_reset, microinstruction_stage[3]);
d_flip_flop mi4(
  .data(resettable_mi4),
  .clock(clock),
  .current_state(microinstruction_stage[4])
);

wire resettable_mi5;
and(resettable_mi5, not_reset, microinstruction_stage[4]);
d_flip_flop mi5(
  .data(resettable_mi5),
  .clock(clock),
  .current_state(microinstruction_stage[5])
);

wire resettable_mi6;
and(resettable_mi6, not_reset, microinstruction_stage[5]);
d_flip_flop mi6(
  .data(resettable_mi6),
  .clock(clock),
  .current_state(microinstruction_stage[6])
);

wire resettable_mi7;
and(resettable_mi7, not_reset, microinstruction_stage[6]);
d_flip_flop mi7(
  .data(resettable_mi7),
  .clock(clock),
  .current_state(microinstruction_stage[7])
);

endmodule