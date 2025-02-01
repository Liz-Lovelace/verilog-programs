module add_two_bits (
  input a,
  input b,
  output out_carry,
  output out_sum
);

xor(out_sum, a, b);
and(out_carry, a, b);

endmodule


module add_two_bits_with_carry (
  input a,
  input b,
  input in_carry,
  output out_carry,
  output out_sum
);

wire sum_from_nocarry, carry_from_nocarry;

add_two_bits nocarry_adder(
  .a(a),
  .b(b),
  .out_carry(carry_from_nocarry),
  .out_sum(sum_from_nocarry)
);

xor(out_sum, sum_from_nocarry, in_carry); // done with sum output

wire shifted_sum_if_in_carry;
and(shifted_sum_if_in_carry, sum_from_nocarry, in_carry);
or(out_carry, shifted_sum_if_in_carry, carry_from_nocarry); // done with carry output

endmodule

module add_8_bits (
  input [7:0] a,
  input [7:0] b,
  output [7:0] out_sum,
  output out_carry
);

wire [6:0] internal_carry;

add_two_bits add0(
  .a(a[0]),
  .b(b[0]),
  .out_carry(internal_carry[0]),
  .out_sum(out_sum[0])
);

add_two_bits_with_carry add1(
  .a(a[1]),
  .b(b[1]),
  .in_carry(internal_carry[0]),
  .out_carry(internal_carry[1]),
  .out_sum(out_sum[1])
);

add_two_bits_with_carry add2(
  .a(a[2]),
  .b(b[2]),
  .in_carry(internal_carry[1]),
  .out_carry(internal_carry[2]),
  .out_sum(out_sum[2])
);

add_two_bits_with_carry add3(
  .a(a[3]),
  .b(b[3]),
  .in_carry(internal_carry[2]),
  .out_carry(internal_carry[3]),
  .out_sum(out_sum[3])
);

add_two_bits_with_carry add4(
  .a(a[4]),
  .b(b[4]),
  .in_carry(internal_carry[3]),
  .out_carry(internal_carry[4]),
  .out_sum(out_sum[4])
);

add_two_bits_with_carry add5(
  .a(a[5]),
  .b(b[5]),
  .in_carry(internal_carry[4]),
  .out_carry(internal_carry[5]),
  .out_sum(out_sum[5])
);

add_two_bits_with_carry add6(
  .a(a[6]),
  .b(b[6]),
  .in_carry(internal_carry[5]),
  .out_carry(internal_carry[6]),
  .out_sum(out_sum[6])
);

add_two_bits_with_carry add7(
  .a(a[7]),
  .b(b[7]),
  .in_carry(internal_carry[6]),
  .out_carry(out_carry),
  .out_sum(out_sum[7])
);

endmodule 