module bridge_controller(input logic HCLK,
						 input logic HRESETn,
						 
						 input logic req_valid,
						 input logic write_reg,
						 
						 input logic AWREADY,
						 input logic WREADY,
						 input logic BVALID,
						 input logic [1:0] BRESP,
						 
						 input logic ARREADY,
						 input logic RVALID,
						 input logic [31:0] RDATA,
						 input logic [1:0] RRESP,
						 
						 output logic req_done,
						 
						 output logic start_write,
						 output logic start_read,
						 
						 output logic HREADYOUT,
						 output logic HRESP,
						 output logic [31:0] HRDATA
						 );
	
	typedef enum logic [2:0] {
		IDLE,
		WRITE_ADDR_DATA,
		WRITE_RESP,
		READ_ADDR,
		READ_DATA,
		COMPLETE
	}state_t;
	
	state_t state, next_state;
	
	logic aw_done, w_done;
	
	always_ff @(posedge HCLK or negedge HRESETn) begin
		if(!HRESETn) begin
			state <= IDLE;
			aw_done = 0;
			w_done = 0;
		end
		else begin
			state <= next_state;
			
			if (state == IDLE && next_state == WRITE_ADDR_DATA) begin
				aw_done <= 0;
				w_done <= 0;
			end
			
			if(state == WRITE_ADDR_DATA) begin
				if(AWREADY) aw_done <= 1;
				if(WREADY) w_done <= 1;
			end
		end
	end
	
	always_comb begin
		next_state = state;
	    req_done = '0;
	    start_write = '0;
	    start_read = '0;
	    HREADYOUT = 0;
	    HRESP = '0;
	    HRDATA = '0;
		
		case(state)
			IDLE: begin
				HREADYOUT = 1;
				if (req_valid && write_reg) begin
					next_state = WRITE_ADDR_DATA;
				end
				else if (req_valid && !write_reg) begin
					next_state = READ_ADDR;
				end
			end
			
			WRITE_ADDR_DATA: begin
				start_write = 1;
				if (aw_done && w_done) begin
					next_state = WRITE_RESP;
				end
			end
			
			WRITE_RESP: begin
				if(BVALID) begin
					next_state = COMPLETE;
					HRESP = BRESP[1];
				end
			end
			
			READ_ADDR: begin
				start_read = 1;
				if (ARREADY) begin
					next_state = READ_DATA;
				end
			end
			
			READ_DATA: begin
				if (RVALID) begin
					HRDATA = RDATA;
					HRESP = RRESP[1];
					next_state = COMPLETE;
				end
			end
			
			COMPLETE: begin
				next_state = IDLE;
				req_done = 1;
				HREADYOUT = 1;
			end
			
			default: next_state = IDLE;
		endcase
	end

endmodule