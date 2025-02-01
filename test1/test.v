module test_microinstruction;
  reg clock;
  reg reset;
  
  // Instantiate the fallthrough_microinstructions
  fallthrough_microinstructions fmic (
    .clock(clock),
    .reset(reset)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  // Test stimulus
  initial begin
    // Initialize signals
    reset = 1;
    #10;
    reset = 0;
    
    // Let it run for a while
    #120;

    reset = 1;
    #10;
    reset = 0;

    #50;
    
    $finish;
  end

  // Debug logging system
  initial begin
    // Set up debug logging
    $dumpfile("test.vcd");
    $dumpvars(0, test_microinstruction);
  end

  // Debug logging on clock edges
  always @(posedge clock or negedge clock) begin
    // Access internal signals using hierarchical paths
    $display("T=%0t [%s] mic: reset=%b clock=%b stage=[%b %b %b %b %b %b %b %b]",
      $time,
      clock ? "RISE" : "FALL",
      reset,
      clock,
      fmic.mic.microinstruction_stage[0],
      fmic.mic.microinstruction_stage[1],
      fmic.mic.microinstruction_stage[2],
      fmic.mic.microinstruction_stage[3],
      fmic.mic.microinstruction_stage[4],
      fmic.mic.microinstruction_stage[5],
      fmic.mic.microinstruction_stage[6],
      fmic.mic.microinstruction_stage[7]
    );
  end

endmodule
