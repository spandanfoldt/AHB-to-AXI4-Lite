module request_capture(input logic HCLK,
					   input logic HRESETn,
					   
					   input logic HSEL,
					   input logic [1:0] HTRANS,
					   input logic HREADY,
					   
					   input logic [31:0] HADDR,
					   input logic HWRITE,
					   input logic [2:0] HSIZE,
					   input logic [2:0] HBURST,
					   input logic [3:0] HPROT,
					   input logic [31:0] HWDATA,
					   
					   input logic req_done,
					   
					   output logic req_valid,
					   output logic [31:0] addr_reg,
					   output logic [31:0] data_reg,
					   output logic write_reg,
					   output logic [1:0] trans_reg,
					   output logic [2:0] size_reg,
					   output logic [2:0] burst_reg,
					   output logic [3:0] prot_reg
					   );
					   
	logic capture;
	assign capture = HSEL && HREADY && HTRANS[1];
	
	always_ff @(posedge HCLK or negedge HRESETn) begin
		if(!HRESETn) begin
			req_valid <= 1'b0;
			addr_reg <= '0;
			data_reg <= '0;
			write_reg <= '0;
			trans_reg <= '0;
			size_reg <= '0;
			burst_reg <= '0;
			prot_reg <= '0;
		end
		
		else if(capture) begin
			req_valid <= 1'b1;
			addr_reg <= HADDR;
			data_reg <= HWDATA;
			write_reg <= HWRITE;
			trans_reg <= HTRANS;
			size_reg <= HSIZE;
			burst_reg <= HBURST;
			prot_reg <= HPROT;
		end
		
		else if (req_done)
			req_valid <= 1'b0;
	end
	
endmodule