-- 4일차 복습
SELECT COUNT(DISTINCT job)
FROM emp;

SELECT DISTINCT job, (SELECT COUNT(DISTINCT job) FROM emp)
FROM emp;


SELECT ssn
        , SUBSTR(ssn, 1, 2) year
        , EXTRACT(MONTH FROM TO_DATE(SUBSTR(ssn, 1, 6))) month  
        , SUBSTR(ssn, 5, 2) "date"
        , SUBSTR(ssn, 8, 1) gender
FROM insa;

SELECT name, SUBSTR(ssn, 1, 8) || '******' rrn
FROM insa
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 1 AND ssn LIKE '7%';

SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_12%';

SELECT ename
        , NULLIF(ename, 'SMITH')
FROM emp;

-- COALESCE : 합동하다.
SELECT sal, comm
        , sal + NVL(comm, 0) pay
        , sal + NVL2(comm, comm, 0) pay
        , COALESCE(sal+comm, sal, 0) pay
FROM emp;

SELECT name, ssn
        , NVL2(NULLIF(SUBSTR(ssn, 8, 1), '2'), 'O', 'X')
        , NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1) gender
        , NVL2(NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1), '여자', '남자')
FROM insa;

SELECT SYSDATE
        , TO_CHAR(SYSDATE, 'CC') -- 21세기
        , TO_CHAR(SYSDATE, 'SCC') -- 21세기
FROM dual;

-- '05/01/10'
SELECT '05/01/10'
        , TO_CHAR( TO_DATE('05/01/10', 'RR/MM/DD'), 'YYYY') rr -- 2005
        , TO_CHAR( TO_DATE('05/01/10', 'YY/MM/DD'), 'YYYY') yy -- 2005
        , TO_CHAR( TO_DATE('97/01/10', 'RR/MM/DD'), 'YYYY') -- 1997
        , TO_CHAR( TO_DATE('97/01/10', 'YY/MM/DD'), 'YYYY') -- 2097
FROM dual;

SELECT ename, hiredate
        , TO_CHAR(hiredate, 'YYYY')
FROM emp;

SELECT ename, REPLACE(ename, UPPER('m'), '*')
FROM emp
WHERE ename LIKE '%'||UPPER('m')||'%';
--WHERE UPPER(ename) LIKE '%M%';

-- [문제] emp 테이블에서 ename 'la' 대소문자 구분없이 있는 사원 조회
SELECT ename
        , REPLACE(ename, 'LA', '<span style="color:red">LA</span>')
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i'); -- i옵션은 대소문자 상관없이
-- match_option : i(대소문자 구분x), c(대소문자 구분o), m(멀티 라인), x(공백문자 무시)
--WHERE ename LIKE '%la%' OR ename LIKE '%lA%' OR ename LIKE '%La%' OR ename LIKE '%LA%' ;

-- 복수행 함수
SELECT COUNT(*)
FROM emp;

-- 단일행 함수
SELECT LOWER(ename)
FROM emp;

-- insa 테이블에서 남자사원만
--WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn,-7,1), 2) = 1;
SELECT ssn
FROM insa
WHERE REGEXP_LIKE(ssn, '^7.{6}[13579]');

-- [문제] insa 테이블에서 성이 김씨, 이씨만 조회
-- 1) LIKE
SELECT *
FROM insa
WHERE name LIKE '김%' OR name LIKE '이%';

-- 2) REGEXP_LIKE()
SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[김이]');

-- [문제] insa 테이블에서 성이 김씨, 이씨를 제외한 사원 조회
-- 1) LIKE
SELECT *
FROM insa
WHERE NOT (name LIKE '김%' OR name LIKE '이%');

-- 2) REGEXP_LIKE()
SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[^김이]');

SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
FROM emp
ORDER BY pay DESC;

-- SQL연산자 ALL 사용
WITH temp AS (
    SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
    FROM emp
)
SELECT *
FROM temp
--WHERE pay <= ALL (SELECT pay FROM temp); -- 제일 작은
WHERE pay >= ALL (SELECT pay FROM temp); -- 제일 큰

SELECT MAX(sal + NVL(comm, 0)) max_pay
        , MIN(sal + NVL(comm, 0)) min_pay
FROM emp;

SELECT deptno, ename, sal+NVL(comm, 0) pay
FROM emp
WHERE sal+NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) max_pay FROM emp);
--WHERE sal+NVL(comm, 0) = 5000;

-------------------------------------------------------------------------

-- [집합연산자(Set Operator)]
-- 1) 두 테이블의 컬럼 수가 같고, 
-- 2) 대응되는 컬럼끼리 데이터 타입이 동일해야 한다.
-- 3) 컬럼이름은 달라도 상관 없으며, 
-- 4) 집합 연산의 결과로 출력되는 컬럼의 이름은 첫 번째 select 절의 컬럼 이름을 따른다.
-- 5) 합집합 : UNION, UNION ALL
--    교집합 : INTERSECT
--    차집합 : MINUS

-- emp + insa 모든 사원 정보를 조회
SELECT empno, ename, hiredate
FROM emp
UNION
SELECT num, name, ibsadate
FROM insa;

-- [UNION과 UNION ALL의 차이점]
-- 1) insa 테이블의 개발부 조회
SELECT name, city, buseo
FROM insa
WHERE buseo='개발부'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city='인천';
-- 3) INTERSECT
-- 4) 차집합
SELECT name, city, buseo
FROM insa
WHERE buseo='개발부'
UNION ALL
-- 2) insa 테이블의 출신지역 : 인천 조회
SELECT name, city, buseo
FROM insa
WHERE city='인천';

-- [문제] insa 테이블에서 여자 o,남자 x
SELECT name,  NVL2(NULLIF(MOD(SUBSTR(ssn,-7, 1), 2), 1), 'X', 'O') gender
FROM insa;


-- 집합연산자()
-- 1) 남자 조회
SELECT name
FROM insa
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 1;
-- 2) 여자 조회
SELECT name, ssn, 'X' gender
FROM insa
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 1;

--IS NAN == NOT A number
--IS [NOT] INFINITE

---------------------------------------------------------

--1. 오라클 함수 정의
--2.      "기능"
--3.      "종류" 
_______________________________________________________________
--(1) 숫자함수
--    ROUND() - 반올림함수
SELECT ROUND(15.193) a
        , ROUND(15.193, 1)
--        , ROUND(15.193, n) -- 소수점 n+1 자리에서 반올림
        , ROUND(15.193, -1) -- 소수점을 기준. 일의 자리에서 반올림
        , ROUND(15.193, -2) -- 십의 자리에서 반올림
FROM dual;

--    CELL() - 올림함수
-- 지정된 숫자보다 같거나 큰 정수 중에 가장 최소값
SELECT CEIL(15.193)
        , CEIL(15.913)
FROM dual;

--    FLOOR() - 내림함수, TRUNC()
-- 지정된 숫자보다 작거나 같은 정수 중에 최대값
SELECT FLOOR(15.193)
        , FLOOR(15.913)
FROM dual;

-- 15.193 숫자를 소수점 2자리에서 절삭 <- TRUNC(절삭 위치) 사용
SELECT FLOOR(15.8193)
        , FLOOR(15.8193*10)/10
        , TRUNC(15.8193, 1)
        , TRUNC(15.8193, 2)
        , TRUNC(15.8193, -1) -- 일의 자리에서 절삭
FROM dual;

-- 소수점 3자리에서 반올림해서 소수점 2자리까지 출력.
SELECT 10/3
        , ROUND(10/3, 2)
FROM dual;

-- 나머지 MOD(), REMAINDER()
SELECT MOD(19,4)
        , REMAINDER(19, 4)
FROM dual;

-- MOD(n2, n1)          = n2-n1*FLOOR(n2/n1)
-- REMAINDER(n2, n1)    = n2-n1*ROUND(n2/n1)

--ABS() - 절댓값
SELECT ABS(100), ABS(-100)
        , SIGN(100), SIGN(-100)
        , SIGN(0)
        , POWER(2,3)
        , SQRT(2)
FROM dual;

--(2) 문자함수
-- UPPER()
-- LOWER()
-- INITCAP()
-- CONCAT()
-- SUBSTR()

-- LENGTH()
SELECT DISTINCT job
        , LENGTH(job)
FROM emp;

-- emp 테이블에서 ename에 M 문자가 있는 사원 조회
-- L 문자가 있는 위치값을 조회
SELECT ename, job, INSTR(ename, 'L')
FROM emp
WHERE REGEXP_LIKE(ename, 'L', 'i');
--WHERE ename LIKE '%M%';

-- INSTR()
SELECT INSTR('corporate floor','or') 
        , INSTR('corporate floor','or', 1, 3)
        , INSTR('corporate floor','or', -1, 3)
        , INSTR('corporate floor','or', 4) 
        , INSTR('corporate floor','or', 4, 2)
FROM dual;

-- RPAD() / LPAD()
-- PAD == 패드, 덧 대는 것, 매워 넣는 것
-- 형식) RPAD(expr1, n[, expr2])

-- 100 #
SELECT ename, sal + NVL(comm, 0) pay
        , ROUND(sal + NVL(comm, 0), -2)
        , ROUND(sal + NVL(comm, 0), -2)/100
        , RPAD(' ', ROUND(sal + NVL(comm, 0), -2)/100+1, '#')
        , RPAD(ROUND(sal + NVL(comm, 0), -2)/100, ROUND(sal + NVL(comm, 0), -2)/100+LENGTH(TO_CHAR(ROUND(sal + NVL(comm, 0), -2)/100)), '#')
--        , LPAD(sal + NVL(comm, 0), 10, '*')
--        , RPAD(sal + NVL(comm, 0), 10, '*')
FROM emp;

-- RTRIM() / LTRIM(), TRIM()
SELECT '[' || '   admin   ' || ']'
        , '[' || LTRIM('   admin   ') || ']'
        , '[' || RTRIM('   admin   ') || ']'
        , '[' || TRIM('   admin   ') || ']'
        , '[' || LTRIM('xyxyadminxyxy', 'xy') || ']'
        , '[' || RTRIM('xyxyadminxyxy', 'xy') || ']'
FROM dual;

-- ASCII(), CHR()
SELECT ASCII('A'), ASCII('a'), ASCII('0')
        , CHR(65), CHR(97), CHR(48)
FROM dual;

-- GREATEST() / LEAST()
SELECT GREATEST(3,5,2,4,1)
        , LEAST(3,5,2,4,1)
        , GREATEST('MBC', 'TVC', 'SBS')
FROM dual;

-- REPLACE

-- VSIZE()
SELECT VSIZE('a'), VSIZE('한')
FROM dual;




--(3) 날짜함수
--(4) 변환함수
--(5) 일반함수 - 정규표혀닉 함수
--(6) 집계함수
        

CREATE TABLE TEST (
    ID VARCHAR2(20) PRIMARY KEY,
    NAME VARCHAR2(20),
    EMAIL VARCHAR2(20)
);

INSERT INTO test(id, name, email)
VALUES(1, '한라산', '');
INSERT INTO test(id, name, email)
VALUES(2, '백두산', '');
INSERT INTO test(id, name, email)
VALUES(3, '금강산', '');

SELECT *
FROM test;

