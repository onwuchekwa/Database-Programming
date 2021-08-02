SPOOL guard-on-exit-loop.txt

SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_counter   NUMBER := 0; -- Declares counter for iteration
  v_result  NUMBER; -- This holds the result of the product of 5 and the counter
BEGIN
  LOOP -- Starts Loop
    v_result := 5 * v_counter; -- Passes the product of 5 and counter to v_result
    DBMS_OUTPUT.PUT_LINE('5'||' x '||v_counter||' = '|| v_result); -- Displays the output  
    v_counter := v_counter + 1; -- Increments the counter
    IF v_counter >= 12 THEN -- Exits the loop after the 12th iteration
      EXIT;
    END IF;
  END LOOP; -- Ends Loop
END;
/

SPOOL OFF