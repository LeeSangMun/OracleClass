SELECT *
FROM all_users
WHERE username = UPPER('hr'); -- 대문자로 변환
-- WHERE username = 'HR';

-- (1) 오라클 예약어 확인 - date 예약어 확인
SELECT *
FROM DICTIONARY
WHERE table_name LIKE '%WORDS%';

SELECT *
FROM V_$RESERVED_WORDS
WHERE keyword = 'DATE';

-- 스키마.객체명 -> 별명 시노님
SELECT *
FROM scott.emp;

SELECT *
FROM dba_tables -- 
--FROM user_tables; -- 현재 사용자(user)의 소유한 테이블 정보만 조회
--FROM all_tables; -- 현재 사용자 소유한 테이블 + 권한 부여된 테이블 정보를 조회
where TABLE_NAME='DUAL';


CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

SELECT *
FROM arirang;

GRANT SELECT ON arirang TO hr;

DROP PUBLIC SYNONYM arirang;

SELECT *
--FROM all_synonyms;
FROM user_synonyms;
