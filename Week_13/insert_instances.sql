/*
||  Name:          insert_instances.sql
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
SPOOL insert_instances.txt

-- ... insert your solution here ...

-- ========================================================================
-- An insert_instances.sql file that inserts 21 object type instances
-- ========================================================================
CREATE OR REPLACE 
  PROCEDURE insert_man
  (
    pv_oid   NUMBER
  , pv_oname VARCHAR2
  , pv_name  VARCHAR2
  , pv_genus VARCHAR2
  ) IS
  
  lv_man man_t := man_t
  (
    oid   => pv_oid
  , oname => pv_oname
  , name  => pv_name
  , genus => pv_genus
  );
  
  BEGIN
    INSERT INTO tolkien (tolkien_id, tolkien_character)
	  VALUES (tolkien_s.NEXTVAL, lv_man);
	COMMIT;
  END;
/

CREATE OR REPLACE 
  PROCEDURE insert_hobbit
  (
    pv_oid   NUMBER
  , pv_oname VARCHAR2
  , pv_name  VARCHAR2
  , pv_genus VARCHAR2
  ) IS
  
  lv_hobbit hobbit_t := hobbit_t
  (
    oid   => pv_oid
  , oname => pv_oname
  , name  => pv_name
  , genus => pv_genus
  );
  
  BEGIN
    INSERT INTO tolkien (tolkien_id, tolkien_character)
	  VALUES (tolkien_s.NEXTVAL, lv_hobbit);
	COMMIT;
  END;
/

CREATE OR REPLACE 
  PROCEDURE insert_dwarf
  (
    pv_oid   NUMBER
  , pv_oname VARCHAR2
  , pv_name  VARCHAR2
  , pv_genus VARCHAR2
  ) IS
  
  lv_dwarf dwarf_t := dwarf_t
  (
    oid   => pv_oid
  , oname => pv_oname
  , name  => pv_name
  , genus => pv_genus
  );
  
  BEGIN
    INSERT INTO tolkien (tolkien_id, tolkien_character)
	  VALUES (tolkien_s.NEXTVAL, lv_dwarf);
	COMMIT;
  END;
/


CREATE OR REPLACE 
  PROCEDURE insert_elf
  (
    pv_oid     NUMBER
  , pv_oname   VARCHAR2
  , pv_name    VARCHAR2
  , pv_genus   VARCHAR2
  , pv_elfkind VARCHAR2
  ) IS
  
  lv_noldor noldor_t;
  lv_silvan silvan_t;
  lv_sindar sindar_t;
  lv_teleri teleri_t; 
  
  lv_tolkien_seq NUMBER := tolkien_s.NEXTVAL;
  lv_elfkind     elf_t;
  
  BEGIN
    IF pv_elfkind = 'Noldor' THEN
	  lv_noldor := noldor_t
	  (
	    oid     => pv_oid
	  , oname   => pv_oname
	  , name    => pv_name
	  , genus   => pv_genus
	  , elfkind => pv_elfkind
	  );
	  lv_elfkind := lv_noldor;
	ELSIF pv_elfkind = 'Silvan' THEN 
	  lv_silvan := silvan_t
	  (
	    oid     => pv_oid
	  , oname   => pv_oname
	  , name    => pv_name
	  , genus   => pv_genus
	  , elfkind => pv_elfkind
	  );
	  lv_elfkind := lv_silvan;
	ELSIF pv_elfkind = 'Sindar' THEN 
	  lv_sindar := sindar_t
	  (
	    oid     => pv_oid
	  , oname   => pv_oname
	  , name    => pv_name
	  , genus   => pv_genus
	  , elfkind => pv_elfkind
	  );
	  lv_elfkind := lv_sindar;
	ELSIF pv_elfkind = 'Teleri' THEN 
	  lv_teleri := teleri_t
	  (
	    oid     => pv_oid
	  , oname   => pv_oname
	  , name    => pv_name
	  , genus   => pv_genus
	  , elfkind => pv_elfkind
	  );
	  lv_elfkind := lv_teleri;
	END IF;
  
    INSERT INTO tolkien (tolkien_id, tolkien_character)
	  VALUES (lv_tolkien_seq, lv_elfkind);
	COMMIT;
  END;
/

CREATE OR REPLACE 
  PROCEDURE insert_orc
  (
    pv_oid   NUMBER
  , pv_oname VARCHAR2
  , pv_name  VARCHAR2
  , pv_genus VARCHAR2
  ) IS
  
  lv_orc orc_t := orc_t
  (
    oid   => pv_oid
  , oname => pv_oname
  , name  => pv_name
  , genus => pv_genus
  );
  
  BEGIN
    INSERT INTO tolkien (tolkien_id, tolkien_character)
	  VALUES (tolkien_s.NEXTVAL, lv_orc);
	COMMIT;
  END;
/

CREATE OR REPLACE 
  PROCEDURE insert_maia
  (
    pv_oid   NUMBER
  , pv_oname VARCHAR2
  , pv_name  VARCHAR2
  , pv_genus VARCHAR2
  ) IS
  
  lv_maia maia_t := maia_t
  (
    oid   => pv_oid
  , oname => pv_oname
  , name  => pv_name
  , genus => pv_genus
  );
  
  BEGIN
    INSERT INTO tolkien (tolkien_id, tolkien_character)
	  VALUES (tolkien_s.NEXTVAL, lv_maia);
	COMMIT;
  END;
/

CREATE OR REPLACE 
  PROCEDURE insert_goblin
  (
    pv_oid   NUMBER
  , pv_oname VARCHAR2
  , pv_name  VARCHAR2
  , pv_genus VARCHAR2
  ) IS
  
  lv_goblin goblin_t := goblin_t
  (
    oid   => pv_oid
  , oname => pv_oname
  , name  => pv_name
  , genus => pv_genus
  );
  
  BEGIN
    INSERT INTO tolkien (tolkien_id, tolkien_character)
	  VALUES (tolkien_s.NEXTVAL, lv_goblin);
	COMMIT;
  END;
/

BEGIN
  insert_man(1, 'Man', 'Boromir', 'Men');
  insert_man(2, 'Man', 'Faramir', 'Men');
  insert_hobbit(3, 'Hobbit', 'Bilbo', 'Hobbits');
  insert_hobbit(4, 'Hobbit', 'Frodo', 'Hobbits');
  insert_hobbit(5, 'Hobbit', 'Merry', 'Hobbits');
  insert_hobbit(6, 'Hobbit', 'Pippin', 'Hobbits');
  insert_hobbit(7, 'Hobbit', 'Samwise', 'Hobbits');
  insert_dwarf(8, 'Dwarf', 'Gimli', 'Dwarves');
  insert_elf(9, 'Elf', 'Feanor', 'Elves', 'Noldor');
  insert_elf(10, 'Elf', 'Tauriel', 'Elves', 'Silvan');
  insert_elf(11, 'Elf', 'Earwen', 'Elves', 'Teleri');
  insert_elf(12, 'Elf', 'Celeborn', 'Elves', 'Teleri');
  insert_elf(13, 'Elf', 'Thranduil', 'Elves', 'Sindar');
  insert_elf(14, 'Elf', 'Legolas', 'Elves', 'Sindar');
  insert_orc(15, 'Orc', 'Azog the Defiler', 'Orcs');
  insert_orc(16, 'Orc', 'Bolg', 'Orcs');
  insert_maia(17, 'Maia', 'Gandalf the Grey', 'Maiar');
  insert_maia(18, 'Maia', 'Radagast the Brown', 'Maiar');
  insert_maia(19, 'Maia', 'Saruman the White', 'Maiar');
  insert_goblin(20, 'Goblin', 'The Great Goblin', 'Goblins');
  insert_man(21, 'Man', 'Aragorn', 'Men');
END;
/

/* Close log file. */
SPOOL OFF

/* Close connection. */
QUIT;
