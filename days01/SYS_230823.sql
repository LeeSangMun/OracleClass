show user;
select * from all_users;

SELECT *
FROM dba_users;

CREATE USER ������ IDENTIFIED BY ��й�ȣ;
CREATE USEr scott  IDENTIFIED BY tiger;

-- CREATE SESSION �ý��� ���� �ο�
-- 1) SYS ���� ����
SHOW USER;
-- 2) ���� �ο�
GRANT CREATE SESSION TO scott;
GRANT CONNECT, RESOURCE TO scott; -- �� �ο�
-- 3) ���� ȸ��
REVOKE CREATE SESSION FROM scott;

-- �̸� ���ǵ� �Ѱ� �ü�������� ��
-- 1) ����Ŭ ��ġ �� �̸� ���ǵ� ���� ��ȸ
SELECT *
FROM dba_roles;

-- scott ���� ����
-- 1) SYS ����
-- ORA-01940: cannot drop a user that is currently connected
DROP USER scott;

SELECT *
FROM all_users;