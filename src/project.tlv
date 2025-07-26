\m5_TLV_version 1d: tl-x.org
\m5

    // *******************************************
    // * For ChipCraft Course                    *
    // * Replace this file with your own design. *
    // *******************************************

    use(m5-1.0)
\SV
/*
 * Copyright (c) 2023 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

//
// Design: Pipelined 4x4 Multiplier
// Latency: 2 clock cycles
//
module pipelined_multiplier_4x4 (
  // Inputs
  input             clk,
  input             rst_n,
  input             enable,
  input      [3:0]  a_in,
  input      [3:0]  b_in,

  // Output
  output     [7:0]  product_out
);

  // Stage 1 registers for inputs A and B
  reg [3:0] a_s1_reg;
  reg [3:0] b_s1_reg;

  // Stage 2 register for the final product
  reg [7:0] product_s2_reg;

  // Pipelined logic
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      a_s1_reg <= 4'b0;
      b_s1_reg <= 4'b0;
      product_s2_reg <= 8'b0;
    end
    else if (enable) begin
      // First pipeline stage: Capture inputs
      a_s1_reg <= a_in;
      b_s1_reg <= b_in;
      
      // Second pipeline stage: Multiply the values from the first stage
      // and register the result.
      product_s2_reg <= a_s1_reg * b_s1_reg;
    end
  end

  // Assign final output from the last pipeline stage
  assign product_out = product_s2_reg;

endmodule


// Top-level module for the chip template
module tt_um_nishit0072e_multiplier (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  // Instantiate the multiplier
  pipelined_multiplier_4x4 multiplier_inst (
      .clk(clk),
      .rst_n(rst_n),
      .enable(ena),
      .a_in(ui_in[3:0]),      // a_in gets lower 4 bits of ui_in
      .b_in(ui_in[7:4]),      // b_in gets upper 4 bits of ui_in
      .product_out(uo_out)    // Connect product directly to the output
  );

  // All output pins must be assigned. If not used, assign to 0.
  // uo_out is already driven by the multiplier instance above.
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

endmodule
