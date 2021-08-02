-- ======================================================================
--  Name:    object_cleanup.sql
--  Author:  Michael McLaughlin
--  Date:    02-Apr-2020
-- ------------------------------------------------------------------
--  Purpose: Prepare final project environment with sequential
--           program unit to cleanup object type dependents.
-- ======================================================================

/* Open log file. */
SPOOL object_cleanup.txt

/* ========================================
||  Drop types from the most dependent to
||  the least dependent.
|| ========================================
*/

DECLARE
  /* Declare table of strings. */
  TYPE list IS TABLE OF VARCHAR2(30);

  /* Declare a variable of the table type. */
  lv_list  LIST := list('NOLDOR_T','SILVAN_T','SINDAR_T','TELERI_T'
	               ,'ORC_T','MAN_T','MAIA_T','HOBBIT_T'
		       ,'GOBLIN_T','ELF_T','DWARF_T');

  /* Declare a dynamic cursor to check the data dictionary. */
  CURSOR get_object 
  ( cv_object_name  VARCHAR2 ) IS
    SELECT o.object_name
    FROM   user_objects o
    WHERE  o.object_name = cv_object_name
    AND    o.object_type = 'TYPE';
BEGIN
  /* Conditionally drop types. */
  FOR i IN 1..lv_list.COUNT LOOP
    FOR j IN get_object(i) LOOP
      EXECUTE IMMEDIATE 'DROP TYPE '||j.object_name;
    END LOOP;
  END LOOP;
END;
/

/* Drop tolkien table, which is dependent on
   the base_t type. */
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

/* Drop base type after all dependents. */
BEGIN
  FOR i IN (SELECT o.object_name
	    FROM   user_objects o
	    WHERE  o.object_name = 'BASE_T'
            AND    o.object_type = 'TYPE') LOOP
    EXECUTE IMMEDIATE 'DROP TYPE '||i.object_name;
  END LOOP;
END;
/

/* Close log file. */
SPOOL OFF

/* Quit script. */
QUIT
