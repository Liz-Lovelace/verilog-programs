module multiplexer_8_to_1_of_256(
  input [7:0] binary,
  output [255:0] selectors
);

wire [7:0] not_binary_8;

/* MACRO multiplexer
  type: binaryToSingleBit
  inputWidth: 2
  inputWire: binary
  inputNotWire: not_binary_8
  outputWire: selectors
*/
//START GENERATED CODE (edit this in the preprocessor)
not(not_binary_8[0], binary[0]);
not(not_binary_8[1], binary[1]);
and(selectors[0], not_binary_8[0], not_binary_8[1]);

and(selectors[1], binary[0], not_binary_8[1]);

and(selectors[2], not_binary_8[0], binary[1]);

and(selectors[3], binary[0], binary[1]);


//END GENERATED CODE

endmodule


module multiplexer_16_to_1_of_65536(
  input [15:0] binary,
  output [65535:0] selectors
);

wire [15:0] not_binary_16;

/* mMACRO multiplexer
  type: binaryToSingleBit
  inputWidth: 16
  inputWire: binary
  inputNotWire: not_binary_16
  outputWire: selectors
*/

endmodule
