CREATE OR REPLACE PROCEDURE register_emp
    (v_empno IN number,
     v_ename IN varchar2,
     v_deptno IN number )IS
BEGIN
  INSERT INTO emp(empno, ename, deptno) VALUES (v_empno, v_ename, v_deptno);
  exception
  when DUP_VAL_ON_INDEX then
    DBMS_OUTPUT.PUT_LINE('중복 데이터로 등록 불가');
  when others then
    DBMS_OUTPUT.PUT_LINE('기타 에러 발생');
END;

select empno, ename, deptno from emp where empno = 10;
