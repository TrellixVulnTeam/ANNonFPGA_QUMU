library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dotp_fsmd is

	generic (NBITS : natural := 8;
			NBELMTS: natural := 8;
			REG_DELAY: natural := 100;
			INT_BITS: natural := 3);
	port(
		signal start, clk, rst: in std_logic;
		signal a_in, b_in: in std_logic_vector(NBITS*NBELMTS-1 downto 0);
		signal ready: out std_logic;
		signal z_out: out std_logic_vector(NBITS+integer(ceil(log2(real(NBELMTS))))-1 downto 0)
		);

	end entity dotp_fsmd;

architecture rtl of dotp_fsmd is


	constant ZERO : signed(NBITS-1 downto 0) := (others => '0');
	constant CNT_ZERO : unsigned(integer(ceil(log2(real(NBELMTS)))) downto 0) := (others => '0');

	-- states & state register
	type state_type is (ST_IDLE, ST_ZERO, ST_LOAD, ST_OP);
	signal state_reg, state_next : state_type;

	-- data registers
	type input_type is array (0 to NBELMTS-1) of signed(NBITS-1 downto 0);
	signal a_reg, a_next, b_reg, b_next : input_type; -- input registers
	signal k_reg, k_next : unsigned(integer(ceil(log2(real(NBELMTS)))) downto 0) := (others => '0'); -- counting register (forced to use 4 bits for 8 elememts for complete addition)
	signal acc_reg, acc_next: signed(NBITS+integer(ceil(log2(real(NBELMTS))))-1 downto 0) := (others => '0'); -- accumulating register

	--internal status signals
	signal k_count0, a_in0, b_in0: std_logic;

	--functional unit outputs
	signal add_out : signed(NBITS+integer(ceil(log2(real(NBELMTS))))-1 downto 0);
	signal dec_out : unsigned(integer(ceil(log2(real(NBELMTS)))) downto 0);


begin

	--(CU) state register

	CU_REG: process(clk, rst)
	begin
		if rst ='1' then
			state_reg <= ST_IDLE;
		elsif rising_edge(clk) then
			state_reg <= state_next after REG_DELAY*ps;
		end if;
	end process CU_REG;

	--(CU) next-state logic
	CU_NSL: process (a_in0, b_in0, state_reg, start, k_count0)
	begin
		state_next <= state_reg;
		case state_reg is
		when ST_IDLE => if start ='1' then
							if b_in0 ='1' or a_in0 ='1' then
								state_next <= ST_ZERO;
							else
								state_next <= ST_LOAD;
							end if;
						end if;
		when ST_ZERO => state_next <= ST_IDLE;
		when ST_LOAD => state_next <= ST_OP;
		when ST_OP => if k_count0 = '1' then
						state_next <= ST_IDLE;
						end if;

		end case;
	end process CU_NSL;

	--(CU) output logic
	CU_OL: ready <= '1' when state_reg = ST_IDLE else '0';

	-- (DPU) data registers
	DPU_REG: process (clk, rst)
	begin
		if rst = '1' then
			a_reg <= (others => ZERO);
			b_reg <= (others => ZERO);
			k_reg <= (others => '0');
			acc_reg <= (others => '0');
		elsif rising_edge(clk) then
			a_reg <= a_next after REG_DELAY*ps;
			b_reg <= b_next after REG_DELAY*ps;
			k_reg <= k_next after REG_DELAY*ps;
			acc_reg <= acc_next after REG_DELAY*ps;
		end if;
	end process DPU_REG;

	-- (DPU) status signals
	a_in0 <= '1' when a_in = std_logic_vector(ZERO) else '0';
	b_in0 <= '1' when b_in = std_logic_vector(ZERO) else '0';
	k_count0 <= '1' when k_next = CNT_ZERO else '0';

	-- (DPU) routing mux
	DPU_RMUX: process(state_reg, a_in, b_in, a_reg, b_reg, k_reg, acc_reg, add_out, dec_out)
	begin
		a_next <= a_reg;
		b_next <= b_reg;
		k_next <= k_reg;
		acc_next <= acc_reg;
		case state_reg is
		when ST_IDLE => null;
		when ST_ZERO => acc_next <= (others => '0');
		when ST_LOAD => for i in 0 to NBELMTS-1 loop
							a_next(i) <= signed(a_in(NBITS*(i+1)-1 downto (NBITS*i)));
							b_next(i) <= signed(b_in(NBITS*(i+1)-1 downto (NBITS*i)));
						end loop;
						k_next <= to_unsigned(NBELMTS, k_next'length);
						acc_next <= (others => '0');
		when ST_OP   => acc_next <= add_out;
						k_next <= dec_out;
		end case;
	end process DPU_RMUX;

	--(DPU) functional units
	-- use a process here for integer variable
	DPU_FCT: process(a_reg, b_reg, k_reg, acc_reg)
		variable k : natural := 0;
		variable prod : std_logic_vector(2*NBITS-1 downto 0);
	begin
	add_out <= (others => '0');
	k := to_integer(k_reg);

	dec_out <= k_reg - 1;
	if k /= 0 then
		prod := std_logic_vector(a_reg(k-1)*b_reg(k-1));
	--	if shift_right(acc_reg, (NBITS-INT_BITS-1)) <= (2**INT_BITS-1) and shift_right(acc_reg, (NBITS-INT_BITS-1)) >= (-2**INT_BITS) then
			add_out <= acc_reg + signed(prod(2*NBITS-1)&prod(2*NBITS-INT_BITS-3 downto NBITS-INT_BITS-1));
	--	else
		--	add_out <= acc_reg;
		--end if;
	end if;
	end process DPU_FCT;

	--(DPU) data output
	z_out <= std_logic_vector(acc_reg);
	end architecture rtl;
