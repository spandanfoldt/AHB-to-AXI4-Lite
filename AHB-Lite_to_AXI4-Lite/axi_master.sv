module axi_master(input logic HCLK,
				  input logic HRESETn,
				  
				  input logic start_write,
				  input logic start_read,
				  
				  input logic [31:0] addr_reg,
				  input logic [31:0] data_reg,
				  
				  input logic AWREADY,
				  input logic WREADY,
				  
				  input logic BVALID,
				  //input logic [1:0] BRESP,
				  
				  input logic ARREADY,
				  input logic RVALID,
				  //input logic [31:0] RDATA,
				  //input logic [1:0] RRESP,
				  
				  output logic [31:0] AWADDR,
				  output logic AWVALID,
				  
				  output logic [31:0] WDATA,
				  output logic [3:0] WSTRB,
				  output logic WVALID,
				  
				  output logic BREADY,
				  
				  output logic [31:0] ARADDR,
				  output logic ARVALID,
				  
				  output logic RREADY,
				  
				  output logic write_done,
				  output logic read_done
				  );
	
	                     //transmitted already?
	logic aw_sent;       //AWVALID
	logic w_sent;		 //WVALID
	logic ar_sent;		 //ARVALID
	
	logic b_done;
	logic r_done;
	
	always_ff @(posedge HCLK or negedge HRESETn) begin
		if(!HRESETn) begin
			aw_sent <= 0;
			w_sent <= 0;
			b_done <= 0;
		end
		
		else begin
			if(!start_write) begin
				aw_sent <= 0;
				w_sent <= 0;
				b_done <= 0;
			end
			else begin
				if(AWVALID && AWREADY)
					aw_sent <= 1;
				if(WVALID && WREADY)
					w_sent <= 1;
				if(BVALID && BREADY)
					b_done <= 1;
			end
		end
	end
	
	always_ff @(posedge HCLK or negedge HRESETn) begin
		if(!HRESETn) begin
			ar_sent <= 0;
			r_done <= 0;
		end
		
		else begin
			if(!start_read) begin
				ar_sent <= 0;
				r_done <= 0;
			end
			
			else begin
				if(ARVALID && ARREADY)
					ar_sent <= 1;
				if(RVALID && RREADY)
					r_done <= 1;
			end
		end
	end
	
	always_comb begin
		AWADDR = addr_reg;
		AWVALID = start_write && !aw_sent;
		
		WDATA = data_reg;
		WVALID = start_write && !w_sent;
		WSTRB = 4'hF;
		
		BREADY = start_write && aw_sent && w_sent && !b_done;
		
		ARADDR = addr_reg;
		ARVALID = start_read && !ar_sent;
		
		RREADY = start_read && ar_sent && !r_done;
		
		write_done = b_done;
		read_done = r_done;
	end
endmodule