-- 2일차 복습 
-- 11번
SELECT buseo, name, basicpay+sudang pay
	FROM insa
	WHERE 2000000 <= basicpay+sudang AND basicpay+sudang <= 2500000
	ORDER BY buseo, pay DESC;
    
DESC insa;

WITH e AS
(
    SELECT buseo, name, basicpay+sudang pay
    FROM insa
)
--, d AS 
--(
--    SELECT deptno, dname
--    FROM dept
--)
SELECT e.*, e.buseo, e.name, e.pay
FROM e
WHERE pay BETWEEN 2000000 AND 2500000;

-- 인라인 뷰(INLINE VIEW)
SELECT *
FROM (
        SELECT buseo, name, basicpay+sudang pay
        FROM insa
     ) 
WHERE pay BETWEEN 2000000 AND 2500000;

-- 12번
SELECT empno, ename, hiredate
FROM emp
--WHERE hiredate >= '81/1/1' AND hiredate <= '81/12/31'
--WHERE hiredate BETWEEN '81/1/1' AND '81/12/31'
ORDER BY hiredate;


SELECT *
FROM dual;

DESC dual;

-- 오늘 날짜 조회
SELECT SYSDATE 
    , EXTRACT(YEAR FROM SYSDATE) year
    , EXTRACT(MONTH FROM SYSDATE) month
    , EXTRACT(DAY FROM SYSDATE) day
    , TO_CHAR(SYSDATE, 'YY')
FROM dual;

-- 두 사원을 삭제
DELETE 
FROM emp
where empno IN (7876,7788);
--ROLLBACK;
COMMIT;
SELECT empno, ename, hiredate
    , EXTRACT(YEAR FROM hiredate) h_year  
FROM emp
WHERE SUBSTR(hiredate, 1, 2) = '81'
--WHERE TO_CHAR(hiredate, 'YY') = 81 -- 오류가 안난다. 좋은 코딩은 아니다.
--WHERE TO_CHAR(hiredate, 'YY') = '81'
--WHERE EXTRACT(YEAR FROM hiredate) = 1981
ORDER BY hiredate ;

-- SUBSTR 함수 설명
SELECT SUBSTR('abcdesfg', 3,2)
        , SUBSTR('abcdefg',3)
        , SUBSTR('abcdefg', -3,2)
FROM dual; 


-- 14-3번 문제
-- number -> char
SELECT empno, ename, job
--        , NVL(comm, 'CEO') mgr
        , NVL(TO_CHAR(mgr), 'CEO') mgr
        , hiredate, sal, comm, deptno
FROM emp;

SELECT 'ABCd', UPPER('AbCd'), LOWER('AbCd'), INITCAP('AbCd')
FROM dual;

SELECT name
    -- 왼쪽 정렬은 문자, 오른쪽 정렬은 숫자
    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang) pay
    , TO_CHAR(basicpay + sudang, 'L99,999,999') pay, ibsadate
FROM insa;

------------------------------------------------------------------------------

-- [문제] insa 테이블에서 이름, 주민등록번호, 년도, 월, 일, 성별, 검증 조회
-- 문길수 721217-1****
SELECT name, SUBSTR(ssn, 0, 8) || '******' rrn, SUBSTR(ssn, 1, 2) 년도, SUBSTR(ssn, 3, 2) 월, SUBSTR(ssn, 5, 2) 일, SUBSTR(ssn, 8, 1) 성별
FROM insa;

SELECT name, SUBSTR(ssn, 0, 8) || '******' rrn
            , SUBSTR(ssn, 1, 2) "year"
            , SUBSTR(ssn, 3, 2) "month"
            , SUBSTR(ssn, 5, 2) "date" 
            , SUBSTR(ssn, 8, 1) gender
            , SUBSTR(ssn, -1)
FROM insa;

-- 오라클 연산자
1) 산술 연산자 + - * /
SELECT 1+2
        , 1-2
        , 1*2
        , 1/2
        -- , 2/0
        -- , 3.14/0
        -- , 1%2
        , MOD(1, 2)
FROM dual;

-- 2)연결 연산자(??) 

-- 3) 사용자 정의 연산자  CREATE OPERATOR 문으로 연산자를 생성할 수 있음

-- 4) 계층적 질의 연산자 

-- 5) 비교 연산자    =   !=  <>  ^=  >   <   >=  <=
    -- ANY, SOME, ALL
SELECT deptno
FROM dept;

SELECT *
FROM emp
WHERE deptno > ANY (SELECT deptno FROM dept);
--WHERE deptno <= ANY (SELECT deptno FROM dept);
--WHERE deptno <= ALL (SELECT deptno FROM dept); -- 10번 부서만 출력됨
--WHERE deptno <= 20;

-- 6) 논리 연산자 : AND OR NOT

-- 7) SQL 연산자
--  1) [NOT] IN (목록)
--  2) [NOT] BETWEEN a AND b
--  3) IS [NOT] NULL
--  4) ANY, SOME, ALL + WHERE 절 서브쿼리
--  5) EXISTS 상관 서브쿼리
--  6) 문자 패턴 검사할 떼
--      [NOT] LIKE  -   연산자
--        - 문자 패턴 검색할 때 사용된다.
--        - 패턴에 사용되는 기호 -> 와일드 카드 : % _
--        - 와일드 카드를 일반 문자처럼 사용하고 싶을 때 ESCAPE 옵션을 사용
--        REGEXP_LIKE     -   함수

-- emp 사원테이블에 R문자로 시작하는 사원을 검색
-- insa 테이블에 사원명이 '이'씨인 사원만 검색
-- insa 테이블에 사원명이 ' 이 '씨인 사원만 검색
-- insa 테이블에 사원명이 마지막에 '이'씨인 사원만 검색
SELECT *
FROM insa
WHERE name LIKE '%이';
--WHERE name LIKE '%이%';
--WHERE name LIKE '이%';
--WHERE SUBSTR(name, 1, 1)='이';

-- insa 테이블에 81년생 사원 정보 조회
SELECT *
FROM insa
WHERE ssn LIKE '81%';

-- insa 테이블에서 남자사원만 조회
SELECT *
FROM insa
WHERE ssn LIKE '______-1%';

-- 이름의 두 번째 글자가 '순'
SELECT *
FROM insa
WHERE name LIKE '_순%';

SELECT *
FROM dept;

-- 새로운 부서를 추가
INSERT INTO dept (deptno, dname, loc) 
VALUES(50, '한글_나라', 'SEOUL');
INSERT INTO dept (deptno, dname, loc) 
VALUES(60, '한100%나', 'SEOUL');
COMMIT;

-- 부서명에 '_나' 검색
SELECT *
FROM dept
WHERE dname LIKE '%\_나%' ESCAPE '\';

-- 부서명에 % 부서를 검색
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';

DESC dept;

-- UPDATE
--UPDATE 테이블명 SET 컬럼명=컬럼값 [WHERE 조건절] 
UPDATE dept 
SET loc='KOREA'
WHERE loc='SEOUL';

DELETE FROM dept
WHERE deptno >= 50;
COMMIT;

ROLLBACK;

-- [dual] ? PUBLIC SYNONYM 
-- scott 사용자가 소유하고 있는 테이블 정보 조회
SELECT *
FROM tabs;
SELECT *
FROM all_tables;

SELECT *
FROM arirang;


-- [오라클 함수]
