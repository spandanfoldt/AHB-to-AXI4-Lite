module ahb_lite_master(input logic HCLK,
					   input logic HRESETn,
					   
					   input logic start_transfer,
					   
					   input logic [31:0] addr_reg,
					   input logic [31:0] data_reg,
					   input logic write_reg,
					   input logic [1:0] trans_reg,
					   input logic [2:0] size_reg,
					   input logic [2:0] burst_reg,
					   input logic [3:0] prot_reg,
					   
					   output logic [31:0] HADDR_o,
					   output logic [31:0] HWDATA_o,
					   output logic HWRITE_o,
					   output logic [1:0] HTRANS_o,
					   output logic [2:0] HSIZE_o,
					   output logic [2:0] HBURST_o,
					   output logic [3:0] HPROT_o
					   );
	always_comb begin
		HADDR_o = '0;
        HWDATA_o = '0;
        HWRITE_o = 0;
        HTRANS_o = '0;
        HSIZE_o = '0;
        HBURST_o = '0;
        HPROT_o = '0;
		
		if (start_transfer) begin
			HADDR_o = addr_reg;
			HWDATA_o = data_reg;
			HWRITE_o = write_reg;
			HTRANS_o = trans_reg;
			HSIZE_o = size_reg;
			HBURST_o = burst_reg;
			HPROT_o = prot_reg;
		end
	end
endmodule