drop database if exists company;
create database company;
use company;
create table Department (
  DeptNo int,
  DeptName char(20),
  Floor int,
  primary key(DeptNo)
);
insert into Department
values(1, '영업', 8),(2, '기획', 10),(3, '개발', 9);

select * from Department;