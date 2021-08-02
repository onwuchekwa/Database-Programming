/*
||  Name:          apply_plsql_lab2-2.sql
||  Author:        Sunday Onwuchekwa
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 3 lab.
*/

-- Call seeding libraries.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab2-2.txt

-- Enter your solution here.

SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

DECLARE
  -- Declare local variables
  lv_raw_input VARCHAR(225);
  lv_input     VARCHAR2(10);
  
BEGIN
  lv_raw_input := '&1'; -- Get data from user
  
  -- If no parameter, print 'Hello World!'
  IF lv_raw_input IS NULL THEN 
    dbms_output.put_line('Hello World!');
    
  -- If the parameter is 10 characters or less, print the 'Hello ' + the parameter + '!'
  ELSIF LENGTH(lv_raw_input) <= 10 THEN
    lv_input := lv_raw_input;
    dbms_output.put_line('Hello '||lv_input||'!');
    
  -- If the parameter is more than 10 characters in length, print the 'Hello ' + the first 10 characters of the parameter + '!'.
  ELSIF LENGTH(lv_raw_input) > 10 THEN
    lv_input := SUBSTR(lv_raw_input, 1, 10);
    dbms_output.put_line('Hello '||lv_input||'!');
  END IF;
EXCEPTION WHEN OTHERS THEN
  dbms_output.put_line('Exception ['||SQLERRM||']');
END;
/

-- Close log file.
SPOOL OFF
QUIT;
