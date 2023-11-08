drop user c##test cascade;

-- test 사용자 생성하기
CREATE USER c##test IDENTIFIED BY database;


-- Grant 명령어로 접속, 사용 권한 주기
grant connect, resource, create view  to c##test;


alter user c##test default tablespace USERS quota unlimited on USERS;