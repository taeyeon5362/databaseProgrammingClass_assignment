drop user c##test cascade;

-- test ����� �����ϱ�
CREATE USER c##test IDENTIFIED BY database;


-- Grant ��ɾ�� ����, ��� ���� �ֱ�
grant connect, resource, create view  to c##test;


alter user c##test default tablespace USERS quota unlimited on USERS;