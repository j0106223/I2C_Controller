`default_nettype none
module clk_divider (
    reset_n,
    clk_div,
    clk_i,
    clk_o
);
    
    input  wire reset_n;
    input  wire [15:0]clk_div;//divisor, let firmware to calculate it
    input  wire clk_i;
    output wire clk_o;

    assign clk_o = clk;

    reg  cnt;
    wire cnt_nx = (cnt > clk_div) ? (cnt + 1'b1) : 1'b0;
    always @(posedge clk_i or negedge reset_n) begin
        if (!reset_n) begin
            cnt <= 0;
        end else begin
            cnt <= cnt_nx;
        end
    end

    reg  clk;
    wire clk_nx = (cnt > clk_div) ? ~clk : clk;
    always @(posedge clk_i or negedge reset_n) begin
        if (!reset_n) begin
            clk <= 0;
        end else begin
            clk <= clk_nx;
        end
    end
endmodule