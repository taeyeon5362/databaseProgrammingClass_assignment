CREATE OR REPLACE FUNCTION Date2EnrollYear(dDate IN DATE)
RETURN NUMBER
IS
  nYear NUMBER;
  sMonth CHAR(2);
BEGIN
  /* 10 월 ~ 12 월 : 매개변수로 받은 날짜의 다음 년도, 10 월~12 월 외 : 매개변수로 받은 날짜의 년도 */
  nYear := TO_NUMBER(TO_CHAR(dDate,'YYYY')); -- 매개변수로 받은 날짜 중 '년도' 추출
  sMonth := TO_CHAR(dDate,'MM'); -- 매개변수로 받은 날짜 중 '월' 추출

  IF (sMonth = '10' OR sMonth = '11' OR sMonth = '12') THEN
  nYear := nYear + 1;
  END IF;

  RETURN nYear;
END;
