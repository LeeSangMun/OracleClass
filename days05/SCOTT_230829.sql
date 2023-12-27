SELECT empno, ename, job, mgr, hiredate
    , sal+NVL(comm, 0) pay 
    , deptno
FROM emp
WHERE sal+NVL(comm, 0) IN ((SELECT MAX(sal+NVL(comm, 0)) FROM emp), (SELECT MIN(sal+NVL(comm, 0)) FROM emp));

SELECT ename, sal, comm
FROM emp
WHERE comm <= 400 OR comm IS NULL;

-- LNNVL(조건식)
SELECT ename, sal, comm
FROM emp
WHERE LNNVL(comm > 400);

SELECT *
FROM emp e
WHERE sal+NVL(comm, 0) = (
    SELECT MAX(sal+NVL(comm, 0)) 
    FROM emp 
    WHERE e.deptno=deptno
);

SELECT deptno, MAX(sal+NVL(comm, 0)) max_pay
FROM emp
GROUP BY deptno;

SELECT SUBSTR('031)1234-5678', INSTR('031)1234-5678', '1234'), INSTR('031)1234-5678', '-')-INSTR('031)1234-5678', ')')-1)
FROM dual;

-- TRUNC() - 절삭 함수, 숫자, 날짜, 특정 위치
-- FLOOR() - 절삭 함수, 숫자, 소수점 1번째 자리
SELECT SYSDATE      -- 오라클 날짜 DATE
    , SYSTIMESTAMP  -- 오라클 날짜 TIMESTAMP
    , TRUNC(SYSDATE, 'YEAR')
    , TRUNC(SYSDATE, 'MONTH')
    , TRUNC(SYSDATE) -- 시간, 분, 초 절삭
FROM dual;

SELECT ename, sal, comm, sal+NVL(comm, 0) pay
    , (SELECT ROUND(AVG(sal+NVL(comm, 0)), 5) FROM emp) avg_pay
    , (SELECT SUM(sal+NVL(comm, 0)) FROM emp)
FROM emp
WHERE sal+NVL(comm, 0) > (SELECT ROUND(AVG(sal+NVL(comm, 0)), 5) FROM emp);

--------------------------------------------------------------------
-- 각 사원들의 총급여합
-- 각 사원들의 수
-- 각 사원들의 평균급여
SELECT SUM(sal + NVL(comm, 0)) sum_pay -- 27125
    , COUNT(*) cnt
    , AVG(sal + NVL(comm, 0)) avg_pay
    , MAX(sal + NVL(comm, 0)) max_pay
    , MIN(sal + NVL(comm, 0)) min_pay
    , STDDEV(sal + NVL(comm, 0)) stddev_pay -- 표준편차 : 분산의 제곱근
    , VARIANCE(sal + NVL(comm, 0)) variance_pay -- 분산 : (각 사원 pay - avg_pay)^2의 평균
FROM emp;

-- [문제] emp테이블의 pay 순으로 등수 매기기
SELECT ename, pay
FROM (SELECT ename, sal+NVL(comm, 0) pay FROM emp ORDER BY pay DESC);

SELECT t.ename, t.pay, (SELECT COUNT(*)+1 FROM emp WHERE sal+NVL(comm,0)>t.pay) pay_rank
FROM (SELECT ename, sal+NVL(comm, 0) pay FROM emp) t
ORDER BY pay;

-- 날짜 함수
-- 1) SYSDATE
SELECT SYSDATE 
    , TO_CHAR(SYSDATE, 'YYYY-MM-DD AM HH12:MI:SS')
    , TO_CHAR(SYSDATE, 'DL TS DY DAY WW W, IW')
FROM dual;

-- 몇 번째 주 : WW, W, IW

-- 2) ROUND
SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'DL TS')
    , ROUND(SYSDATE)
    , ROUND(SYSDATE, 'DD')
    , ROUND(SYSDATE, 'MONTH')
    , ROUND(SYSDATE, 'YEAR')
FROM dual;

-- 3) TRUNC
SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'DL TS')
    , TRUNC(SYSDATE)
    , TRUNC(SYSDATE, 'DD')
    , TRUNC(SYSDATE, 'MONTH')
    , TRUNC(SYSDATE, 'YEAR')
FROM dual;

-- 4) MONTHS_BETWEEN
-- 날짜 + 숫자 = 날짜         날짜에 일수를 더하여 날짜 계산 
-- 날짜 - 숫자 = 날짜         날짜에 일수를 감하여 날짜 계산 
-- 날짜 + 숫자/24 = 날짜      날짜에 시간을 더하여 날짜 계산 
-- 날짜 - 날짜 = 일수         날짜에 날짜를 감하여 일수 계산 
-- emp 테이블의 각 사원들의 근무일 수, 근무개월 수, 근무년 수 조회
SELECT ename
    , hiredate
    , SYSDATE
    , ROUND(SYSDATE - hiredate) 근무일수
    , ROUND(MONTHS_BETWEEN(SYSDATE, hiredate), 1) 근무개월수
    , ROUND(MONTHS_BETWEEN(SYSDATE, hiredate)/12, 1) 근무년수
FROM emp;

SELECT SYSDATE 
    , TO_CHAR(SYSDATE, 'TS')
    , SYSDATE + 1
    , SYSDATE + 10
    , TO_CHAR(SYSDATE + 1/24, 'TS')
FROM dual;

-- 5) ADD_MONTHS
SELECT SYSDATE
    , ADD_MONTHS(SYSDATE, 3)
    , ADD_MONTHS(SYSDATE, -1)
FROM dual;

-- 6) LAST_DAY
SELECT SYSDATE
    , LAST_DAY(SYSDATE)
    , TO_CHAR(LAST_DAY(SYSDATE), 'DD')
    , TO_CHAR(LAST_DAY(SYSDATE), 'DY')
    , TO_CHAR(TRUNC(SYSDATE, 'MONTH'), 'DY')
--    , TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE,-1))+1, 'DY')
--    , TO_CHAR(SYSDATE-EXTRACT(DAY FROM SYSDATE)+1, 'DY')
FROM dual;

-- 7) NEXT_DAY
SELECT SYSDATE, TO_CHAR(SYSDATE, 'DAY')
    , NEXT_DAY(SYSDATE, '금요일')
    , NEXT_DAY(SYSDATE, '화요일')
FROM dual;

SELECT SYSDATE
    , CURRENT_DATE
FROM dual;

-- [문제]  개강일(23.7.13 (목))로부터 
SELECT TO_CHAR(TO_DATE('23.7.13 (목)', 'YY.MM.DD (DY)')+100, 'DL')
FROM dual;

-- [변환함수]
-- 1) TO_NUMBER
SELECT '100'+1
FROM dual;




-- [일반함수]
-- 1) DECODE
--        - 여러 개의 조건을 주어 ??
--        - 비교연산 = 만 사용 가능
--        - FROM 절 사용 x
--        - PL/SQL 안에서 사용할 수 있는 함수

int x = 10;
if(x==11) {
    return C;
} else if(x==12) {
    return D;
} else if(x==13) {
    return E;
} else {
    return F;
}
DECODE(x, 11, C, 12, D, 13, E, F)

-- 예) insa 테이블에서 주민등록번호를 가지고 "남자", "여자"라고 출력
SELECT name, ssn, NVL2(NULLIF(MOD(SUBSTR(ssn, 8, 1), 2), 1), '여자', '남자') gender
FROM insa;

SELECT name, ssn, DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '남자', '여자') gender
FROM insa;

-- [문제] emp 테이블에서 10번 부서원 급여 15% , 20번 부서원 30%, 30번 부서원 5% 인상
--       출력 부서번호, 사원명, 급여, 인상액, 인상된 급여
SELECT deptno, ename
    , sal+NVL(comm, 0) pay
    , DECODE(deptno, 10, (sal+NVL(comm, 0))*0.15, 20, (sal+NVL(comm, 0))*0.2, (sal+NVL(comm, 0))*0.05) "인상"
    , DECODE(deptno, 10, (sal+NVL(comm, 0))*1.15, 20, (sal+NVL(comm, 0))*1.2, (sal+NVL(comm, 0))*1.05) "인상된 급여"
FROM emp;

