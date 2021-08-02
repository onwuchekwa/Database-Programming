SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  lv_month_count NUMBER;
  TYPE month_table IS TABLE OF VARCHAR(10); -- This uses a scalar datatype (varchar)
  
  lv_month_of_the_year month_table := month_table
  (
     'January'
   , 'February'
   , 'March'
   , 'April'
   , 'May'
   , 'June'
   , 'July'
   , 'August'
   , 'September'
   , 'October'
   , 'November'
   , 'December'
   );

BEGIN
  lv_month_count := 0; -- Initialize the count
  DBMS_OUTPUT.PUT_LINE('The following are months in a year:');
  FOR i IN lv_month_of_the_year.FIRST..lv_month_of_the_year.LAST LOOP -- Start Loop
    lv_month_count := lv_month_count + 1; -- Increment the counter
	DBMS_OUTPUT.PUT_LINE('Month '||lv_month_count||': '||lv_month_of_the_year(i)); -- Display the result
  END LOOP; -- End Loop
END;
/

