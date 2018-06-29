library verilog;
use verilog.vl_types.all;
entity \bus\ is
    port(
        clock           : in     vl_logic;
        execute_instruction_cpu1: in     vl_logic;
        execute_instruction_cpu2: in     vl_logic;
        instruction     : in     vl_logic;
        address         : in     vl_logic_vector(2 downto 0);
        data_in         : in     vl_logic_vector(3 downto 0);
        data_out_cpu1   : out    vl_logic_vector(3 downto 0);
        data_out_cpu2   : out    vl_logic_vector(3 downto 0);
        done_cpu1       : out    vl_logic;
        done_cpu2       : out    vl_logic
    );
end \bus\;
