SET SERVEROUTPUT ON

-- Create a package specification to uses a procedure to list all contacts in the table
CREATE OR REPLACE PACKAGE contact_data AUTHID DEFINER AS
  -- Public procedure to list all contacts
  PROCEDURE list_contacts; 
END contact_data; -- End package specification
/

-- Create a package body
CREATE OR REPLACE PACKAGE BODY contact_data AS
  -- It must have the same procedure define in the specification
  -- Private procedure to list all contacts
  PROCEDURE list_contacts IS
    -- A cursor to get first and last name from the contact table
    CURSOR curr_contacts IS
      SELECT 
        last_name
      , first_name
      FROM contact;
    
	  -- Private variables to hold data gotten from DB and number of iteration
      lv_contact_list curr_contacts%ROWTYPE;
      lv_count NUMBER := 0;
    
    BEGIN
      OPEN curr_contacts;
	  -- Loop through the data in the cursor and pass the values to the variable
      LOOP
        lv_count := lv_count + 1; -- Increment counter by 1
        FETCH curr_contacts INTO lv_contact_list;
        EXIT WHEN curr_contacts%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Contact #' || lv_count); -- Display count
		-- Display surname and first name separated by a comma
        DBMS_OUTPUT.PUT_LINE('Full Name: ' || lv_contact_list.last_name || ', ' || lv_contact_list.first_name);
      END LOOP;
  END list_contacts;
END contact_data;
/

-- Call the package
BEGIN    
   contact_data.list_contacts; 
END; 
/  
