/*
||  Name:          apply_plsql_lab3.sql
||  Date:          01 Sept 2020
||  Author:        Sunday Onwuchekwa
||  Purpose:       Complete 325 Chapter 4 lab.
*/

-- Call seeding libraries.
--@$LIB/cleanup_oracle.sql
--@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Open log file.
--SPOOL apply_plsql_lab3.txt

-- Enter your solution here.

/* Declare a RECORD TYPE */
DECLARE 
  TYPE three_type IS RECORD
  (
    xnum NUMBER,
    xdate DATE,
    xstring VARCHAR2(30)
  );
  
  /* Declare a collection of strings. */
  TYPE list IS TABLE OF VARCHAR2(100);
  
  /* Declare variable of the RECORD */
  lv_three_type THREE_TYPE;
  
  /* Declare a list of the collection type. */
  lv_input LIST;
  
  /* Three variables to store the input */
  lv_input1 VARCHAR2(100);
  lv_input2 VARCHAR2(100);
  lv_input3 VARCHAR2(100);
  
BEGIN
  /* Prompt for the input values */
  lv_input1 := '&1';
  lv_input2 := '&2';
  lv_input3 := '&3';
  
  /* Put the three values into LIST */
  lv_input := list(lv_input1, lv_input2, lv_input3);
  
  --Loop through the list of values to find only the valid value
  FOR i IN 1..lv_input.COUNT LOOP
    IF REGEXP_LIKE(lv_input(i), '^[[:digit:]]*$') THEN
       lv_three_type.xnum := lv_input(i);
    ELSIF verify_date(lv_input(i)) IS NOT NULL THEN
       lv_three_type.xdate := lv_input(i);
    ELSIF REGEXP_LIKE(lv_input(i), '^[[:alnum:]]*$') THEN
       lv_three_type.xstring := lv_input(i);
    END IF;
  END LOOP;
  
  /* DBMS_OUTPUT */
  dbms_output.put_line('Record ['||lv_three_type.xnum||'] ['||lv_three_type.xstring||'] ['||lv_three_type.xdate||']');
END;
/
-- Close log file.
--SPOOL OFF
QUIT;
