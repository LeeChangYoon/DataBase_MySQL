drop database if exists Bachelor;
create database Bachelor;
use Bachelor;

create table student (
	 id int,
     Name char(4),
     Major char(20),
     
     primary key(id)
);

create table course (
	CourseNo int,
    Course_Name char(30),
    Credit int,
    
    primary key(CourseNo)
);

create table course_taken (
	No MEDIUMINT NOT NULL AUTO_INCREMENT,
    id int,
	CourseNo int,
    grade char(5),
    
    primary key(No)
    #foreign key(id) references student(id),
    #foreign key(CourseNo) references course(CourseNo)
);

insert into student
values (32183641, '이창윤', '모바일시스템공학과'),
	   (32185761, '이재헌', '모바일시스템공학과'),
       (32186549, '손태희', '소프트웨어공학과');

insert into course
values (452660, '데이터베이스키초', 3),
	   (527980, '객체지향프로그래밍', 3),
       (515310, '글로벌중국어', 2),
       (502320, '디지털논리회로', 3),
       (521360, '뉴욕타임즈영어읽기와작문', 2);
       
insert into course_taken (id, CourseNo, grade)
values (32183641, 452660, 'A+'),
	   (32185761, 527980, 'A'),
       (32186549, 515310, 'B+'),
       (32183641, 521360, 'A+'),
       (32185761, 502320, 'A');
       
Select course_taken.No, student.Name, course.Course_Name, course_taken.grade
From student, course, course_taken
Where student.Id = course_taken.Id and course.CourseNo = course_taken.CourseNo;



    