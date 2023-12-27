-- 7일차 복습
-- [13-2]
WITH temp AS(
    SELECT MAX(sal) max_sal, MIN(sal) min_sal
    FROM emp
    WHERE deptno=30
)
SELECT *
FROM temp t, emp e
WHERE e.deptno=30 AND e.sal=t.max_sal OR e.sal = t.min_sal;

-- [14]
-- 1)
WITH temp AS (
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e, dept d
    WHERE e.deptno(+) = d.deptno
    GROUP BY d.deptno, dname
)
SELECT *
FROM temp
WHERE cnt IN ((SELECT MAX(cnt) FROM temp)
            , (SELECT MIN(cnt) FROM temp));

-- 2)
WITH a AS(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e, dept d
    WHERE e.deptno(+) = d.deptno
    GROUP BY d.deptno, dname
), b AS(
    SELECT MIN(cnt) min_cnt, MAX(cnt) max_cnt
    FROM a
)
SELECT *
FROM a,b
WHERE a.cnt IN (b.min_cnt, b.max_cnt);

--3)
-- 분석 함수 : FIRST, LAST
-- 집계함수와 함계 사용되어 주어진 그룹에 대해 
-- 내부적으로 순위를 매겨 결과를 산출하는 함수
WITH a AS(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e, dept d
    WHERE e.deptno(+) = d.deptno
    GROUP BY d.deptno, dname
)
SELECT MIN(deptno) KEEP(DENSE_RANK FIRST ORDER BY cnt) deptno, MIN(cnt)
    , MAX(deptno) KEEP(DENSE_RANK LAST ORDER BY cnt) deptno, MAX(cnt)
    
FROM a;

--------------------------------------------------------------
-- [분석함수] ? 테이블에 있는 행에 대해 특정 그룹별로 집계값을 산출할 때 사용하는 함수.
-- 1) ROW_NUMBER()
-- 2) RANK()
-- 3) DENSE_RANK()
-- 4) CUME_DIST() : 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
--                      분포도값(비율) : 0 < 사이의 값 <= 1
--      예) 부서별 급여에 따른 누적 분포도 값 조회
SELECT deptno, ename, sal
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_dist
FROM emp;

-- 5) PERCENT_RANK() : 해당 그룹 내의 백분위 순위
--                        0 <= 사이의 값 <= 1
--                      백분위순위 ? 그룹 안에서 해당 로우(행)의 값보다 (작은 값의 비율)
SELECT deptno, ename, sal
    , PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal) dept_dist
FROM emp;



SELECT deptno, ename, sal
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_dist
    , PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal) dept_dist
FROM emp
WHERE deptno = 30;

30	JAMES	950	    0.1666666666666666666666666666666666666667	0
30	WARD	1250	0.5	                                        0.2
30	MARTIN	1250	0.5	                                        0.2
30	TURNER	1500	0.6666666666666666666666666666666666666667	0.6
30	ALLEN	1600	0.8333333333333333333333333333333333333333	0.8
30	BLAKE	2850	1	                                        1

-- 6) NTITLE(expr) : 파티션 별로 expr에 명시된 만큼 분활한 경과를 반환하는 함수
                    분할 하는 수를 버킸(bucket)이록 한다.
                    
    SELECT deptno, ename, sal
        , NTILE(4) OVER(ORDER BY sal) ntitles
    FROM emp;
    
    SELECT buseo, name, basicpay
        , NTILE(2) OVER(PARTITION BY buseo ORDER BY basicpay)
    FROM insa;
    
-- 7) WITH_BUCKET(expr,min_value, max_value, num_buckets)
--    NTILE()유사
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal) ntilees
    , WIDTH_BUCKET(sal, 0, 5000, 4) widthbuckets
FROM emp;

-- 8) LAG(expr, offset, default_value)  : 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조(선행 행)
--    LEAD(expr, offset, default_value) : 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조(후행 행)

SELECT ename, hiredate, sal
    , LAG(sal, 1, 0) OVER(ORDER BY hiredate) prev_sal
    , LAG(sal, 2, -1) OVER(ORDER BY hiredate) prev_sal
    , LEAD(sal, 1, -1) OVER(ORDER BY hiredate) next_sal
FROM emp
WHERE deptno = 30;

SELECT '***ADMIN***'
    , REPLACE('***ADMIN***', '*', '')
    , TRIM('*' FROM '***ADMIN***')
FROM dual;


-- [오라클 자료형]
create table test (
    aa char
    , bb char(3)
    , cc char(3 char)
);

DROP TABLE test;
DESC test;
SELECT *
FROM tabs;

-- ORA-12899: value too large for column "SCOTT"."TEST"."BB" (actual: 4, maximum: 3)
insert into test values('a','aaaa','aaaa');
-- ORA-12899: value too large for column "SCOTT"."TEST"."CC" (actual: 4, maximum: 3)
insert into test values('a','aaa','aaaa');

insert into test values('a','aaa','aaa');

insert into test values('b','욜','우리');

-- ORA-12899: value too large for column "SCOTT"."TEST"."BB" (actual: 6, maximum: 3)
insert into test values('b','우리','우리');

COMMIT;

SELECT *
FROM test;

