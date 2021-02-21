-----------------INSERTING SOME INITIAL RECORDS-------------------
INSERT ALL
  INTO universities VALUES (1, 'Free University') 
  INTO universities VALUES (2, 'Agrarian University')
  INTO universities VALUES (3, 'Tbilisi State University')
  INTO universities VALUES (4, 'Tbilisi State Medical University')
  INTO universities VALUES (5, 'Georgian Technical University')
SELECT * FROM dual; 

INSERT ALL 
  INTO faculties VALUES (1, 'MACS', 1)
  INTO faculties VALUES (2, 'MACS:E', 1)
  INTO faculties VALUES (3, 'ESM', 1)
  INTO faculties VALUES (4, 'VA[A]DS',1)
  INTO faculties VALUES (5, 'Biology', 2)
  INTO faculties VALUES (6, 'Engineering', 2)
  INTO faculties VALUES (7, 'Business', 2)
  INTO faculties VALUES (8, 'Economics', 3)
  INTO faculties VALUES (9, 'ISET', 3)
  INTO faculties VALUES (10, 'Computer Science', 3)
  INTO faculties VALUES (11, 'Medicine', 4)
  INTO faculties VALUES (12, 'Stomatology', 4)
  INTO faculties VALUES (13, 'Pharmacy', 4)
  INTO faculties VALUES (14, 'Public Health', 4)
  INTO faculties VALUES (15, 'Architecture', 5)
  INTO faculties VALUES (16, 'Electro Engineering', 5)
SELECT * FROM dual;

INSERT ALL
  INTO subjects VALUES (1, 'Math')
  INTO subjects VALUES (2, 'Literature')
  INTO subjects VALUES (3, 'English')
  INTO subjects VALUES (4, 'Russian')
  INTO subjects VALUES (5, 'Biology')
  INTO subjects VALUES (6, 'Chemistry')
  INTO subjects VALUES (7, 'History')
SELECT * FROM dual;

INSERT ALL
  INTO exam_center VALUES (1, '#147 public school', 'Tbilisi, Digmis masivi 3kv')
  INTO exam_center VALUES (2, '#177 public school', 'Tbilisi, Gldani')
  INTO exam_center VALUES (3, '#175 public school', 'Tbilisi, Mukhiani')
  INTO exam_center VALUES (4, '#103 public school', 'Tbilisi, Meskheti st.72')
  INTO exam_center VALUES (5, '#41 public school', 'Kutaisi, Rustaveli st.127')
  INTO exam_center VALUES (6, '#2 public school', 'Zugdidi, Z.Gamsakhudria st.9')
  INTO exam_center VALUES (7, '#22 public school', 'Rustavi, Kutaisi st.6')
SELECT * FROM dual;  

INSERT ALL
  INTO constant_dates VALUES(1, 1, TO_DATE('1/03/2022', 'DD/MM/YYYY'))         
  INTO constant_dates VALUES(2, 2, TO_DATE('2/03/2022', 'DD/MM/YYYY'))
  INTO constant_dates VALUES(3, 3, TO_DATE('3/03/2022', 'DD/MM/YYYY'))
  INTO constant_dates VALUES(4, 4, TO_DATE('4/03/2022', 'DD/MM/YYYY'))
  INTO constant_dates VALUES(5, 5, TO_DATE('5/03/2022', 'DD/MM/YYYY'))
  INTO constant_dates VALUES(6, 6, TO_DATE('6/03/2022', 'DD/MM/YYYY'))
  INTO constant_dates VALUES(7, 7, TO_DATE('7/03/2022', 'DD/MM/YYYY')) 
SELECT * FROM dual; 

INSERT ALL
  INTO sys_params VALUES(1, 'update_date', 10)
  INTO sys_params VALUES(2, 'max_faculties', 20)
  INTO sys_params VALUES(3, 'max_students_room', 30)
SELECT * FROM dual;

COMMIT;
/*
SELECT * FROM universities;
SELECT * FROM faculties;
SELECT * FROM subjects;
SELECT * FROM exam_center;
SELECT * FROM constant_dates;
SELECT * FROM sys_params;
*/
