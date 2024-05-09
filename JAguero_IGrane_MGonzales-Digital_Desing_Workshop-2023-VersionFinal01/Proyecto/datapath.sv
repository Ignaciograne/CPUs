<<<<<<< HEAD:JAguero_IGrane_MGonzales-Digital_Desing_Workshop-2023-VersionFinal01/Proyecto/datapath.sv
module datapath(input  logic 		   clk, reset,
					 input  logic [1:0]  RegSrc, 
					 input  logic	 	   RegWrite,
					 input  logic [1:0]  ImmSrc,
					 input  logic 	      ALUSrc,
					 input  logic [3:0]  ALUControl,
					 input  logic 		   MemToReg,
					 input  logic 		   PCSrc,
					 output logic [3:0]  ALUFlags,
					 output logic [31:0] PC, 
					 input  logic [31:0] Instr, 
					 output logic [31:0] ALUResult, WriteData, 
					 input  logic [31:0] ReadData,
					 output logic [1:0]  MemorySelector
					 );
	
	logic [31:0] PCNext, PCPlus4, PCPlus8;
	logic [31:0] ExtImm, SrcA, SrcB, Result;
	logic [3:0]  RA1, RA2;
	
	// Next PC
	mux2 #(32)  pcmux(PCPlus4, Result, PCSrc, PCNext);
	flopr #(32) pcreg(clk, reset, PCNext, PC);
	adder #(32) pcadd1(PC, 32'b100, PCPlus4);
	adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);
	
	// Register file
	mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
	regfile   rf(clk, RegWrite, RA1, RA2, Instr[15:12], Result, PCPlus8, SrcA, WriteData);
	
	mux2 #(32) resmux(ALUResult, ReadData, MemToReg, Result);
	extend    ext(Instr[23:0], ImmSrc, ExtImm, MemorySelector);
	
	// ALU
	mux2 #(32) srcbmux(WriteData, ExtImm, ALUSrc, SrcB);
	//alu #(32) ownALU(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
	//chavarria ownALU(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
	ALUChava ownALU(SrcA, SrcB, ALUControl, ALUFlags, ALUResult);
=======
module datapath(input logic         clk, reset,
					 input logic  [1:0]  RegSrcD, ImmSrcD,
					 input logic         ALUSrcE, BranchTakenE,
					 input logic  [3:0]  ALUControlE,
					 input logic         MemtoRegW, PCSrcW, RegWriteW,
					 output logic [31:0] PCF,
					 input logic  [31:0] InstrF,
					 output logic [31:0] InstrD,
					 output logic [31:0] ALUOutM, WriteDataM,
					 input logic  [31:0] ReadDataM,
					 output logic [3:0]  ALUFlagsE,
>>>>>>> c951c2ff4ab034a0dda1c5b6ed5f502a36b4234b:datapath.sv
					 
					 // logica de riesgos (hazard logic)
					 output logic        Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E,
					 input logic  [1:0]  ForwardAE, ForwardBE,
					 input logic         StallF, StallD, FlushD);


	logic [31:0] PCPlus4F, PCnext1F, PCnextF;
	logic [31:0] ExtImmD, rd1D, rd2D, PCPlus8D;
	logic [31:0] rd1E, rd2E, ExtImmE, SrcAE, SrcBE, WriteDataE, ALUResultE;
	logic [31:0] ReadDataW, ALUOutW, ResultW;
	logic [3:0]  RA1D, RA2D, RA1E, RA2E, WA3E, WA3M, WA3W;
	logic        Match_1D_E, Match_2D_E;
	
	
	
	// Fetch stage
	mux2 #(32) pcnextmux(PCPlus4F, ResultW, PCSrcW, PCnext1F);
	mux2 #(32) branchmux(PCnext1F, ALUResultE, BranchTakenE, PCnextF);
	flopenr #(32) pcreg(clk, reset, ~StallF, PCnextF, PCF);
	adder #(32) pcadd(PCF, 32'h4, PCPlus4F);
	
	// Decode stage
	assign PcPlus8D = PCPlus4F; // skip register
	flopenrc #(32) instrreg(clk, reset, ~StallD, FlushD, InstrF, InstrD);
	mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrcD[0], RA1D);
	mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrcD[1], RA2D);
	regfile rf(clk, RegWriteW, RA1D, RA2D, WA3W, ResultW, PCPlus8D, rd1D, rd2D);
	extend ext(InstrD[23:0], ImmSrcD, ExtImmD);
	
	// Execute stage
	flopr #(32) rd1reg(clk, reset, rd1D, rd1E);
	flopr #(32) rd2reg(clk, reset, rd2D, rd2E);
	flopr #(32) immreg(clk, reset, ExtImmD, ExtImmE);
	flopr #(4) wa3ereg(clk, reset, InstrD[15:12], WA3E);
	flopr #(4) ra1reg(clk, reset, RA1D, RA1E);
	flopr #(4) ra2reg(clk, reset, RA2D, RA2E);
	mux3 #(32) byp1mux(rd1E, ResultW, ALUOutM, ForwardAE, SrcAE);
	mux3 #(32) byp2mux(rd2E, ResultW, ALUOutM, ForwardBE, WriteDataE);
	mux2 #(32) srcbmux(WriteDataE, ExtImmE, ALUSrcE, SrcBE);
	alu alu(SrcAE, SrcBE, ALUControlE, ALUResultE, ALUFlagsE);
	
	// Memory stage
	flopr #(32) aluresreg(clk, reset, ALUResultE, ALUOutM);
	flopr #(32) wdreg(clk, reset, WriteDataE, WriteDataM);
	flopr #(4) wa3mreg(clk, reset, WA3E, WA3M);
	
	// Writeback stage
	flopr #(32) aluoutreg(clk, reset, ALUOutM, ALUOutW);
	flopr #(32) rdreg(clk, reset, ReadDataM, ReadDataW);
	flopr #(4)  wa3wreg(clk, reset, WA3M, WA3W);
	mux2 #(32)  resmux(ALUOutW, ReadDataW, MemtoRegW, ResultW);
	
	// Hazard comparison
	eqcmp #(4) m0(WA3M, RA1E, Match_1E_M);
	eqcmp #(4) m1(WA3W, RA1E, Match_1E_W);
	eqcmp #(4) m2(WA3M, RA2E, Match_2E_M);
	eqcmp #(4) m3(WA3W, RA2E, Match_2E_W);
	eqcmp #(4) m4a(WA3E, RA1D, Match_1D_E);
	eqcmp #(4) m4b(WA3E, RA2D, Match_2D_E);
	assign Match_12D_E = Match_1D_E | Match_2D_E;

endmodule