module fallthrough_microinstructions(
  input clock,
  input reset
);

wire [7:0] microinstruction_stage;

// Instantiate the microinstruction_counter
microinstruction_counter mic (
  .clock(clock),
  .reset(reset),
  .microinstruction_stage(microinstruction_stage)
);

endmodule 