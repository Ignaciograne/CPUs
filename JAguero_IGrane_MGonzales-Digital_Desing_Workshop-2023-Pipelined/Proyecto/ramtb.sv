`timescale 1ns / 1ps

module ramtb;

  logic        clk, reset;
  logic [31:0] WriteDataM, DataAdrM;
  logic        MemWriteM;
  logic [31:0] ReadDataM;

  // Instantiate the top module
  top dut (
    .clk(clk),
    .reset(reset),
    .WriteDataM(WriteDataM),
    .DataAdrM(DataAdrM),
    .MemWriteM(MemWriteM)
  );

  // Clock generation
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  // Reset generation
  initial begin
    reset = 1'b1;
    #30;
    reset = 1'b0;
  end

  // Testbench variables
  integer i;

  // Testbench process
  initial begin
    // Wait for reset to deassert
    //@(negedge reset);

    // Wait for a few clock cycles
    //repeat(50) @(posedge clk);

    // Display RAM contents
    $display("RAM Contents:");
    for (i = 0; i <= 104; i = i + 4) begin
      DataAdrM = i;
      @(posedge clk);
      ReadDataM = dut.ram1.q;
      $display("Address: %0d, Data: %0h", i, ReadDataM);
    end

    // Finish the simulation
    $stop;
  end

endmodule