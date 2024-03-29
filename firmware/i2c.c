#include <"stdint.h">
void i2c_write(device_id, device_reg, wdata){
    i2c_burst_write(device_id, device_reg, wdata, 1);    
}

i2c_read(device_id, device_reg, rdata){
    i2c_burst_read(device_id, device_reg, rdata, burst_cnt);
    return rdata[0];
}

i2c_burst_write(device_id, device_reg, wdata, burst_cnt){
    //fsm
    /*
    0.if(buzy){
        wait
     }
        
    1.set buzy
    2.set timer
    3.set i2c struct member to argument value 
    4.start i2c
    return;

    */
}
i2c_burst_read(device_id, device_reg, rdata, burst_cnt){
    //fsm
    /*
    while(buzy)
    1.set buzy
    2.set timer
    3.set  argument value to i2c struct members  
    4.start i2c
    */
}
struct i2c {
    uint8_t device_id;
    uint8_t device_reg_addr;
    uint8_t rx_buffer;
    uint8_t tx_buffer;
    int     burst_cnt;
    int rw
    int state
};

i2c_init() {
    //set clk_div
    //state = IDLE
}
i2c_isr() {
    
}
void i2c_isr();
i2c_stop
i2c_start
i2c_write_byte
i2c_stop
i2c_stop

i2c_get_rxdata();

i2c_get_txdata();
i2c_set_txdata();

i2c_get_clk_div();
i2c_set_clk_div();

i2c_set_control();

i2c_get_status();