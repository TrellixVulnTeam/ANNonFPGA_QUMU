library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


-- 1 output GRU unit --> Must specify GRU layer output size for recurrent terms matrix size.
-- To be used in parallel with OUTPUT_SIZE-1 same GRU units.
-- Recurrence should be done by routing the output of this block to the S inputs of this block and all other parallel blocks
entity gru is
	generic(
			NBITS       : natural := 8;
			INPUT_SIZE  : natural := 4;
			OUTPUT_SIZE : natural := 2;
			INT_BITS    : natural := 3 --integer bits + sign bit
	);
	port(
		 clk, rst  : in std_logic;
		 start     : in std_logic;
		 ready     : out std_logic;
		 xn        : in std_logic_vector(NBITS*INPUT_SIZE-1 downto 0);
		 sn_1      : in std_logic_vector(NBITS*OUTPUT_SIZE-1 downto 0);
		 uz        : in std_logic_vector(NBITS*INPUT_SIZE-1 downto 0);
		 ur        : in std_logic_vector(NBITS*INPUT_SIZE-1 downto 0);
		 uh        : in std_logic_vector(NBITS*INPUT_SIZE-1 downto 0);
		 wz        : in std_logic_vector(NBITS*OUTPUT_SIZE-1 downto 0);
		 wr        : in std_logic_vector(NBITS*OUTPUT_SIZE-1 downto 0);
		 wh        : in std_logic_vector(NBITS*OUTPUT_SIZE-1 downto 0);
		 bz        : in std_logic_vector(NBITS-1 downto 0);
		 br        : in std_logic_vector(NBITS-1 downto 0);
		 bh        : in std_logic_vector(NBITS-1 downto 0);

		 -- new inputs/outputs for external element-wise product
		 elemwise_prod : in std_logic_vector(NBITS*OUTPUT_SIZE-1 downto 0);
		 elemwise_ready: in std_logic;
		 elemwise_start: out std_logic;

		 snj       : out std_logic_vector(NBITS-1 downto 0);
		 rnj       : out std_logic_vector(NBITS-1 downto 0);

			-- debug signals
			DEBUG_rnj_reg 		: out std_logic_vector(NBITS-1 downto 0);
			DEBUG_rnj_rec_out	: out std_logic_vector(NBITS+integer(ceil(log2(real(OUTPUT_SIZE))))-1 downto 0);
			DEBUG_rnj_dir_out	: out std_logic_vector(NBITS+integer(ceil(log2(real(INPUT_SIZE))))-1 downto 0);
			DEBUG_znj_reg			: out std_logic_vector(NBITS-1 downto 0);
			DEBUG_znj_rec_out	: out std_logic_vector(NBITS+integer(ceil(log2(real(OUTPUT_SIZE))))-1 downto 0);
			DEBUG_znj_dir_out	: out std_logic_vector(NBITS+integer(ceil(log2(real(INPUT_SIZE))))-1 downto 0);
			DEBUG_hnj_reg			: out std_logic_vector(NBITS-1 downto 0);
			DEBUG_hnj_rec_out	: out std_logic_vector(NBITS+integer(ceil(log2(real(OUTPUT_SIZE))))-1 downto 0);
			DEBUG_hnj_dir_out	: out std_logic_vector(NBITS+integer(ceil(log2(real(INPUT_SIZE))))-1 downto 0)

	);
	end entity gru;

architecture fsmd of gru is
	-- types
	type state_type is (IDLE, WAIT_RN_DOTP, CALC_RN, WAIT_ELEMWISE, WAIT_HN_DOTP, CALC_HN, RESULT);

	-- registers
	signal rnj_reg, rnj_next: std_logic_vector(NBITS-1 downto 0);
	signal rnj_rec_out: std_logic_vector(NBITS+integer(ceil(log2(real(OUTPUT_SIZE))))-1 downto 0);
	signal rnj_dir_out: std_logic_vector(NBITS+integer(ceil(log2(real(INPUT_SIZE))))-1 downto 0);
	signal znj_reg, znj_next: std_logic_vector(NBITS-1 downto 0);
	signal znj_rec_out: std_logic_vector(NBITS+integer(ceil(log2(real(OUTPUT_SIZE))))-1 downto 0);
	signal znj_dir_out: std_logic_vector(NBITS+integer(ceil(log2(real(INPUT_SIZE))))-1 downto 0);
	--signal znj_inv_reg, znj_inv_next: std_logic_vector(NBITS-1 downto 0);
	signal hnj_reg, hnj_next: std_logic_vector(NBITS-1 downto 0);
	signal hnj_rec_out: std_logic_vector(NBITS+integer(ceil(log2(real(OUTPUT_SIZE))))-1 downto 0);
	signal hnj_dir_out: std_logic_vector(NBITS+integer(ceil(log2(real(INPUT_SIZE))))-1 downto 0);
	-- signal elemwise_out: std_logic_vector(NBITS*OUTPUT_SIZE-1 downto 0);
	signal snj_reg, snj_next: std_logic_vector(NBITS-1 downto 0);

	-- internal control signals
	-- removed internal signals for element-wise product (exported)
	--signal start_elemwise, ready_elemwise: std_logic;
	signal start_z_rec, start_r_rec, start_h_rec: std_logic;
	signal start_z_dir, start_r_dir, start_h_dir: std_logic;
	signal ready_z_rec, ready_r_rec, ready_h_rec: std_logic;
	signal ready_z_dir, ready_r_dir, ready_h_dir: std_logic;

	signal state_reg, state_next : state_type;
begin

	-- debug
	DEBUG_rnj_reg <= rnj_reg;
	DEBUG_rnj_dir_out <= rnj_dir_out;
	DEBUG_rnj_rec_out <= rnj_rec_out;
	DEBUG_hnj_reg <= hnj_reg;
	DEBUG_hnj_dir_out <= hnj_dir_out;
	DEBUG_hnj_rec_out <= hnj_rec_out;
	DEBUG_znj_reg <= znj_reg;
	DEBUG_znj_dir_out <= znj_dir_out;
	DEBUG_znj_rec_out <= znj_rec_out;

	-- control block


	CU_NSL: process (state_reg, start, elemwise_ready, ready_r_dir, ready_r_rec, ready_h_dir, ready_h_rec)
	begin
		state_next <= state_reg;
		start_z_rec <= '0';
		start_r_rec <= '0';
		start_r_dir <= '0';
		start_z_dir <= '0';
		start_h_dir <= '0';
		elemwise_start <= '0';
		start_h_rec <= '0';
		case state_reg is
		when IDLE    => if start ='1' then
					       state_next <= WAIT_RN_DOTP;
						   start_z_rec <= '1';
						   start_r_rec <= '1';
						   start_r_dir <= '1';
						   start_z_dir <= '1';
						   start_h_dir <= '1';
					    end if;
		when WAIT_RN_DOTP => if ready_r_dir='1' and ready_r_rec='1' then
						 	  state_next <= CALC_RN;
							end if;
		when CALC_RN => 	state_next <= WAIT_ELEMWISE;
							elemwise_start <= '1';
		when WAIT_ELEMWISE =>  if elemwise_ready = '1' then
								state_next <= WAIT_HN_DOTP;
								start_h_rec <= '1';
							end if;
		when WAIT_HN_DOTP => if ready_h_rec = '1' and ready_h_dir = '1' then
								state_next <= CALC_HN;
								end if;
			when CALC_HN => state_next <= RESULT;
			when RESULT =>  state_next <= IDLE;
		end case;
	end process CU_NSL;
	ready <= '1' when state_reg = IDLE else '0';

	-- first stage, generate rn and zn.
	ZN_DIR: entity work.dotp_fsmd(rtl)
		generic map (
			NBITS => NBITS,
			NBELMTS => INPUT_SIZE,
			REG_DELAY => 0,
			INT_BITS => INT_BITS
			)
		port map (
			start => start_z_dir,
			clk => clk,
			rst => rst,
			a_in => xn,
			b_in => uz,
			ready => ready_z_dir,
			z_out => znj_dir_out
		);
	ZN_REC: entity work.dotp_fsmd(rtl)
		generic map (
			NBITS => NBITS,
			NBELMTS => OUTPUT_SIZE,
			REG_DELAY => 0,
			INT_BITS => INT_BITS
			)
		port map (
			start => start_z_rec,
			clk => clk,
			rst => rst,
			a_in => sn_1,
			b_in => wz,
			ready => ready_z_rec,
			z_out => znj_rec_out
			);
 	RN_DIR: entity work.dotp_fsmd(rtl)
		generic map (
			NBITS => NBITS,
			NBELMTS => INPUT_SIZE,
			REG_DELAY => 0,
			INT_BITS => INT_BITS
			)
		port map (
			start => start_r_dir,
			clk => clk,
			rst => rst,
			a_in => xn,
			b_in => ur,
			ready => ready_r_dir,
			z_out => rnj_dir_out
		);
	RN_REC: entity work.dotp_fsmd(rtl)
		generic map (
			NBITS => NBITS,
			NBELMTS => OUTPUT_SIZE,
			REG_DELAY => 0,
			INT_BITS => INT_BITS
			)
		port map (
			start => start_r_rec,
			clk => clk,
			rst => rst,
			a_in => sn_1,
			b_in => wr,
			ready => ready_r_rec,
			z_out => rnj_rec_out
		);
	HN_DIR: entity work.dotp_fsmd(rtl)
		generic map (
			NBITS => NBITS,
			NBELMTS => INPUT_SIZE,
			REG_DELAY => 0,
			INT_BITS => INT_BITS
			)
		port map (
			start => start_h_dir,
			clk => clk,
			rst => rst,
			a_in => xn,
			b_in => uh,
			ready => ready_h_dir,
			z_out => hnj_dir_out
		);
	HN_REC: entity work.dotp_fsmd(rtl)
		generic map (
			NBITS => NBITS,
			NBELMTS => OUTPUT_SIZE,
			REG_DELAY => 0,
			INT_BITS => INT_BITS
			)
		port map (
			start => start_h_rec,
			clk => clk,
			rst => rst,
			a_in => elemwise_prod,     -- result of elementwise product between sn_1 and rn
			b_in => wh,
			ready => ready_h_rec,
			z_out => hnj_rec_out
		);

		REG: process(clk, rst)
		begin
			if rst = '1' then
				state_reg <= IDLE;
				znj_reg <= (others => '0');
				rnj_reg <= (others => '0');
				hnj_reg <= (others => '0');
				snj_reg <= (others => '0');
			elsif rising_edge(clk) then
				state_reg <= state_next;
				znj_reg <= znj_next;
				rnj_reg <= rnj_next;
				hnj_reg <= hnj_next;
				snj_reg <= snj_next;
			end if;
		end process REG;

		R_CALC: process(br, rnj_dir_out, rnj_rec_out, rnj_reg, state_reg)
		variable rn_real: real;
		begin

			rnj_next <= rnj_reg;
			if state_reg = CALC_RN then
				rn_real := real(to_integer(signed(rnj_dir_out)+signed(rnj_rec_out)+signed(br)))/(2.0**(NBITS-INT_BITS-1));
				rnj_next <= std_logic_vector(to_signed(integer(2.0**(NBITS-INT_BITS-1)*1.0/(1.0+exp(-rn_real))), rnj_next'length));
			end if;
		end process R_CALC;

		Z_CALC: process(bz, znj_dir_out, znj_rec_out, znj_reg, state_reg)
		variable zn_real : real;
		begin
			znj_next <= znj_reg;
			if state_reg = CALC_RN then
				zn_real := real(to_integer(signed(znj_dir_out)+signed(znj_rec_out)+signed(bz)))/(2.0**(NBITS-INT_BITS-1));
				znj_next <= std_logic_vector(to_signed(integer(2.0**(NBITS-INT_BITS-1)*1.0/(1.0+exp(-zn_real))), znj_next'length));
			end if;
		end process Z_CALC;


		H_CALC: process(hnj_reg, hnj_dir_out, hnj_rec_out, bh, state_reg)
		variable hn_real: real;
		begin
			hnj_next <= hnj_reg;
			if state_reg = CALC_HN then
				hn_real := real(to_integer(signed(hnj_dir_out)+signed(hnj_rec_out)+signed(bh)))/(2.0**(NBITS-INT_BITS-1));
				hnj_next <= std_logic_vector(to_signed(integer(2.0**(NBITS-INT_BITS-1)*(1.0-2.0/(1.0+exp(2.0*hn_real)))), hnj_next'length));
			end if;
		end process H_CALC;

		S_CALC: process(snj_reg, znj_reg, hnj_reg, state_reg)
		variable snj_temp : signed(2*NBITS-1 downto 0);
		begin
			snj_next <= snj_reg;
			if state_reg = RESULT then
				snj_temp := shift_right((to_signed(2**(NBITS-INT_BITS-1), znj_reg'length)-signed(znj_reg))*signed(snj_reg),NBITS-INT_BITS-1)+shift_right(signed(znj_reg)*signed(hnj_reg),NBITS-INT_BITS-1);
				snj_next <= std_logic_vector(snj_temp(2*NBITS-1)&snj_temp(NBITS-2 downto 0));
			end if;
		end process S_CALC;


		--output logic
		rnj <= rnj_reg;
		snj <= snj_reg;
		end architecture fsmd;
