library verilog;
use verilog.vl_types.all;
entity bcd_7seg is
    port(
        BCD             : in     vl_logic_vector(3 downto 0);
        SSEG_CA         : out    vl_logic_vector(6 downto 0)
    );
end bcd_7seg;
