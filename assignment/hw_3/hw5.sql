CREATE OR REPLACE PROCEDURE SelectTimeTable( sStudentId IN CHAR, nYear IN NUMBER, nSemester IN NUMBER)
IS
    sId COURSE.C_ID%TYPE; -- 과목번호
    sName COURSE.C_NAME%TYPE; -- 과목명
    nUnit COURSE.C_UNIT%TYPE; -- 학점
    nTime TEACH.T_TIME%TYPE; -- 교시
    sWhere TEACH.T_WHERE%TYPE; -- 강의실
    nTotUnit NUMBER := 0; -- 총학점
    CURSOR cur IS
      SELECT c.c_id, c.c_name, c.c_unit, t.t_time, t.t_where -- 과목번호, 과목명, 학점, 교시, 강의실
      FROM enroll e, course c, teach t
      WHERE e.s_id = sStudentId AND e.e_year = nYear AND e.e_semester = nSemester AND
             t.t_year = nYear AND t.t_semester = nSemester AND c.c_id = e.c_id AND t.c_id = e.c_id
      ORDER BY t.t_time;
BEGIN
      OPEN cur;
      DBMS_OUTPUT.put_line('<수강신청 시간표>');
      DBMS_OUTPUT.put_line('학번:' || sStudentId);
      DBMS_OUTPUT.put_line('년도:' || TO_CHAR(nYear));
      DBMS_OUTPUT.put_line('학기:' || TO_CHAR(nSemester));
      LOOP
        FETCH cur INTO sId, sName, nUnit, nTime, sWhere;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.put_line('교시:'||TO_CHAR(nTime)||', 과목번호:'||sID||', 과목명:'||sName||', 학점:'||TO_CHAR(nUnit)||', 강의실:'|| sWhere);
        nTotUnit := nTotUnit + nUnit;
      END LOOP;
      DBMS_OUTPUT.put_line('총 '||TO_CHAR(cur%ROWCOUNT)||' 과목과 총'||TO_CHAR(nTotUnit)||'학점을 신청하였습니다.');
      CLOSE cur;
END;
