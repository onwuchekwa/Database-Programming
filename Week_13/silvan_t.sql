/*
||  Name:          silvan_t.sql
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
SPOOL silvan_t.txt

-- ... insert your solution here ...

-- ========================================================================
-- A silvan_t object type and type body as a subtype of the elf_t 
-- object type, and a QUIT; statement in a silvan_t.sql file..
-- ========================================================================
CREATE OR REPLACE
  TYPE silvan_t UNDER elf_t
  (
    elfkind VARCHAR2(30)
  , CONSTRUCTOR FUNCTION silvan_t
    (
	  oid     NUMBER
	, oname   VARCHAR2
	, name    VARCHAR2
	, genus   VARCHAR2
	, elfkind VARCHAR2
	) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , OVERRIDING MEMBER PROCEDURE set_name (name VARCHAR2)
  , OVERRIDING MEMBER FUNCTION get_genus RETURN VARCHAR2
  , OVERRIDING MEMBER PROCEDURE set_genus (genus VARCHAR2)
  , MEMBER FUNCTION get_elfkind RETURN VARCHAR2
  , MEMBER PROCEDURE set_elfkind (elfkind VARCHAR2)
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2
  )
  INSTANTIABLE NOT FINAL;
/

DESC silvan_t

-- =======================================================================
-- Implement a silvan_t type body in a silvan_t.sql file 
-- =======================================================================
CREATE OR REPLACE
  TYPE BODY silvan_t IS
  /* Formalized default constructor. */ 
  CONSTRUCTOR FUNCTION silvan_t
  (
    oid     NUMBER
  , oname   VARCHAR2
  , name    VARCHAR2
  , genus   VARCHAR2
  , elfkind VARCHAR2
  ) RETURN SELF AS RESULT IS
  BEGIN
    /* Assign inputs to instance variables. */
    self.oid     := oid;
	self.oname   := oname;
    self.name    := name;
	self.genus   := genus;
	self.elfkind := elfkind;
	RETURN;
  END silvan_t;
  
  /* An overriding function for get_name. */
  OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
  BEGIN
    RETURN self.name;
  END get_name;
  
  /* A setter function to set the name attribute. */
  OVERRIDING MEMBER PROCEDURE set_name
  (
    name VARCHAR2
  ) IS
  BEGIN
    self.name := name;
  END set_name;

  /* A getter function to return the genus attribute. */
  OVERRIDING MEMBER FUNCTION get_genus RETURN VARCHAR2 IS
  BEGIN
    RETURN self.genus;
  END get_genus;
  
  /* A setter procedure to set the genus attribute. */
  OVERRIDING MEMBER PROCEDURE set_genus
  (
    genus VARCHAR2
  ) IS
  BEGIN
    self.genus := genus;
  END set_genus;
  
  /* A getter function to return the elfkind attribute. */
  MEMBER FUNCTION get_elfkind RETURN VARCHAR2 IS
  BEGIN
    RETURN self.elfkind;
  END get_elfkind;
  
  /* A setter procedure to set the genus attribute. */
  MEMBER PROCEDURE set_elfkind
  (
    elfkind VARCHAR2
  ) IS
  BEGIN
    self.elfkind := elfkind;
  END set_elfkind;
  
  /* An overriding function for to_string. */
  OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
  BEGIN
    RETURN (self AS elf_t).to_string()||'['||self.elfkind||']';
  END to_string;
END;
/

-- Close log file.
SPOOL OFF

/* Close connection. */
QUIT;
