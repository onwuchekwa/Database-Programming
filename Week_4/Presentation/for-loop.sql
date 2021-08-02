SPOOL for-loop.txt

SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_result  NUMBER; -- This holds the result of the product of 5 and the counter
BEGIN
  FOR v_counter IN 0..12 --The FOR keyword marks the begining of the loop. 0 is the minimum number and 12 is the maximum number
  LOOP -- Starts Loop 
    v_result := 5 * v_counter; -- Passes the product of 5 and counter to v_result
    DBMS_OUTPUT.PUT_LINE('5'||' x '||v_counter||' = '|| v_result); -- Displays the output 
  END LOOP; -- Ends Loop
END;
/

SPOOL OFF
