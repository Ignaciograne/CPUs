module imem(input  logic [31:0] a,
				output logic [31:0] rd); // Instruction memory

	logic [31:0] RAM[63:0];
	
	initial
		$readmemh("C:/Users/Ignac/Documentos/Arqui1/PruebasDeProcesador/JAguero_IGrane_MGonzales-Digital_Desing_Workshop-2023-VersionConROMs/Proyecto/memfiletwo.dat", RAM);
	
	assign rd = RAM[a[22:2]]; // word aligned
				
endmodule