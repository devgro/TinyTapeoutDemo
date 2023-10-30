typedef enum logic[3:0] {
    ADD         = 4'd0,
    SUBTRACT    = 4'd1,
    AND         = 4'd2,
    OR          = 4'd3,
    EQUALS      = 4'd4,
    NOT         = 4'd5,
    GT          = 4'd6,
    LT          = 4'd7
} alu_op_t;

module BCDtoSevenSegment
  (input  logic [3:0] bcd,
   output logic [6:0] segment);

  always_comb
    unique case (bcd) 
      4'd0: segment = 7'b011_1111;
      4'd1: segment = 7'b000_0110;
      4'd2: segment = 7'b101_1011;
      4'd3: segment = 7'b100_1111;
      4'd4: segment = 7'b110_0110;
      4'd5: segment = 7'b110_1101;
      4'd6: segment = 7'b111_1101;
      4'd7: segment = 7'b000_0111;
      4'd8: segment = 7'b111_1111;
      4'd9: segment = 7'b110_0111;
      default: segment = 7'b0;
    endcase

endmodule : BCDtoSevenSegment

module tt_um_alu_chip (
    input  logic [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output logic [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  logic [7:0] uio_in,   // IOs: Bidirectional Input path
    output logic [7:0] uio_out,  // IOs: Bidirectional Output path
    output logic [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  logic       ena,      // will go high when the design is enabled
    input  logic       clk,      // clock
    input  logic       rst_n);   // reset_n - low to reset);
    
    logic [3:0] alu_in_1, alu_in_2, alu_op_in, alu_out;

    assign alu_in_1 = ui_in[7:4];
    assign alu_in_2 = ui_in[3:0];
    assign alu_op_in = uio_in[3:0];
    assign uio_out[7:4] = alu_out;
    assign uio_oe = 8'hF0;
    assign uio_out[3:0] = 4'd0;
    
    BCDtoSevenSegment bcd_out(.bcd(alu_out), .segment(uo_out[6:0]));
    assign uo_out[7] = 1'b0;
    // 4 input a, 4 input b, 4 bidirectional alu_op_in, 4 bidirectional result_out, 7 output result_7seg
    always_comb begin
      case(alu_op_in)  
        ADD: alu_out = alu_in_1 + alu_in_2;
        SUBTRACT: alu_out = alu_in_1 - alu_in_2;
        AND: alu_out = alu_in_1 & alu_in_2;
        OR: alu_out = alu_in_1 & alu_in_2;
        EQUALS: alu_out = (alu_in_1 == alu_in_2) ? (4'hF) : (4'h0);
        NOT: alu_out = ~alu_in_1;    
        GT: alu_out = (alu_in_1 > alu_in_2) ? (4'hF) : (4'h0);
        LT: alu_out = (alu_in_1 < alu_in_2) ? (4'hF) : (4'h0);
        default: alu_out = 4'd0;
      endcase
    end


endmodule : tt_um_alu_chip
