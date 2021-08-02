/*
||  Name:          apply_plsql_lab12.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 13 lab.
*/

-- Set the Environment
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Call seeding libraries.
--@$LIB/cleanup_oracle.sql
--@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

DROP TYPE item_obj FORCE;
DROP TYPE item_tab;
DROP FUNCTION item_list;

-- Open log file.
SPOOL apply_plsql_lab12.txt

-- Enter your solution here.
-- ========================================================================
--  Create the item_obj object type
-- ========================================================================
CREATE OR REPLACE
  TYPE item_obj IS OBJECT
  ( 
    title        VARCHAR2(60)
  , subtitle     VARCHAR2(60)
  , rating       VARCHAR2(8)
  , release_date DATE
  );
/

desc item_obj

-- ========================================================================
--  Create the item_tab object type
-- ========================================================================
CREATE OR REPLACE
  TYPE item_tab IS TABLE of item_obj;
/

desc item_tab

-- ========================================================================
--  Create a item_list function
-- ========================================================================
CREATE OR REPLACE
  FUNCTION item_list
  ( 
    pv_start_date DATE
	-- Assign TRUNC(SYSDATE) + 1 as the DEFAULT value of the pv_end_date
  , pv_end_date   DATE DEFAULT (TRUNC(SYSDATE) + 1) 
  ) RETURN item_tab IS
 
  -- Create an item_rec record type that mirrors the item_obj object type.
  TYPE item_rec IS RECORD
  ( 
	 title        VARCHAR2(60)
   , subtitle     VARCHAR2(60)
   , rating       VARCHAR2(8)
   , release_date DATE
   );
 
   -- Create an item_cur system reference cursor that is weakly typed cursor.
   item_cur   SYS_REFCURSOR;
 
   -- Create an item_row variable of the item_rec data type
   item_row   ITEM_REC;
   /* Create an item_set variable of the item_tab collection type, and create 
	  an empty instance of the item_tab collection.
   */
   item_set   ITEM_TAB := item_tab();
 
   -- Declare dynamic statement.
   stmt  VARCHAR2(2000);
   BEGIN
      /* Assign an NDS string to the stmt variable. 
	     The string should return the following columns 
	  */
      stmt := 'SELECT item_title AS title
            , item_subtitle AS subtitle
            , item_rating AS rating
            , item_release_date AS release_date '
         || 'FROM   item '
         || 'WHERE  item_rating_agency = ''MPAA'''
         || 'AND  item_release_date > :start_date AND item_release_date < :end_date';
 
      DBMS_OUTPUT.PUT_LINE(stmt);

      /* Open the item_cur system reference cursor with the stmt dynamic 
	     statement, and assign the pv_start_date and pv_end_date variables 
	     inside the USING clause 
	  */
      OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;
      LOOP
        /* Fetch the item_cur system reference cursor into the item_row 
		   variable of the item_rec data type 
		*/
        FETCH item_cur INTO item_row;
        EXIT WHEN item_cur%NOTFOUND;
 
        -- Extend space in the item_set variable of the item_tab collection     
        item_set.EXTEND;
        item_set(item_set.COUNT) := item_obj
		                            ( 
		                              title  => item_row.title
                                    , subtitle => item_row.subtitle
                                    , rating   => item_row.rating
                                    , release_date => item_row.release_date 
								    );
      END LOOP;
 
      /* Return item set back to the calling program. */
      RETURN item_set;
  END item_list;
/

desc item_list;

-- ========================================================================
--  Test the item_list function with a query that uses the TABLE function 
-- and returns only the title and rating members from each of the 
-- item_obj object types
-- ========================================================================
COL title   FORMAT A60 HEADING "Title"
COL rating  FORMAT A6 HEADING "Rating"
SELECT   il.title AS Title
,        il.rating AS Rating
FROM     TABLE(item_list('01-JAN-2000')) il
ORDER BY 1, 2;

-- Close log file.
SPOOL OFF
