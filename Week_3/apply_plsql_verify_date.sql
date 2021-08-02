-- Open log file.
SPOOL apply_plsql_verify_date.txt

CREATE OR REPLACE
  FUNCTION verify_date
  ( pv_date_in  VARCHAR2) RETURN DATE IS
  /* Local return variable. */
  lv_date  DATE;
BEGIN
  /* Check for a DD-MON-RR or DD-MON-YYYY string. */
  IF REGEXP_LIKE(pv_date_in,'^[0-9]{2,2}-[ADFJMNOS][ACEOPU][BCGLNPRTVY]-([0-9]{2,2}|[0-9]{4,4})$') THEN
    /* Case statement checks for 28 or 29, 30, or 31 day month. */
    CASE
      /* Valid 31 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('JAN','MAR','MAY','JUL','AUG','OCT','DEC') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 31 THEN 
        lv_date := pv_date_in;
      /* Valid 30 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('APR','JUN','SEP','NOV') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 30 THEN 
        lv_date := pv_date_in;
      /* Valid 28 or 29 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) = 'FEB' THEN
        /* Verify 2-digit or 4-digit year. */
        IF (LENGTH(pv_date_in) = 9 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,2)) + 2000,4) = 0 OR
            LENGTH(pv_date_in) = 11 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,4)),4) = 0) AND
            TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 29 THEN
          lv_date := pv_date_in;
        ELSE /* Not a leap year. */
          IF TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 28 THEN
            lv_date := pv_date_in;
          ELSE
            lv_date := null;
          END IF;
        END IF;
      ELSE
        /* Assign a null. */
        lv_date := null;
    END CASE;
  ELSE
    /* Assign a null. */
    lv_date := null;
  END IF;
  /* Return date. */
  RETURN lv_date;
END;
/

/* You can check valid dates with a DD-MON-RR format: */
SELECT verify_date('28-FEB-10') AS "Non-Leap Year"
,      verify_date('29-FEB-12') AS "Leap Year"
,      verify_date('31-MAR-14') AS "31-Day Year"
,      verify_date('30-APR-14') AS "30-Day Year"
FROM   dual;

/* You can check valid dates with a DD-MON-YYYY format: */
SELECT verify_date('28-FEB-2010') AS "Non-Leap Year"
,      verify_date('29-FEB-2012') AS "Leap Year"
,      verify_date('31-MAR-2014') AS "31-Day Year"
,      verify_date('30-APR-2014') AS "30-Day Year"
FROM   dual;

/* You can check badly formatted dates with the following query: */
SELECT verify_date('28-FEB-2010') AS "Non-Leap Year"
,      verify_date('29-FEB-2012') AS "Leap Year"
,      verify_date('31-MAR-2014') AS "31-Day Year"
,      verify_date('30-APR-2014') AS "30-Day Year"
FROM   dual;

-- Close log file.
SPOOL OFF
