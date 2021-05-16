use pubs;

# A-1
select P.pub_name as 출판사, count(*) as 직원수
from employee as E, publishers as P
where E.pub_id = P.pub_id
group by 출판사
order by 직원수 asc;

# A-2-i
select stor.stor_name as 서점, sum(sal.qty) as 주문수량, sum(sal.qty * t.price) as 주문금액
from sales as sal, titles as t, stores as stor
where sal.ord_date like '%1993%' and stor.stor_id = sal.stor_id
and   sal.title_id = t.title_id
group by 서점 order by 서점 asc;

# A-2-ii
select stor.stor_name as 서점,  total.qty as 주문수량, total.price as 주문금액
from (select stor_name from stores) as stor 
left join (select stor.stor_name as stor_name, sum(sal.qty) as qty, sum(sal.qty * t.price) as price
		   from sales as sal, titles as t, stores as stor
           where sal.ord_date like '%1993%' and stor.stor_id = sal.stor_id 
           group by stor_name) as total
on stor.stor_name = total.stor_name;

# A-4
select t.title as '책 이름'
from titleauthor as ta , titles as t
where t.title_id = ta.title_id
and   ta.title_id not in (select ta.title_id 
						  from titleauthor as ta 
                          where ta.au_ord <> 1);

# A-5
select concat(concat(a.au_fname, ' '), a.au_lname) as '저자 이름'
from authors as a, (select au_id, count(*) as count from titleauthor group by au_id) as total
where a.au_id = total.au_id
and   total.count >= all (select count(*) from titleauthor group by au_id);

use classicmodels;

# B-1
select month(ord.orderDate) as 월별, sum(ordd.priceEach * ordd.quantityOrdered) as 판매량
from orders as ord, orderdetails as ordd
where ord.orderNumber = ordd.orderNumber
and   ord.status <> 'Cancelled'
and   ord.orderDate like '%2004%'
group by 월별;


# B-2
select off.officeCode as 회사명, count(ord.customerNumber) as '주문 횟수', 
	   avg(ordd.priceEach * ordd.quantityOrdered) as '평균 주문 금액', 
	   max(ordd.priceEach * ordd.quantityOrdered) as '최대 주문 금액'
from offices as off, employees as e, customers as c, orders as ord, orderdetails as ordd
where ord.orderNumber = ordd.orderNumber and c.customerNumber = ord.customerNumber
and   e.employeeNumber = c.salesRepEmployeeNumber and e.officeCode = off.officeCode
group by 회사명 order by 회사명;

# B-3
select e.officeCode as 회사명, ord.orderDate as '주문 날짜', ordd.priceEach * ordd.quantityOrdered as '주문 금액'
from orders as ord, orderdetails as ordd, customers as c, employees as e
where ord.orderNumber = ordd.orderNumber
and   ord.customerNumber = c.customerNumber and c.salesRepEmployeeNumber = e.employeeNumber
and   ordd.priceEach * ordd.quantityOrdered >= all (select ordd.priceEach * ordd.quantityOrdered
												    from orderdetails as ordd);