
/* Set printing. */
SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK OFF
 
/* Declare a test script. */
DECLARE
  lv_order  ORDER_COMP := order_comp('Clark Kent','Superman');
BEGIN
  dbms_output.put_line(lv_order.to_string);
END;
/
 
/* Declare a test script. */
DECLARE
  lv_order  ORDER_COMP := order_subcomp('Clark Kent','Superman','The Quest for Peace');
BEGIN
  dbms_output.put_line(lv_order.to_string);
END;
/
 
/* Quit the connection. */
QUIT;
