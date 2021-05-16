use 학사DB;


-- A(1) 이장택 교수가 강의한 과목을 수강한 학생들의 이름과 수강 과목명 그리고 소속 전공 명을 구하라.
--     전공이 미정인 학생들도 포함하시오.
select s.name as 학생이름, c.name as 과목명, d.name as 학과명
from instructor i, course c, course_taken ct, student s, department d
where i.name = '이장택' and 
      i.pid = c.instructor and c.id = ct.cid and ct.sid = s.id and s.major = d.id;
	  
select s.name as 학생이름, c.name as 과목명, d.name as 학과명
from ( ( (instructor i join course c on c.instructor = i.pid)
         join course_taken ct on c.id = ct.cid)
	   join student s on ct.sid = s.id)
     left outer join department d on s.major = d.id	  
where i.name = '이장택';	    -- '이석균'으로 변경해볼 것.
-- left outer join의 대상이 무엇인지 중요.


 -- (2) 통계학 과목을 한 과목도 수강하지 않은 학생의 학번을 구하라.
-- 우선 통계전공의 과목(즉 통계전공의 개설과목)을 한 과목이라도 수강한 학생들의 학번을 구하면
-- 중복이 발생함을 확인
select ct.sid
from instructor i, course c, course_taken ct
where i.dept = 'ss' and c.instructor = i.pid and ct.cid = c.id;

-- 이제 하나도 듣지 않았던 학생의 학번을 구하면
select s.name
from student s
where s.id not in(
   select ct.sid
   from instructor i, course c, course_taken ct
   where i.dept = 'ss' and c.instructor = i.pid and ct.cid = c.id
);

-- (3) 1997년과 1998년에 한 번도 개설(수강)되지 않은 과목번호와 과목명을 구하라. 
-- 단계별 진행
select ct.cid
from course_taken ct
where ct.year_taken = 1997 or ct.year_taken = 1998;

(select id
from course)
except 
(select ct.cid
from course_taken ct
where ct.year = 1997 or ct.year = 1998)

select s.id, s.name
from ( (select id from course) 
       except 
       (select ct.cid
        from course_taken ct
        where ct.year_taken = 1997 or ct.year_taken = 1998)
     ) t, course s
where t.id = s.id

select  c.id, c.name
from course c
where c.id not in (
   select ct.cid
   from course_taken ct
   where ct.year_taken = 1997 or ct.year_taken = 1998
   );


-- (4) 기초전산과 데이타베이스를 둘 다 수강한 학생들의 이름을 구하라.
select s.name
from student s
where s.id in (select sid 
               from course_taken ct, course c
               where ct.cid = c.id and c.name = '데이타베이스')
      and
      s.id in (select sid
               from course_taken ct, course c
               where ct.cid = c.id and c.name = '기초전산')
;               

------------------------------------------------------------
------------------------------------------------------------
-- World Database에 대한 문제
use world;

-- (1) China의 도시 수를 계산하시오.
select ci.ID, ci.Name from city ci join country co on ci.CountryCode = co.Code
where co.Name = 'China';

select count(*) as NumberOfCityInChina from city ci join country co on ci.CountryCode = co.Code
where co.Name = 'China';

-- (2) 가장 적은 인구를 가지고 있는 국가의 이름과 인구수를 구하시오.
select Name, Population
from Country
order by 2 ASC
limit 7;

select Name, Population
from country
where Population = (select MIN(population) from country );

-- (3) Caribbean 지역에서 소통되는 모든 언어들을 구하시오.
-- Caribbean 지역의 국가 코드들
select Code, NAME from country where region = 'Caribbean';

select distinct cl.Language from countryLanguage cl join country co on cl.CountryCode = co.code
where co.region = 'Caribbean';

SELECT distinct world.countrylanguage.Language
FROM world.country
LEFT JOIN world.countrylanguage 
ON world.country.Code = world.countrylanguage.CountryCode
WHERE world.country.Region = "Caribbean";

-- (4) 소통되는 언어가 명시되지 않은 국가의 코드와 이름을 구하시오.
select code from country;  -- 239 rows
select distinct countryCode from countrylanguage;
select code, name from country where code not in (select distinct countryCode from countrylanguage); 

-- (5) 다른 도시이지만 동일 명칭의 도시들의 쌍에 대해 각각 ID와 이름을 구하시오.
select c1.Name, c1.ID,  c2.ID
from city c1, city c2
where c1.ID <> c2.ID and c1.Name = c2.Name
Order by 1, 2, 3 desc;    -- 같은 이름의 도시들이 반복되는 걸 볼 수 있음


-- C. pubs DB
use Pubs;
-- (1) 'Binnet & Hardley' 명칭의 출판사에서 출판한 책 이름을 구하시오.

select title from titles where pub_id in (select pub_id from publishers where pub_name = 'Binnet & Hardley');
;

-- (2) pubs 데이터베이스에서 날짜는 datetime으로 표현되며 datetime 타입의 데이터는 
-- 다양한 함수들을 통해 연, 월, 일, 시간 등의 정보를 각각 추출할 수 있다. 1990년과 
-- 1991년에 고용된 직원들에 대해 직원 명을 성과 이름과 맡은 직책을 반환하시오. 
-- 단 직원 명은 fname과 lname 순으로 하나의 문자열(string)로 반환하시오.
select concat(e.fname, ' ', e.lname) as Name, j.job_desc
from employee e left outer join jobs j on e.job_id = j.job_id
where (year(e.hire_date) = 1990 or year(e.hire_date) = 1991)
;

---------------------------------------------------------------
use classicmodels
;

-- (1) 취소된 주문의 주문번호, 고객 명, 담당 직원 명(last name), 주문 날짜, 그리고 그 이유(comments)를 구하시오.

select o.orderNumber, c.customerName, e.lastName EmployeeName,
       o.orderDate, o.comments
from orders o join customers c on 
     o.customerNumber = c.customerNumber
     join employees e on 
	  c.salesRepEmployeeNumber = e.employeeNumber
where status = 'Cancelled';

select o.orderNumber, c.customerName, e.lastName EmployeeName,
       o.orderDate, o.comments
from orders o join customers c on 
     o.customerNumber = c.customerNumber
     left outer join employees e on 
	  c.salesRepEmployeeNumber = e.employeeNumber
where status = 'Cancelled';
-- 담당직원이 없는 경우도 표시해야 하므로

-- (2) 주문번호 10100에 의해 주문된 모든 제품 이름을 구하시오.
select p.productName from OrderDetails od join Products p on od.ProductCode = p.ProductCode where od.OrderNumber = 10100;
