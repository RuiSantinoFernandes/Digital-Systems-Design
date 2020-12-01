LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

use std.textio.all;
use ieee.std_logic_textio.all; -- require for writing/reading std_logic etc.

entity vga_sim is
-- Port ( );
end vga_sim;

architecture Behavioral of vga_sim is
    component vga_top IS
        PORT (
            pxl_clk   : IN STD_LOGIC;
            vga_orange   : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            vga_green : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            vga_purple  : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
            vga_hsync : OUT STD_LOGIC;
            vga_vsync : OUT STD_LOGIC
 );
    END component;
    
    signal pxl_clk : std_logic := '1';
    signal vga_orange, vga_green : STD_LOGIC_VECTOR (2 DOWNTO 0);
    signal vga_purple : std_logic_vector (1 downto 0);
    signal vga_hsync, vga_vsync : std_logic;
    -- Procedure for clock generation from https://stackoverflow.com/a/17924556/7537973
    procedure clk_gen(signal clk : out std_logic; constant FREQ : real) is
        constant PERIOD    : time := 1 sec / FREQ;        -- Full period
        constant HIGH_TIME : time := PERIOD / 2;          -- High time
        constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
        begin
        -- Check the arguments
        assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero; time resolution to large for frequency" severity FAILURE;
        -- Generate a clock cycle
        loop
          clk <= '1';
          wait for HIGH_TIME;
          clk <= '0';
          wait for LOW_TIME;
        end loop;
    end procedure;
    
    procedure log_vga is
        variable c : integer := 0;
        variable write_col_to_output_buf : line; -- write lines one by one to output_buf
        file file_handler : text open write_mode is "simout.dat";
        begin
        loop
            wait for 40ns;
            if (c > 100) then
    --                write(write_col_to_output_buf, t);
                write(write_col_to_output_buf, vga_hsync);
                write(write_col_to_output_buf, vga_vsync);
                write(write_col_to_output_buf, vga_orange(2));
                write(write_col_to_output_buf, vga_green(2));
                write(write_col_to_output_buf, vga_purple(1));
                writeline(file_handler, write_col_to_output_buf);
            end if;
            c := c + 1;
        end loop;
    end procedure;
    begin

    UUT: vga_top port map (pxl_clk => pxl_clk, vga_orange => vga_orange, vga_green => vga_green, vga_purple => vga_purple, vga_hsync => vga_hsync, vga_vsync => vga_vsync);
    
    process
        variable v, h : std_logic;
        variable r, g : std_logic_vector(2 downto 0);
        variable b : std_logic_vector(1 downto 0);
        variable t : time := 0ns;
        variable c : integer := 0;
        -- Clock calcs
        constant clkfreq : real := 108.000E6;
        constant PERIOD    : time := 1 sec / clkfreq;        -- Full period
        constant HIGH_TIME : time := PERIOD / 2;          -- High time
        constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
    begin
--        file_open(file_handler, "simout.txt", write_mode);
        clk_gen(pxl_clk, clkfreq); -- must have decimal part
        wait;
    end process;
    process
        variable c : integer := 0;
        variable write_col_to_output_buf : line; -- write lines one by one to output_buf
        file file_handler : text open write_mode is "D:/Downloads/simout2.txt";
        variable t : time := 0ns;
        constant tsep : string := ": ";
        constant space : string := " ";
        constant clkfreq : real := 108.000E6;
        constant PERIOD    : time := 1 sec / clkfreq;        -- Full period
    begin
        loop
            wait for PERIOD;
            if (c > 1) then
                write(write_col_to_output_buf, t);
                write(write_col_to_output_buf, tsep);
                write(write_col_to_output_buf, vga_hsync);
                write(write_col_to_output_buf, space);
                write(write_col_to_output_buf, vga_vsync);
                write(write_col_to_output_buf, space);
                write(write_col_to_output_buf, vga_orange);
                write(write_col_to_output_buf, space);
                write(write_col_to_output_buf, vga_green);
                write(write_col_to_output_buf, space);
                write(write_col_to_output_buf, vga_purple);
                writeline(file_handler, write_col_to_output_buf);
            end if;
            c := c + 1;
            t := t + PERIOD;
        end loop;
        wait;
    end process;
end Behavioral;
