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

module tt_um_nishit0072e_mult (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);
// Internal pipeline stage registers
    logic [3:0] a_s1_reg;
    logic [3:0] b_s1_reg;
    logic [7:0] product_s2_reg;

    // Pipelined sequential logic for the multiplier
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset for all pipeline stages
            a_s1_reg <= '0;
            b_s1_reg <= '0;
            product_s2_reg <= '0;
        end
        else if (ena) begin
            // Stage 1: Capture inputs from ui_in port
            a_s1_reg <= ui_in[3:0];
            b_s1_reg <= ui_in[7:4];
            
            // Stage 2: Register the product of the previous stage's inputs
            product_s2_reg <= a_s1_reg * b_s1_reg;
        end
    end

    // Assign the final registered product to the dedicated output port
    assign uo_out = product_s2_reg;
  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in;  // Example: ou_out is ui_in
  assign uio_out = 0;
  assign uio_oe  = 0;

endmodule
