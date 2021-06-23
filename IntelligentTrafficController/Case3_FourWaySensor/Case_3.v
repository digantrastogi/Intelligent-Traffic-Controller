`timescale 1s / 1ms
////////////////////////////////////////////////////////////////////////////////

`define TRUE 1'b1
`define FALSE 1'b0

module HC_trafficController
 (hwy, cntry, X, clock, clear);

output [1:0] hwy, cntry; //2-bit output for 3 states of signal
reg [2:0] hwy, cntry; //declared output signals are registers
input X; //if TRUE, indicates that there is car on
input clock, clear;
parameter RED = 3'b100,
 YELLOW = 3'b010,
 GREEN = 3'b001;
parameter S0 = 3'd0,
 S1 = 3'd1,
 S2 = 3'd2,
 S3 = 3'd3,
 S4 = 3'd4;

reg [2:0] state;
reg [2:0] next_state;
//state changes only at positive edge of clock
always @(posedge clock)
 if (clear)
 state <= S0; //Controller starts in S0 state
 else
 state <= next_state; //State change
always @(state)
begin
 hwy = GREEN; //Default Light Assignment for Highway light
 cntry = RED; //Default Light Assignment for Country light
 case(state)
 S0: ; // No change, use default
 S1: hwy = YELLOW;
 S2: hwy = RED;
 S3: begin
 hwy = RED;
 cntry = GREEN;
 end
 S4: begin
 hwy = RED;
 cntry = YELLOW;
 end
 endcase
end
always @(state or X)
begin
 case (state)
 S0: if(X)
 next_state = S1;
 else
 next_state = S0;
 S1: begin //delay some positive edges of clock
 next_state = S2;
 end
 S2: begin //delay some positive edges of clock
 next_state = S3;
 end
 S3: if(X)
 next_state = S3;
 else
 next_state = S4;
 S4: begin //delay some positive edges of clock
 next_state = S0;
 end
 default: next_state = S0;
 endcase
end
endmodule