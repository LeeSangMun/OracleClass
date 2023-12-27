-- 7���� ����
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
-- �м� �Լ� : FIRST, LAST
-- �����Լ��� �԰� ���Ǿ� �־��� �׷쿡 ���� 
-- ���������� ������ �Ű� ����� �����ϴ� �Լ�
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
-- [�м��Լ�] ? ���̺� �ִ� �࿡ ���� Ư�� �׷캰�� ���谪�� ������ �� ����ϴ� �Լ�.
-- 1) ROW_NUMBER()
-- 2) RANK()
-- 3) DENSE_RANK()
-- 4) CUME_DIST() : �־��� �׷쿡 ���� ������� ���� ������ ���� ��ȯ
--                      ��������(����) : 0 < ������ �� <= 1
--      ��) �μ��� �޿��� ���� ���� ������ �� ��ȸ
SELECT deptno, ename, sal
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_dist
FROM emp;

-- 5) PERCENT_RANK() : �ش� �׷� ���� ����� ����
--                        0 <= ������ �� <= 1
--                      ��������� ? �׷� �ȿ��� �ش� �ο�(��)�� ������ (���� ���� ����)
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

-- 6) NTITLE(expr) : ��Ƽ�� ���� expr�� ��õ� ��ŭ ��Ȱ�� ����� ��ȯ�ϴ� �Լ�
                    ���� �ϴ� ���� ���c(bucket)�̷� �Ѵ�.
                    
    SELECT deptno, ename, sal
        , NTILE(4) OVER(ORDER BY sal) ntitles
    FROM emp;
    
    SELECT buseo, name, basicpay
        , NTILE(2) OVER(PARTITION BY buseo ORDER BY basicpay)
    FROM insa;
    
-- 7) WITH_BUCKET(expr,min_value, max_value, num_buckets)
--    NTILE()����
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal) ntilees
    , WIDTH_BUCKET(sal, 0, 5000, 4) widthbuckets
FROM emp;

-- 8) LAG(expr, offset, default_value)  : �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ����(���� ��)
--    LEAD(expr, offset, default_value) : �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ����(���� ��)

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


-- [����Ŭ �ڷ���]
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

insert into test values('b','��','�츮');

-- ORA-12899: value too large for column "SCOTT"."TEST"."BB" (actual: 6, maximum: 3)
insert into test values('b','�츮','�츮');

COMMIT;

SELECT *
FROM test;

