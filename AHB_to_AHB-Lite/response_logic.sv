module response_logic (input logic HREADYOUT_i,
					   input logic HRESP_i,
					   input logic [31:0] HRDATA_i,
					   
					   output logic HREADYOUT,
					   output logic HRESP,
					   output logic [31:0] HRDATA
					   );
	
	assign HREADYOUT = HREADYOUT_i;
	assign HRESP = HRESP_i;
	assign HRDATA = HRDATA_i;
endmodule

//this module can me neglected as the three assignments can be done in top module itself
//or it can be instantiated like i will do here