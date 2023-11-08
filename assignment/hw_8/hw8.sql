CREATE OR REPLACE PROCEDURE InsertEnroll(sStudentId IN CHAR, sCourseId IN CHAR, result OUT VARCHAR2) -- 입력 결과 메시지
IS
  too_many_sumCourseUnit EXCEPTION;
  too_many_courses EXCEPTION;
  too_many_students EXCEPTION;
  duplicate_time EXCEPTION;
  nYear NUMBER; -- 수강신청 년도
  nSemester NUMBER; -- 수강신청 학기
  nSumCourseUnit NUMBER; -- 수강신청완료된 과목들의 총학점
  nCourseUnit NUMBER; -- 학점
  nCnt NUMBER;
  nTeachMax NUMBER; -- (수강신청 년도,학기,과목에 대한) 최대 학생수(최대 정원)

BEGIN
  result := '';

  DBMS_OUTPUT.put_line('#');
  DBMS_OUTPUT.put_line(sStudentId || '님이 과목번호 ' || sCourseId || '의 수강 등록을 요청하였습니다.');

  /* (수강신청하는 오늘 날짜를 기준으로) 수강신청 년도, 학기 알아내기 : 함수 사용 */
  nYear := Date2EnrollYear(SYSDATE); -- 수강신청 년도
  nSemester := Date2EnrollSemester(SYSDATE); -- 수강신청 학기

  /* 에러 처리 1 : 최대학점(18 학점) 초과 여부 검사 */
  -- (수강신청 년도, 학기에 해당 학생의) 수강신청 완료(enroll 테이블에 저장 완료)된 과목들의 총학점
  SELECT SUM(c.c_unit)
  INTO nSumCourseUnit
  FROM course c, enroll e
  WHERE e.s_id = sStudentId and e.e_year = nYear and e.e_semester = nSemester
  and e.c_id = c.c_id;

  -- 현재 수강신청을 하려고 하는 과목의 학점을 검색하여 nCourseUnit 변수에 저장
  SELECT c_unit
  INTO nCourseUnit
  FROM course
  WHERE c_id = sCourseId ;

  -- 수강신청 완료된 과목들의 총학점 + 현재 수강신청을 하려고 하는 과목의 학점 > 18 인지 검사
  IF(nSumCourseUnit + nCourseUnit > 18)
  THEN
    RAISE too_many_sumCourseUnit;
  END IF;

  /* 에러 처리 2 : 동일한 과목 신청 여부 검사 */
  -- 해당 학생의 수강신청 완료(enroll 테이블에 저장 완료)된 과목 중, 현재 수강신청을 하려고 하는 과목이 있는지 검사
  SELECT COUNT(*)
  INTO nCnt
  FROM enroll
  WHERE s_id = sStudentId and c_id = sCourseId;

  IF (nCnt > 0)
  THEN
    RAISE too_many_courses;
  END IF;

  /* 에러 처리 3 : 수강신청 인원 초과 여부 검사 */
  -- (수강신청 년도,학기,과목에 대한) 최대 학생수(최대 정원) 검색
  SELECT t_max
  INTO nTeachMax
  FROM teach
  WHERE t_year= nYear and t_semester = nSemester and c_id = sCourseId;

  -- (수강신청 년도,학기,과목으로) 이미 수강신청 완료(enroll 테이블에 저장 완료)된 학생수 검색하여 nCnt 변수에 저장
  SELECT COUNT(*)
  INTO nCnt
  FROM enroll
  WHERE e_year = nYear and e_semester = nSemester and c_id = sCourseId;

  -- (수강신청 년도,학기,과목에 대한) 수강신청 완료 학생수 >= (수강신청 년도,학기,과목에 대한)최대 학생수 인지 검사
  IF (nCnt >= nTeachMax)
  THEN
    RAISE too_many_students;
  END IF;

  /* 에러 처리 4 : 신청한 과목들 시간 중복 여부 */
  -- (수강신청 년도,학기에) 수강신청하려고 하는 과목의 교시(수업시간)와
  -- (수강신청 학생,년도,학기로) 이미 수강신청 완료된 과목들의 교시(수업시간)
  -- 중 중복되는 교시(수업시간)가 있는지 검사
  SELECT COUNT(*)
  INTO nCnt
  FROM
  (
      SELECT t_time
      FROM teach
      WHERE t_year=nYear and t_semester = nSemester and c_id = sCourseId
      INTERSECT
      SELECT t.t_time
      FROM teach t, enroll e
      WHERE e.s_id=sStudentId and e.e_year=nYear and e.e_semester = nSemester and
            t.t_year=nYear and t.t_semester = nSemester and
            e.c_id=t.c_id
  );

  IF (nCnt > 0)
  THEN
    RAISE duplicate_time;
  END IF;

  /* 수강 신청 : Enroll 테이블에 학번,과목번호,수강년도, 수강학기 입력 */
  INSERT INTO enroll(S_ID, C_ID, E_YEAR, E_SEMESTER) VALUES(sStudentId, sCourseId, nYear, nSemester);
  COMMIT;
  result := '수강신청 등록이 완료되었습니다.';
EXCEPTION
  WHEN too_many_sumCourseUnit THEN
    result := '최대학점을 초과하였습니다.';
  WHEN too_many_courses THEN
    result := '이미 등록된 과목을 신청하였습니다.';
  WHEN too_many_students THEN
    result := '수강신청 인원이 초과되어 등록이 불가능합니다.';
  WHEN duplicate_time THEN
    result := '이미 등록된 과목 중 중복되는 시간이 존재합니다.';
  WHEN OTHERS THEN
    result := SQLCODE;
END;
