`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer: Mal Mostafa
// 
// Create Date: 6/15/2025 05:26:34 PM
// Design Name: Analog Model of LIF neuron
// Module Name: RC_tb
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


module RC_tb();
    //input register declaration
    reg       clk;
    reg       reset;
    reg [7:0] I_app;
    reg [7:0] R;
    reg [7:0] C;
    
    //output wire declaration
    wire [15:0] V_mem;
    wire [15:0] V_out;
    wire [15:0] dVmem_dt;
    
    //instantiate a neuron
    RC_LIF n0 (
        .clk(clk),
        .reset(reset),
        .I_app(I_app),
        .R(R),
        .C(C),
        .V_mem(V_mem),
        .V_out(V_out),
        .dVmem_dt(dVmem_dt)
        );
        
     //clk signal freq = 1Mhz
     //initalizing clock variable
     initial begin
        clk = 0;
     end
     //generate clk signal
     always #500 clk =~clk;
     
     //begin simulation
     initial begin
        
        //set input current value
        I_app <= 8'd5;
        //set membrane resistance = 10kohm
        R <= 8'd10;
        //set membrane capacitance = 1uF
        C <= 8'd1;
        
        //initalize neuron (reset active)
        reset <= 1;
        //wait 1 clk cycle for neuron to update
        #1000;
        //pull reset back to low
        reset <= 0;
        
        //run simulation 
        #10000000;
        //end sim
        $finish;
     end   
     
    
endmodule
