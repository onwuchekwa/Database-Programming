CREATE OR REPLACE
  TYPE order_subcomp UNDER order_comp
  ( subtitle  VARCHAR2(20)
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE FINAL;
/

CREATE OR REPLACE TYPE BODY order_subcomp IS
  /* Implement an overriding to_string function with
     generalized invocation. */
  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN (self AS order_comp).to_string||'['||self.subtitle||']';
  END to_string;
END;
/

SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  lv_order  ORDER_COMP := order_subcomp('Clark Kent','Superman','The Quest for Peace');
BEGIN
  dbms_output.put_line(lv_order.to_string);
END;
/

QUIT;

