CREATE OR REPLACE FUNCTION Date2EnrollSemester(dDate IN DATE)
RETURN NUMBER
IS
  nSemester NUMBER;
  sMonth CHAR(2);
BEGIN
  sMonth := TO_CHAR(dDate,'MM');

  IF ((sMonth >= '10' and sMonth <= '12') or (sMonth >= '01' and sMonth <= '03')) THEN
      nSemester := 1;
  ELSE
      nSemester := 2;
  END IF;

  RETURN nSemester;
END;
