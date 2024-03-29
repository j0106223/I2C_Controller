module i2c_ctrl (
    clk,
    reset_n
);
    input clk;
    input reset_n;
    wire rx_cnt;
    wire tx_cnt;
    //fsm
    reg state;
    reg state_nx;
    localparam  = ;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= ;
        end else begin
            state <= state_nx
        end
    end
 input  wire start;
    input  wire stop;
    input  wire write;
    input  wire read_ack;
    input  wire read_nack;
    always @* begin
        case(state)
            IDLE:
            start:
            start:
            WRITE:
            WRITE1:
            WRITE2:
            WRITE3:
            WRITE4:
            WRITE5:
            WRITE6:
            WRITE7:
            PAUSE:
            read:
            read:
            read:
            read:
            read:
            read:
            read:
            stop:
            0:
            0:
            0:
            0:
            0:
            0:
            0:
        endcase
    end

    //out scl_en
    //out sda
endmodule