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
        
    2.set buzy
    1.set timer
    1.set i2c struct member to argument value 
    2.start i2c
    while(state != IDLE){
        if(timeout)
        return;
    }

    */
}
i2c_burst_read(device_id, device_reg, rdata, burst_cnt){
    //fsm
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