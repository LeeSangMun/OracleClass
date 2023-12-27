-- 6일차 복습
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" TS (DY)')
FROM dual;

-- [9번 문제] Oracle 11g PARTITION OUTER JOIN 구문
WITH j AS (
    SELECT DISTINCT job
    FROM emp
)
SELECT deptno, j.job, SUM(COALESCE(sal+comm, sal, 0)) 
FROM j LEFT OUTER JOIN emp e PARTITION BY (deptno) ON j.job=e.job
GROUP BY deptno, j.job
ORDER BY deptno;

SELECT buseo, COUNT(*) count
FROM insa
WHERE MOD(SUBSTR(ssn, 8, 1), 2)=0
GROUP BY buseo
HAVING COUNT(*) >= 5;

-----------------------------------------------------------------
SELECT *
FROM emp;

SELECT *
FROM salgrade;

-- deptno, ename, sal, grade 조회 
SELECT deptno, ename, sal
    , CASE
        WHEN sal >= 700 AND sal <= 1200 THEN 1
        WHEN sal >= 1201 AND sal <= 1400 THEN 2
        WHEN sal >= 1401 AND sal <= 2000 THEN 3
        WHEN sal >= 2001 AND sal <= 3000 THEN 4
        WHEN sal >= 3001 AND sal <= 9999 THEN 5
      END grade
FROM emp;

-- NON EQAUL JOIN
SELECT deptno, ename, sal
    , losal || '~' || hisal
    , grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;

SELECT deptno, ename
FROM emp
ORDER BY deptno;

-- LISTAGG()
-- 10, KING, CLARK, MILLER ..
SELECT deptno
    , LISTAGG(ename, '\') WITHIN GROUP(ORDER BY ename)
FROM emp
GROUP BY deptno;


SELECT d.deptno
    , NVL(LISTAGG(ename, '\') WITHIN GROUP(ORDER BY ename), '사원없음')
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno=d.deptno
GROUP BY d.deptno;

-- GROUPING SETS 절
-- 예) GROUP BY exp1
--      UNION ALL
--    GROUP BY exp2

-- GROUPING SETS(exp1, exp2)
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT job, COUNT(*)
FROM emp
GROUP BY job;

SELECT deptno, job, COUNT(*)
FROM emp
GROUP BY GROUPING SETS (deptno, job);


-- emp테이블에서 급여를 가장 많이 받는 사원의 정보(empno, deptno, ename, pay) 조회
SELECT deptno, empno, ename, sal+NVL(comm, 0) pay
FROM emp
--WHERE sal+NVL(comm, 0) >= ALL (SELECT sal+NVL(comm, 0) FROM emp);
WHERE sal+NVL(comm, 0) = (SELECT MAX(sal+NVL(comm, 0)) FROM emp);

-- RANK 순위 함수
-- [TOP-N 분석]
--  1) ORDER BY 정렬된 인라인뷰
--  2) ROWNUM 의사컬럼 - 행마다 순서대로 번호를 부여하는 컬럼
--  3) n값은 < 또는 >=를 사용하여 정의하며, 반환될 행의 개수를 지정한다.

-- ROWID, ROWNUM -> 의사(pseudo) 컬럼
SELECT ROWID, ROWNUM, ename
FROM emp;

SELECT deptno, ename, hiredate, sal+NVL(comm,0) pay
FROM emp
ORDER BY pay DESC;

SELECT ROWNUM, e.*
FROM (
    SELECT deptno, ename, hiredate, sal+NVL(comm,0) pay
    FROM emp
    ORDER BY pay DESC
) e
--WHERE ROWNUM BETWEEN 3 AND 5; -- Top부터 n까지 가져올 수 있다.
WHERE ROWNUM <= 3;
--WHERE ROWNUM=1;


-- RANK 순위 함수
-- 1) RANK()
-- 2) DENSE_RANK()
-- 3) PERCENT_RANK()
-- 4) FIRST(), LAST()
-- 5) ROW_NUMBER() ***

SELECT e.*
FROM(
    SELECT deptno, ename, sal+NVL(comm, 0) pay
        , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm, 0) DESC) 급여순위
    FROM emp
) e
WHERE 급여순위 BETWEEN 3 AND 5;
--WHERE 급여순위 = 1;

-- [문제] emp테이블에서 각 부서별 최고급여를 받는 사원의 정보를 조회
-- (deptno, dname, ename, pay, hiredate, grade)
SELECT e.*
FROM(
    SELECT deptno, ename, sal+NVL(comm, 0) pay
        , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm, 0) DESC) 급여순위
    FROM emp
) e;

WITH temp AS(
    SELECT deptno, ename, sal, sal+NVL(comm,0) pay, hiredate
    , grade
    FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
)
SELECT d.deptno, dname, ename, pay, hiredate, grade
FROM temp t JOIN dept d ON t.deptno=d.deptno;

SELECT d.deptno, dname, ename, sal + NVL(comm,0) pay, hiredate, grade
FROM dept d JOIN emp e ON d.deptno = e.deptno
            JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;
            
SELECT e.*
FROM(
   SELECT d.deptno, dname, ename, sal + NVL(comm,0) pay, hiredate, grade
        , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm, 0) DESC) 급여순위
   FROM dept d JOIN emp e ON d.deptno = e.deptno
               JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
) e
WHERE 급여순위 = 1;

SELECT e.*
FROM (
    SELECT d.deptno, dname, ename, sal+NVL(comm, 0) pay, grade
        , ROW_NUMBER() OVER(PARTITION BY d.deptno ORDER BY sal+NVL(comm,0)) 급여순위
    FROM emp e, dept d, salgrade s
    WHERE e.deptno=d.deptno AND e.sal BETWEEN s.losal AND s.hisal
) e
WHERE 급여순위 = 1;

SELECT empno, ename, sal
    , ROW_NUMBER() OVER(ORDER BY sal DESC) rn_rank
    , RANK() OVER(ORDER BY sal DESC) r_rank
    , DENSE_RANK() OVER(ORDER BY sal DESC) dr_rank
FROM emp; 

SELECT empno, ename, sal
    , ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) rn_rank
    , RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) r_rank
    , DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) dr_rank
FROM emp; 

-- [문제] emp 테이블에서 각 사원 급여를 부서 순위, 사원전체의 순위 조회
SELECT empno, ename, deptno, sal
    , RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) "부서 순위"
    , RANK() OVER (ORDER BY sal DESC) "사원전체 순위"
FROM emp
ORDER BY deptno;

-- [문제] insa 사원수 출력
-- 남자사원수 : 31
-- 여자사원수 : 29
-- 전체      : 60

-- ROLLUP, CUBE 분석함수 -- GROUP BY 절에 사용할 수 있는 함수
SELECT DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '남자', 0, '여자', '전체') || '사원수' gender
    , COUNT(*)
FROM insa
GROUP BY CUBE( MOD(SUBSTR(ssn, 8, 1), 2));
GROUP BY ROLLUP( MOD(SUBSTR(ssn, 8, 1), 2));

SELECT buseo, jikwi, SUM(basicpay) sum_pay
FROM insa
GROUP BY buseo, CUBE(jikwi)
--GROUP BY buseo, ROLLUP(jikwi)
--GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo;

-- [문제] emp 테이블에서 가장 빨리 입사한 사원과 가장 늦게(최근)에 입사한 사원의
-- 차이 일수

SELECT MAX(hiredate) - MIN(hiredate)
FROM emp;

WITH a AS (
    SELECT hiredate
    FROM (
        SELECT hiredate
            , ROW_NUMBER() OVER (ORDER BY hiredate DESC) h_rank
        FROM emp
    )
    WHERE h_rank = 1
), b AS (
    SELECT hiredate
    FROM (
        SELECT hiredate
            , ROW_NUMBER() OVER (ORDER BY hiredate) h_rank
        FROM emp
    )
    WHERE h_rank = 1
)
SELECT a.hiredate - b.hiredate
FROM a, b;

-- [문제] insa 테이블에서 각 사원들의 만나이를 계산해서 출력
SELECT name, ssn
    , ABS(SUBSTR("생년월일", 0, 4) - EXTRACT(YEAR FROM SYSDATE)) + DECODE(SIGN(SUBSTR(생년월일, 5)-TO_CHAR(SYSDATE, 'MMDD')), 1, -1, 0) 만나이
FROM(
    SELECT name, ssn
        , CASE 
            WHEN SUBSTR(ssn, 8, 1) IN ('1','2','5','6') THEN 19
            WHEN SUBSTR(ssn, 8, 1) IN ('3','4','7','8') THEN 20
            ELSE 18
          END || SUBSTR(ssn,0,6) "생년월일"
    FROM insa
) e;

SELECT ssn
FROM insa;

SELECT t.name, t.ssn
    , t.now_year - t.birth_year + 
      CASE is_birth_check
        WHEN -1 THEN -1
        ELSE 0
      END american_age
    , t.now_year - t.birth_year + 1 counting_age
FROM (
    SELECT name, ssn
        , TO_CHAR(SYSDATE, 'YYYY') now_year
        , CASE  
             WHEN  SUBSTR(ssn, -7, 1) IN ( 1,2,5,6 ) THEN 1900
             WHEN  SUBSTR(ssn, -7, 1) IN ( 3,4,7,8 ) THEN 2000
             ELSE 1800
           END + SUBSTR(ssn, 0, 2) birth_year
        , SIGN( TRUNC(SYSDATE) - TO_DATE( SUBSTR(ssn, 3, 4), 'MMDD') ) is_birth_check
    FROM insa
) t;


-- Oracle : dbms_random 패키지
SELECT dbms_random.value
FROM dual;

SELECT dbms_random.value(0, 100) -- 0.0 <=   <100
FROM dual;

SELECT dbms_random.string('U', 5) -- UPPER 대문자 5
FROM dual;

SELECT dbms_random.string('L', 5) -- LOWER 대문자 5
FROM dual;

SELECT dbms_random.string('A', 5) -- 알바펫 대소문자
FROM dual;

SELECT dbms_random.string('X', 5) -- 대문자 + 숫자 
FROM dual;

SELECT dbms_random.string('P', 5) -- 알파벳 + 특수문자
FROM dual;

SELECT TRUNC(dbms_random.value*101) -- 0<= score 정수 <= 100
    , TRUNC(dbms_random.value(0, 45))+1 -- 1 <= lotto 정수 <= 45
    , TRUNC(dbms_random.value(0, 200-150+1))+150 -- 150 <= v 정수 <= 200
FROM dual;

-- [피봇(pivot) 설명]
-- https://blog.naver.com/gurrms95/222697767118
-- 피봇(pivot) : 축을 중심으로 회전시키다.
SELECT job
FROM emp;

-- 각 job(업무) 몇 명 파악
SELECT job, COUNT(*)
FROM emp
GROUP BY job;

SELECT COUNT(DECODE(job, 'CLERK', ' ')) 
    , COUNT(DECODE(job, 'SALESMAN', ' ')) 
    , COUNT(DECODE(job, 'PRESIDENT', ' ')) 
    , COUNT(DECODE(job, 'MANAGER', ' ')) 
    , COUNT(DECODE(job, 'ANALYST', ' '))
FROM emp;

SELECT COUNT(*)
FROM emp;

--SELECT * 
--FROM (피벗 대상 쿼리문)
--PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN(피벗컬럼 값 AS 별칭...))

SELECT * 
FROM (SELECT job FROM emp)
PIVOT (COUNT(*) FOR job IN('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));

SELECT * 
FROM (
    SELECT 
        job 
        , TO_CHAR(hiredate, 'FMMM') || '월' hire_month
    FROM emp
)
PIVOT(
    count(*)
    FOR hire_month IN ('1월', '2월')
);

-- [문제] emp 테이블에서 각 부서별로 + 각 job 별로 인원수를 가로 출력
-- 추가 문제 40 0 0 0 0 0 ...
SELECT * 
FROM (SELECT deptno, job FROM emp)
PIVOT (COUNT(*) FOR job IN('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'))
ORDER BY deptno;

SELECT job, COUNT(*)OVER(ORDER BY job)
FROM emp;




