`default_nettype none
module avs_i2c_top (
    clk,
    reset_n,
    avs_s0_address,
    avs_s0_read,
    avs_s0_readdata,
    avs_s0_write,
    avs_s0_writedata,
    avs_s0_irq
);
    input  wire        clk;
    input  wire        reset_n;
    input  wire  [2:0] avs_s0_address;
    input  wire        avs_s0_read;
    output wire [31:0] avs_s0_readdata;
    input  wire        avs_s0_write;
    input  wire [31:0] avs_s0_writedata;
    output wire        avs_s0_irq;


    assign avs_s0_irq = interrupt;
    assign avs_s0_readdata =  ({32{sel_rxdata}}  & reg_rxdata)
                             |({32{sel_txdata}}  & reg_txdata)
                             |({32{sel_clk_div}} & reg_clk_div)
                             |({32{sel_control}} & reg_control)
                             |({32{sel_status}}  & reg_status);
    wire [31:0] reg_rxdata;
    wire [31:0] reg_txdata;
    wire [31:0] reg_clk_div;
    wire [31:0] reg_control;
    wire [31:0] reg_status;
    
    wire sel_rxdata  = (avs_s0_address == 0);
    wire sel_txdata  = (avs_s0_address == 1);
    wire sel_clk_div = (avs_s0_address == 2);
    wire sel_control = (avs_s0_address == 3);
    wire sel_status  = (avs_s0_address == 4);

    wire rxdata_we = sel_rxdata  & avs_s0_write;
    wire rxdata_en = rxdata_we;

    wire txdata_we = sel_txdata  & avs_s0_write;
    wire txdata_en = txdata_we;

    wire clk_div_we = sel_clk_div & avs_s0_write;
    wire clk_div_en = clk_div_we;

    wire control_we = sel_control & avs_s0_write;
    
    //rxdata field
    reg   [7:0] rxdata;
    wire  [7:0] rxdata_nx;
    //txdata field
    reg   [7:0] txdata;
    wire  [7:0] txdata_nx;

    //clk_div field
    reg  clk_div;
    wire clk_div_nx;
    //status field
    wire buzy;
    wire ack;
    reg  interrupt;
    wire interrupt_nx;
    //control field
    wire stop      = control_we & avs_s0_writedata[];
    wire start     = control_we & avs_s0_writedata[];
    wire write     = control_we & avs_s0_writedata[];
    wire read_ack  = control_we & avs_s0_writedata[];
    wire read_nack = control_we & avs_s0_writedata[];
    wire int_clr   = control_we & avs_s0_writedata[];//write 1 to clear pending interrupt

    //status
    wire interrupt_en  = int_clr | done; //logic bug

    assign rxdata_reg  = {{24{1'b0}}, rxdata};
    assign txdata_reg  = {{24{1'b0}}, txdata};
    assign clk_div_reg = {{24{1'b0}}, clk_div_reg};
    assign control_reg = {{24{1'b0}}, control_reg};
    assign status_reg  = {{24{1'b0}}, status_reg};
    

    assign rxdata_nx = (en_rxdata) ? avs_s0_writedata[7:0] : rxdata;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            rxdata <= 0;
        end else begin
            rxdata <= rxdata_nx;    
        end
    end

    assign txdata_nx = (en_txdata) ? avs_s0_writedata[7:0] : txdata;
    always @(posedge clk or negedge reset_n) begin
        txdata <= txdata_nx;
    end

    assign clk_div_nx = (en_clk_div) ? avs_s0_writedata : clk_div;
    always @(posedge clk or negedge reset_n) begin
        clk_div <= clk_div_nx;
    end

    //status fileds

    //control field
    assign int_clr_nx;
    always @(posedge clk or negedge reset_n) begin
        int_clr <= int_clr_nx;
    end

/*
    iclab: i2c spec
interface: alvalon MM

register map

[7:0]rxdata
[7:0]txdata

clk_div

control:(INT)READ_NACK READ_ACK WRITE stop start

status:ACK IDLE BUZY //Auto clear INT by read 

the software need to know what phase in i2c protocol
*/
endmodule