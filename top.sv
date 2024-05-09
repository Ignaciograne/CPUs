module top(input  logic 		 clk, reset,
           output logic [31:0] WriteDataM, DataAdrM,
           output logic        MemWriteM,
			  output logic [31:0] ReadDataM);

	logic [31:0] PCF;
	logic [31:0] InstrF;//, ReadData;

	
	
	arm arm1(clk, reset, PCF, InstrF, MemWriteM, DataAdrM, WriteDataM, ReadDataM);
	
	imem imem1(PCF, InstrF);
	
	// Instancia de módulo ROM personalizado
	/*
    instructionROM rom1(
        .address(PC[15:0]), 
        .clock(clk),
        .q(Instr)
    );*/
	 
	//dmem dmen1(clk, MemWrite, DataAdr, WriteData, ReadData);
	 
	 LargerRAM ram1(
		  .clock(clk),
		  .wren(MemWriteM),
        .address(DataAdrM),
        .data(WriteDataM),
        .q(ReadDataM)
    );


endmodule