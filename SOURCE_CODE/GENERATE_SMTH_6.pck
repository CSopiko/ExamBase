create or replace package GENERATE_SMTH is

  -- Purpose : Procedures in this package take part in exam environment generation/simulation
  
  PROCEDURE generate_exam_cards;
  PROCEDURE generate_scores;
  PROCEDURE generate_exam_rooms;

end GENERATE_SMTH;
/
create or replace package body GENERATE_SMTH is

 PROCEDURE generate_exam_cards IS
    v_id              students.id%TYPE;
    v_prev_id         students.id%TYPE := -1;
    v_pin             students.pin%TYPE;
    v_fn              students.first_name%TYPE;
    v_ln              students.last_name%TYPE;
    v_center_add      exam_center.center_address%TYPE;
    v_subid           subjects.id%TYPE;
    v_subname         subjects.sub_name%TYPE;
    v_examd           constant_dates.day_of_exam%TYPE;
    v_exroom          exam_rooms.id%TYPE;
    v_curr_cardno     NUMBER := 0;
    CURSOR c_exam_cards_set IS
      SELECT s.id, s.pin, s.first_name, s.last_name, exc.center_address, 
             sub.id, sub.sub_name, consd.day_of_exam , stexr.room_id
      FROM students s
      LEFT JOIN stud_center stc
      ON   s.id = stc.st_id
      LEFT JOIN exam_center exc
      ON   stc.center_id = exc.id
      JOIN stud_subj sts
      ON   s.id = sts.st_id
      JOIN subjects sub
      ON   sts.sub_id = sub.id
      JOIN constant_dates consd
      ON   sub.id = consd.sub_id
      JOIN 
      (SELECT * FROM stud_room str JOIN exam_rooms exr
      ON str.room_id = exr.id) stexr
      ON stexr.st_id = s.id AND stexr.sub_id = sts.sub_id
      ORDER BY s.id;
  BEGIN

    OPEN c_exam_cards_set;
    LOOP
      FETCH c_exam_cards_set 
            INTO v_id, v_pin, v_fn, v_ln, v_center_add, v_subid, v_subname, v_examd, v_exroom;
      EXIT WHEN c_exam_cards_set%NOTFOUND;
      IF NOT (v_prev_id = v_id) THEN 
        v_curr_cardno := exam_cards_idseq.nextval;
      END IF;
      v_prev_id := v_id;
      INSERT INTO exam_cards
             VALUES(v_curr_cardno, v_id, v_pin, v_fn, v_ln, v_center_add, 
                                   v_subid, v_subname, v_examd, v_exroom );        
    END LOOP;  
    CLOSE c_exam_cards_set;  
  END generate_exam_cards;    
--------------------------
   PROCEDURE generate_scores IS
    v_score_id     scores.id%TYPE;     
    v_st           students.id%TYPE;
    v_sub          subjects.id%TYPE;
    v_score        scores.score%TYPE := 0;
    CURSOR c_scores IS
      SELECT s.id, stsb.sub_id 
      FROM students s
      JOIN stud_subj stsb
      ON   s.id = stsb.st_id
      ORDER BY s.id;    
  BEGIN
    OPEN c_scores;
    LOOP
      FETCH c_scores INTO v_st, v_sub;
      EXIT WHEN c_scores%NOTFOUND;
      v_score := dbms_random.value(1, 100);
      v_score_id := scores_idseq.nextval;
      INSERT INTO scores
             VALUES(v_score_id, v_st, v_sub, v_score);
    END LOOP;   
  END;                  

-------------------------
 PROCEDURE generate_exam_rooms IS
    CURSOR c_examination_rooms IS
      SELECT stc.center_id,  sts.sub_id, COUNT(*)
      FROM stud_center stc
      INNER JOIN stud_subj sts
      ON stc.st_id = sts.st_id
      GROUP BY stc.center_id, sts.sub_id
    ORDER BY stc.center_id;
    
    v_c_center_id             NUMBER;    
    v_c_subject_id            NUMBER;
    v_c_curr_count            NUMBER;
    v_rooms_amount            NUMBER;
    v_current_room_id         NUMBER;
    v_max_students            NUMBER;

    CURSOR c_st_room IS
      SELECT stc.st_id, exr.id
      FROM stud_center stc
      INNER JOIN stud_subj sts
      ON stc.st_id = sts.st_id
      INNER JOIN exam_rooms exr
      ON stc.center_id = exr.center_id AND sts.sub_id = exr.sub_id
      ORDER BY stc.center_id;
    v_c_st_id                 NUMBER;
    v_c_room_id               NUMBER;
    v_current_st_room_id      NUMBER;
    
  BEGIN
    -------GENERATING EXAMINATION ROOMS-------
    SELECT sp.p_value INTO v_max_students
    FROM sys_params sp
    WHERE sp.p_name = 'max_students_room';
    
    OPEN c_examination_rooms;
    LOOP
      FETCH c_examination_rooms 
            INTO v_c_center_id, v_c_subject_id, v_c_curr_count; 
      EXIT WHEN c_examination_rooms%NOTFOUND;
      v_rooms_amount := CEIL(v_c_curr_count/v_max_students);
      FOR n IN 1..v_rooms_amount
        LOOP
        v_current_room_id := ex_rooms_id_seq.nextval;
        INSERT INTO exam_rooms
               VALUES(v_current_room_id, v_c_center_id, v_c_subject_id);            
      END LOOP;    
    END LOOP; 
    CLOSE c_examination_rooms;
    -----STUDENTS IN EXAMINATION ROOMS-----
    OPEN c_st_room;
    LOOP
      FETCH c_st_room INTO v_c_st_id, v_c_room_id;
      EXIT WHEN c_st_room%NOTFOUND;
      v_current_st_room_id := st_room_id_seq.nextval;
      INSERT INTO stud_room
             VALUES (v_current_st_room_id, v_c_st_id, v_c_room_id);
    END LOOP;
    
    CLOSE c_st_room;  
  END;

end GENERATE_SMTH;
/
