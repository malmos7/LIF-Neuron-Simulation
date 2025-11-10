`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer: Mal Mostafa
// 
// Create Date: 06/26/2025 01:43:17 PM
// Design Name: LIF neuron Discrete Decay Model
// Module Name: LIFSIM
// Project Name: 
// Target Devices: Opal Kelly XEM7310
// Tool Versions: Vivado 2019
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LIFSIM #(
    //firing threshold
    parameter signed Vth = 0.05 * 65536, //50 mv
    //membrane potential decay
    parameter dv = 16'd3277,    // dv = 0.05 * 65536 fixed-point
    //leak current decay 
    parameter du = 16'd32768  // du = 0.5 * 65536 fixed-point
    
)(
    //input signals
    input wire clk,
    input wire reset,
    input wire        [15:0] I_app,
    input wire signed [15:0] I_fb,
    //output signals 
    output reg signed [15:0] V_mem,
    output reg        [15:0] V_out, //change to 1 bit
    output reg signed [15:0] U_leak,
    output reg signed [31:0] dU_dt,
    output reg signed [31:0] dV_dt
    );
    
    //register to hold next val of membrane voltage
    reg signed [15:0] Vm_temp;
    
    //rising edge triggered
    always @(posedge clk) begin
        //initalize all signals to 0 when reset high
        if (reset) begin
            V_mem <= 16'd0;
            V_out <= 16'd0;
            U_leak <= 16'd0;
            dU_dt <= 32'd0;
            dV_dt <= 32'd0;
            Vm_temp <= 16'd0;
        end else begin  //reset is low
            
            //update leakage current 
            dU_dt <= U_leak - ((U_leak * du) >> 16);
            U_leak <= $signed(I_app) + I_fb + dU_dt;
            
            //update membrane potential 
            dV_dt <= V_mem - ((V_mem * dv )>>16);
            V_mem <= U_leak + dV_dt;
            
            //set temp var 
            Vm_temp <= V_mem;
                //checking if membrane potential reached threshold
                if (Vm_temp >= Vth) begin
                  //reset voltages and spike
                  V_mem <= 16'd0;
                  V_out <= 16'd1;
                  dV_dt <= 32'd0;           
                end else begin
                   //do not spike
                   V_out <= 16'd0; 
                end
        end
    
    end
    
endmodule
