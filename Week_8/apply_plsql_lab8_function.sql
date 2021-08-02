/*
||  Name:          apply_plsql_lab8.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 9 lab.
*/

SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE UNLIMITED

-- Drop and Recreate tables
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- =====================================================================
-- Fix the system_user table
-- =====================================================================
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';

/* 
  The next UPDATE statement should be inserted to ensure your iterative 
  test cases all start at the same point, or common data state
*/
UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';

-- A small anonymous block PL/SQL program lets you fix this mistake
DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;

  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;

  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);

BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

/* 
  The above query should update four rows, and you can verify 
  the update with the following query
*/
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';

-- Open log file.
SPOOL apply_plsql_lab8_function.txt

-- Enter your solution here.

-- =====================================================================
-- You need to insert three new users, as qualified below (manually 
-- enter the system_user_id as numeric literals rather than calling 
-- the system_user_s1 sequence):
-- =====================================================================
INSERT INTO system_user 
(
  system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
(
  6
, 'BONDSB'
, 1
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'DBA')
, 'Barry'
, 'L'
, 'Bonds'
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'SYSTEM_ADMIN')
, SYSDATE
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'SYSTEM_ADMIN')
, SYSDATE
);

INSERT INTO system_user 
(
  system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
(
  7
, 'CURRYW'
, 1
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'DBA')
, 'Wardell'
, 'S'
, 'Curry'
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'SYSTEM_ADMIN')
, SYSDATE
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'SYSTEM_ADMIN')
, SYSDATE
);

INSERT INTO system_user 
(
  system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date
)
VALUES
(
  -1
, 'ANONYMOUS'
, 1
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'DBA')
, ''
, ''
, ''
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'SYSTEM_ADMIN')
, SYSDATE
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'SYSTEM_ADMIN')
, SYSDATE
);

-- You can confirm the inserts with the following query:
COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';

-- =====================================================================
-- The contact_package specification changes as follows when you convert 
-- the overloaded insert_contact procedures to functions:
-- =====================================================================
CREATE OR REPLACE PACKAGE contact_package IS
  FUNCTION insert_contact 
  (
    pv_first_name            VARCHAR2
  , pv_middle_name           VARCHAR2
  , pv_last_name             VARCHAR2
  , pv_contact_type          VARCHAR2
  , pv_account_number        VARCHAR2
  , pv_member_type           VARCHAR2
  , pv_credit_card_number    VARCHAR2
  , pv_credit_card_type      VARCHAR2
  , pv_city                  VARCHAR2
  , pv_state_province        VARCHAR2
  , pv_postal_code           VARCHAR2
  , pv_address_type          VARCHAR2
  , pv_country_code          VARCHAR2
  , pv_area_code             VARCHAR2
  , pv_telephone_number      VARCHAR2
  , pv_telephone_type        VARCHAR2
  , pv_user_name             VARCHAR2
  )
  RETURN NUMBER;
  
  FUNCTION insert_contact
  (
    pv_first_name            VARCHAR2
  , pv_middle_name           VARCHAR2
  , pv_last_name             VARCHAR2
  , pv_contact_type          VARCHAR2
  , pv_account_number        VARCHAR2
  , pv_member_type           VARCHAR2
  , pv_credit_card_number    VARCHAR2
  , pv_credit_card_type      VARCHAR2
  , pv_city                  VARCHAR2
  , pv_state_province        VARCHAR2
  , pv_postal_code           VARCHAR2
  , pv_address_type          VARCHAR2
  , pv_country_code          VARCHAR2
  , pv_area_code             VARCHAR2
  , pv_telephone_number      VARCHAR2
  , pv_telephone_type        VARCHAR2
  , pv_user_id               NUMBER
  )
  RETURN NUMBER;

END contact_package;
/

DESC contact_package;

-- =====================================================================
-- Create a contact_package package body that implements two 
-- insert_contact functions
-- =====================================================================
CREATE OR REPLACE PACKAGE BODY contact_package IS
-- ======================================================
-- First function
-- ======================================================
  FUNCTION insert_contact 
  (
    pv_first_name            VARCHAR2
  , pv_middle_name           VARCHAR2
  , pv_last_name             VARCHAR2
  , pv_contact_type          VARCHAR2
  , pv_account_number        VARCHAR2
  , pv_member_type           VARCHAR2
  , pv_credit_card_number    VARCHAR2
  , pv_credit_card_type      VARCHAR2
  , pv_city                  VARCHAR2
  , pv_state_province        VARCHAR2
  , pv_postal_code           VARCHAR2
  , pv_address_type          VARCHAR2
  , pv_country_code          VARCHAR2
  , pv_area_code             VARCHAR2
  , pv_telephone_number      VARCHAR2
  , pv_telephone_type        VARCHAR2
  , pv_user_name             VARCHAR2
  )
  RETURN NUMBER
  IS
  /*
  Local variables to hold common_lookup_type values, system date,
  and system_user_id
  */

  lv_contact_type     NUMBER;
  lv_member_type      NUMBER;
  lv_credit_card_type NUMBER;
  lv_address_type     NUMBER;
  lv_telephone_type   NUMBER;
  lv_system_date      DATE      := SYSDATE;
  lv_member_id        NUMBER;
  lv_created_by       NUMBER;
  lv_count            NUMBER;
  lv_returned_value   NUMBER    := 0;
  
  /*
  write a SELECT-INTO cursor to retrieve the correct system_user_id 
  since the list of system_user_name values should be 
  unique (the values should be SYSADMIN, DBA 1, DBA 2, DBA 3, or DBA 4)
  */
  CURSOR curr_get_types
  (  
    cv_table_name  VARCHAR2
  , cv_column_name VARCHAR2
  , cv_lookup_type VARCHAR2
  )
  IS
  SELECT 
    common_lookup_id 
  FROM  common_lookup
  WHERE common_lookup_table  =  cv_table_name
    AND common_lookup_column =  cv_column_name
    AND common_lookup_type   =  cv_lookup_type;
	
   /* Return Member */
  CURSOR get_member
  (
	cv_account_number VARCHAR2
  ) 
  IS
  SELECT 
    member_id
  FROM member
  WHERE account_number = cv_account_number;
  
  BEGIN
    FOR i IN curr_get_types('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
      lv_contact_type := i.common_lookup_id;
    END LOOP;
  
  FOR i IN curr_get_types('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
    lv_member_type := i.common_lookup_id;
  END LOOP;
  
  FOR i IN curr_get_types('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
    lv_credit_card_type := i.common_lookup_id;
  END LOOP;
  
  FOR i IN curr_get_types('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
    lv_address_type := i.common_lookup_id;
  END LOOP;
  
  FOR i IN curr_get_types('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
    lv_telephone_type := i.common_lookup_id;
  END LOOP;
  
  /*
    You should use a SELECT-INTO statement to access the system_user_id 
    column of the system_user table 
  */
  SELECT 
    system_user_id
  INTO   lv_created_by
  FROM   system_user
  WHERE  system_user_name = pv_user_name;
  
  -- Create a SAVEPOINT as a starting position.
  SAVEPOINT first_starting_position;
  
  /* Open CURSOR */
  OPEN get_member(pv_account_number);
  FETCH get_member INTO lv_member_id;
  
  /* Inserts for Member Table */
  IF get_member%NOTFOUND THEN
	INSERT INTO member
    (
      member_id
    , member_type
    , account_number
    , credit_card_number
    , credit_card_type
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    )
    VALUES
    (
      member_s1.NEXTVAL
    , lv_member_type
    , pv_account_number
    , pv_credit_card_number
    , lv_credit_card_type
    , lv_created_by
    , lv_system_date
    , lv_created_by
    , lv_system_date
    );
   END IF;
	
	INSERT INTO contact
    (
      contact_id
    , member_id
    , contact_type
    , last_name
    , first_name
    , middle_name
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    )
    VALUES
    (
      contact_s1.NEXTVAL
    , member_s1.CURRVAL
    , lv_contact_type
    , pv_last_name
    , pv_first_name
    , pv_middle_name
    , lv_created_by
    , lv_system_date
    , lv_created_by
    , lv_system_date
    );
  
    INSERT INTO address
    (
      address_id
    , contact_id
    , address_type
    , city
    , state_province
    , postal_code
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    )
    VALUES
    (
      address_s1.NEXTVAL
    , contact_s1.CURRVAL
    , lv_address_type
    , pv_city
    , pv_state_province
    , pv_postal_code
    , lv_created_by
    , lv_system_date
    , lv_created_by
    , lv_system_date
    );
  
    INSERT INTO telephone
    (
      telephone_id
    , contact_id
    , address_id
    , telephone_type
    , country_code
    , area_code
    , telephone_number
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    )
    VALUES
    (
      telephone_s1.NEXTVAL
    , contact_s1.CURRVAL
    , address_s1.CURRVAL
    , lv_telephone_type
    , pv_country_code
    , pv_area_code
    , pv_telephone_number
    , lv_created_by
    , lv_system_date
    , lv_created_by
    , lv_system_date
    );
  
    COMMIT;
	RETURN lv_returned_value;
    EXCEPTION WHEN OTHERS THEN
      ROLLBACK TO first_starting_position;
	  RETURN lv_returned_value + 1;  
  END insert_contact;
  
-- ======================================================
-- Second Function
-- ======================================================  
  FUNCTION insert_contact
  (
    pv_first_name            VARCHAR2
  , pv_middle_name           VARCHAR2
  , pv_last_name             VARCHAR2
  , pv_contact_type          VARCHAR2
  , pv_account_number        VARCHAR2
  , pv_member_type           VARCHAR2
  , pv_credit_card_number    VARCHAR2
  , pv_credit_card_type      VARCHAR2
  , pv_city                  VARCHAR2
  , pv_state_province        VARCHAR2
  , pv_postal_code           VARCHAR2
  , pv_address_type          VARCHAR2
  , pv_country_code          VARCHAR2
  , pv_area_code             VARCHAR2
  , pv_telephone_number      VARCHAR2
  , pv_telephone_type        VARCHAR2
  , pv_user_id               NUMBER
  )
  RETURN NUMBER
  IS
  /*
  Local variables to hold common_lookup_type values, system date,
  and system_user_id
  */

  lv_contact_type     NUMBER;
  lv_member_type      NUMBER;
  lv_credit_card_type NUMBER;
  lv_address_type     NUMBER;
  lv_telephone_type   NUMBER;
  lv_system_date      DATE   := SYSDATE;
  lv_member_id        NUMBER;
  lv_created_by       NUMBER := NVL(pv_user_id, -1);
  lv_returned_value   NUMBER := 0;
  
  /*
  write a SELECT-INTO cursor to retrieve the correct system_user_id 
  since the list of system_user_name values should be 
  unique (the values should be SYSADMIN, DBA 1, DBA 2, DBA 3, or DBA 4)
  */
  CURSOR curr_get_types
  (  
    cv_table_name  VARCHAR2
  , cv_column_name VARCHAR2
  , cv_lookup_type VARCHAR2
  )
  IS
  SELECT 
    common_lookup_id 
  FROM  common_lookup
  WHERE common_lookup_table  =  cv_table_name
    AND common_lookup_column =  cv_column_name
    AND common_lookup_type   =  cv_lookup_type;
	
   /* Return Member */
  CURSOR get_member
  (
	cv_account_number VARCHAR2
  ) 
  IS
  SELECT 
    member_id
  FROM member
  WHERE account_number = cv_account_number;
  
  BEGIN
    FOR i IN curr_get_types('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
      lv_contact_type := i.common_lookup_id;
    END LOOP;
  
  FOR i IN curr_get_types('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
    lv_member_type := i.common_lookup_id;
  END LOOP;
  
  FOR i IN curr_get_types('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
    lv_credit_card_type := i.common_lookup_id;
  END LOOP;
  
  FOR i IN curr_get_types('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
    lv_address_type := i.common_lookup_id;
  END LOOP;
  
  FOR i IN curr_get_types('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
    lv_telephone_type := i.common_lookup_id;
  END LOOP;
  
  /*
    You should use a SELECT-INTO statement to access the system_user_id 
    column of the system_user table 
  */
  SELECT 
    system_user_id
  INTO   lv_created_by
  FROM   system_user
  WHERE  system_user_id = pv_user_id;
  
  -- Create a SAVEPOINT as a starting position.
  SAVEPOINT second_starting_position;
  
  /* Open CURSOR */
  OPEN get_member(pv_account_number);
  FETCH get_member INTO lv_member_id;
  
  /* Inserts for Member Table */
  IF get_member%NOTFOUND THEN
	INSERT INTO member
    (
      member_id
    , member_type
    , account_number
    , credit_card_number
    , credit_card_type
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    )
    VALUES
    (
      member_s1.NEXTVAL
    , lv_member_type
    , pv_account_number
    , pv_credit_card_number
    , lv_credit_card_type
    , lv_created_by
    , lv_system_date
    , lv_created_by
    , lv_system_date
    );
   END IF;
	
	INSERT INTO contact
    (
      contact_id
    , member_id
    , contact_type
    , last_name
    , first_name
    , middle_name
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    )
    VALUES
    (
      contact_s1.NEXTVAL
    , member_s1.CURRVAL
    , lv_contact_type
    , pv_last_name
    , pv_first_name
    , pv_middle_name
    , lv_created_by
    , lv_system_date
    , lv_created_by
    , lv_system_date
    );
  
    INSERT INTO address
    (
      address_id
    , contact_id
    , address_type
    , city
    , state_province
    , postal_code
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    )
    VALUES
    (
      address_s1.NEXTVAL
    , contact_s1.CURRVAL
    , lv_address_type
    , pv_city
    , pv_state_province
    , pv_postal_code
    , lv_created_by
    , lv_system_date
    , lv_created_by
    , lv_system_date
    );
  
    INSERT INTO telephone
    (
      telephone_id
    , contact_id
    , address_id
    , telephone_type
    , country_code
    , area_code
    , telephone_number
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
    )
    VALUES
    (
      telephone_s1.NEXTVAL
    , contact_s1.CURRVAL
    , address_s1.CURRVAL
    , lv_telephone_type
    , pv_country_code
    , pv_area_code
    , pv_telephone_number
    , lv_created_by
    , lv_system_date
    , lv_created_by
    , lv_system_date
    );
  
    COMMIT;
	RETURN lv_returned_value;
    EXCEPTION WHEN OTHERS THEN
      ROLLBACK TO second_starting_position;
	  RETURN lv_returned_value + 1;  
  END insert_contact;
END contact_package;
/

-- ==================================================================
-- The insert_contact function requires a formal parameter list. 
-- The function should include all the values that you need to 
-- insert or discover to insert into the member, contact, address, 
-- and telephone tables. 
-- ==================================================================
BEGIN
  IF contact_package.insert_contact 
  (
    pv_first_name            =>  'Shirley'
  , pv_middle_name           =>  NULL
  , pv_last_name             =>  'Partridge'
  , pv_contact_type          =>  'CUSTOMER'
  , pv_account_number        =>  'SLC-000012'
  , pv_member_type           =>  'GROUP'
  , pv_credit_card_number    =>  '8888-6666-8888-4444'
  , pv_credit_card_type      =>  'VISA_CARD'
  , pv_city                  =>  'Lehi'
  , pv_state_province        =>  'Utah'
  , pv_postal_code           =>  '84043'
  , pv_address_type          =>  'HOME'
  , pv_country_code          =>  '001'
  , pv_area_code             =>  '207'
  , pv_telephone_number      =>  '877-4321'
  , pv_telephone_type        =>  'HOME'
  , pv_user_name             =>  'DBA 3'
  ) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Contact inserted');
  END IF;
  
  IF contact_package.insert_contact 
  (
    pv_first_name            =>  'Keith'
  , pv_middle_name           =>  NULL
  , pv_last_name             =>  'Partridge'
  , pv_contact_type          =>  'CUSTOMER'
  , pv_account_number        =>  'SLC-000012'
  , pv_member_type           =>  'GROUP'
  , pv_credit_card_number    =>  '8888-6666-8888-4444'
  , pv_credit_card_type      =>  'VISA_CARD'
  , pv_city                  =>  'Lehi'
  , pv_state_province        =>  'Utah'
  , pv_postal_code           =>  '84043'
  , pv_address_type          =>  'HOME'
  , pv_country_code          =>  '001'
  , pv_area_code             =>  '207'
  , pv_telephone_number      =>  '877-4321'
  , pv_telephone_type        =>  'HOME'
  , pv_user_id               =>  6
  ) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Contact inserted');
  END IF;
  
  IF contact_package.insert_contact
  (
    pv_first_name            =>  'Laurie'
  , pv_middle_name           =>  NULL
  , pv_last_name             =>  'Partridge'
  , pv_contact_type          =>  'CUSTOMER'
  , pv_account_number        =>  'SLC-000012'
  , pv_member_type           =>  'GROUP'
  , pv_credit_card_number    =>  '8888-6666-8888-4444'
  , pv_credit_card_type      =>  'VISA_CARD'
  , pv_city                  =>  'Lehi'
  , pv_state_province        =>  'Utah'
  , pv_postal_code           =>  '84043'
  , pv_address_type          =>  'HOME'
  , pv_country_code          =>  '001'
  , pv_area_code             =>  '207'
  , pv_telephone_number      =>  '877-4321'
  , pv_telephone_type        =>  'HOME'
  , pv_user_id               =>  -1
  ) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Contact inserted');
  END IF;
END;
/

-- ==================================================================
-- After you call the overloaded insert_contact functions three 
-- times, you should be able to run the following verification query 
-- ==================================================================
COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';

-- Close log file.
SPOOL OFF
