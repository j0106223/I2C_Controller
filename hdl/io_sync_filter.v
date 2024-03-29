module io_sync_filter (
    reset_n,
    clk_sync,
    clk_filter,
    in,
    out
);
    input  wire reset_n;
    input  wire clk_sync;
    input  wire clk_filter;
    input  wire in;
    output  reg out;
    reg [1:0] sync_buffer;
    reg [2:0] filter_buffer;
    always @(posedge clk_sync or negedge reset_n) begin
        if (!reset_n) begin
            sync_buffer <= 2'b11;
        end else begin
            sync_buffer[0]<= in;
            sync_buffer[1]<= sync_buffer[0];
        end
    end

    always @(posedge clk_filter or negedge reset_n) begin
        if (!reset_n) begin
            filter_buffer <= 3'b111;
        end else begin
            filter_buffer[0] <= sync_buffer[1];
            filter_buffer[1] <= filter_buffer[0];
            filter_buffer[2] <= filter_buffer[1];
        end
    end

    //Emulate the schmitt trigger
    always @(posedge clk_filter or negedge reset_n) begin
        if (!reset_n) begin
            out <= 1'b1;
        end else begin
            if (filter_buffer == 3'b111) begin
                out <= 1'b1;
            end else if (filter_buffer == 3'b000) begin
                out <= 1'b0;
            end
        end
    end
endmodule 