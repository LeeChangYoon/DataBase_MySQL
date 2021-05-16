
DROP DATABASE IF EXISTS company;
CREATE DATABASE IF NOT EXISTS company;
USE company;

DROP TABLE IF EXISTS department;
CREATE TABLE IF NOT EXISTS department (
  DeptNo tinyint(3) unsigned NOT NULL,
  DeptName char(10) DEFAULT NULL,
  Floor tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (DeptNo)
);
insert into department values
(1, '영업', 8), (2, '기획', 10), (3, '개발', 9);


DROP TABLE IF EXISTS employee;
CREATE TABLE IF NOT EXISTS employee (
  EmpNo smallint(6) NOT NULL,
  EmpName char(10) DEFAULT NULL,
  Title char(10) DEFAULT NULL,
  Dno tinyint(3) unsigned DEFAULT NULL,
  Salary int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (EmpNo),
  CONSTRAINT FK_Employee_Department FOREIGN KEY (Dno) REFERENCES department (DeptNo)
);

insert into employee values
(2106, '김창섭', '대리', 2, 2000000), (3426, '박영권', '과장', 3, 2500000), (3011, '이수민', '부장', 1, 3000000), (1003, '조민희', '대리', 1, 2000000), (3427, '최종철', '사원', 3, 1500000);

-- 예제1: 없는 부서 번호로 직원 삽입의 경우
insert into employee values (5000, 'test', 'test', 5, 500000);


-- 예제2: 부모 테이블의 행의 삭제(1번 부서의 삭제)
delete from department where deptNo = 1;


-- 예제3: 부모 테이블의 기본 키 값의 변경(영업 부서의 부서 번호 5로 변경)
update department set DeptNo = 5 where DeptName = '영업';


-- 예제4: 자식 테이블에서의 외래키의 처리 방식의 변경. 
-- 부모 테이블에서의 삭제의 경우.
alter table employee drop foreign key FK_Employee_Department;
alter table employee add 
			constraint FK_Employee_Department foreign key (DNo) references Department(DeptNo) 
            on delete set null;

delete from department where deptNo = 1;
select * from department;

-- 예제5: 자식 테이블에서의 외래키의 처리 방식의 변경. 
-- 부모 테이블에서의 update의 경우.(개발 부서의 부서 번호 5로 변경).
alter table employee drop foreign key FK_Employee_Department;
alter table employee add 
			constraint FK_Employee_Department foreign key (DNo) references Department(DeptNo) 
            on delete set null
            on update cascade;

update department set DeptNo = 5 where DeptName = '기획';
select * from department;
select * from employee;


