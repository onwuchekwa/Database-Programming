set verify off
set serveroutput on size unlimited
/*
create or replace
type multiplicant is varray(3) of integer;
*/
declare
  TYPE multiplicant is varray(4) of number;
  lv_multiplicant multiplicant;
  multiplier NUMBER := 5;
  product number := 0;
Begin
  lv_multiplicant := multiplicant(1,2,3);      
  for i in 1..lv_multiplicant.count loop
    product := lv_multiplicant(i) * multiplier;
    DBMS_OUTPUT.PUT_LINE(lv_multiplicant(i)||' x '||multiplier||' = '||product);
  end loop; 
  dbms_output.put_line((chr(13));
  -- EXTENDS THE VARRAY BY ONE
  DBMS_OUTPUT.put_line('varray extend');
  lv_multiplicant.extend;
  lv_multiplicant(lv_multiplicant.count) := 4;  
  for i in 1..lv_multiplicant.count loop
    product := lv_multiplicant(i) * multiplier;
    DBMS_OUTPUT.PUT_LINE(lv_multiplicant(i)||' x '||multiplier||' = '||product);
  end loop;
End;
/
