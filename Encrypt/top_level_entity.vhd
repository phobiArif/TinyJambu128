library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--PROGRAM Top Level

entity top_level_entity is
	port(
		tx : out std_logic;
		rx : in std_logic;
		clock : in std_logic
	);
end top_level_entity;

architecture main of top_level_entity is
	component stateupdate is
		port(
			ne, ade, pe : in std_logic;
			nscd, adscd, pscd : out std_logic;
			m : in std_logic_vector(119 downto 0);
			mlen : in std_logic_vector(6 downto 0);
			statein : in std_logic_vector(31 downto 0);
			stateout : out std_logic_vector(31 downto 0);
			clock : in std_logic;
			cycle : out std_logic_vector(2 downto 0);
			reset : in std_logic
		);
	end component;
	component fb_em is
		port(
			fb : in std_logic_vector(2 downto 0);
			fb_en : in std_logic;
			statein : in std_logic_vector(2 downto 0);
			stateout : out std_logic_vector(2 downto 0);
			done : out std_logic
		);
	end component;
	component pb_em is
		port(
			mlen : in std_logic_vector(6 downto 0);
			statein : in std_logic_vector(1 downto 0);
			stateout : out std_logic_vector(1 downto 0);
			pbade, pbpe : in std_logic;
			done : out std_logic
		);
	end component;
	component sreg is
		port(
			en : in std_logic;
			statein : in std_logic_vector(127 downto 0);
			stateout : out std_logic_vector(127 downto 0);
			sh : in std_logic;
			clock : in std_logic;
			input : in std_logic
		);
	end component;
	component cgen is
		port(
			state : in std_logic_vector(31 downto 0);
			m : in std_logic_vector(119 downto 0);
			cout : out std_logic_vector(119 downto 0);
			mlen : in std_logic_vector(6 downto 0);
			en : in std_logic;
			cycle : out std_logic_vector(2 downto 0);
			done : out std_logic;
			reset : in std_logic
		);
	end component;
	component creg is
		port(
			en : in std_logic;
			clock : in std_logic;
			cin : in std_logic_vector(119 downto 0);
			cout : out std_logic_vector(119 downto 0)
		);
	end component;
	component rxd is
		port(
			rx : in std_logic;
			clock : in std_logic;
			en : in std_logic;
			m : buffer std_logic_vector(119 downto 0);
			done : buffer std_logic;
			mlen : out std_logic_vector(6 downto 0)
		);
	end component;
	component txd is
		port(
			creg : in std_logic_vector(119 downto 0);
			mlen : in std_logic_vector(6 downto 0);
			clock : in std_logic;
			tx : out std_logic;
			en : in std_logic;
			done : out std_logic
		);
	end component;
	component tag is
		PORT(
			clk : IN STD_LOGIC; 
			st  : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
			tag1: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
			enable : IN STD_LOGIC
		);
	end component;
	component tgen is
		port(
			state : in std_logic_vector(31  downto 0);
			tagout : out std_logic_vector(63 downto 0);
			en1, en2 : in std_logic
		);
	end component;
	component register_plaintext is
		PORT(
			m_clock : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			en_M : IN STD_LOGIC;
			m_in: IN STD_LOGIC_VECTOR (119 downto 0);
			M : OUT STD_LOGIC_VECTOR (119 downto 0)
		);
	end component;
	component Permutation is
		PORT (
			lim					: IN STD_LOGIC_VECTOR(9 downto 0);
			stateRegister		: IN STD_LOGIC_VECTOR (127 DOWNTO 0);	
			permutationStart	: IN STD_LOGIC;
			permutationDone		: out STD_LOGIC;
			feedback : out std_logic;
			clock : in std_logic
		);
	end component;
	signal ne : std_logic;
	signal ade : std_logic;
	signal pe : std_logic;
	signal nscd : std_logic;
	signal adscd : std_logic;
	signal pscd : std_logic;
	signal sur : std_logic;
	signal fb_en : std_logic;
	signal fbd : std_logic;
	signal pbd : std_logic;
	signal pbade : std_logic;
	signal pbpe : std_logic;
	signal sre : std_logic;
	signal shift : std_logic;
	signal feedback : std_logic;
	signal cto : std_logic_vector(119 downto 0);
	signal cge : std_logic;
	signal cgd : std_logic;
	signal cgr : std_logic;
	signal cre : std_logic;
	signal cfrom : std_logic_vector(119 downto 0);
	signal re : std_logic;
	signal rd : std_logic;
	signal cen : std_logic;
	signal mto : std_logic_vector(119 downto 0);
	signal te : std_logic;
	signal td : std_logic;
	signal tto : std_logic_vector(63 downto 0);
	signal tfrom : std_logic_vector(63 downto 0);
	signal tge : std_logic;
	signal tag1 : std_logic;
	signal tag2 : std_logic;
	signal mr : std_logic;
	signal lim : std_logic_vector(9 downto 0);
	signal ps : std_logic;
	signal pd :  std_logic;
	signal fb : std_logic_vector(2 downto 0);
	signal m : std_logic_vector(119 downto 0);
	signal mlen : std_logic_vector(6 downto 0);
	signal stateto : std_logic_vector(127 downto 0) := (others => 'Z');
	signal statefrom : std_logic_vector(127 downto 0);
	signal cycle : std_logic_vector(2 downto 0);
	component fsm is
		port(
			clock : in std_logic;
			ne, ade, pe, sur, fb_en, pbade, pbpe, sre, shift, cge, cgr, cre, re, te, tag1, tag2, mr, ps : out std_logic;
			nscd, adscd, pscd, fbd, pbd, cgd, rd, td, pd : in std_logic;
			lim : out std_logic_vector(9 downto 0);
			cycle : in std_logic_vector(2 downto 0);
			fb : out std_logic_vector(2 downto 0);
			rx : in std_logic;
			mlen : in std_logic_vector(6 downto 0)
		);
	end component;
begin
	tge <= tag1 or tag2;
	su : stateupdate
		port map(
			ne => ne,
			ade => ade,
			pe => pe,
			nscd => nscd,
			adscd => adscd,
			pscd => pscd,
			m => m,
			mlen => mlen,
			statein => statefrom(127 downto 96),
			stateout => stateto(127 downto 96),
			clock => clock,
			cycle => cycle,
			reset => sur
		);
	framebits : fb_em
		port map(
			fb => fb,
			fb_en =>fb_en,
			statein => statefrom(38 downto 36),
			stateout => stateto(38 downto 36),
			done => fbd
		);
	pb : pb_em
		port map(
			mlen => mlen,
			statein => statefrom(33 downto 32),
			stateout => stateto(33 downto 32),
			pbade => pbade,
			pbpe => pbpe,
			done => pbd
		);
	st : sreg
		port map(
			en => sre,
			statein => stateto,
			stateout => statefrom,
			sh => shift,
			clock => clock,
			input => feedback
		);
	cg : cgen 
		port map(
			state => statefrom(95 downto 64),
			m => m,
			cout => cto,
			mlen => mlen,
			en => cge,
			cycle => cycle,
			done => cgd,
			reset => cgr
		);
	cr : creg
		port map(
			en => cre,
			clock => clock,
			cin => cto,
			cout => cfrom
		);
	recv : rxd
		port map(
			rx => rx,
			clock => clock,
			en => re,
			m => mto,
			done => rd,
			mlen => mlen
		);
	tran : txd
		port map(
			creg => cfrom,
			mlen => mlen,
			clock => clock,
			tx => tx,
			en => te,
			done => td
		);
	tagr : tag
		port map(
			clk => clock,
			st => tto,
			tag1 => tfrom,
			enable => tge
		);
	tagg : tgen
		port map(
			state => statefrom(95 downto 64),
			tagout => tto,
			en1 => tag1,
			en2 => tag2
		);
	mreg : register_plaintext
		port map(
			m_clock => clock,
			reset => mr,
			en_M => re,
			m_in => mto,
			M => m
		);
	p : Permutation
		port map(
			lim => lim,
			stateRegister => statefrom,
			permutationStart => ps,
			permutationDone	=> pd,
			feedback => feedback,
			clock => clock
		);
	control : fsm
		port map(
			clock => clock,
			ne => ne, 
			ade => ade,
			pe => pe,
			sur => sur,
			fb_en => fb_en,
			pbade => pbade,
			pbpe => pbpe,
			sre => sre,
			shift => shift,
			cge => cge,
			cgr => cgr,
			cre => cre,
			re => re,
			te => te,
			tag1 => tag1,
			tag2 => tag2,
			mr => mr,
			ps => ps,
			nscd => nscd,
			adscd => adscd,
			pscd => pscd,
			fbd => fbd,
			pbd => pbd,
			cgd => cgd,
			rd => rd,
			td => td,
			pd => pd,
			lim => lim,
			cycle => cycle,
			rx => rx,
			fb => fb,
			mlen => mlen
		);
end main;