Set ServerOutput On
declare
  cursor dept_info is
      select deptno, dname
      from dept;
  v_deptno dept.deptno%type;
  v_dname dept.dname%type;
  nSum number := 0;
begin
  open dept_info;
  loop
      fetch dept_info into v_deptno, v_dname;
      exit when dept_info%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('부서번호 : ' || v_deptno || '부서이름 : ' || v_dname);
      if(mod(v_deptno, 4) = 0) then
          nSum := nSum + v_deptno;
      end if;
  end loop;
  close dept_info;
  DBMS_OUTPUT.PUT_LINE('4의 배수인 부서번호의 합계 :' ||to_char(nSum));
end;
