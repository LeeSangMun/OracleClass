show user;
select * from all_users;

SELECT *
FROM dba_users;

CREATE USER 계정명 IDENTIFIED BY 비밀번호;
CREATE USEr scott  IDENTIFIED BY tiger;

-- CREATE SESSION 시스템 권한 부여
-- 1) SYS 계정 접속
SHOW USER;
-- 2) 권한 부여
GRANT CREATE SESSION TO scott;
GRANT CONNECT, RESOURCE TO scott; -- 롤 부여
-- 3) 권한 회수
REVOKE CREATE SESSION FROM scott;

-- 미리 정의된 롤과 운영체제에서의 룰
-- 1) 오라클 설치 후 미리 정의된 롤을 조회
SELECT *
FROM dba_roles;

-- scott 계정 삭제
-- 1) SYS 접속
-- ORA-01940: cannot drop a user that is currently connected
DROP USER scott;

SELECT *
FROM all_users;