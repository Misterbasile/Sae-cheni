LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Pro_v1 IS
    PORT (
        CLOCK_50 : IN STD_LOGIC;            -- Horloge système (50 MHz)
        reset    : IN STD_LOGIC;            -- Réinitialisation
        leds     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)  -- LEDs rouges (0 à 7)
    );
END ENTITY Pro_v1;

ARCHITECTURE behavior OF Pro_v1 IS

    -- Signal pour générer une horloge de 1 Hz
    SIGNAL clk_1Hz   : STD_LOGIC := '0';   
    SIGNAL counter   : INTEGER RANGE 0 TO 24999999 := 0;  
    SIGNAL led_counter : INTEGER RANGE 0 TO 7 := 0;     

BEGIN

    -- Processus pour générer l'horloge de 1 Hz
    PROCESS (CLOCK_50, reset)
    BEGIN
        IF reset = '1' THEN
            counter <= 0;
            clk_1Hz <= '0';  
        ELSIF rising_edge(CLOCK_50) THEN
            -- Compter jusqu'à 25 millions pour diviser l'horloge de 50 MHz à 1 Hz
            IF counter = 24999999 THEN
                counter <= 0;
                clk_1Hz <= NOT clk_1Hz;  
            ELSE
                counter <= counter + 1;
            END IF;
        END IF;
    END PROCESS;

    -- Processus pour faire défiler les LEDs
    PROCESS (clk_1Hz, reset)
    BEGIN
        IF reset = '1' THEN
            led_counter <= 0;
            leds <= "00000001";  -- Allumer la LED 0
        ELSIF rising_edge(clk_1Hz) THEN
            -- Faire défiler les LEDs de 0 à 7 successivement
            CASE led_counter IS
                WHEN 0  => leds <= "00000001";  
                WHEN 1  => leds <= "00000010";  
                WHEN 2  => leds <= "00000100";  
                WHEN 3  => leds <= "00001000";  
                WHEN 4  => leds <= "00010000";  
                WHEN 5  => leds <= "00100000";  
                WHEN 6  => leds <= "01000000";  
                WHEN 7  => leds <= "10000000";  
            END CASE;

            -- Incrémentation du compteur des LEDs
            IF led_counter = 7 THEN
                led_counter <= 0;  
            ELSE
                led_counter <= led_counter + 1;  
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE behavior;

