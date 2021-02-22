# ExamBase
## Overview
University entrance exams management system initially written in PL/SQL for Oracle Database course (Free university of Tbilisi) assignment. In this system students can choose which subjects to pass, faculties with priorities and exam centers. \
Note that entrants are referred as students.

## Usage
### Prerequisites
```
Get Started With Oracle Database 11g Express Edition 
PL/SQL developer
```
### Run programm
After opening files from [SOURCE_CODE](https://github.com/CSopiko/ExamBase/tree/main/SOURCE_CODE) folder in PL/SQL developer:
1. Execute/Compile **MAIN_TABLES_1.sql**
2. Execute/Compile **VALIDATIONS_2.pck**
3. Execute/Compile **STUDENT_REGISTRATION_3.pck**
4. Execute/Compile **INITIAL_VALUES_4.sql**
5. Execute/Compile **SEQUENCES_VIEWS_5.sql**
6. Execute/Compile **GENERATE_SMTH_6.pck**
7. Execute/Compile **SIMULATION_PROCESS_7.sql**

## Instructions
- Student can make changes in personal information X<sup>[1](#f1)</sup> days before exams. 
- Personal information before changes is available for viewing.
- Student can choose maximum X<sup>[2](#f2)</sup> faculties.
- Registred students are automatically distributed in examination rooms.
- In each room maximum amount of students is X<sup>[3](#f3)</sup>.
- In each room only one subject is being examined at a time.




---
<a maxDays ="f1">1</a>: by default X=10

<a maxDays ="f2">2</a>: by default X=20

<a maxDays ="f3">3</a>: by default X=30


## License

[MIT](https://choosealicense.com/licenses/mit/)