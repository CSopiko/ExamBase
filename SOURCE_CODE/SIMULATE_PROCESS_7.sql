
--------------------------------------------------------------
DECLARE
  v_current_st_id         NUMBER;
  v_current_st_sub_id     NUMBER;
  v_current_st_fac_id     NUMBER;
  v_current_st_center_id  NUMBER;
  error_msg               VARCHAR2(150) := '';
  error_code              NUMBER;
   

BEGIN 
  error_msg := '';
  v_current_st_id := reg_st_id_seq.nextval;  
  hr.student_registration.add_student(v_current_st_id, 'Sopiko', 'Kurdadze', 
                                  9000111222, 'skurd18@freeuni.edu.ge', error_msg , error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  --add subjects
  error_msg := '';                                  
  v_current_st_sub_id := st_sub_id_seq.nextval;
  hr.student_registration.add_student_subject(v_current_st_sub_id, v_current_st_id, 1, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;  
  error_msg := '';  
  v_current_st_sub_id := st_sub_id_seq.nextval; 
  hr.student_registration.add_student_subject(v_current_st_sub_id, v_current_st_id, 2, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  error_msg := '';  
  v_current_st_sub_id := st_sub_id_seq.nextval;
  hr.student_registration.add_student_subject(v_current_st_sub_id, v_current_st_id, 3, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  --add faculties
  error_msg := '';  
  v_current_st_fac_id := st_fac_id_seq.nextval;
  hr.student_registration.add_student_faculty(v_current_st_fac_id, v_current_st_id, 1, 1, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF; 
  error_msg := ''; 
  v_current_st_fac_id := st_fac_id_seq.nextval;  
  hr.student_registration.add_student_faculty(v_current_st_fac_id, v_current_st_id, 3, 2, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  error_msg := ''; 
  v_current_st_fac_id := st_fac_id_seq.nextval;  
  hr.student_registration.add_student_faculty(v_current_st_fac_id, v_current_st_id, 7, 3, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
 --try to violate 
  error_msg := ''; 
  v_current_st_fac_id := st_fac_id_seq.nextval;  
  hr.student_registration.add_student_faculty(v_current_st_fac_id, v_current_st_id, 7, 3, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  --add exam center 
 error_msg := '';   
  v_current_st_center_id := st_center_id_seq.nextval; 
  hr.student_registration.add_student_excenter(v_current_st_center_id, v_current_st_id, 1, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  error_msg := '';   
----  
  v_current_st_id := reg_st_id_seq.nextval;
  hr.student_registration.add_student(v_current_st_id, 'Saxeli', 'Gvari', 
                                  12345678901, 'sgvari@gmail.com', error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  error_msg := '';                                   
  v_current_st_sub_id := st_sub_id_seq.nextval;                                                                                   
  hr.student_registration.add_student_subject(v_current_st_sub_id, v_current_st_id, 1, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  error_msg := '';  
  v_current_st_sub_id := st_sub_id_seq.nextval;   
  hr.student_registration.add_student_subject(v_current_st_sub_id, v_current_st_id, 2, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  error_msg := '';  
  v_current_st_fac_id := st_fac_id_seq.nextval; 
  hr.student_registration.add_student_faculty(v_current_st_fac_id, v_current_st_id, 1, 1, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF; 
  error_msg := '';  
  v_current_st_center_id := st_center_id_seq.nextval; 
  hr.student_registration.add_student_excenter(v_current_st_center_id, v_current_st_id, 2, error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  error_msg := '';   
  --try to violate
  v_current_st_id := reg_st_id_seq.nextval;
  hr.student_registration.add_student(v_current_st_id, 'Firstname', 'LastName', 
                                 12345678001, 'sgvari@gmail.com', error_msg, error_code);
  IF NOT(LENGTH(error_msg) = 0) THEN DBMS_OUTPUT.PUT_LINE(error_code || ' ' || error_msg); END IF;
  error_msg := ''; 
  
  GENERATE_SMTH.generate_exam_rooms;
  GENERATE_SMTH.generate_exam_cards;
  GENERATE_SMTH.generate_scores;    

END;
/
COMMIT;
