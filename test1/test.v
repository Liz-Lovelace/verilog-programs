module test_microinstruction;
  reg [7:0] binary;
  wire [255:0] selectors;
  integer i;  // Add counter variable
  
  // Instantiate the multiplexer
  multiplexer_8_to_1_of_256 mux (
    .binary(binary),
    .selectors(selectors)
  );

  // Test stimulus
  initial begin
    // Test all possible 8-bit values
    for (i = 0; i < 256; i = i + 1) begin
      binary = i;  // Assign to binary using the counter
      #1;
      $display("binary=%b selectors=%b", binary, selectors);
    end
    
    $finish;
  end

  // Debug logging system
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, test_microinstruction);
  end

  /* Original test code commented out
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

  // Debug logging on clock edges
  always @(posedge clock or negedge clock) begin
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
  */

endmodule
