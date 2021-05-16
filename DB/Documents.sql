use 학사db;

# 1. 두 테이블에 대한 join

select S.name as 이름, CT.cid as 과목코드, CT.grade as 학점
from student as S, course_taken as CT
where S.id = CT.sid;

# 2. 세 테이블에 대한 join

select S.name as 이름, C.name as 과목명, CT.grade as 학점
from student as S, course as C, course_taken as CT
where S.id = CT.sid and C.id = CT.cid;


# A-1

select S.name as 이름, C.name as 교과명, D.name 학과명
from student as S, course as C, department as D, course_taken as CT
where C.instructor in (select I.pid from instructor as I where I.name = '이장택')
and   C.id = CT.cid and S.id = CT.sid
and   S.major in (null, D.id);


# A-2

select S.name as 이름
from student as S
where S.name not in (select S.name 
					 from   student as S, course_taken as CT 
                     where  CT.cid IN ('ss111','ss311','ss312','ss321') 
                     and    CT.sid = S.id); 


# A-3

select distinct C.id as 과목번호, C.name as 과목명
from course as C, course_taken as CT
where C.id not in (select CT.cid 
				   from course_taken as CT
                   where CT.year_taken in (1997, 1998));


# A-4

select S.name as 이름
from student as S
where S.id in (select CT.sid from course_taken as CT, course as C where C.name = '기초전산' and C.id = CT.cid)
and   S.id in (select CT.sid from course_taken as CT, course as C where C.name = '데이타베이스' and C.id = CT.cid);


use world;

# B-1

select count(C.id) as '도시 수'
from city as C, country as N
where N.Name = 'China' and N.code = C.CountryCode;


# B-2

select N.Name as 이름, N.Population as '인구 수'
from country as N
where N.Population in (select min(Population) from country);


# B-3

select distinct CN.Language as 언어
from countrylanguage as CN
where CN.CountryCode in (select Code from country where Region = 'Caribbean');


# B-4

select distinct N.Code as 지역코드, N.Name as 이름 
from country as N, countrylanguage as CN
where N.Code not in (select CountryCode from countrylanguage);


# B-5

select C1.Name as 도시명, C1.id as 코드1, C2.id as 코드2
from city as C1, city as C2
where C1.Name = C2.Name and C1.ID <> C2.ID;


use pubs;

# C-1

select T.title as 제목
from titles as T, publishers as P
where T.pub_id in (select pub_id from publishers where pub_name = 'Binnet & Hardley');


# C-2

select concat(E.fname, ' ', E.lname) as 이름
from employee as E
where E.hire_date between '1990-01-01' and '1990-12-31';


use classicmodels;

# D-1

select O.orderNumber as 주문번호, C.customerName as '고객 이름', E.lastName as 직원명, O.orderDate as '주문 일자', O.comments as 이유
from orders as O, customers as C, employees as E
where O.status = 'Resolved'
and   C.customerNumber = O.customerNumber
and   C.salesRepEmployeeNumber = E.employeeNumber;


# D-2

select P.productName as 상품명
from products as P, orderdetails as OT
where OT.orderNumber = 10100
and   OT.productCode = P.productCode;


