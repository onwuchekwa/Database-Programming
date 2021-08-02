-- ======================================================================
--  Name:    create_tolkien.sql
--  Author:  Michael McLaughlin
--  Date:    02-Apr-2020
-- ------------------------------------------------------------------
--  Purpose: Prepare final project environment.
-- ======================================================================

/* Set environment variables. */
SET PAGESIZE 999

/* Write to log file. */
SPOOL create_tolkien.txt

/* Drop the tolkien table. */
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

/* Drop and create a tolkien_s sequence. */
CREATE SEQUENCE tolkien_s START WITH 1001;

/* Close log file. */
SPOOL OFF

/* Exit the connection. */
QUIT

