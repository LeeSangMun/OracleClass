-- 5일차 복습
SELECT DISTINCT buseo, (SELECT COUNT(*) FROM insa WHERE i.buseo=buseo)
FROM insa i;

WITH m AS (
    SELECT DISTINCT buseo
    FROM insa
)
SELECT buseo, (SELECT COUNT(*) FROM insa WHERE m.buseo=buseo)
FROM m;

-- 1번 추가 문제
-- insa 테이블에서 남자사원수, 여자사원수 조회
WITH i AS (
    SELECT MOD(SUBSTR(ssn, 8, 1), 2) gender
    FROM insa
)
SELECT (SELECT COUNT(*) FROM insa WHERE MOD(SUBSTR(ssn, 8, 1), 2)=i.gender) cnt
FROM i
GROUP BY i.gender;

SELECT DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '남자사원수', '여자사원수'), COUNT(*)
FROM insa
GROUP BY MOD(SUBSTR(ssn, 8, 1), 2);
-- 1-2)
SELECT COUNT(*) "전체사원수"
    , COUNT(DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '남자사원수')) "남자 사원수"
FROM insa;

-- (문제제시) 사원이 존재하지 않는 부서는 0으로
--SELECT deptno, (SELECT COUNT(*) FROM emp WHERE d.deptno=deptno)
--FROM dept d;

-- 피봇(pivot) 기능 // 옆으로 출력


SELECT num, name
    , ibsadate
    , TO_DATE(TO_CHAR(ibsadate, 'YYYY')||TO_CHAR(SYSDATE, 'MM')||TO_CHAR(SYSDATE, 'DD'))
FROM insa
WHERE num IN (1001,1002);

SELECT name, ssn
    , DECODE(SIGN(SUBSTR(ssn, 3, 4) - TO_CHAR(TO_DATE('2023.03.21'), 'MMDD')), -1, '생일 전', 1, '생일 후', '오늘 생일')
FROM insa;

SELECT COUNT(DECODE(SIGN(SUBSTR(ssn, 3, 4) - TO_CHAR(TO_DATE('2023.03.21'), 'MMDD')), -1, '생일 전 사원수')) "생일 전 사원수"
    , COUNT(DECODE(SIGN(SUBSTR(ssn, 3, 4) - TO_CHAR(TO_DATE('2023.03.21'), 'MMDD')), 1, '생일 후 사원수')) "생일 후 사원수"
    , COUNT(DECODE(SIGN(SUBSTR(ssn, 3, 4) - TO_CHAR(TO_DATE('2023.03.21'), 'MMDD')), 0, '오늘 생일 사원수')) "오늘 생일 사원수"
FROM insa;

SELECT TO_CHAR(TO_DATE('2022.1.1'), 'IW')
    , TO_CHAR(TO_DATE('2022.1.1'), 'WW')
    , TO_CHAR(TO_DATE('2022.1.2'), 'IW')
    , TO_CHAR(TO_DATE('2022.1.2'), 'WW')
    , TO_CHAR(TO_DATE('2022.1.3'), 'IW')
    , TO_CHAR(TO_DATE('2022.1.3'), 'WW')
    , TO_CHAR(TO_DATE('2022.1.8'), 'IW')
    , TO_CHAR(TO_DATE('2022.1.8'), 'WW')
FROM dual;

SELECT TO_DATE('2022', 'YYYY') -- 22/08/01
    , TO_DATE('2022.02', 'YYYY.MM') -- 22/02/01
    , TO_DATE('02', 'MM') -- 23/02/01
FROM dual;

-- case 문
SELECT name, ssn, DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '남자', '여자') gender
    , CASE MOD(SUBSTR(ssn, 8, 1), 2) WHEN 1 THEN '남자'
           ELSE '여자'
      END gender
    , CASE WHEN MOD(SUBSTR(ssn, 8, 1), 2)=1 THEN '남자'
           ELSE '여자'
      END gender
FROM insa;


SELECT SUM(DECODE(SIGN(sal+NVL(comm, 0)-(SELECT AVG(sal+NVL(comm, 0)) FROM emp)), -1, null, sal+NVL(comm, 0)))
    , SUM(CASE WHEN sal+NVL(comm, 0)-(SELECT AVG(sal+NVL(comm, 0)) FROM emp) >= 0 THEN sal+NVL(comm, 0)
               ELSE NULL
          END) sum_pay
FROM emp;

-- 이거는 JOIN
WITH a AS (
    SELECT TO_CHAR( AVG(sal + NVL(comm, 0)), '9999.00' ) avg_pay  -- 2260.42
    FROM emp 
) , 
b AS (
    SELECT empno, ename, sal + NVL(comm, 0) pay
    FROM emp  
)
SELECT *
FROM b , a    -- JOIN
WHERE b.pay >= a.avg_pay;

SELECT SUM(t.pay)
FROM (
    SELECT empno, ename, sal+NVL(comm,0) pay
    FROM emp
    WHERE sal+NVL(comm,0) >= (SELECT AVG(sal+NVL(comm, 0)) FROM emp)
) t;

SELECT deptno
FROM dept d
WHERE 0 < (SELECT COUNT(*) FROM emp WHERE d.deptno=deptno);

SELECT deptno
FROM dept d
WHERE 0 = (SELECT COUNT(*) FROM emp WHERE d.deptno=deptno);

SELECT deptno
FROM dept
MINUS
SELECT DISTINCT deptno
FROM emp;

SELECT deptno, DECODE(deptno, 10, (SELECT COUNT(*) FROM emp WHERE d.deptno=deptno)
                            , 20, (SELECT COUNT(*) FROM emp WHERE d.deptno=deptno)
                            , 30, (SELECT COUNT(*) FROM emp WHERE d.deptno=deptno)
                            , 40, (SELECT COUNT(*) FROM emp WHERE d.deptno=deptno)) "사원수"
FROM dept d;
------------------------------------------------------------------------------------

-- [조인(JOIN)]
-- 예) 부서번호, 사원번호, 사원명, 입사일자 조회 
-- 중복된 컬럼만 어떤테이블인지 명시해주면 된다.
SELECT e.deptno, dname, empno, ename, hiredate
FROM emp e, dept d
WHERE e.deptno=d.deptno;

SELECT d.deptno
FROM emp e JOIN dept d
ON e.deptno=d.deptno;


-- 15, 15-2 풀이 조인 사용
SELECT d.deptno
    , dname
    , COUNT(e.empno)
FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno, dname
HAVING COUNT(e.empno) != 0;

SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT ename, sal+NVL(comm, 0) pay
  	  	, (sal+NVL(comm, 0))*DECODE(deptno, 10, 1.15
                                 , 20, 1.1
                 		         , 30, 1.05
                 		         , 40, 1.2) "인상된 금액"
        , (sal+NVL(comm, 0))*CASE deptno
                                WHEN 10 THEN 1.15
                                WHEN 20 THEN 1.1
                                WHEN 30 THEN 1.05
                                WHEN 40 THEN 1.2
                              END
FROM emp;




