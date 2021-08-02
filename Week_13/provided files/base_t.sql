-- ======================================================================
--  Name:    base_t.sql
--  Author:  Michael McLaughlin
--  Date:    02-Apr-2020
-- ------------------------------------------------------------------
--  Purpose: Prepare final project environment.
-- ======================================================================

-- Open log file.
SPOOL base_t.txt

CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oid   NUMBER
  , oname VARCHAR2(30)
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname
    ( oname  VARCHAR2 )
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE
  TYPE BODY base_t IS
  /* Implement a get_oname function. */
  MEMBER FUNCTION get_oname
  RETURN VARCHAR2 IS
  BEGIN
    RETURN self.oname;
  END get_oname;
  /* Implement a set_oname procedure. */
  MEMBER PROCEDURE set_oname
  ( oname  VARCHAR2 ) IS
  BEGIN
    self.oname := oname;
  END set_oname;
  /* Implement a get_name function - place order for SQL. */
  MEMBER FUNCTION get_name
  RETURN VARCHAR2 IS
  BEGIN
    RETURN NULL;
  END get_name;
  /* Implement a to_string function. */
  MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.oid||']['||self.oname||']';
  END to_string;
END;
/

SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  lv_object  BASE_T := base_t(1,'BASE_T');
BEGIN
  dbms_output.put_line(lv_object.to_string);
END;
/

-- Close log file.
SPOOL OFF

-- Quit SQL*Plus session.
QUIT

