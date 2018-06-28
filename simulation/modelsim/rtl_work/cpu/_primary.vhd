library verilog;
use verilog.vl_types.all;
entity cpu is
    port(
        bus_in          : in     vl_logic_vector(10 downto 0);
        clock           : in     vl_logic;
        execute_instruction: in     vl_logic;
        instruction     : in     vl_logic;
        address         : in     vl_logic_vector(2 downto 0);
        data_in         : in     vl_logic_vector(3 downto 0);
        data_out        : out    vl_logic_vector(3 downto 0);
        done            : out    vl_logic;
        bus_out         : out    vl_logic_vector(9 downto 0)
    );
end cpu;
