select *
from emp
where ename like '_A%' and length(ename = 5;


select empno, ename, to_cahr(hiredate, 'YYYY-MM-DD')
from emp
where empno >= 7800;


select LOWER(substr(ename, 1, 3))
from emp
where empno >= 7800;


select a.empno, a.ename, b.dname
from emp a, dept b
where a.deptno = b.deptno and a.job in (select job from emp where deptno = 10) and a.deptno = 20
order by a.ename;


select d,deptno, dname, count(*) 사원수, avg(sal) 급여평균 
from emp e, dept d
where e.deptno = d.deptno
group by d.deptno, dname
having count(*) >= 4 and avg(Sal) >= 1000;


select empno, ename, sal*12+nvl(comn, 0) 연봉
from emp
order by 3 desc;

select job, avg_sal,
        case when avg_sal >= 3000 then 'Excellent'
            when avg_sal >= 2000 then 'good'
            else 'well'
        end as GRADE
from (select job, avg(sal) avg_sal from emp where mgr is not null group by job);


select orker, empno, worker.ename 사원이름, manager.ename 관리자명
from emp worker, emp manager
where worker.mgr = manager.empno and manager.ename= 'JONES';


select 
      case when sal (Select max(sal) from emp) then '최대급여사원 : '
      else '최소급여사원 : '
      end || ename as ename, sal
from emp
where sal = (Select max(Sal) from emp) or sal = (Select min(Sal) from emp)
order by sal desc;
