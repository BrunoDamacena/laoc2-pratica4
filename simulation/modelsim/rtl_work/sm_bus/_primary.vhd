library verilog;
use verilog.vl_types.all;
entity sm_bus is
    port(
        clock           : in     vl_logic;
        state           : in     vl_logic_vector(1 downto 0);
        writeMiss       : in     vl_logic;
        readMiss        : in     vl_logic;
        invalidate      : in     vl_logic;
        writeBack       : out    vl_logic;
        abortMemoryAccess: out    vl_logic;
        currentState    : out    vl_logic_vector(1 downto 0)
    );
end sm_bus;
