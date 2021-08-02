-- ======================================================================
--  Name:    insert_instances.sql
--  Author:  Michael McLaughlin
--  Date:    02-Apr-2020
-- ------------------------------------------------------------------
--  Purpose: Prepare final project environment.
-- ======================================================================

-- Open the log file.
SPOOL insert_instances.txt

-- Here's a sample insert.
INSERT INTO tolkien
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, hobbit_t( oid   => tolkien_s.CURRVAL
	  , name  => 'MAN_T'
          , oname => 'Man'
          , name  => 'Boromir' ));

-- Put your other insert statements here.


-- Close the log file.
SPOOL OFF

QUIT;
