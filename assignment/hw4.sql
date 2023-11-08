create or replace trigger sal_trigger
before
insert or delete or update
on emp
for each row

declare
    sal_trigger exception;
begin
    if :new.sal < 10 then
        raise sal_trigger;
    end if;
exception
    when sal_trigger then
      raise_application_error(-20005,'급여부족');
end;

insert into emp(empno, sal) values(30,5);
