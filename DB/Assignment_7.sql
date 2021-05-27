/* 본 과제는 간단한 수준의 학사DB를 구성하는 내용으로
   student, course, department, instructor, course_taken으로 
   구성된다. 본 과제를 통해 학생들은 테이블 간의 참조 관계를 고려한 테이븓들의 생성, 
   그리고 자기 참조 테이블의 경우 데이터들 간의 참조 관계를 고려한 데이터 입력을 경험한다.
   또한 기본 키, 외래 키를 포함한 주요 제약조건 constraint의 이름을 
   명시하여 오류 발생 시 어떤 오류인지 확인할 수 있도록 한다.   
*/

# 데이터베이스의 생성
drop database if exists 학사DB;
CREATE DATABASE IF NOT EXISTS 학사DB;
USE 학사DB;

# department 테이블의 생성과 데이터 입력
CREATE TABLE IF NOT EXISTS department (
	id CHAR(10) NOT NULL,
	name CHAR(10),
	constraint pk_department PRIMARY KEY (id)
);

INSERT INTO department (id, name) VALUES
	('cs', '전산전공'),
	('ss', '통계전공');
    
# instructor 테이블의 생성과 데이터 입력
CREATE TABLE IF NOT EXISTS instructor (
	pid CHAR(10) NOT NULL,
	name CHAR(10) NOT NULL,
	dept CHAR(10),
	constraint pk_instructor PRIMARY KEY (pid),
	constraint uniq_instructor UNIQUE KEY (name),
	constraint fk_instructor_department foreign key(dept) references department(id)
);
	
INSERT INTO instructor (pid, name, dept) VALUES
	('cs10', '구자영', 'cs'),
	('cs11', '우진운', 'cs'),
	('cs12', '유해영', 'cs'),
	('cs13', '이석균', 'cs'),
	('cs14', '조경산', 'cs'),
	('cs15', '조성제', 'cs'),
	('ss16', '이강섭', 'ss'),
	('ss17', '황형태', 'ss'),
	('ss18', '이장택', 'ss');

# course 테이블의 생성과 데이터 입력
CREATE TABLE IF NOT EXISTS course (
	id CHAR(10) NOT NULL,
	name CHAR(20),
	instructor CHAR(10),
	prerequisite CHAR(10),
	PRIMARY KEY (id),
	Constraint fk_Course_Instructor foreign key(instructor) references instructor(pid),
	CONSTRAINT fk_Prerequisite_Course foreign key(prerequisite) references course(id)
);

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES 	('cs111', '기초전산', 'cs13', NULL);

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('ss111', '전산통계', 'ss18', NULL);

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs211', '수치해석', 'cs12', 'cs111');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs221', '자료구조론', 'cs11', 'cs111');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs222', '시스템프로그래밍', 'cs10', 'cs111');
	
INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs311', '컴퓨터 구조론', 'cs14', 'cs111');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs312', '알고리즘', 'cs11', 'cs221');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs321', '프로그래밍언어론', 'cs13', 'cs221');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs322', '운영체제', 'cs15', 'cs222');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs411', '데이타베이스', 'cs13', 'cs321');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs413', '컴퓨터네트워크', 'cs14', 'cs311');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('ss311', '응용해석학', 'ss17', 'ss111');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('ss312', '통계적 품질관리', 'ss16', 'ss111');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('cs421', '소프트웨어 공학', 'cs12', 'cs312');

INSERT INTO course (id, name, instructor, prerequisite) 
VALUES	('ss321', '회귀분석', 'ss18', 'ss312');

# student 테이블의 생성과 데이터 입력
CREATE TABLE IF NOT EXISTS student (
	id CHAR(10) NOT NULL,
	name CHAR(10) NOT NULL,
	major CHAR(10) DEFAULT NULL,
	address CHAR(30) DEFAULT '단국대학교',
	gpa FLOAT,
	bdate date,
	constraint pk_student PRIMARY KEY (id),
	constraint fk_student_department foreign key(major) references department(id)
);

INSERT INTO student (id, name, major, address, gpa, bdate) VALUES
	('930405', '한나라', 'cs', '서울 마포구 원효로', 3.299999952, '1974-06-12'),
	('940123', '강동희', 'ss', '서울 중구 필동', 3.625, '1975-08-07'),
	('950564', '허영만', 'cs', '서울 강동구 풍납동', 1.75, '1976-12-21'),
	('960157', '이동주', 'cs', '서울 서초구 잠원동', 1.799999952, '1977-10-10'),
	('970734', '조용필', NULL, '서울 영등포구 영등포동', 2, '1978-07-12'),
	('980115', '이미숙', 'ss', '서울 서초구 반포동', 3.75, NULL),
	('980397', '조용기', NULL, '서울 서대문구 홍은동', 2.25, NULL);

# course_taken 테이블의 생성과 데이터 입력
CREATE TABLE IF NOT EXISTS course_taken (
	no INT NOT NULL auto_increment,
	sid CHAR(10),
	cid CHAR(10),
	grade FLOAT,
	year_taken INT,
	PRIMARY KEY (no),
	foreign key(sid) references student(id),
	CONSTRAINT fk_CourseTaken_Course foreign key(cid) references course(id)
);


INSERT INTO course_taken (sid, cid, grade, year_taken) VALUES
	('930405', 'cs111', 2.0, 1993),
	('930405', 'cs211', 4.0, 1996),
	('930405', 'cs221', 3.0, 1996),
	('930405', 'cs222', 3.0, 1996),
	('930405', 'cs311', 3.0, 1997),
	('930405', 'cs321', 4.0, 1997),
	('930405', 'cs411', 4.0, 1998),
	('940123', 'ss111', 2.0, 1994),
	('940123', 'cs111', 4.0, 1997),
	('940123', 'cs221', 4.0, 1997),
	('940123', 'ss311', 4.0, 1997),
	('940123', 'ss312', 4.0, 1998),
	('940123', 'ss321', 3.0, 1998),
	('950564', 'cs111', 2.0, 1995),
	('950564', 'cs211', 2.0, 1996),
	('950564', 'cs222', 1.0, 1997),
	('950564', 'cs311', 2.0, 1998),
	('950564', 'cs411', 2.0, 1999),
	('960157', 'cs111', 1.0, 1996),
	('960157', 'cs211', 2.0, 1997),
	('970734', 'cs111', 1.0, 1997),
	('970734', 'cs211', 3.0, 1998),
	('970734', 'cs222', 2.0, 1998),
	('980115', 'ss111', 4.0, 1998),
	('980115', 'cs111', 3.0, 1998),
	('980115', 'cs221', 3.0, 1998),
	('980115', 'cs222', 4.0, 1998),
	('980115', 'cs311', 4.0, 1999),
	('980397', 'cs111', 2.0, 1998),
	('980397', 'cs211', 2.0, 1999);


# 1. 학사 DB와 유사한 DB 생성 -> DB Name: 자신 이름 + 학번의 마지막 숫자
# 홍길동_student3 (sid(char(10), sname3 char(10), major char(10), gpa3 float))
# 홍길동_course3(cid3 char(10), cname3 char(20), instructor3 char(10))
# 홍길동_course_taken3(sid3 char(10), cid3 char(10), grade3 float, year_taken3 int)

# (a)
# 테이블 정의
DROP DATABASE IF exists 이창윤_1_DB;
CREATE DATABASE IF NOT EXISTS 이창윤_1_DB;
USE 이창윤_1_DB;

# a-1. 이창윤_student1
CREATE TABLE IF NOT EXISTS 이창윤_student1 (
	sid1   CHAR(10) NOT NULL,
	sname1 CHAR(10) NOT NULL,
	major1 CHAR(10),
	gpa1   FLOAT,
	PRIMARY KEY(sid1)
);

# a-2. 이창윤_course1
CREATE TABLE IF NOT EXISTS 이창윤_course1 (
    cid1        CHAR(10) NOT NULL,
    cname1      CHAR(20),
    instructor1 CHAR(10),
    PRIMARY KEY(cid1)
);

# a-3. 이창윤_course_taken1
CREATE TABLE IF NOT EXISTS 이창윤_course_taken1 (
	sid1   		CHAR(10),
	cid1   		CHAR(10),
	grade1 		FLOAT,
	year_taken1 INT,
	PRIMARY KEY(sid1, cid1),
	FOREIGN KEY(sid1) REFERENCES 이창윤_student1(sid1),
	CONSTRAINT fk_CourseTaken_Course FOREIGN KEY(cid1) REFERENCES 이창윤_course1(cid1)
);


# (b)
# 학사 DB로 부터 데이터 입력 
# major -> 전공 이름으로 구성 O
# student 데이터 중 학번 마지막 수가 1인 경우 제외 O
# insturctor3 -> 교수 이름으로 구성 O

# b-1. 이창윤_student1
INSERT INTO 이창윤_student1 (sid1, sname1, major1, gpa1)
SELECT s.id, s.name, d.name, s.gpa
FROM 학사DB.student s, 학사DB.department d
WHERE right(s.id, 1) NOT LIKE '1' AND s.major LIKE d.id;

# b-2. 이창윤_course!
INSERT INTO 이창윤_course1 (cid1, cname1, instructor1)
SELECT c.id, c.name, i.name
FROM 학사DB.course c, 학사DB.instructor i
WHERE c.instructor LIKE i.pid;

# b-3. 이창윤_course_taken1
INSERT INTO 이창윤_course_taken1 (sid1, cid1, grade1, year_taken1)
SELECT s.sid1, c.cid1, ct.grade, ct.year_taken
FROM 학사DB.course_taken ct, 이창윤_student1 s, 이창윤_course1 c
WHERE s.sid1 LIKE ct.sid AND c.cid1 LIKE ct.cid;

# (c)
# 다음을 실행
select * 
from 이창윤_student1 natural join 이창윤_course_taken1 natural join 이창윤_course1
order by sid1;


# 2. 이창윤_course_taken1에 학생의 수강 과목과 성적을 입력하는 저장 프로시저 '이창윤 _AddCourseGrade1'를 구현
# 매개변수 -> 학생 이름(pStud_name1), 과목 이름(pCo_name1), 성적(pGrade1), plsError1(int), 현재의 날짜(year)
# plsError -> 식별 불가능: 학생 -> 1, 과목 -> 2, 둘 다 -> 3, 그 이외 -> 4
# Error Handler 반드시 포함

# (a)
DROP PROCEDURE IF EXISTS 이창윤_AddCourseGrade1;

DELIMITER $$
CREATE PROCEDURE 이창윤_AddCourseGrade1 (
	IN pStud_name1 CHAR(10),
    IN pCo_name1   CHAR(20),
    IN pGrade1     FLOAT,
    OUT plsError1  INT
)
BEGIN
	# Error
	DECLARE CONTINUE HANDLER FOR 1048
    BEGIN
		IF 	   pStud_name1 NOT IN (SELECT sname1 FROM 이창윤_student1) 
		   AND pCo_name1   IN (SELECT cname1 FROM 이창윤_course1)  THEN SET plsError1 = 1;
        ELSEIF pStud_name1 IN (SELECT sname1 FROM 이창윤_student1) 
		   AND pCo_name1   NOT IN (SELECT cname1 FROM 이창윤_course1)  THEN SET plsError1 = 2;
        ELSEIF pStud_name1 NOT IN (SELECT sname1 FROM 이창윤_student1) 
		   AND pCo_name1   NOT IN (SELECT cname1 FROM 이창윤_course1)  THEN SET plsError1 = 3;
        END IF;
    END;
    
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET plsError1 = 4;
	
    # Transaction
	START TRANSACTION;
		INSERT INTO 이창윤_course_taken1 (sid1, cid1, grade1, year_taken1)
		SELECT (SELECT sid1 FROM 이창윤_student1 WHERE sname1 = pStud_name1), 
			   (SELECT cid1 FROM 이창윤_course1  WHERE cname1 = pCo_name1  ), pGrade1, YEAR(NOW());
	COMMIT;
    
END$$
DELIMITER ;

# (b)
# b-1. 정상구현
CALL 이창윤_AddCourseGrade1('강동희', '데이타베이스', 4.0, @RESULT);
SELECT @RESULT;

# b-2. 학생 식별 불가능
CALL 이창윤_AddCourseGrade1('이창윤', '데이타베이스', 4.0, @RESULT);
SELECT @RESULT;

# b-3. 과목 식별 불가능
CALL 이창윤_AddCourseGrade1('강동희', '참좋은밤이에요', 4.0, @RESULT);
SELECT @RESULT;

# b-4. 학생, 과목 식별 불가능
CALL 이창윤_AddCourseGrade1('이창윤', '참좋은밤이에요', 4.0, @RESULT);
SELECT @RESULT;

# b-5. 그 이외의 에러 -> example) 이미 그 과목을 수강한 데이터가 존재하여 PRIMARY KEY가 겹칠 경우
CALL 이창윤_AddCourseGrade1('한나라', '데이타베이스', 4.0, @RESULT);
SELECT @RESULT;


# 3. 학생들의 평점(GPA)을 수강 내역으로부터 계산하는 저장 프로시저를 커서를 통해 구현 
# MySQL에서는 read only 커서만을 제공하므로 갱신은 update문을 사용해야 한다. 구현 내용과 실행 결과를 보이시오.
DROP PROCEDURE IF EXISTS 이창윤_ComputeGPA1;

DELIMITER $$
CREATE PROCEDURE 이창윤_ComputeGPA1 ()
BEGIN
	DECLARE idx INT DEFAULT 0;
    DECLARE grade_sid CHAR(10);
    
    DEClARE sid_cursor CURSOR FOR SELECT sid1 FROM 이창윤_student1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET idx = TRUE;
    
    OPEN sid_cursor;
		update_loop:LOOP
			FETCH sid_cursor INTO grade_sid;
            
            IF idx THEN LEAVE update_loop;
            END IF;
            
            SELECT @SUM := SUM(grade1), @COUNT := COUNT(grade1) 
            FROM 이창윤_course_taken1 
            WHERE grade_sid = sid1;
            
            UPDATE 이창윤_student1
            SET gpa1 = @SUM / @COUNT
            WHERE sid1 = grade_sid;
            
		END LOOP update_loop;
	CLOSE sid_cursor;
    
END$$
DELIMITER ;

# 강동희 학생의 GPA가 3.5 -> 3.57 로 변경된 것을 확인 할 수 있다.
CALL 이창윤_ComputeGPA1();
SELECT * FROM 이창윤_student1;


# 4. 수강 내역 테이블에 대한 audit 정보를 담는 이창윤_course_taken_Audit1 테이블 정의
# Trigger들을 통해 audit 정보를 입력
# 이창윤_course_taken_Audit1 테이블의 필드 -> 일련번호, 이창윤_course_taken1의 기본 키, 사용자 정보, 실행 연산, 수정 시간
# 사용자 정보 -> USER() 함수 이용: 현 세션의 사용자 변환

# 이창윤_course_taken_Audit1 테이블 생성
CREATE TABLE IF NOT EXISTS 이창윤_course_taken_Audit1 (
	serial_num  INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sid1        CHAR(10),
	cid1   		CHAR(10),
	user_now	CHAR(40),
    exe_type	CHAR(10),
    exe_time	DATETIME,
	FOREIGN KEY(sid1) REFERENCES 이창윤_course_taken1(sid1),
	CONSTRAINT fk_이창윤_CourseTaken_Course FOREIGN KEY(cid1) REFERENCES 이창윤_course_taken1(cid1)
);

# (a)
# 이창윤_course_taken_Audit1 Trigger 생성
DROP TRIGGER IF EXISTS Audit_insert_trigger;
DROP TRIGGER IF EXISTS Audit_delete_trigger;
DROP TRIGGER IF EXISTS Audit_update_trigger;

# a-1. insert
DELIMITER $$
CREATE TRIGGER Audit_insert_tigger
BEFORE INSERT ON 이창윤_course_taken1
FOR EACH ROW
BEGIN
	DECLARE sid1_temp CHAR(10);
    DECLARE cid1_temp CHAR(10);
    
    SET sid1_temp = NEW.sid1;
    SET cid1_temp = NEW.cid1;
    
    INSERT INTO 이창윤_course_taken_Audit1 (sid1, cid1, user_now, exe_type, exe_time)
    VALUE (sid1_temp, cid1_temp, USER(), 'INSERT', NOW());
END$$
DELIMITER ;

# a-2. delete
DELIMITER $$ 
CREATE TRIGGER Audit_delete_trigger
BEFORE DELETE ON 이창윤_course_taken1
FOR EACH ROW
BEGIN
	DECLARE sid1_temp CHAR(10);
    DECLARE cid1_temp CHAR(10);
    
    SET sid1_temp = OLD.sid1;
    SET cid1_temp = OLD.cid1;
    
    INSERT INTO 이창윤_course_taken_Audit1 (sid1, cid1, user_now, exe_type, exe_time)
    VALUE (sid1_temp, cid1_temp, USER(), 'DELETE', NOW());
END$$
DELIMITER ;

# a-3. update
DELIMITER $$ 
CREATE TRIGGER Audit_update_trigger
BEFORE UPDATE ON 이창윤_course_taken1
FOR EACH ROW
BEGIN
	DECLARE sid1_temp CHAR(10);
    DECLARE cid1_temp CHAR(10);
    
    SET sid1_temp = OLD.sid1;
    SET cid1_temp = OLD.cid1;
    
    INSERT INTO 이창윤_course_taken_Audit1 (sid1, cid1, user_now, exe_type, exe_time)
    VALUE (sid1_temp, cid1_temp, USER(), 'UPDATE', NOW());
END$$
DELIMITER ;


# (b)
# b-1. insert trigger 작동
INSERT INTO 이창윤_course_taken1
VALUE ('940123', 'cs222', 2.0, 1993);

SELECT * FROM 이창윤_course_taken_Audit1;

# b-2. update trigger 작동
UPDATE 이창윤_course_taken1
SET year_taken1 = 2021
WHERE sid1 LIKE '940123' AND cid1 LIKE 'cs222';

SELECT * FROM 이창윤_course_taken_Audit1;


# b-3. delete trigger 작동
SET foreign_key_checks = 0;
DELETE FROM 이창윤_course_taken1
WHERE sid1 = '940123' AND cid1 = 'cs222';
SET foreign_key_checks = 1;

SELECT * FROM 이창윤_course_taken_Audit1;


# 5. 장학생(이창윤_ScholarshipStudent1) 테이블을 view로 정의하려고 한다.
# view란? -> 다른 테이블들을 참조하는 가상의 테이블
# view를 사용하는 이유 -> 보안에 도움이 된다, 복잡한 쿼리를 단순화 할 수 있다.

#(a)
# 구현 내용
CREATE VIEW 이창윤_ScholarshipStudent1 AS
SELECT sid1, sname1, major1, gpa1
FROM 이창윤_student1
WHERE gpa1 >= 3.5;

SELECT * FROM 이창윤_ScholarshipStudent1;

# (b)
# b-1. MySQL의 Check Option 이란?
# WITH CHECK OPTION으로 사용되며 조건 컬럼값을 변경하지 못하게 하는 옵션이다.

# b-2. Check Option을 장학생 뷰에 적용했을 때의 변화
# Check Option을 적용하고 나면 뷰 생성 시 조건으로 사용되었던 gpa1은 
# ALTER문으로 변경할 수 없게 된다.
CREATE OR REPLACE VIEW 이창윤_ScholarshipStudent1 AS
SELECT sid1, sname1, major1, gpa1
FROM 이창윤_student1
WHERE gpa1 >= 3.5;

SELECT * FROM 이창윤_ScholarshipStudent1;
