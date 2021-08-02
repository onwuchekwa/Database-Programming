/*
||  Name:          orc_t.sql
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
SPOOL orc_t.txt

-- ... insert your solution here ...

-- ========================================================================
-- A orc_t object type and type body as a subtype of the base_t 
-- object type, and a QUIT; statement in a orc_t.sql file.
-- ========================================================================
CREATE OR REPLACE
  TYPE orc_t UNDER base_t
  (
    name  VARCHAR2(30)
  , genus VARCHAR2(30)
  , CONSTRUCTOR FUNCTION orc_t
    (
	  oid   NUMBER
	, oname VARCHAR2
	, name  VARCHAR2
	, genus VARCHAR2
	) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER PROCEDURE set_name (name VARCHAR2)
  , MEMBER FUNCTION get_genus RETURN VARCHAR2
  , MEMBER PROCEDURE set_genus (genus VARCHAR2)
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2
  )
  INSTANTIABLE NOT FINAL;
/

DESC orc_t

-- =======================================================================
-- Implement a orc_t type body in a orc_t.sql file 
-- =======================================================================
CREATE OR REPLACE
  TYPE BODY orc_t IS
  /* Formalized default constructor. */ 
  CONSTRUCTOR FUNCTION orc_t
  (
    oid   NUMBER
  , oname VARCHAR2
  , name  VARCHAR2
  , genus VARCHAR2
  ) RETURN SELF AS RESULT IS
  BEGIN
    /* Assign inputs to instance variables. */
    self.oid    := oid;
	self.oname  := oname;
    self.name   := name;
	self.genus  := genus;
	RETURN;
  END orc_t;
  
  /* An overriding function for get_name. */
  OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
  BEGIN
    RETURN self.name;
  END get_name;
  
  /* A setter function to set the name attribute. */
  MEMBER PROCEDURE set_name
  (
    name VARCHAR2
  ) IS
  BEGIN
    self.name := name;
  END set_name;

  /* A getter function to return the genus attribute. */
  MEMBER FUNCTION get_genus RETURN VARCHAR2 IS
  BEGIN
    RETURN self.genus;
  END get_genus;
  
  /* A setter procedure to set the genus attribute. */
  MEMBER PROCEDURE set_genus
  (
    genus VARCHAR2
  ) IS
  BEGIN
    self.genus := genus;
  END set_genus;
  
  /* An overriding function for to_string. */
  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN (self AS base_t).to_string()||'['||self.name||']['||self.genus||']';
  END to_string;
END;
/

SHOW ERRORS

-- Close log file.
SPOOL OFF

/* Close connection. */
QUIT;
