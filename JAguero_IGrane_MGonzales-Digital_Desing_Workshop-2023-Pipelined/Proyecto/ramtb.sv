`timescale 1ns / 1ps

module ramtb;
    // Inputs
    reg clk;
    reg reset;
    reg [15:0] address;

    // Outputs
    wire [31:0] q;

    // Instantiate the RAM module
    RAMMemory uut (
        .address(address),
        .clock(clk),
        .data(32'b0), // No data writing in this test
        .wren(0), // Write enable is off
        .q(q)
    );

    // Clock generation
    always #10 clk = ~clk; // Toggle clock every 10 ns

    // Test sequence
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        address = 0;

        // Reset the system
        #25;
        reset = 0;
        #25;
        reset = 1;
        #20;

        // Read cycle
        for (int i = 0; i <= 104; i++) begin
            address = i; // Set the address
            #20; // Wait for memory to process
            $display("Address: %d, Data: %h", address, q); // Display address and data
        end

        // Complete the test
        #100;
        $stop;
    end
endmodule
