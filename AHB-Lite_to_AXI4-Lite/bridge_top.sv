module bridge_top(

    input logic HCLK,
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

    output logic HREADYOUT,
    output logic HRESP,
    output logic [31:0] HRDATA,

    output logic [31:0] AWADDR,
    output logic AWVALID,
    input  logic AWREADY,

    output logic [31:0] WDATA,
    output logic [3:0] WSTRB,
    output logic WVALID,
    input  logic WREADY,

    input logic BVALID,
    input logic [1:0] BRESP,
    output logic BREADY,

    output logic [31:0] ARADDR,
    output logic ARVALID,
    input logic ARREADY,

    input logic [31:0] RDATA,
    input logic [1:0] RRESP,
    input logic RVALID,
    output logic RREADY

);

    logic req_valid;
    logic req_done;
    
    logic [31:0] addr_reg;
    logic [31:0] data_reg;
    
    logic write_reg;
    
    logic [1:0] trans_reg;
    logic [2:0] size_reg;
    logic [2:0] burst_reg;
    logic [3:0] prot_reg;
    
    logic start_write;
    logic start_read;
    
    request_capture u_capture(
    
        .HCLK(HCLK),
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
    
    bridge_controller u_controller(
    
        .HCLK(HCLK),
        .HRESETn(HRESETn),
    
        .req_valid(req_valid),
        .write_reg(write_reg),
    
        .AWREADY(AWREADY),
        .WREADY(WREADY),
    
        .BVALID(BVALID),
        .BRESP(BRESP),
    
        .ARREADY(ARREADY),
    
        .RVALID(RVALID),
        .RDATA(RDATA),
        .RRESP(RRESP),
    
        .req_done(req_done),
    
        .start_write(start_write),
        .start_read(start_read),
    
        .HREADYOUT(HREADYOUT),
        .HRESP(HRESP),
        .HRDATA(HRDATA)
    
    );
    
    axi_master u_axi(
    
        .HCLK(HCLK),
        .HRESETn(HRESETn),
    
        .start_write(start_write),
        .start_read(start_read),
    
        .addr_reg(addr_reg),
        .data_reg(data_reg),
    
        .AWREADY(AWREADY),
        .WREADY(WREADY),
    
        .BVALID(BVALID),
    
        .ARREADY(ARREADY),
        .RVALID(RVALID),
    
        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
    
        .WDATA(WDATA),
        .WSTRB(WSTRB),
        .WVALID(WVALID),
    
        .BREADY(BREADY),
    
        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
    
        .RREADY(RREADY),
    
        .write_done(),
        .read_done()
    
    );
    
endmodule