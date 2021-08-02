SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DROP TYPE month_table;
CREATE OR REPLACE
  TYPE month_table IS OBJECT
  (
     month_index VARCHAR(10)
   , month_name VARCHAR(15)
  );
   / 
DECLARE
  TYPE month_of_year IS TABLE OF month_table; 

  lv_month_of_the_year month_of_year := month_of_year
  (
    month_table('Month 1: ', 'January')
   , month_table('Month 2: ', 'February')
   , month_table('Month 3: ', 'March')
   , month_table('Month 4: ', 'April')
   , month_table('Month 5: ', 'May')
   , month_table('Month 6: ', 'June')
   , month_table('Month 7: ', 'July')
   , month_table('Month 8: ', 'August')
   , month_table('Month 9: ', 'September')
   , month_table('Month 10: ', 'October')
   , month_table('Month 11: ', 'November')
   , month_table('Month 12: ', 'December')
  );

BEGIN
  DBMS_OUTPUT.PUT_LINE('The following are months in a year:');
  FOR i IN 1..lv_month_of_the_year.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(lv_month_of_the_year(i).month_index||lv_month_of_the_year(i).month_name); 
  END LOOP;
END;
/