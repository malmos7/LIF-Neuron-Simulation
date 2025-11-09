`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2025 05:10:42 PM
// Design Name: 
// Module Name: RC_LIF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RC_LIF(
    input wire clk,
    input wire reset,
    input wire [7:0] I_app,
    input wire [7:0] R,
    input wire [7:0] C,
    output reg [15:0] V_mem,
    output reg [15:0] V_out,
    output reg [15:0] dVmem_dt
    );
    
    //-----------------RC LIF NEURON------------
    /*
        -a constant current is applied as an input to the system
        -the current charges the capacitor which increases Vmem
        -once Vmem is equal to the thresh voltage 
        -Vout is set to 1 and Vmem drops to zero 
        -reset is set to 1clk
    */
    
    //defining internal register fro threshold voltage parameter
    parameter Vth = 16'd50;
    
    //rising edge-trigger
    always @(posedge clk) begin
        //reset active
        if (reset) begin
        // set all values to resting state 
            V_mem <= 16'd0;
            V_out <= 16'd0;
            dVmem_dt <= 16'd0;
        end else begin // reset is low
        
            //evaluate RC inputs to avoid division by 0 or truncated integer vals
            if (R!=0 && C!=0) begin
                //compute membrane potential rate of change
                dVmem_dt <= (I_app - V_mem * (1/R)) * (1/C);
            end else begin
                dVmem_dt <= 16'd0;
            end
           
            //check if membrane potential reached firing threshold
            if (V_mem < Vth) begin
                //update membrane potential if below threshold
                V_mem <= V_mem + dVmem_dt;
                V_out <= 16'd0;   //and do not spike
            end else if(V_mem >= Vth) begin
                //spike if membrane potential reaches firing threshold 
                V_out <= 16'd1;
                V_mem <= 16'd0; //return membrane potential to rest state
            end else begin 
            //set both to resting state
                V_out <= 16'd0;
                V_mem <= 16'd0;
            end 
            
        end //end reset == 0
     end //end always
            
endmodule
