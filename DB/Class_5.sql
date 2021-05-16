drop database if exists 이창윤;
create database 이창윤;
use 이창윤;

create table 이창윤_department (
ID 		int 			not null,
Name 	varchar(50) 	not null,

primary key (ID)
);

create table 이창윤_student (
ID 		int 			not null,
Name 	varchar(10) 	not null,
Major 	int     		not null,
GPA 	double 			null,

primary key (ID),
unique key (Name),
foreign key (Major) references 이창윤_department(ID)
);

create table 이창윤_instructor (
PID 	int 			not null,
Name 	varchar(50) 	not null, 
Dept 	int 			not null,

primary key(PID),
foreign key (Dept) references 이창윤_department(ID)
);

create table 이창윤_course (
ID 				int 			not null,
Name 			varchar(50) 	not null,
Instructor 		int 			not null,
Prerequisite 	int 			null,

primary key(ID),
foreign key (Prerequisite) references 이창윤_course(ID),
foreign key (Instructor) references 이창윤_Instructor(PID)
);

create table 이창윤_course_taken (
No 		int      		not null auto_increment,
SID 	int 			not null,
CID 	int 			not null,
Grade 	varchar(10) 	not null,

primary key(No),
foreign key (SID) references 이창윤_student(ID),
foreign key (CID) references 이창윤_course(ID)
);

insert into 이창윤_department
values (26549135, '모바일시스템공학과'),
	   (23014948, '소프트웨어공학과'),
       (24030570, '전자전기공학과'),
       (27846561, '교양대학');
select * from 이창윤_department;
       
insert into 이창윤_student
values (32183641, '이창윤', 26549135, 4.21),
       (37532833, '이재헌', 26549135, 3.80),
       (39185874, '손재희', 23014948, 4.01),
       (30419160, '김채운', 24030570, 3.35);
select * from 이창윤_student;
       
insert into 이창윤_instructor
values (32338092, '이석균', 23014948),
	   (30763946, '이현우', 26549135),
       (38749147, '임종국', 26549135),
       (30792387, '김주웅', 24030570),
       (38456468, '찰스코퍼랜드', 27846561);
select * from 이창윤_instructor;       
       
insert into 이창윤_course
values (452660, '데이터베이스기초', 32338092, null),
       (326460, '기초프로그래밍1', 30763946, null),
       (527980, '객체지향프로그래밍(SW)', 38749147, null),
       (515320, '글로벌핵심영어1', 38456468, null),
       (326470, '기초프로그래밍2', 38749147, 326460),
	   (521190, '기초모바일실험', 30763946, 326470),
       (515330, '글로벌핵심영어2', 38456468, 515320),
       (515340, '글로벌핵심영어3', 38456468, 515330);
select * from 이창윤_course;
       
insert into 이창윤_course_taken (SID, CID, Grade)
values (32183641, 452660, 'A+'),
	   (32183641, 521190, 'A+'),
       (37532833, 326470, 'B'),
       (37532833, 326460, 'A'),
       (39185874, 527980, 'A+'),
       (39185874, 452660, 'B+'),
       (30419160, 326460, 'C+'),
       (30419160, 326470, 'F'),
       (32183641, 515320, 'A+'),
       (32183641, 515330, 'A+');
select * from 이창윤_course_taken;