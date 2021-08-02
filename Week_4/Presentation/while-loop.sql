SPOOL while-loop.txt

SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_counter  NUMBER := 0; -- Declaring the variable
  v_result NUMBER; -- This holds the result of the product of 5 and the counter
BEGIN
  WHILE v_counter <= 12 -- Keyword 'WHILE' marks the beginning of the loop, and it also checks whether the value of 'v_counter' is less than or equal to 12
    LOOP
      v_result := 5 * v_counter; -- Pass the product of 5 and counter to v_result
      DBMS_OUTPUT.PUT_LINE('5'||' x '||v_counter||' = '||v_result); -- Displays the output
      v_counter := v_counter + 1; -- Increments the counter
    END LOOP; -- Ends Loop
END;
/

SPOOL OFF