LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY bit IS
	PORT (
		v_sync    : IN STD_LOGIC;
		pixel_row : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
		pixel_col : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
		orange       : OUT STD_LOGIC;
		green     : OUT STD_LOGIC;
		purple      : OUT STD_LOGIC
	);
END bit;

ARCHITECTURE Behavioral OF bit IS
	CONSTANT size  : INTEGER := 10;
	SIGNAL bit_on : STD_LOGIC; -- indicates whether bit is over current pixel position
	-- current bit position - intitialized to center of screen
	SIGNAL bit_x  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
	SIGNAL bit_y  : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(300, 11);
	-- current bit motion - initialized to +4 pixels/frame
	SIGNAL bit_y_motion : STD_LOGIC_VECTOR(20 DOWNTO 0) := "00000000100";
BEGIN
	orange <= '1'; -- color setup for orange bit on white background
	green <= NOT bit_on;
	purple  <= NOT bit_on;
	-- draws bit current pixel address covered by bit position
	bdraw : PROCESS (bit_x, bit_y, pixel_row, pixel_col) IS
	BEGIN
		IF (pixel_col >= bit_x - size) AND
		 (pixel_col <= bit_x + size) AND
			 (pixel_row >= bit_y - size) AND
			 (pixel_row <= bit_y + size) THEN
				bit_on <= '1';
		ELSE
			bit_on <= '0';
		END IF;
    END PROCESS;
    -- process to moves the bit once every frame
    mbit : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(v_sync);
        -- allow for bounce off top or bottom of screen
        IF bit_y + size >= 600 THEN
            bit_y_motion <= "11111111100"; -- -4 pixels
        ELSIF bit_y <= size THEN
            bit_y_motion <= "00000000100"; -- +4 pixels
        END IF;
        bit_y <= bit_y + bit_y_motion; -- compute next bit position
    END PROCESS;
END Behavioral;
