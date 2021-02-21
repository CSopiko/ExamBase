-------------------------------TRIGGERS-------------------------------                           
CREATE OR REPLACE TRIGGER t_students_log
  BEFORE UPDATE
  ON students
  FOR EACH ROW
BEGIN
  validations.check_change_time;
  INSERT INTO students_log
         VALUES(:OLD.id, 
                :OLD.first_name, 
                :OLD.last_name, 
                :OLD.pin, 
                :OLD.email);                   
END;
/
-------------------------------SEQUENCES------------------------------

CREATE SEQUENCE reg_st_id_seq
                START WITH 1
                INCREMENT BY 1
                NOCYCLE
                NOCACHE;
/  
CREATE SEQUENCE st_sub_id_seq
                START WITH 1
                INCREMENT BY 1
                NOCYCLE
                NOCACHE;
/
CREATE SEQUENCE st_fac_id_seq
                START WITH 1
                INCREMENT BY 1
                NOCYCLE
                NOCACHE;
/
CREATE SEQUENCE st_center_id_seq
                START WITH 1
                INCREMENT BY 1
                NOCYCLE
                NOCACHE;
/                 

CREATE SEQUENCE ex_rooms_id_seq
                START WITH 1
                INCREMENT BY 1
                NOCYCLE
                NOCACHE;
/

CREATE SEQUENCE st_room_id_seq
                START WITH 1
                INCREMENT BY 1
                NOCYCLE
                NOCACHE;
/                 
CREATE SEQUENCE exam_cards_idseq
                START WITH 1
                INCREMENT BY 1
                NOCYCLE
                NOCACHE;
/ 
CREATE SEQUENCE scores_idseq
                START WITH 1
                INCREMENT BY 1
                NOCYCLE
                NOCACHE;
/
--------------------VIEWS--------------------------
--University RATING
CREATE OR REPLACE VIEW university_rating
AS SELECT u.uni_name, COUNT(*) AS RATING
   FROM stud_fac fs
   LEFT JOIN faculties f
   ON  fs.fac_id = f.id
   LEFT JOIN universities u
   ON  f.uni_id = u.id
   GROUP BY uni_name
   ORDER BY COUNT(*) DESC;
      
--Average percentage score

CREATE VIEW students_results
AS SELECT s.first_name, s.last_name, s.pin, sub.sub_name, sc.score
   FROM scores sc JOIN subjects sub
   ON (sc.sub_id = sub.id)
   JOIN students s
   ON (sc.st_id = s.id)
   ORDER BY (SELECT AVG(score)
            FROM scores scr
            WHERE scr.st_id = sc.st_id) DESC, sub.sub_name ASC;

            
/*
DROP VIEW  students_results;
DROP VIEW  university_rating;

DROP SEQUENCE reg_st_id_seq;                      
DROP SEQUENCE st_sub_id_seq;
DROP SEQUENCE st_fac_id_seq;
DROP SEQUENCE st_center_id_seq;
DROP SEQUENCE ex_rooms_id_seq;
DROP SEQUENCE st_room_id_seq;
DROP SEQUENCE exam_cards_idseq;
DROP SEQUENCE scores_idseq;
*/
            
