
------------------------------------------------------------
------------------------------------------------------------
use Pubs
;
-- (1) 현재 직원(employee)는 출판사에 관계없이 하나의 테이블에 저장되어 있다. 
--    각 출판사 명 별 직원 수를 구하시오. 단 출판사 이름은 유일하지 않다고 가정합니다.
select p.pub_name, count(*) as `Number of Employees`
from publishers p, employee e
where p.pub_id = e.pub_id
group by p.pub_id, p.pub_name
;

-- (2) 책에 대해 pubs의 서점들에 의해 1993년도에 주문된 총 판매된 수량, 총 주문 금액을 구하려 한다. 
--    이때 책 이름 별 판매수량 및 주문금액은 sales 테이블의 데이터로부터 계산합니다.
-- (i) 주문된 적이 있는 경우에 한해 위의 질의 내용을 구하라.
-- 기초 자료
select count(*) from titles;
select count(*) from sales;
select * 
from titles t join sales s on t.title_id = s.title_id;
-- 93년도 기초 자료
select * 
from titles t join sales s on t.title_id = s.title_id
where year(s.ord_date) = 1993; 

select t.title, sum(s.qty) as 주문수량, sum(t.price * s.qty) as 주문금액
from  titles t join sales s on  t.title_id = s.title_id
where year(s.ord_date) = 1993
group by t.title_id, t.title
;
-- (ii)
select * 
from titles t left outer join sales s on t.title_id = s.title_id;

select * 
from titles t left outer join sales s on t.title_id = s.title_id
where year(s.ord_date) = 1993;

select t.title, sum(s.qty) as 주문수량, sum(t.price * s.qty) as 주문금액
from  titles t left outer join sales s on t.title_id = s.title_id
group by t.title_id, t.title
;

select t.title, sum(s.qty) as 주문수량, sum(t.price * s.qty) as 주문금액
from  titles t left outer join sales s on t.title_id = s.title_id
where year(s.ord_date) = 1993
group by t.title_id, t.title
;

/* 과제에서는 1993년도에 주문된 내용으로 한정. 따라서 where 절에 
연도 비교 조건이 포함되어 left outer join의 결과에 날짜 비교가 Unknown 따라서 
위의 방식으로는 처리가 되지 않음. UNION을 사용해야 */

select t.title, sum(s.qty) as 주문수량, sum(t.price * s.qty) as 주문금액
from  titles t join sales s on t.title_id = s.title_id
where year(s.ord_date) = 1993
group by t.title_id, t.title
union
select t.title, 0 as 주문수량, 0 as 주문금액
from  titles t 
where t.title_id NOT IN 
     (select s.title_id
      from sales s
      where year(s.ord_date) = 1993
      )
;

-- (4) 단독 저자에 의해 저술된 책 이름을 구하시오.
select title
from titles
where title_id In (
	select ta.title_id
	from titleauthor ta
	group by ta.title_id
	having count(*) = 1)
;

select title 
from titles 
where title_id not in (
     select ta.title_id
     from titleauthor ta
     where ta.au_ord >= 2
     )
; #이 경우 저자가 표시되지 않은 책들도 포함됨.

-- (5) 가장 많은 책을 저술한 저자의 이름을 구하시오.
-- 단계별 설명
-- (solution a)
select count(*) as NoOfBooks
from titleauthor
group by au_id
;

select max(temp.NoOfBooks)
from (select count(*) as NoOfBooks
      from titleauthor
      group by au_id) temp
;

select concat(a.au_fname, ' ', a.au_lname) as 저자이름, count(*)
from authors a join titleauthor ta on a.au_id = ta.au_id
group by a.au_id, a.au_fname, a.au_lname
having count(*) = (
				select max(temp.NoOfBooks)
				from (select count(*) as NoOfBooks
			         from titleauthor
			         group by au_id) temp
)
;

# (solution b)

set @NofBook = (
			select  count(*) as NoOfBooks
			from titleauthor
			group by au_id
			Order by 1 desc
			limit 1);
			
select @NofBook;			

select concat(a.au_fname, ' ', a.au_lname) as 저자이름
from authors a join titleauthor ta on a.au_id = ta.au_id
group by a.au_id, a.au_fname, a.au_lname
having count(*) = @NofBook
;

----------------------------------------------------------------
----------------------------------------------------------------
use classicmodels ;

# (1) 2004년도 매출 실적을 월별로 계산하려고 한다. 이를 구하는 SQL문을 쓰시오.
# 매출을 계산할 때 날짜는 주문 날짜를 기준으로 계산한다.

select month(O.OrderDate) as '월', sum(od.quantityOrdered * od.priceEach) as '매출액'
from orders o join orderdetails od on 
    o.orderNumber = od.orderNumber
where year(o.orderDate) = 2004 
group by month(o.orderDate)
Order by month(o.orderDate) ;

# (2) 고객 회사들에 대해 매출 성향을 분석하려고 한다. 
# 각 고객 회사에 대해 회사명, 주문 회수, 평균 주문 금액, 최대 주문 금액을 구하시오. 
select c.customerName, count(o.orderNumber) as 주문수, count(distinct o.orderNumber) as 주문수,
       round(avg(temp.OrderAmount),2) as 평균주문금액, round(max(temp.OrderAmount),2) as 최대주문금액
from customers c join 
      (Orders o
        join 
	    (select od.orderNumber, sum(od.quantityOrdered * od.priceEach) as OrderAmount
           from orderdetails od
           group by od.orderNumber) temp 
		   on temp.orderNumber = o.orderNumber
       )  on c.customerNumber = o.customerNumber
group by c.customerNumber, c.customerName
order by c.customerName
;

select * from customers c left outer join orders o on c.customerNumber = o.customerNumber;
select * from customers c join orders o on c.customerNumber = o.customerNumber;
-- 고객회사 별 주문 내역을 구하기 전 주문번호 별 주문 금액이 계산되어야
-- 그 후 고객 회사 별 주문 정보를 계산해야. 모든 회사가 주문했었다는 가정.

-- (3) 가장 많은 주문 금액의 주문의 담당 직원 명, 주문문 금액, 주문날짜, 
--    그 주문을 했던 고객 회사명을 구하시오.
-- (a)
 
set @OrderNo = (select  od.orderNumber
                from OrderDetails od
                group by od.orderNumber
                Order By sum(od.priceEach *od.quantityOrdered) desc
                limit 1);
set @OrderTotal = (select sum(od.priceEach *od.quantityOrdered)  
                   from orderDetails od
						 where od.orderNumber = @OrderNo
						 );              

select @OrderNo, @OrderTotal;
 
select concat(E.FirstName, ' ', E.LastName) as 직원이름,
       @OrderTotal as 주문금액,
       O.OrderDate as 주문날짜,
       C.CustomerName as 고객회사
from (Orders O join Customers C on O.customerNumber = C.customerNumber)
     join Employees E on C.salesRepEmployeeNumber = E.EmployeeNumber
where O.OrderNumber = @OrderNo
;

# (b) 변수 부분을 중첩 SQL 문을 통해 구하는 방법

select concat(E.FirstName, ' ', E.LastName) as 직원이름,
       (select sum(od2.quantityOrdered * od2.priceEach) from orderDetails od2 where od2.OrderNumber = o.orderNumber) as 주문금액,
       O.OrderDate as 주문날짜,
       C.CustomerName as 고객회사
from (Orders O join Customers C on O.customerNumber = C.customerNumber)
     join Employees E on C.salesRepEmployeeNumber = E.EmployeeNumber
where o.orderNumber =  ( select od1.OrderNumber
                         from orderDetails OD1
                         group by Od1.OrderNumber 
		  			          Order by sum(od1.quantityOrdered * od1.priceEach) desc
								 limit 1) ;



# (c) 가상 테이블 방법을 사용
select concat(E.FirstName, ' ', E.LastName) as 직원이름,
       temp.OrderAmount as 주문금액,
       O.OrderDate as 주문날짜,
       C.CustomerName as 고객회사
from (
      select od.orderNumber, sum(od.priceEach * od.quantityOrdered) as OrderAmount
      from OrderDetails od
      group by od.OrderNumber) temp 
		join Orders o on temp.orderNumber = o.orderNumber
		join Customers c on o.customerNumber = c.customerNumber
		join Employees e on c.salesRepEmployeeNumber = e.employeeNumber
order by temp.OrderAmount DESC
limit 1
;

-- (d) 반환 결과가 1이상인 경우도 계산 가능
select C.CustomerName as 고객회사,
       sum(od.quantityOrdered * od.priceEach) as 주문금액,
       O.OrderDate as 주문날짜
from Orders O, Customers C, orderDetails od
where O.OrderNumber = od.OrderNumber and 
      O.CustomerNumber = C.CustomerNumber
group by O.OrderNumber, O.OrderDate, C.CustomerName
having sum(od.quantityOrdered * od.priceEach) >= all ( select sum(Od.priceEach * Od.quantityOrdered)
                                                 from OrderDetails OD
                                                 group by Od.OrderNumber
                                               )
;



