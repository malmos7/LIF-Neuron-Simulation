
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer: Mal Mostafa
// 
// Create Date: 06/26/2025 02:47:30 PM
// Design Name: LIF neuron Discrete Decay Model
// Module Name: LIFSIM_tb
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
`timescale 1ns / 1ps

module LIFSIM_tb();
    //parameters
   parameter signed [15:0] Vth = 0.05 * 65536; //equivalent to 50 mV
   parameter  [15:0] dv = 16'd6;// membrane decay coefficient (~10 ms τ)
	 parameter  [15:0] du = 16'd6;// leak current decay coefficient (~10 ms τ)
   
    //inputs 
	reg   	     clk; //this is the sys_clk
	reg      	  reset; 
	reg 	[15:0]  I_app;

	//outputs of the first neuron
	wire  signed [15:0] V_mem;
	wire         [15:0] V_out;
	wire  signed [15:0] U_leak;
	
	//decay parameters
	wire  signed [31:0] dU_dt;
	wire  signed [31:0] dV_dt;
	
   
    
	//instantiate DUT
	//first neuron
	LIFSIM  # (
	       
	       .Vth(Vth),
	       .dv(dv),  
	       .du(du)
	
	         ) neuron (

				.clk(clk),
				.reset(reset),
				.I_app(I_app),
				.I_fb(16'd0),
				.V_mem(V_mem),
				.V_out(V_out),
				.U_leak(U_leak),
				.dU_dt(dU_dt),
				.dV_dt(dV_dt)
	);
	
	
// Generate a clock that should be driven to design
// This clock will flip its value every 0.5us -> time period = 1us -> freq = 1 MHz
//same freq as sys_clk
// initializing clock at zero
	initial begin
		clk = 0;
	end
	
	always #500 clk = ~clk;
  

	initial begin
		$display("starting sim");
		
		I_app <= 16'd1;
		//initializing reset
		reset <= 1;
      #1000 reset <= 0;
		//allow simulation to run
		#10000000;
		//finishing simulation
		$display("Sim finished");
		$finish;
		
	end

	
endmodule
