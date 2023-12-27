-- scott

-- SQL 수행 과정 이해 --
-- Opimizer 검색 --

-- HR 계정(샘플 계정)

-- HR 계정의 상태 확인
-- 일반 사용자는 dba_XXX 사용불가
SELECT *
FROM dba_users;

-- DQL문 : select --
-- 1) 데이터 가져오는 데 사용하는 SQL문
-- 2) 대상 : 테이블, 뷰
-- 3) 사용자가 소유한 테이블 이거나 뷰면 가능
--       SELECT 권한
       
SELECT *
FROM emp;

-- SELECT 문 절 순서
--[WITH 절]            -- 1
--SECELT 절          --6
--FROM 절          -- 2 
--[WHERE 절]  -- 3
-- 계층 절 hierarchical_query_cause
--[GROBP BY절]  -- 4
--[HAVING 절 ]  -- 5
--[ORDER BY 절]  -- 7

INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-87', 'dd-MM-yy')-51,1100,NULL,20);  

INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-87', 'dd-MM-yy')-85,3000,NULL,20);

COMMIT;

-- scott 사용자가 소유한 테이블 정보 조회
SELECT * -- * -> 모든 목록 조회
FROM tabs; -- 뷰 [데이터 사전]에 저장되어있음

-- emp 테이블의 모든 사원 정보조회
SELECT *
FROM emp;

-- emp 테이블의 구조 확인
DESCRIBE emp;
DESC emp;

-- emp 테이블의 사원 정보(사원번호, 사원명, 입사일자) 조회
SELECT empno, ename, hiredate
FROM emp;

-- dept 테이블의 구조 확인
DESC dept;

-- dept 테이블의 모든 컬럼을 조회
SELECT *
FROM dept;

-- emp 테이블의 job을 조회
-- 각 사원들의 job을 조회
SELECT job
FROM emp;

--CLERK
--SALESMAN
--SALESMAN
--MANAGER
--SALESMAN
--MANAGER
--MANAGER
--PRESIDENT
--SALESMAN
--CLERK
--ANALYST
--CLERK
--CLERK
--ANALYST


-- 사원들의 job 종류만 조회 // 중복제거
SELECT DISTINCT job
FROM emp;

--CLERK
--SALESMAN
--PRESIDENT
--MANAGER
--ANALYST

-- 사원들의 job 종류만 조회해서 카운트
SELECT COUNT(DISTINCT job), COUNT(job)
FROM emp;

-- emp 테이블에서 각사원의 사원명, 입사일자 조회
-- 80(RR)/12(MM)/17(DD) 년/월/일 NLS
--  YY/MM/DD 와는 다르다.
SELECT ENAME, HIREDATE
FROM emp;

--[문제] emp 테이블에서 사원의 부서번호, 사원명, 급여(sal+comm) 조회
-- 커미션 미확인된 값(null)은 0으로 처리 -> null 처리
-- NULL이 나온다.
-- 어떤 값을 null과 연산하면 null이 나온다.
-- as(alias)
SELECT DEPTNO, ename
--        , NVL(comm, 0)+sal as "pay"
--        , NVL(comm, 0)+sal "pay"
--        , NVL(comm, 0)+sal my pay // 에러
--        , NVL(comm, 0)+sal "my pay"
        , NVL(comm, 0)+sal my_pay
        , (NVL(comm, 0)+sal)*12 연봉
FROM emp;

-- emp 테이블에서 모든 사원정보를 조회
SELECT ENAME, HIREDATE
FROM emp;

-- emp 테이블에서 deptno 30 부서원들만 조회 (deptno, ename, job, hiredate, pay)
SELECT deptno, ename, job, hiredate
--        , NVL(sal+comm, sal) pay
        , sal + NVL(comm, 0) pay
FROM emp
WHERE deptno=30;

-- emp 테이블에서 20, 30 부서원의 정보를 조회
-- SELECT deptno, * // 구문 오류
-- SELECT deptno, emp.* // ok
SELECT deptno, ename, job, hiredate
FROM emp
WHERE deptno in (20,30);

SELECT deptno, ename, job, hiredate
FROM emp
WHERE deptno in 10 AND job='CLERK'; -- 검색어는 대소문자 구분 해야 한다.

-- scott 계정 + insa.sql 스크립트파일 열어서 테이블 생성, INSERT 문

desc insa;

-- 1) 서울 사람의 이름(name), 출신도(city), 부서명(buseo), 직위(jikwi) 출력 
-- + 이름순으로 오름차순 정렬
-- + 부서별로 1차 오름차순 정렬 2차 이름으로 내림차순
SELECT name, city, buseo, jikwi
FROM insa
where city='서울'
ORDER BY buseo, name DESC;

-- 2) 출신도가 서울 사람이면서 기본급이 150만원 이상인 사람 출력 (name, city, basicpay, ssn) 
SELECT name, city, basicpay, ssn
FROM insa
where city='서울' AND basicpay >= 1500000;

-- 3) 출신도가 서울 사람이거나 부서가 개발부인 자료 출력 (name, city, buseo) 
SELECT name, city, buseo
FROM insa
where city='서울' OR buseo='개발부';

-- 4) 출신도가 서울, 경기인 사람만 출력 (name, city, buseo) 
SELECT name, city, buseo
FROM insa
where city in ('서울', '경기');

-- 5) 급여(basicpay + sudang)가 250만원 이상인 사람. 단 필드명은 한글로 출력. (name, basicpay, sudang, basicpay+sudang)
-- SELECT 절들의 처리 순서 때문에 where에서는 별칭을 못쓴다.
-- + pay 내림차순
SELECT name, basicpay, sudang, basicpay+sudang  pay
FROM insa
WHERE basicpay+sudang >= 2500000
ORDER BY pay DESC;

-- 직속상사(mgr)가 없는 사원의 정보를 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- mgr 자리에 null -> BOSS 로 변경
SELECT empno, ename, job, nvl(cast(mgr as varchar(4)) , 'BOSS'), hiredate
FROM emp
WHERE mgr IS NULL;
