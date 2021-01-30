#!/bin/bash
docker cp ~/src/legal-tools/rawData/"$0"-"$1"-"$2"*Daily* mysql8:/media/"$0""$1""$2"-daily.txt
docker exec -it mysql8 bash `mysql --local_infile=1 -h db -u root -proot -D crim_db`
docker exec -it mysql8 bash `mysql -e "use crim_db;" -e "LOAD DATA LOCAL INFILE '/media/"$0""$1""$2"-daily.txt' INTO TABLE cases 
  FIELDS TERMINATED BY '\t' 
  LINES TERMINATED BY '\r' 
  IGNORE 1 LINES
  ( rundate, cdi, cas, @fda, ins, cad, crt, cst, dst, bam, curr_off, curr_off_lit, curr_l_d, nda, cnc, rea, def_nam, def_spn, def_rac, def_sex, def_dob, def_stnum, def_stnam, def_cty, def_st, def_zip, aty_nam, aty_spn, aty_coc, aty_coc_lit, def_birthplace, def_uscitizen)
  set fda = STR_TO_DATE(@fda, '%m%d%y');"`
docker exec -it mysql8 bash `mysql -e "use crim_db;" -e "INSERT INTO mailer(hbk_id, cas, def_spn, def_nam, def_stnum_stnam, def_cty_st_zip, curr_off_lit)
  SELECT
    CONCAT(
      DATE_FORMAT(fda,'%Y%m%d'), MID(cas,5,4)
    ),
    cas,
    def_spn,
    CONCAT(
      MID(
        def_nam,INSTR(def_nam,',') + 1,999
      ),' ',
      MID(
        def_nam,1,INSTR(def_nam,',') -1
      )
    ),
    CONCAT(def_stnum,' ',def_stnam),
    CONCAT(def_cty,', ',def_st,' ',def_zip),
    curr_off_lit
  FROM 
    cases
  WHERE 
    CHAR_LENGTH(def_stnam)>1 
    AND def_stnam NOT LIKE '%HOMELESS%' 
    AND def_stnam NOT LIKE '%TRANSIENT%' 
    AND def_stnam NOT LIKE '%UNK%' 
    AND aty_nam NOT LIKE 'KHAN, HADEE BABAR' 
    AND aty_coc_lit NOT LIKE '%HIRED%' 
    AND cad NOT LIKE '%DISM%' 
    AND (dst='B' OR dst='O' OR dst='N');"`
docker exec -it mysql8 bash `mysql -e "use crim_db;" -e "CREATE TABLE temp
SELECT
 GROUP_CONCAT(hbk_id SEPARATOR '|') AS hbk_id, 
 GROUP_CONCAT(cas SEPARATOR ', ') AS cas, 
 def_spn, 
 GROUP_CONCAT(def_nam SEPARATOR '|') AS def_nam, 
 GROUP_CONCAT(def_stnum_stnam SEPARATOR '|') AS def_stnum_stnam, 
 GROUP_CONCAT(def_cty_st_zip SEPARATOR '|') AS def_cty_st_zip, 
 GROUP_CONCAT(curr_off_lit SEPARATOR ', ') AS curr_off_lit
FROM mailer
GROUP BY def_spn;" -e "TRUNCATE TABLE mailer;" -e "INSERT INTO mailer(hbk_id, cas, def_spn, def_nam, def_stnum_stnam, def_cty_st_zip, curr_off_lit)
SELECT 
 MID(hbk_id, 1, IF(INSTR(hbk_id,'|') > 0, INSTR(hbk_id,'|') - 1, LENGTH(hbk_id))),
 cas, 
 def_spn,
 MID(def_nam, 1, IF(INSTR(def_nam,'|') > 0, INSTR(def_nam,'|') - 1,LENGTH(def_nam))),
 MID(def_stnum_stnam, 1, IF(INSTR(def_stnum_stnam,'|') > 0, INSTR(def_stnum_stnam,'|') - 1, LENGTH(def_stnum_stnam))),
 MID(def_cty_st_zip, 1, IF(INSTR(def_cty_st_zip,'|') > 0, INSTR(def_cty_st_zip,'|') - 1, LENGTH(def_cty_st_zip))),
 curr_off_lit
FROM temp;" -e "DROP TABLE temp;"`