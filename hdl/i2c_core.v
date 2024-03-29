`default_nettype none
module i2c_core (
    clk,
    reset_n,
    //data
    rxdata,
    txdata,
    //clk_div
    clk_div
    //control
    start,
    stop,
    write,
    read_ack,
    read_nack,
    //status
    buzy,
    ack_fail,
    rx_done,
    tx_done,
    start_done,
    stop_done,
    //export
    sda_i,//filtered
    scl_i,//filtered
    sda_o,
    scl_o
);
    input  wire clk;
    input  wire reset_n;
    //data
    output wire [7:0] rxdata;
    input  wire [7:0] txdata;
    //clk_div
    input wire [15:0] clk_div;
    //control
    input  wire start;
    input  wire stop;
    input  wire write;
    input  wire read_ack;
    input  wire read_nack;
    //status
    output wire buzy;
    output wire ack_fail;
    output wire rx_done;
    output wire tx_done;
    output wire start_done;
    output wire stop_done;
    //export
    input  wire sda_i;
    input  wire scl_i;
    output wire sda_o;
    output wire scl_o;
    wire i2c_clk;
    wire i2c_clk_en;
    assign scl_o = i2c_clk_en & i2c_clk;
    assign scl_o = (state == idle) ? 1'b1 : 
                   (stat  == stretch) ? 1'b0:
                             i2c_clk;
                             
    //pull sda
    //pull down scl
    //start pulse
    reg sda_d1;
    reg scl_d1;
    wire sda_posedge;
    wire scl_posedge;
    wire sda_negedge;
    wire scl_negedge;

    assign sda_posedge = ({sda_d1, sda_i} == 2'b01);
    assign scl_posedge = ({scl_d1, scl_i} == 2'b01);
    assign sda_negedge = ({sda_d1, sda_i} == 2'b10);
    assign scl_negedge = ({scl_d1, scl_i} == 2'b10);
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sda_d1 <= 1'b1;
            scl_d1 <= 1'b1;
        end else begin
            sda_d1 <= sda_i;
            scl_d1 <= scl_i;
        end
    end
    assign start_done = scl_negedge & (state == start);
    assign stop_done  = sda_posedge & (state == stop);
    assign rx_done = scl_negedge & (state == rx_ack);
    assign tx_done = scl_negedge & (state == tx_ack);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
        end else begin
        end
    end

    
    clk_divider i2c_clk_gen(
        .reset_n (reset_n),
        .clk_div (clk_div),
        .clk_i   (clk),
        .clk_o   (i2c_clk)
    );
endmodule