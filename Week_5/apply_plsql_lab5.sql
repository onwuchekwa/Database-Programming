/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Enter your solution here.
SET PAGESIZE 999
SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- ----------------------------------------------------------------------
-- CREATE SEQUENCE rating_agency_s
-- ----------------------------------------------------------------------
DROP SEQUENCE rating_agency_s;
CREATE SEQUENCE rating_agency_s
START WITH      1001
INCREMENT BY    1;

-- ----------------------------------------------------------------------
-- CREATE TABLE rating_agency
-- ----------------------------------------------------------------------
CREATE TABLE rating_agency AS
  SELECT rating_agency_s.NEXTVAL AS rating_agency_id
  ,      il.item_rating AS rating
  ,      il.item_rating_agency AS rating_agency
  FROM   (SELECT DISTINCT
              i.item_rating
         ,    i.item_rating_agency
         FROM item i) il;

-- ----------------------------------------------------------------------
-- ALTER TABLE rating_agency
-- ----------------------------------------------------------------------
ALTER TABLE 
  item
ADD 
( 
  rating_agency_id NUMBER 
);

-- ----------------------------------------------------------------------
-- CREATE OBJECTS AND TABLE COLLECTION
-- ----------------------------------------------------------------------
-- Drop existing object type
DROP TYPE rating_agency_data;
-- CREATE OBJECT  rating_agency_data
CREATE OR REPLACE
  TYPE rating_agency_data IS OBJECT
  (
     rating_agency_id NUMBER
   , rating           VARCHAR2(8)
   , rating_agency    VARCHAR2(4)
  );
/

--Create a collection of rating_agency_data
CREATE OR REPLACE
  TYPE rating_agency_record IS TABLE OF rating_agency_data; 
/

-- Open log file.
SPOOL apply_plsql_lab5.txt

-- ----------------------------------------------------------------------
-- SHOW TABLES
-- ----------------------------------------------------------------------
--  Check it’s contents
SELECT * FROM rating_agency;

SET NULL ''
COLUMN table_name   FORMAT A18
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

-- ----------------------------------------------------------------------
-- Anonymous PL/SQL block to read the RATING_AGENCY
-- ----------------------------------------------------------------------
DECLARE
  -- Initialize a variable
	lv_rating_agency_data rating_agency_data; 
	lv_rating_agency_record rating_agency_record;
  
  -- Create a cursor
  CURSOR c IS
    SELECT 
	  rating_agency_id, rating, rating_agency
	FROM rating_agency;

BEGIN
    lv_rating_agency_record := rating_agency_record();
	
	--Loop through the cursor and assign data to the collection
	FOR i IN c LOOP
      lv_rating_agency_data := rating_agency_data
      ( 
        rating_agency_id => i.rating_agency_id
      , rating => i.rating
      , rating_agency => i.rating_agency 
      );
      
	  lv_rating_agency_record.EXTEND;
	  lv_rating_agency_record(lv_rating_agency_record.COUNT) := rating_agency_data
	  (
	    lv_rating_agency_data.rating_agency_id
      , lv_rating_agency_data.rating	
      , lv_rating_agency_data.rating_agency	  
	  );
	END LOOP;
	
	-- UPDATE rating_agency_id
	FOR j IN 1..lv_rating_agency_record.COUNT LOOP
	  UPDATE item SET
	    rating_agency_id = lv_rating_agency_record(j).rating_agency_id
	  WHERE item_rating = lv_rating_agency_record(j).rating
	    AND item_rating_agency = lv_rating_agency_record(j).rating_agency;
	END LOOP;
	COMMIT;
END;
/

-- ----------------------------------------------------------------------
-- Verify the results of your anonymous PL/SQL block
-- ----------------------------------------------------------------------
SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;


-- Close log file.
SPOOL OFF

