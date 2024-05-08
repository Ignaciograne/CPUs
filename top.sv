module top(input logic 			 clk, reset,
           output logic [31:0] WriteData, DataAdr,
           output logic        MemWrite);

	logic [31:0] PC;
	logic [31:0] Instr, ReadData;
	//logic [31:0] WriteData, DataAdr;
	//logic MemWrite;
	logic [15:0] ROM_Addres;
	logic [7:0] output_ROM;
	
	
	assign ROM_Addres = 16'b0;
	
	arm arm1(clk, reset, PC, Instr, MemWrite, DataAdr, WriteData, ReadData);
	//ROM rom(ROM_Addres, clk, output_ROM);
	//ROM_Instruction rom_instruction(PC, clk, Instr);
	//imem imem1(PC, Instr);
	
	// Instancia de módulo ROM personalizado
    instructionROM rom1(
        .address(PC[15:0]), 
        .clock(clk),
        .q(Instr)
    );
	 
	//dmem dmen1(clk, MemWrite, DataAdr, WriteData, ReadData);
	
	// Instancia de módulo RAM personalizado para datos
	RAMMemory ram1(
        .address(DataAdr[15:0]),
        .clock(clk),
        .data(WriteData),
        .wren(MemWrite),
        .q(ReadData)
    );


endmodule