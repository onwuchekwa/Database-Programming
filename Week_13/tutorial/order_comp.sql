DROP TYPE order_subcomp;
DROP TYPE order_comp;

CREATE OR REPLACE
  TYPE order_comp IS OBJECT
  ( who   VARCHAR2(20)
  , movie VARCHAR2(20)
  , CONSTRUCTOR FUNCTION order_comp
    ( who    VARCHAR2
    , movie  VARCHAR2 )
    RETURN SELF AS RESULT
  , MEMBER FUNCTION to_string RETURN VARCHAR2
  , ORDER MEMBER FUNCTION equals
    ( object order_comp ) RETURN NUMBER )
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE
  TYPE BODY order_comp IS
  /* Implement a default constructor. */
  CONSTRUCTOR FUNCTION order_comp
  ( who    VARCHAR2
  , movie  VARCHAR2 )
  RETURN SELF AS RESULT IS
  BEGIN
    self.who := who;
    self.movie := movie;
    RETURN;
  END order_comp;

  /* Implement a to_string function. */
  MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.movie||']['||self.who||']';
  END to_string;

  /* Implement an equals function. */
  ORDER MEMBER FUNCTION equals
  ( object  ORDER_COMP ) RETURN NUMBER IS
  BEGIN
    IF self.movie < object.movie THEN
      RETURN 1;
    ELSIF self.movie = object.movie AND self.who < object.who THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END equals;
END;
/

SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  lv_order  ORDER_COMP := order_comp('Clark Kent','Superman');
BEGIN
  dbms_output.put_line(lv_order.to_string);
END;
/

QUIT;

