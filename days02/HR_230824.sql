-- HR 계정이 소유하고 있는 테이블 정보 조회
SELECT *
FROM tabs;

-- << HR의 테이블 조사 >>

SELECT *
FROM employees;

DESC employees;

-- 사원 정보 first_name, last_name, name(전체이름) 별칭으로을 조회
SELECT first_name, last_name
        , CONCAT(CONCAT(first_name, ' '), last_name) NAME
        , first_name || ' ' || last_name
FROM employees;

-- 오라클 '문자열' // 문자열에 ''를 붙인다.
-- '날짜형식' // 날짜형식도 '' 붙임