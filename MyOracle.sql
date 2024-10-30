--24102021
--Oracle SQL Practical question with answer Compute all the possible paths | Oracle SELF JOIN Example
select  a.CITY_NAME,b.city_name 
from cities a,cities b
where a.city_id<b.city_id;

select  a.CITY_NAME,b.city_name 
from cities a,cities b
where a.city_name<b.city_name;

select  --a.CITY_NAME,b.city_name,
        distinct
        greatest(a.city_name,b.city_name) gcity,
        least(a.city_name,b.city_name) lcity
from cities a,cities b
where a.city_name<>b.city_name ;

------------------------------------end----------------------------------------------

---29102024

--Oracle SQL Practical question get the list of person reporting under each person

select a.empno,a.ename,b.enamelst,nvl(b.empcount,0) empcount
from emp a left outer join
(
select mgr,
       listagg(ename,',') within group(order by ename) enamelst,
       count(*) empcount
from emp
group by mgr) b on a.empno=b.mgr
order by a.empno;

select a.empno,a.ename,(select 
       listagg(b.ename,',') within group(order by b.ename) 
       from emp b
       where b.mgr=a.empno
       ) enamelst,
       (select 
       count(*) 
       from emp b
       where b.mgr=a.empno
       ) empcount
       from emp a
order by a.empno;

--3rd Method

select m.empno,m.ename,
       listagg(e.ename,',') within group(order by e.ename) enamelst,
       count(e.ename) empcount
from emp m left outer join emp e on m.empno=e.mgr
group by m.empno,m.ename
order by m.empno;

-------------------------------------------------end------------------------------

--30102024

---query to convert the given string into comma(,) seperated values into the column

create table service
(
    service_code varchar(10),
    service_name varchar(50)
);

insert into service values('A','Service-A');
insert into service values('B','Service-B');
insert into service values('C','Service-C');
insert into service values('D','Service-D');

-- select * from service;

create table product_service
(
    product_code varchar(10),
    product_desc varchar(50),
    service_order varchar(50)
);

insert into product_service values('P1','PROD-P1','A,C');
insert into product_service values('P2','PROD-P2','C,B,D');
insert into product_service values('P3','PROD-P3','D,A,C,B');
insert into product_service values('P4','PROD-P4','A,B,C,D');
insert into product_service values('P5','PROD-P5','D,C,B,A,B');*

select product_code,product_desc,service_order,--l,
    listagg(service.service_name,',') within group(order by l) exp_result
    --regexp_substr(service_order,'(.*?,){'||(l-1)||'}([^,]*)',1,1,'',2)
    from product_service,service,
    lateral(select level l from dual connect by level<=regexp_count(service_order,',')+1)
    where service.service_code=regexp_substr(service_order,'(.*?,){'||(l-1)||'}([^,]*)',1,1,'',2)
    group by product_code,product_desc,service_order
    order by product_code;


------------------------------------------end--------------------------------------------------------------------------------------------
