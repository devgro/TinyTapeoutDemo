typedef enum logic[1:0] {
    ADD         = 2'b00,
    SUBTRACT    = 2'b01,
    OR          = 2'b10,
    EQUALS      = 2'b11
} calc_op_t;

module Register
  #(parameter WIDTH = 8)
  (input logic [WIDTH-1:0] D,
   input logic en, clear, clock,
   output logic [WIDTH-1:0] Q);
    
  always_ff @(posedge clock)
    if(en)
      Q <= D;
    else if (clear)
      Q <= 0;
    else
      Q <= Q; 

endmodule: Register

module tt_um_calculator_chip (
    output logic [7:0] NumOut,
    input logic [7:0] NumIn,
    input logic [1:0] OpIn,
    input logic Enter,
    input  logic [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output logic [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  logic [7:0] uio_in,   // IOs: Bidirectional Input path
    output logic [7:0] uio_out,  // IOs: Bidirectional Output path
    output logic [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  logic       ena,      // will go high when the design is enabled
    input  logic       clk,      // clock
    input  logic       rst_n);     // reset_n - low to reset);

    logic [7:0] state_in;

    Register #(8) state(.D(state_in), .en(Enter), .clear(~rst_n), .clock(clock), .Q(NumOut));

    always_ff @(posedge clock) begin
        unique case(OpIn)
            ADD:        state_in = NumOut + NumIn;
            SUBTRACT:   state_in = NumOut - NumIn;
            OR:         state_in = NumOut | NumIn;
            EQUALS:     state_in = NumOut == NumIn;
        endcase
    end

endmodule : tt_um_calculator_chip
