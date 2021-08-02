SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
SET DEFINE ON

DROP TABLE friends_list;
DROP SEQUENCE friends_list_s1;

SPOOL apply_plsql_age.txt

-- ============================================================
-- Create a table to hold friends. 
-- ============================================================
CREATE TABLE friends_list
(
  id               NUMBER PRIMARY KEY
, name       VARCHAR2(60) NOT NULL
, address   VARCHAR2(100) NOT NULL
, age              NUMBER NOT NULL
);

-- ============================================================
-- Create a table sequence to be used as ID 
-- ============================================================
CREATE SEQUENCE friends_list_s1
  INCREMENT BY 1
  START WITH 1001;

-- ============================================================
-- Insert initial record to be used to test the update trigger 
-- ============================================================
INSERT INTO friends_list VALUES
(
  friends_list_s1.NEXTVAL
, 'Samuel Austin'
, 'Cleveland, Ohio'
, 15
);

-- ======================================================================
-- Create a trigger to check if one qualify to be my friend based on age
-- ======================================================================
CREATE OR REPLACE TRIGGER friends_list_trg 
    BEFORE INSERT OR UPDATE OF age
    ON friends_list
    FOR EACH ROW
    WHEN (NEW.age > 0)
DECLARE
  lv_age_difference NUMBER := 0;
BEGIN
    -- check the age of the friend
	IF INSERTING THEN
      IF :NEW.age >= 25 THEN
        raise_application_error(-20101, :NEW.name || '''s age of ' || :NEW.age || ' is greater or equals to the minimum age required to be accepted as a friend');
      END IF;
	ELSIF UPDATING THEN
	  IF :NEW.age >= 25 THEN
	    lv_age_difference := :NEW.age - :OLD.age;
	    DELETE FROM friends_list WHERE id = :OLD.id;
		DBMS_OUTPUT.PUT_LINE('Since your new age of ' || :NEW.age || ' is greater than your previous age of ' || :OLD.age || ' by ' || lv_age_difference || ', we are no longer friends');
	  ELSIF :NEW.age <= :OLD.age THEN
	    raise_application_error(-20101, :NEW.name || '''s age of ' || :NEW.age || ' cannot be less than or equals to the current age of ' || :OLD.age);
	  END IF;
	END IF;
END;
/

-- ============================================================
-- Test inserting someone with age greater than or equals to 25 
-- ============================================================
INSERT INTO friends_list VALUES
(
  friends_list_s1.NEXTVAL
, 'Ferdinand Arthur'
, 'Salt Lake City, Utah'
, 30
);

-- ============================================================
-- Test updating an age to be less than the original value 
-- ============================================================

UPDATE friends_list
SET age = 10
WHERE id = 1001;

SPOOL OFF
