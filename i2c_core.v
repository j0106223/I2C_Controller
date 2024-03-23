module i2c_core (
    clk,
    reset_n,
);
    input  wire clk;
    input  wire reset_n;

    output wire done;
    output wire ack;
    output wire buzy;

    input wire sda;
    input wire scl;
    output wire sda;
    output wire scl;
    
endmodule