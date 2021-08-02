/*
||  Name:          apply_plsql_lab9.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 10 lab.
*/

-- Call seeding libraries from within the following file.
--@$CIT325/lab9/apply_prep_lab9.sql
SET ECHO ON
SET FEEDBACK ON
SET PAGESIZE 49999
SET SERVEROUTPUT ON SIZE 1000000

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- ================================================================
-- Verify the integrity of the avenger.csv file by displaying the 
-- contents of the file
-- ================================================================
cat /u01/app/oracle/upload/textfile/avenger.csv

-- Open log file.
SPOOL apply_plsql_lab9.txt

-- ... insert your solution here ...

-- ================================================================
-- Create the avenger external table
-- ================================================================
CREATE TABLE avenger
( avenger_id      NUMBER
, first_name      VARCHAR2(20)
, last_name       VARCHAR2(20)
, character_name  VARCHAR2(20))
 ORGANIZATION EXTERNAL
 ( TYPE oracle_loader
   DEFAULT DIRECTORY uploadtext
   ACCESS PARAMETERS
   ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
     BADFILE     'UPLOADTEXT':'avenger.bad'
     DISCARDFILE 'UPLOADTEXT':'avenger.dis'
     LOGFILE     'UPLOADTEXT':'avenger.log'
     FIELDS TERMINATED BY ','
     OPTIONALLY ENCLOSED BY "'"
     MISSING FIELD VALUES ARE NULL )
   LOCATION ('avenger.csv'))
REJECT LIMIT 0;

-- ================================================================
-- Verify that the table works with the following query
-- ================================================================
SELECT * FROM avenger;

-- ================================================================
-- Create the file_list external table using a preprocessing clause
-- ================================================================
CREATE TABLE file_list
( file_name VARCHAR2(60))
ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY uploadtext
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      PREPROCESSOR uploadtext:'dir_list.sh'
      BADFILE     'UPLOADTEXT':'dir_list.bad'
      DISCARDFILE 'UPLOADTEXT':'dir_list.dis'
      LOGFILE     'UPLOADTEXT':'dir_list.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL)
    LOCATION ('dir_list.sh'))
  REJECT LIMIT UNLIMITED;
  
-- Describe the file_list table
DESC file_list;

-- ================================================================
-- Verify the file_list external table resolves to the results of the 
-- physical dir_list.sh script file
-- ================================================================
SELECT * FROM file_list;

-- ================================================================
-- creates the load_clob_from_file procedure.
-- ================================================================
CREATE OR REPLACE PROCEDURE load_clob_from_file
( src_file_name     IN VARCHAR2
, table_name        IN VARCHAR2
, column_name       IN VARCHAR2
, primary_key_name  IN VARCHAR2
, primary_key_value IN VARCHAR2 ) IS

  -- Define local variables for DBMS_LOB.LOADCLOBFROMFILE procedure.
  des_clob   CLOB;
  src_clob   BFILE := BFILENAME('UPLOADTEXT',src_file_name);
  des_offset NUMBER := 1;
  src_offset NUMBER := 1;
  ctx_lang   NUMBER := dbms_lob.default_lang_ctx;
  warning    NUMBER;

  -- Define a pre-reading size.
  src_clob_size NUMBER;

  -- Define local variable for Native Dynamic SQL.
  stmt VARCHAR2(2000);

BEGIN

  -- Opening source file is a mandatory operation.
  IF dbms_lob.fileexists(src_clob) = 1 AND NOT dbms_lob.isopen(src_clob) = 1 THEN
    src_clob_size := dbms_lob.getlength(src_clob);
    dbms_lob.OPEN(src_clob,DBMS_LOB.LOB_READONLY);
  END IF;

  -- Assign dynamic string to statement.
  stmt := 'UPDATE '||table_name||' '
       || 'SET    '||column_name||' = empty_clob() '
       || 'WHERE  '||primary_key_name||' = '||''''||primary_key_value||''' '
       || 'RETURNING '||column_name||' INTO :locator';

  -- Run dynamic statement.
  EXECUTE IMMEDIATE stmt USING OUT des_clob;

  -- Read and write file to CLOB, close source file and commit.
  dbms_lob.loadclobfromfile( dest_lob     => des_clob
                           , src_bfile    => src_clob
                           , amount       => dbms_lob.getlength(src_clob)
                           , dest_offset  => des_offset
                           , src_offset   => src_offset
                           , bfile_csid   => dbms_lob.default_csid
                           , lang_context => ctx_lang
                           , warning      => warning );

  -- Close open source file.
  dbms_lob.CLOSE(src_clob);

  -- Commit write and conditionally acknowledge it.
  IF src_clob_size = dbms_lob.getlength(des_clob) THEN
    $IF $$DEBUG = 1 $THEN
      dbms_output.put_line('Success!');
    $END
    COMMIT;
  ELSE
    $IF $$DEBUG = 1 $THEN
      dbms_output.put_line('Failure.');
    $END
    RAISE dbms_lob.operation_failed;
  END IF;

END load_clob_from_file;
/

-- Describe the file_list table
DESC load_clob_from_file;

-- ================================================================
-- Verify that the load_clob_from_file procedure works correctly 
-- in the following anonymous PL/SQL block, which you deploy in the 
-- student user schema. 
-- ================================================================
DECLARE
 /* Declare a cursor to find a single row from the item table. */
 CURSOR c IS
   SELECT i.item_id
   ,      i.item_title
   FROM   item i INNER JOIN common_lookup cl
   ON     i.item_type = cl.common_lookup_id
   WHERE  UPPER(i.item_title) LIKE '%GOBLET%'
   AND    UPPER(cl.common_lookup_meaning) = 'DVD: WIDE SCREEN';
BEGIN
  /* Read the cursor and load one large text file to the row. */
  FOR i IN c LOOP
    load_clob_from_file( src_file_name     => 'HarryPotter4.txt'
                       , table_name        => 'ITEM'
                       , column_name       => 'ITEM_DESC'
                       , primary_key_name  => 'ITEM_ID'
                       , primary_key_value => TO_CHAR(i.item_id) );
  END LOOP;
END;
/

-- ================================================================
-- Use the following query to verify the success of the 
-- anonymous PL/SQL block
-- ================================================================
SELECT i.item_id
,      i.item_title
,      LENGTH(i.item_desc)
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  UPPER(i.item_title) LIKE '%GOBLET%'
AND    UPPER(cl.common_lookup_meaning) = 'DVD: WIDE SCREEN';

-- ================================================================
-- Fix the item_title column for those rows with the following 
-- UPDATE statement:
-- ================================================================
UPDATE item i
SET    i.item_title = 'Harry Potter and the Sorcerer''s Stone'
WHERE  i.item_title = 'Harry Potter and the Sorcer''s Stone';

-- ================================================================
-- Add a text_file_name column as a VARCHAR2(30) to the item table.
-- ================================================================
ALTER TABLE item
ADD text_file_name VARCHAR2(30);

-- ================================================================
-- Verify the list of distinct item_table values that are DVD or VHS 
-- tables with the following query
-- ================================================================
COL text_file_name  FORMAT A16
COL item_title      FORMAT A42
SELECT   DISTINCT
         text_file_name
,        item_title
FROM     item i INNER JOIN common_lookup cl
ON       i.item_type = cl.common_lookup_id
WHERE    REGEXP_LIKE(i.item_title,'^.*'||'Harry'||'.*$')
AND      cl.common_lookup_table = 'ITEM'
AND      cl.common_lookup_column = 'ITEM_TYPE'
AND      REGEXP_LIKE(cl.common_lookup_type,'^(dvd|vhs).*$','i')
ORDER BY i.item_title;

-- ================================================================
-- UPDATE the text_file_name column values by adding the file name 
-- value would match values in the text_file_name column following
-- ================================================================
UPDATE  item i
SET     i.text_file_name = 'HarryPotter1.txt'
WHERE   i.item_title = 'Harry Potter and the Sorcerer''s Stone';

UPDATE  item i
SET     i.text_file_name = 'HarryPotter2.txt'
WHERE   i.item_title = 'Harry Potter and the Chamber of Secrets';

UPDATE  item i
SET     i.text_file_name = 'HarryPotter3.txt'
WHERE   i.item_title = 'Harry Potter and the Prisoner of Azkaban';

UPDATE  item i
SET     i.text_file_name = 'HarryPotter4.txt'
WHERE   i.item_title = 'Harry Potter and the Goblet of Fire';

UPDATE  item i
SET     i.text_file_name = 'HarryPotter5.txt'
WHERE   i.item_title = 'Harry Potter and the Order of the Phoenix';

-- ================================================================
-- Verify the list of distinct text_file_name and item_table 
-- column values that are DVD or VHS tables with the following query
-- ================================================================
COL text_file_name  FORMAT A16
COL item_title      FORMAT A42
SELECT   DISTINCT
         text_file_name
,        item_title
FROM     item i INNER JOIN common_lookup cl
ON       i.item_type = cl.common_lookup_id
WHERE    REGEXP_LIKE(i.item_title,'^.*'||'Harry'||'.*$')
AND      cl.common_lookup_table = 'ITEM'
AND      cl.common_lookup_column = 'ITEM_TYPE'
AND      REGEXP_LIKE(cl.common_lookup_type,'^(dvd|vhs).*$','i')
ORDER BY i.text_file_name;

-- ================================================================
-- Write an update_item_description procedure to upload file names 
-- that match a partial item_title value. The update_item_description 
-- procedure should take one pv_item_title parameter and update all 
-- item_desc column values with the contents of files with matching 
-- file names
-- ================================================================
CREATE OR REPLACE PROCEDURE update_item_description
( pv_item_title VARCHAR2 ) IS

/* Translate partial title to item ID */
  CURSOR c
  ( cv_item_title VARCHAR2 ) IS
    SELECT 
	  item_id
	, text_file_name
    FROM   item i INNER JOIN file_list fl
	  ON i.text_file_name = fl.file_name
    WHERE  REGEXP_LIKE(i.item_title,'^.*'||cv_item_title||'.*$')
    AND    item_type IN
     (SELECT common_lookup_id
      FROM   common_lookup
      WHERE  common_lookup_table = 'ITEM'
      AND    common_lookup_column = 'ITEM_TYPE'
      AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs).*$','i'));
BEGIN
  FOR i IN c (pv_item_title) LOOP
    DBMS_OUTPUT.PUT_LINE('['||i.item_id||']['||i.text_file_name||']');
    load_clob_from_file(
        src_file_name     => i.text_file_name
      , table_name        => 'ITEM'
      , column_name       => 'ITEM_DESC'
      , primary_key_name  => 'ITEM_ID'
      , primary_key_value => i.item_id );
  END LOOP;
END;
/

-- ================================================================
-- Test the update_item_description procedure with the following command
-- ================================================================
EXECUTE update_item_description('Harry Potter');

-- ================================================================
-- Use the following to test the success of the upload:
-- ================================================================
COL item_id     FORMAT 9999
COL item_title  FORMAT A44
COL text_size   FORMAT 999,999
SET PAGESIZE 99
SELECT   item_id
,        item_title
,        LENGTH(item_desc) AS text_size
FROM     item
WHERE    REGEXP_LIKE(item_title,'^Harry Potter.*$')
AND      item_type IN
        (SELECT common_lookup_id
        FROM   common_lookup
        WHERE  common_lookup_table = 'ITEM'
        AND    common_lookup_column = 'ITEM_TYPE'
        AND    REGEXP_LIKE(common_lookup_type,'^(dvd|vhs).*$','i'))
ORDER BY item_id;

-- Close log file.
SPOOL OFF

