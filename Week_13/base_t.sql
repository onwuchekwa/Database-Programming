/*
||  Name:          base_t.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 13 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED

--@/home/student/Data/cit325/lib/cleanup_oracle.sql
--@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

DROP TYPE base_t FORCE;

-- Open log file.
SPOOL base_t.txt

-- ... insert your solution here ...
-- =======================================================================
-- A base_t object type and type body in a base_t.sql file, which includes 
-- a QUIT; statement.
-- =======================================================================
CREATE OR REPLACE
  TYPE base_t IS OBJECT
  (
    oid   NUMBER
  , oname VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t
    (
	  oid   NUMBER
	, oname VARCHAR2
	) RETURN SELF AS RESULT
  , MEMBER FUNCTION  get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname(oname VARCHAR2)
  , MEMBER FUNCTION  get_name RETURN VARCHAR2
  , MEMBER FUNCTION  to_string RETURN VARCHAR2
  )
  INSTANTIABLE NOT FINAL;
/

DESC base_t;

-- =======================================================================
-- Implement a base_t type body in a base_t.sql file 
-- =======================================================================
CREATE OR REPLACE
  TYPE BODY base_t IS
  /* Formalized default constructor. */  
  CONSTRUCTOR FUNCTION base_t
  (
	oid   NUMBER
  , oname VARCHAR2 
  )
  RETURN SELF AS RESULT IS  
  BEGIN
    /* Assign inputs to instance variables. */
    self.oid   := oid;
	self.oname := 'BASE_T';
	RETURN;
  END base_t;
  
  /* A getter function to return the oname attribute. */
  MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
  BEGIN
    RETURN self.oname;
  END get_oname;
  
  /* A setter procedure to set the oname attribute. */
  MEMBER PROCEDURE set_oname
  (
    oname VARCHAR2
  ) IS
  BEGIN
    self.oname := oname;
  END set_oname;
  
  /* A getter function. */
  MEMBER FUNCTION get_name RETURN VARCHAR2 IS
  BEGIN
    RETURN NULL;
  END get_name;
  
  /* A to_string conversion function. */
  MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.oid||']';
  END to_string;
END;
/

-- Close log file.
SPOOL OFF

/* Close connection. */
QUIT;
