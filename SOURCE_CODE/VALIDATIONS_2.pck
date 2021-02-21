CREATE OR REPLACE PACKAGE validations
AS
  PROCEDURE check_student_faculties (p_st_id students.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_change_time       (error_msg OUT VARCHAR2, error_code OUT NUMBER);
  
  PROCEDURE check_student_pin       (p_pin students.pin%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_student_email     (p_email students.email%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_center_id         (p_center_id exam_center.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_faculty_id        (p_faculty_id faculties.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_unique_subj       (p_st_id stud_subj.st_id%TYPE, p_sub_id stud_subj.sub_id%TYPE ,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_unique_fac        (p_st_id stud_fac.st_id%TYPE, p_fac_id stud_fac.fac_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_fac_priority      (p_st_id stud_fac.st_id%TYPE, p_priority stud_fac.priority%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_student_id        (p_st_id students.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);
  PROCEDURE check_subject_id        (p_sub_id subjects.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER);

  e_max_faculties EXCEPTION;
  e_change_info   EXCEPTION;
  e_student_pin   EXCEPTION;
  e_student_email EXCEPTION;
  e_center_id     EXCEPTION;
  e_faculty_id    EXCEPTION;
  e_unique_subj   EXCEPTION;
  e_unique_fac    EXCEPTION;
  e_student_id    EXCEPTION;
  e_subject_id    EXCEPTION;
  
  PRAGMA EXCEPTION_INIT(e_max_faculties, -20000);
  PRAGMA EXCEPTION_INIT(e_change_info,   -20001);
  PRAGMA EXCEPTION_INIT(e_student_pin,   -20002);
  PRAGMA EXCEPTION_INIT(e_student_email, -20003);
  PRAGMA EXCEPTION_INIT(e_center_id,     -20004);
  PRAGMA EXCEPTION_INIT(e_faculty_id,    -20005);
  PRAGMA EXCEPTION_INIT(e_unique_subj,   -20006);
  PRAGMA EXCEPTION_INIT(e_unique_fac,    -20007);
  PRAGMA EXCEPTION_INIT(e_student_id,    -20008);
  PRAGMA EXCEPTION_INIT(e_subject_id,    -20009);

END validations;
/
CREATE OR REPLACE PACKAGE BODY validations
AS
----
  PROCEDURE check_student_faculties (p_st_id students.id%TYPE, error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_num_faculties NUMBER;
    v_max_faculties NUMBER;
    e_add_faculties_excep EXCEPTION;
  BEGIN

    SELECT COUNT(*) INTO v_num_faculties
    FROM stud_fac
    WHERE stud_fac.id = p_st_id;

    SELECT sp.p_value INTO v_max_faculties
    FROM sys_params sp
    WHERE sp.p_name = 'max_faculties';

    IF v_num_faculties >= v_max_faculties THEN
      RAISE e_max_faculties;
    END IF;

  EXCEPTION
    WHEN e_max_faculties THEN
      error_msg := 'You have already chosen maximum amount of faculties';
      error_code := -20000;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END;
----

  PROCEDURE check_change_time(error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_first_exam DATE;
    v_change_time NUMBER;
    e_change_info_excep EXCEPTION;
  BEGIN
    SELECT day_of_exam INTO v_first_exam
    FROM constant_dates
    WHERE id = 1;

    SELECT sp.p_value INTO v_change_time
    FROM sys_params sp
    WHERE sp.p_name = 'update_date';
    IF SYSDATE + v_change_time >= v_first_exam THEN 
      RAISE e_change_info;
    END IF;
  EXCEPTION
    WHEN e_change_info THEN
      error_msg := 'You can not make changes anymore';
      error_code := -20001;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END;
----
  PROCEDURE check_student_pin       (p_pin students.pin%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM students s
    WHERE s.pin = p_pin;

    IF v_rows > 0 THEN
      RAISE e_student_pin;
    END IF;

  EXCEPTION
    WHEN e_student_pin THEN
      error_msg := 'Pin is already in database';
      error_code := -20002;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_student_pin;
---
  PROCEDURE check_student_email     (p_email students.email%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM students s
    WHERE s.email = p_email;

    IF v_rows > 0 THEN
      RAISE e_student_email;
    END IF;
  EXCEPTION
    WHEN e_student_email THEN
      error_msg := 'Email is already in database';
      error_code := -20003;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_student_email;
---
  PROCEDURE check_center_id         (p_center_id exam_center.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM exam_center exc
    WHERE exc.id = p_center_id;
    IF v_rows = 0 THEN
      RAISE e_center_id;
      raise_application_error(-20004, 'Exam center does not exists');
    END IF;
  EXCEPTION
    WHEN e_center_id THEN
      error_msg := 'Exam center does not exists';
      error_code := -20004;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_center_id;
---
  PROCEDURE check_faculty_id        (p_faculty_id faculties.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM faculties fac
    WHERE fac.id = p_faculty_id;

    IF v_rows = 0 THEN
      RAISE e_faculty_id;
    END IF;
  EXCEPTION
    WHEN e_faculty_id THEN
      error_msg := 'Faculty does not exists';
      error_code := -20005;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_faculty_id;
---
  PROCEDURE check_unique_subj       (p_st_id stud_subj.st_id%TYPE, p_sub_id stud_subj.sub_id%TYPE ,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM stud_subj stsb
    WHERE (stsb.st_id = p_st_id AND stsb.sub_id = p_sub_id);
    IF v_rows > 0 THEN
      RAISE e_unique_subj;
    END IF;
  EXCEPTION
    WHEN e_unique_subj THEN
      error_msg := -20006;
      error_code := 'Violation of uniqueness: pair student-subject';
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_unique_subj;
---
  PROCEDURE check_unique_fac        (p_st_id stud_fac.st_id%TYPE, p_fac_id stud_fac.fac_id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM stud_fac stf
    WHERE (stf.st_id = p_st_id AND stf.fac_id = p_fac_id);
    IF v_rows > 0 THEN
      RAISE e_unique_fac;
    END IF;
  EXCEPTION
    WHEN e_unique_fac THEN
      error_msg := 'Violation of uniqueness: pair student-faculty';
      error_code := -20007;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_unique_fac;

  PROCEDURE check_fac_priority      (p_st_id stud_fac.st_id%TYPE, p_priority stud_fac.priority%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM stud_fac stf
    WHERE (stf.st_id = p_st_id AND stf.priority = p_priority);
    IF v_rows > 0 THEN
      RAISE e_unique_fac;
    END IF;

  EXCEPTION
    WHEN e_unique_fac THEN
      error_msg := 'Violation of uniqueness: pair student-faculty';
      error_code := -20007;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_fac_priority;

  PROCEDURE check_student_id        (p_st_id students.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM students
    WHERE id = p_st_id;
    IF v_rows = 0 THEN
      RAISE e_student_id;
      --raise_application_error(-20008, 'Student does not exists');
    END IF;
  EXCEPTION
    WHEN e_student_id THEN
      error_msg := 'Student does not exists';
      error_code := -20008;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_student_id;

  PROCEDURE check_subject_id        (p_sub_id subjects.id%TYPE,
                                     error_msg OUT VARCHAR2, error_code OUT NUMBER) IS
    v_rows NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_rows
    FROM subjects
    WHERE id = p_sub_id;
    IF v_rows = 0 THEN
      RAISE e_student_id;
    END IF;
  EXCEPTION
    WHEN e_subject_id THEN
      error_msg := 'Subject does not exists';
      error_code := -20009;
    WHEN OTHERS THEN
      error_msg := SQLERRM;
      error_code := SQLCODE;
  END check_subject_id;
END validations;
/
