/*
TKU ICLAB: I2C Spec
Interface: Avalon MM

Register map

0: rxdata   [7:0]
1: txdata   [7:0]
2: clk_div [15:0]
3: control  [7:0]
4: status   [7:0]


clk_div = system_freq / (target_freq * 2)

control   [0]: start
control   [1]: stop
control   [2]: write
control   [3]: read_ack
control   [4]: read_nack
control   [5]: int_clr
control [7:6]: reserved

status   [0]: buzy
status   [1]: ack_fail
status   [2]: interrupt
status [7:3]: reserved
*/
`default_nettype none
module avs_i2c_top (
    clk,
    reset_n,
    avs_s0_address,
    avs_s0_read,
    avs_s0_readdata,
    avs_s0_write,
    avs_s0_writedata,
    avs_s0_irq,
    avs_s0_export_sda_i,
    avs_s0_export_scl_i,
    avs_s0_export_sda_o,
    avs_s0_export_scl_o
);
    input  wire        clk;
    input  wire        reset_n;
    input  wire  [2:0] avs_s0_address;
    input  wire        avs_s0_read;
    output wire [31:0] avs_s0_readdata;
    input  wire        avs_s0_write;
    input  wire [31:0] avs_s0_writedata;
    output wire        avs_s0_irq;
    //export
    input  wire avs_s0_export_sda_i;
    input  wire avs_s0_export_scl_i;
    output wire avs_s0_export_sda_o;
    output wire avs_s0_export_scl_o;

    wire [31:0] reg_rxdata;
    wire [31:0] reg_txdata;
    wire [15:0] reg_clk_div;
    wire [31:0] reg_control;
    wire [31:0] reg_status;

    assign avs_s0_irq = interrupt;
    assign avs_s0_readdata =  ({32{sel_rxdata}}  & reg_rxdata)
                             |({32{sel_txdata}}  & reg_txdata)
                             |({32{sel_clk_div}} & reg_clk_div)
                             |({32{sel_control}} & reg_control)
                             |({32{sel_status}}  & reg_status);

    wire sel_rxdata  = (avs_s0_address == 0);
    wire sel_txdata  = (avs_s0_address == 1);
    wire sel_clk_div = (avs_s0_address == 2);
    wire sel_control = (avs_s0_address == 3);
    wire sel_status  = (avs_s0_address == 4);

    //wire rxdata_we = sel_rxdata  & avs_s0_write;
    wire rxdata_en = rx_done;//read only

    wire txdata_we = sel_txdata  & avs_s0_write;
    wire txdata_en = txdata_we;

    wire clk_div_we = sel_clk_div & avs_s0_write;
    wire clk_div_en = clk_div_we;

    wire control_we = sel_control & avs_s0_write;
    //status
    wire rx_done;
    wire tx_done;
    wire start_done;
    wire stop_done;
    wire interrupt_en  =  int_clr
                        | rx_done
                        | tx_done
                        | start_done
                        | stop_done;
    //rxdata field
    reg   [7:0] rxdata;
    wire  [7:0] rxdata_nx;
    //txdata field
    reg   [7:0] txdata;
    wire  [7:0] txdata_nx;

    //clk_div field
    reg  [15:0] clk_div;
    wire [15:0] clk_div_nx;
    //status field
    wire buzy;
    wire ack;
    reg  interrupt;
    wire interrupt_nx;
    //control field
    wire start     = control_we & avs_s0_writedata[0];
    wire stop      = control_we & avs_s0_writedata[1];
    wire write     = control_we & avs_s0_writedata[2];
    wire read_ack  = control_we & avs_s0_writedata[3];
    wire read_nack = control_we & avs_s0_writedata[4];
    wire int_clr   = control_we & avs_s0_writedata[5];//write 1 to clear pending interrupt



    assign reg_rxdata  = {{24{1'b0}}, rxdata};
    assign reg_txdata  = {{24{1'b0}}, txdata};
    assign reg_clk_div = {{16{1'b0}}, clk_div};
    assign reg_control = {{32{1'b0}}};
    assign reg_status  = {{29{1'b0}}, interrupt, ack, buzy};
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            rxdata <= 0;
        end else begin
            if (rxdata_en) begin
                rxdata <= rxdata_nx;
            end
        end
    end

    assign txdata_nx = avs_s0_writedata[7:0];
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            txdata <= 0;
        end else begin
            if (txdata_en) begin
                txdata <= txdata_nx;
            end
        end
    end

    assign clk_div_nx = avs_s0_writedata[15:0];
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            clk_div <= 0;
        end else begin
            if (clk_div_en) begin
                clk_div <= clk_div_nx;
            end
        end
    end

    //status fileds
    assign interrupt_nx = (int_clr) ? 1'b0 : 1'b1;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            interrupt <= 0;
        end else begin
            if (interrupt_en) begin
                interrupt <= interrupt_nx;
            end
        end
    end


    i2c_core i2c_core(
        .clk        (clk),
        .reset_n    (reset_n),
        //data
        .rxdata     (rxdata_nx),
        .txdata     (txdata),
        //control
        .start      (start),
        .stop       (stop),
        .write      (write),
        .read_ack   (read_ack),
        .read_nack  (read_nack),
        //status
        .buzy       (buzy),
        .ack        (ack),
        .rx_done    (rx_done),
        .tx_done    (tx_done),
        .start_done (start_done),
        .stop_done  (stop_done),
        //export
        .sda_i      (avs_s0_export_sda_i),
        .scl_i      (avs_s0_export_scl_i),
        .sda_o      (avs_s0_export_sda_o),
        .scl_o      (avs_s0_export_scl_o)
    );
    
endmodule