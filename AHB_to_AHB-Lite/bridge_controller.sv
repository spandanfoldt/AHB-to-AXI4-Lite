module bridge_controller(input logic HCLK,
						 input logic HRESETn,
						 
						 input logic req_valid,
					     
						 /*input logic [31:0] addr_reg,
					     input logic [31:0] data_reg,
					     input logic write_reg,
					     input logic [1:0] trans_reg,
					     input logic [2:0] size_reg,
					     input logic [2:0] burst_reg,
					     input logic [3:0] prot_reg,*/
						 
						 input logic HREADYOUT_i,
						 input logic [31:0] HRDATA_i,
						 input logic HRESP_i,
						 
						 output logic req_done,
						 
						 output logic HREADYOUT,
						 output logic HRESP,
						 output logic [31:0] HRDATA,
						 
						 output logic start_transfer
						 );
						 
	typedef enum logic [1:0] {
		IDLE,
		TRANSFER,
		COMPLETE
	} state_t;
						
	state_t state;
	state_t next_state;
	
	always_ff @(posedge HCLK or negedge HRESETn) begin
		if (!HRESETn) state <= IDLE;
		else state <= next_state;
	end
	
	always_comb begin
		next_state = state;
		start_transfer = 0;
		req_done = 0;
		HREADYOUT = 1;
		HRESP = 0;
		HRDATA = HRDATA_i;
		case(state)
			IDLE: begin
				next_state = (req_valid)?TRANSFER:IDLE;
				HREADYOUT = 1;
			end
				TRANSFER: begin
				next_state = (HREADYOUT_i == 1'b1)?COMPLETE:TRANSFER;
				start_transfer = 1;
				HREADYOUT = HREADYOUT_i;
			end
			COMPLETE: begin
				next_state = IDLE;
				req_done = 1;
				HREADYOUT = 1;
				HRESP = HRESP_i;
				HRDATA = HRDATA_i;
			end
		endcase
	end

endmodule