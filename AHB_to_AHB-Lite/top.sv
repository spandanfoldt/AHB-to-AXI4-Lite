module top(input logic HCLK,
		   input logic HRESETn,
		   
		   input logic HSEL,
		   input logic HREADY,
		   input logic [1:0] HTRANS,
		   
		   input logic [31:0] HADDR,
		   input logic HWRITE,
		   input logic [2:0] HSIZE,
		   input logic [2:0] HBURST,
		   input logic [3:0] HPROT,
		   input logic [31:0] HWDATA,
		   
		   input logic HREADYOUT_i,
		   input logic HRESP_i,
		   input logic [31:0] HRDATA_i,
		   
		   output logic HREADYOUT,
		   output logic HRESP,
		   output logic [31:0] HRDATA,
		   
		   output logic [31:0] HADDR_o,
		   output logic [31:0] HWDATA_o,
		   output logic HWRITE_o,
		   output logic [1:0] HTRANS_o,
		   output logic [2:0] HSIZE_o,
		   output logic [2:0] HBURST_o,
		   output logic [3:0] HPROT_o
		   );
	
	logic req_valid;
	logic req_done;

	logic start_transfer;

	logic [31:0] addr_reg;
	logic [31:0] data_reg;

	logic write_reg;
	logic [1:0] trans_reg;
	logic [2:0] size_reg;
	logic [2:0] burst_reg;
	logic [3:0] prot_reg;	
	
	request_capture capture(.HCLK(HCLK),
							.HRESETn(HRESETn),
							
							.HSEL(HSEL),
							.HTRANS(HTRANS),
							.HREADY(HREADY),
							
							.HADDR(HADDR),
							.HWRITE(HWRITE),
							.HSIZE(HSIZE),
							.HBURST(HBURST),
							.HPROT(HPROT),
							.HWDATA(HWDATA),
							
							.req_done(req_done),
							
							.req_valid(req_valid),
							.addr_reg(addr_reg),
							.data_reg(data_reg),
							.write_reg(write_reg),
							.trans_reg(trans_reg),
							.size_reg(size_reg),
							.burst_reg(burst_reg),
							.prot_reg(prot_reg)
							);
	
	bridge_controller b_ctrl(.HCLK(HCLK),
							 .HRESETn(HRESETn),
							 
							 .req_valid(req_valid),
							 
							 .HREADYOUT_i(HREADYOUT_i),
							 .HRESP_i(HRESP_i),
							 .HRDATA_i(HRDATA_i),
							 
							 .req_done(req_done),
							 
							 .HREADYOUT(HREADYOUT),
							 .HRESP(HRESP),
							 .HRDATA(HRDATA),
							 
							 .start_transfer(start_transfer)
							 );
	
	ahb_lite_master master(.HCLK(HCLK),
						   .HRESETn(HRESETn),
						   
						   .start_transfer(start_transfer),
						   
                           .addr_reg(addr_reg),
                           .data_reg(data_reg),
                           .write_reg(write_reg),
                           .trans_reg(trans_reg),
                           .size_reg(size_reg),
                           .burst_reg(burst_reg),
                           .prot_reg(prot_reg),
						   
                           .HADDR_o(HADDR_o),
                           .HWDATA_o(HWDATA_o),
                           .HWRITE_o(HWRITE_o),
                           .HTRANS_o(HTRANS_o),
                           .HSIZE_o(HSIZE_o),
                           .HBURST_o(HBURST_o),
                           .HPROT_o(HPROT_o)
						   );
	
	response_logic rl(.HREADYOUT_i(HREADYOUT_i),
					  .HRESP_i(HRESP_i),
					  .HRDATA_i(HRDATA_i),
					  
					  .HREADYOUT(HREADYOUT),
					  .HRESP(HRESP),
					  .HRDATA(HRDATA)
					  );

endmodule