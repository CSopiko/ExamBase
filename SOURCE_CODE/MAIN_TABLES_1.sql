
----------------------UNIVERSITIES----------------------
CREATE TABLE universities
             (id         NUMBER(3)    PRIMARY KEY,
              uni_name   VARCHAR2(100) NOT NULL UNIQUE);
/ 
----------------------FACULTIES----------------------
CREATE TABLE faculties
             (id       NUMBER(5)    PRIMARY KEY,
              fac_name VARCHAR2(50) NOT NULL,
              uni_id   NUMBER(3),
              CONSTRAINT fac_uniid_fk 
                FOREIGN KEY (uni_id)
                REFERENCES  universities(id)
                ON DELETE CASCADE);
/  
----------------------SUBJECTS----------------------
CREATE TABLE subjects
             (id         NUMBER(3)    PRIMARY KEY,
              sub_name   VARCHAR2(30) NOT NULL UNIQUE);
/
----------------------STUDENTS----------------------
CREATE TABLE students
             (id         NUMBER(10)   PRIMARY KEY,
              first_name VARCHAR2(15) NOT NULL, 
              last_name  VARCHAR2(30) NOT NULL,
              pin        NUMBER(11)   NOT NULL UNIQUE,
              email      VARCHAR2(30) NOT NULL UNIQUE);
/
----------------------STUDENTS-LOG----------------------
CREATE TABLE students_log
             (id         NUMBER(10)   PRIMARY KEY,
              first_name VARCHAR2(15) NOT NULL, 
              last_name  VARCHAR2(30) NOT NULL,
              pin        NUMBER(11)   NOT NULL UNIQUE,
              email      VARCHAR2(30) NOT NULL UNIQUE);
/

----------------------EXAM-CENTER----------------------
CREATE TABLE exam_center
             (id             NUMBER(5) PRIMARY KEY,
              center_name    VARCHAR2(50),
              center_address VARCHAR2(50));                                                                 
/
----------------------EXAM-ROOMS----------------------
CREATE TABLE exam_rooms
             (id         NUMBER(5) PRIMARY KEY,
              center_id  NUMBER(5),
              sub_id     NUMBER(3),               
              CONSTRAINT ex_rooms_centid_fk 
                FOREIGN KEY (center_id)
                REFERENCES  exam_center(id) 
                ON DELETE CASCADE,
              CONSTRAINT ex_rooms_subid_fk 
                FOREIGN KEY (sub_id)
                REFERENCES  subjects(id)
                ON DELETE CASCADE);
/
----------------------EXAM-DATES----------------------
CREATE TABLE constant_dates
             (id           NUMBER(3) PRIMARY KEY,
             sub_id        NUMBER(3),
             day_of_exam   DATE,
             CONSTRAINT const_dates_subid_fk 
               FOREIGN KEY (sub_id)
               REFERENCES subjects(id)
               ON DELETE CASCADE);
/ 
----------------------SYSTEM-PARAMETERS----------------------
CREATE TABLE sys_params
                        (id     NUMBER(3) PRIMARY KEY, 
                         p_name  VARCHAR2(30),
                         p_value NUMBER(10));
/ 
----------------------EXAM-SCORES----------------------
CREATE TABLE scores
             (id         NUMBER(10), 
              st_id      NUMBER(10),
              sub_id     NUMBER(3),  
              score      NUMBER(6),
              CONSTRAINT ex_res_stid_fk 
                FOREIGN KEY (st_id)
                REFERENCES students(id)
                ON DELETE CASCADE,
              CONSTRAINT ex_res_subid_fk 
                FOREIGN KEY (sub_id)
                REFERENCES subjects(id)
                ON DELETE CASCADE);  
/ 
----------------------RELATIONAL-TABLES----------------------

-----------------STUDENTS CHOOSE EXAM CENTER-----------------
CREATE TABLE stud_center
             (id         NUMBER(10)   PRIMARY KEY,
              st_id      NUMBER(10),
              center_id  NUMBER(5),
              CONSTRAINT stcent_stid_fk 
                FOREIGN KEY (st_id)
                REFERENCES students(id)
                ON DELETE CASCADE,
              CONSTRAINT stcent_centerid_fk 
                FOREIGN KEY (center_id)
                REFERENCES exam_center(id)
                ON DELETE CASCADE,
              CONSTRAINT stcent_stct_u 
                UNIQUE(st_id, center_id));  
/                            
--------------------STUDENTS IN EXAM ROOMS--------------------
CREATE TABLE stud_room
             (id       NUMBER    PRIMARY KEY,
             st_id     NUMBER(10),
             room_id   NUMBER(5),
             CONSTRAINT roomst_stid_fk 
               FOREIGN KEY (st_id)
               REFERENCES students(id)
               ON DELETE CASCADE,
             CONSTRAINT roomst_roomid_fk 
               FOREIGN KEY (room_id)
               REFERENCES exam_rooms(id)
               ON DELETE CASCADE);
/                
------------------STUDENTS CHOOSE SUBJECTS------------------                         
CREATE TABLE stud_subj             
             (id         NUMBER(10) PRIMARY KEY,
              st_id      NUMBER(10),
              sub_id     NUMBER(3),
              CONSTRAINT sub_st_u 
                UNIQUE (sub_id, st_id),
              CONSTRAINT sub_st_stid_fk 
                FOREIGN KEY (st_id)
                REFERENCES students(id)
                ON DELETE CASCADE,
              CONSTRAINT sub_st_subid_fk 
                FOREIGN KEY (sub_id)
                REFERENCES subjects(id)
                ON DELETE CASCADE);
/ 
------------------STUDENTS CHOOSE FACULTIES------------------
CREATE TABLE stud_fac
             (id           NUMBER(10) PRIMARY KEY,
             st_id         NUMBER(10),
             fac_id        NUMBER(10),
             priority      NUMBER(3),
             CONSTRAINT stud_fac_stid_fk 
               FOREIGN KEY (st_id)
               REFERENCES students(id)
               ON DELETE CASCADE,
             CONSTRAINT stud_fac_facid_fk 
               FOREIGN KEY (fac_id)
               REFERENCES subjects(id)
               ON DELETE CASCADE,
             CONSTRAINT st_priority_u 
               UNIQUE (st_id, priority),
             CONSTRAINT st_fac_u 
               UNIQUE (st_id, fac_id));
/ 
----------------------------EXAM-CARDS-----------------------
CREATE TABLE exam_cards
             (card_no       NUMBER(10),
             stud_id        NUMBER(10),
             pin            NUMBER(11),
             first_name     VARCHAR2(15), 
             last_name      VARCHAR2(30),
             center_address VARCHAR2(50),
             subject_id     NUMBER(3),
             subject_name   VARCHAR2(30),
             exam_date      DATE,
             exam_room      NUMBER(5));
/

/*
DROP TABLE scores;
DROP TABLE stud_room;
DROP TABLE exam_rooms;
DROP TABLE stud_subj;
DROP TABLE stud_center;
DROP TABLE constant_dates;
DROP TABLE stud_fac;
DROP TABLE subjects;
DROP TABLE faculties;
DROP TABLE universities;
DROP TABLE students;
DROP TABLE exam_center;
DROP TABLE students_log;
DROP TABLE sys_params;
DROP TABLE exam_cards;
*/
