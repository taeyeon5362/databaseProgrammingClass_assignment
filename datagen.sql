drop table empbig;
CREATE TABLE EMPBIG
   (EMPNO NUMBER(10) CONSTRAINT PK_EMPBIG PRIMARY KEY, -- i 값으로
	ENAME VARCHAR2(10), -- dbms_random.string('U',6)   text1
	JOB VARCHAR2(9), -- text2
	MGR NUMBER(4),  -- round(dbms_round.value(1,100))    no1
	HIREDATE DATE, -- to_date('94/01/01','YY/MM/DD') + dbms_random.value(0,10) date1
	SAL NUMBER(7,2),  -- round(dbms_random.value(1000,9000))   no2
	COMM NUMBER(7,2),  -- round(dbms_random.value(0, 5000))  no3
	DEPTNO NUMBER(2)  -- round(dbms_random.value(1,4))*10   no4
	);



Set ServerOutput On;

DECLARE
   no1 number;
   no2 number;
   no3 number;
   no4 number;
   date1 DATE;
   text1 VARCHAR2(10);
   text2 VARCHAR2(10);
   id number;
BEGIN

  id := 0;

  FOR i IN 1..10000 LOOP

     SELECT dbms_random.string('U',6),round(dbms_random.value(1,100)),to_date('94/01/01','YY/MM/DD') + dbms_random.value(0,10), round(dbms_random.value(1000,9000)) , round(dbms_random.value(0, 5000)), round(dbms_random.value(1,4))*10 into text1, no1, date1, no2, no3, no4 from dual;


     SELECT mod(i,5) INTO id FROM dual;
     IF id=0 THEN text2 := 'CLERK'; 
     ELSIF id=1 THEN text2 := 'SALESMAN';
     ELSIF id=2 THEN text2 := 'PRESIDENT';
     ELSIF id=3 THEN text2 := 'MANAGER';
     ELSE  text2 := 'ANALYST';
     END IF;


     IF id <3 THEN -- COMM에 데이터 입력
       insert into empbig values (i, text1, text2, no1, date1, no2, no3, no4);
     ELSE
       insert into empbig(empno, ename, job,mgr,hiredate,sal,deptno) values (i, text1, text2, no1, date1, no2, no4);
     END IF;

END LOOP;

DBMS_OUTPUT.PUT_LINE('!!! 10000 data generation completed !!!');
COMMIT;

END;
