CREATE OR REPLACE PACKAGE student_registration AS

  PROCEDURE add_student             (p_id students.id%TYPE, p_f_name students.first_name%TYPE,
                                     p_l_name students.last_name%TYPE, p_pin students.pin%TYPE,
                                     p_email students.email%TYPE, error_msg OUT VARCHAR2, error_code OUT NUMBER);

  PROCEDURE add_student_subject     (p_id stud_subj.id%TYPE, p_stud_id stud_subj.st_id%TYPE,
                                     p_subj_id stud_subj.sub_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);

  PROCEDURE add_student_faculty     (p_id stud_fac.id%TYPE, p_stud_id stud_fac.st_id%TYPE,
                                     p_fac_id stud_fac.fac_id%TYPE, p_priority stud_fac.priority%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);

  PROCEDURE add_student_excenter    (p_id stud_center.id%TYPE, p_stud_id stud_center.st_id%TYPE,
                                     p_center_id stud_center.center_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);

  PROCEDURE change_student_excenter (stud_id stud_center.st_id%TYPE, center_id stud_center.center_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE change_student_f_name   (id students.id%TYPE, f_name students.first_name%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE change_student_l_name   (id students.id%TYPE, l_name students.last_name%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE change_student_pin      (id students.id%TYPE, pin students.pin%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE change_student_email    (id students.id%TYPE, email students.email%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE remove_student_subject  (stud_id stud_subj.st_id%TYPE, subj_id stud_subj.sub_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE remove_student_faculty  (stud_id stud_fac.st_id%TYPE, fac_id stud_fac.fac_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);

END student_registration;
/
CREATE OR REPLACE PACKAGE BODY student_registration
AS
  PROCEDURE add_student             (p_id students.id%TYPE, p_f_name students.first_name%TYPE,
                                     p_l_name students.last_name%TYPE, p_pin students.pin%TYPE,
                                     p_email students.email%TYPE, error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
    
    validations.check_student_pin(p_pin, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
    
    validations.check_student_email(p_email, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
--    IF LENGTH(error_msg) = 0 THEN
      INSERT INTO students
             VALUES(p_id, p_f_name, p_l_name, p_pin, p_email);
      COMMIT;
      v_commited := TRUE;
      --DBMS_OUTPUT.PUT_LINE('student added');
--    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END add_student;
---
  PROCEDURE add_student_subject     (p_id stud_subj.id%TYPE, p_stud_id stud_subj.st_id%TYPE,
                                     p_subj_id stud_subj.sub_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
    
    validations.check_unique_subj(p_stud_id, p_subj_id, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
--    IF LENGTH(error_msg) = 0 THEN
      INSERT INTO stud_subj
             VALUES(p_id, p_stud_id, p_subj_id);
      COMMIT;
      v_commited := TRUE;
--    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END add_student_subject;
----
  PROCEDURE add_student_faculty     (p_id stud_fac.id%TYPE, p_stud_id stud_fac.st_id%TYPE,
                                     p_fac_id stud_fac.fac_id%TYPE, p_priority stud_fac.priority%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
    
    validations.check_faculty_id(p_fac_id, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
    
    validations.check_student_faculties(p_stud_id, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
    
    validations.check_unique_fac(p_stud_id, p_fac_id, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
    
    validations.check_fac_priority(p_stud_id, p_priority, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;
--    IF NOT(LENGTH(error_msg) != 0) THEN

      INSERT INTO stud_fac
             VALUES(p_id, p_stud_id, p_fac_id, p_priority);
      COMMIT;
      v_commited := TRUE;
--    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END add_student_faculty;

  PROCEDURE add_student_excenter    (p_id stud_center.id%TYPE, p_stud_id stud_center.st_id%TYPE,
                                     p_center_id stud_center.center_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

    validations.check_center_id(p_center_id, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

--    IF LENGTH(error_msg) = 0 THEN
      INSERT INTO stud_center
             VALUES(p_id, p_stud_id, p_center_id);
      COMMIT;
      v_commited := TRUE;
--    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END add_student_excenter;


  PROCEDURE change_student_excenter (stud_id stud_center.st_id%TYPE, center_id stud_center.center_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

    validations.check_center_id(center_id, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

--    IF LENGTH(error_msg) = 0 THEN
      UPDATE stud_center stc
      SET    stc.center_id = center_id
      WHERE  stc.st_id = stud_id;
      COMMIT;
      v_commited := TRUE;
--    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END change_student_excenter;

  PROCEDURE change_student_f_name   (id students.id%TYPE, f_name students.first_name%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

--    IF LENGTH(error_msg) = 0 THEN
      UPDATE students s
      SET    s.first_name = f_name
      WHERE  s.id = id;
      COMMIT;
      v_commited := TRUE;
--    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END change_student_f_name;

  PROCEDURE change_student_l_name   (id students.id%TYPE, l_name students.last_name%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

--    IF LENGTH(error_msg) = 0 THEN
      UPDATE students s
      SET    s.last_name = l_name
      WHERE  s.id = id;
      COMMIT;
      v_commited := TRUE;
--    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END change_student_l_name;

  PROCEDURE change_student_pin      (id students.id%TYPE, pin students.pin%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

    validations.check_student_pin(pin, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

--    IF LENGTH(error_msg) = 0 THEN
      UPDATE students s
      SET    s.pin = pin
      WHERE  s.id = id;
      COMMIT;
      v_commited := TRUE;
--    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END change_student_pin;
  PROCEDURE change_student_email    (id students.id%TYPE, email students.email%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

    validations.check_student_email(email, error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

--   IF LENGTH(error_msg) = 0 THEN
      UPDATE students s
      SET    s.email = email
      WHERE  s.id = id;
      COMMIT;
      v_commited := TRUE;
--    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END change_student_email;

  PROCEDURE remove_student_subject  (stud_id stud_subj.st_id%TYPE, subj_id stud_subj.sub_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

--    IF LENGTH(error_msg) = 0 THEN
      DELETE FROM stud_subj stsb
      WHERE stsb.st_id = stud_id AND stsb.sub_id = subj_id;
      COMMIT;
      v_commited := TRUE;
--    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END remove_student_subject;

  PROCEDURE remove_student_faculty  (stud_id stud_fac.st_id%TYPE, fac_id stud_fac.fac_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_commited BOOLEAN := FALSE;

  BEGIN
    validations.check_change_time(error_msg, error_code);
    IF NOT(LENGTH(error_msg) = 0) THEN raise_application_error(error_code, error_msg); END IF;

--    IF LENGTH(error_msg) = 0 THEN
      DELETE FROM stud_fac stf
      WHERE stf.st_id = stud_id AND stf.fac_id = fac_id;
      COMMIT;
      v_commited := TRUE;
--    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
      IF v_commited THEN ROLLBACK; END IF;
  END remove_student_faculty;

END;
/
