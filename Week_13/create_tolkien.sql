/*
||  Name:          create_tolkien.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 13 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED

--@/home/student/Data/cit325/lib/cleanup_oracle.sql
--@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL create_tolkien.txt

-- ... insert your solution here ...

-- ========================================================================
-- A create_tolkien.sql file that drops and creates the tolkien table 
-- and tolkien_s sequence
/* Drop the tolkien table and tolkien_s sequence. */
BEGIN
  FOR i IN (SELECT o.object_name
	    ,      o.object_type
	    FROM   user_objects o
	    WHERE  o.object_name IN ('TOLKIEN','TOLKIEN_S')) LOOP
    IF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    ELSIF i.object_type = 'SEQUENCE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    END IF;
  END LOOP;
END;
/


/* Create the tolkien table. */
CREATE TABLE tolkien
( tolkien_id NUMBER
, tolkien_character base_t);

/* Create a tolkien_s sequence. */
CREATE SEQUENCE tolkien_s START WITH 1001;

DESC tolkien;

/* Close log file. */
SPOOL OFF

/* Close connection. */
QUIT;
