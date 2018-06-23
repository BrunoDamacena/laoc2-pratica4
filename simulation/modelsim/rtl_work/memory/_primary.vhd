library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        clock           : in     vl_logic;
        write           : in     vl_logic;
        address         : in     vl_logic_vector(2 downto 0);
        data_in         : in     vl_logic_vector(3 downto 0);
        data_out        : out    vl_logic_vector(3 downto 0)
    );
end memory;
