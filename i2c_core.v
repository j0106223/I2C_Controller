`default_nettype none
module i2c_core (
    clk,
    reset_n,
    //data
    rxdata,
    txdata,
    //control
    start,
    stop,
    write,
    read_ack,
    read_nack,
    //status
    buzy,
    ack,
    rx_done,
    tx_done,
    start_done,
    stop_done,
    //export
    sda_i,
    scl_i,
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
    output wire ack;
    output wire rx_done;
    output wire tx_done;
    output wire start_done;
    output wire stop_done;
    //export
    input  wire sda_i;
    input  wire scl_i;
    output wire sda_o;
    output wire scl_o;
    wire scl;
    clk_divider i2c_clk_gen(
        .reset_n (reset_n),
        .clk_div (clk_div),
        .clk_i   (clk),
        .clk_o   (scl)
    );
endmodule