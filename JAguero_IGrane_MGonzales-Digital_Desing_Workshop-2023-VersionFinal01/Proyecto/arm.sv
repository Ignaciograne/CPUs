<<<<<<< HEAD:JAguero_IGrane_MGonzales-Digital_Desing_Workshop-2023-VersionFinal01/Proyecto/arm.sv
module arm(input 	logic 		 clk, reset,
			  output logic [31:0] PC,
			  input  logic [31:0] Instr,
			  output logic 		 MemWrite,
			  output logic [31:0] ALUResult, WriteData,
			  input  logic [31:0] ReadData,
			  output logic [1:0]  MemorySelector
			  );
			  
	logic [3:0] ALUFlags;
	logic 		RegWrite, ALUSrc, MemToReg, PCSrc;
	logic [1:0] RegSrc, ImmSrc;
	logic [3:0] ALUControl;
	
	controller c(clk, reset, Instr[31:12], ALUFlags, RegSrc, RegWrite,
					 ImmSrc, ALUSrc, ALUControl, MemWrite, MemToReg, PCSrc);
	
	datapath dp(clk, reset, RegSrc, RegWrite, ImmSrc, ALUSrc, ALUControl, MemToReg, 
					PCSrc, ALUFlags, PC, Instr, ALUResult, WriteData, ReadData, MemorySelector);

=======
module arm(input  logic        clk, reset,
			  output logic [31:0] PCF,
			  input  logic [31:0] InstrF,
			  output logic        MemWriteM,
			  output logic [31:0] ALUOutM, WriteDataM,
			  input  logic [31:0] ReadDataM);
>>>>>>> c951c2ff4ab034a0dda1c5b6ed5f502a36b4234b:arm.sv

   logic [1:0]  RegSrcD, ImmSrcD;
	logic [3:0]  ALUControlE;
	logic        ALUSrcE, BranchTakenE, MemtoRegW, PCSrcW, RegWriteW;
	logic [3:0]  ALUFlagsE;
	logic [31:0] InstrD;
	logic        RegWriteM, MemtoRegE, PCWrPendingF;
	logic [1:0]  ForwardAE, ForwardBE;
	logic        StallF, StallD, FlushD, FlushE;
	logic        Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E;
	
	controller c(clk, reset, InstrD[31:12], ALUFlagsE,
					 RegSrcD, ImmSrcD,
					 ALUSrcE, BranchTakenE, ALUControlE,
					 MemWriteM,
					 MemtoRegW, PCSrcW, RegWriteW,
					 RegWriteM, MemtoRegE, PCWrPendingF,
					 FlushE);
	
	datapath dp(clk, reset,	
	            RegSrcD, ImmSrcD,
					ALUSrcE, BranchTakenE, ALUControlE,
					MemtoRegW, PCSrcW, RegWriteW,
					PCF, InstrF, InstrD,
					ALUOutM, WriteDataM, ReadDataM,
					ALUFlagsE,
					Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
					ForwardAE, ForwardBE, StallF, StallD, FlushD);
	
	hazard h(clk, reset, 
				Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
				RegWriteM, RegWriteW, BranchTakenE, MemtoRegE,
				PCWrPendingF, PCSrcW,
				ForwardAE, ForwardBE,
				StallF, StallD, FlushD, FlushE);
				
endmodule