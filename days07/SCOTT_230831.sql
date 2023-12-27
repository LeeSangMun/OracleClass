-- 6���� ����
SELECT TO_CHAR(SYSDATE, 'YYYY"��" MM"��" DD"��" TS (DY)')
FROM dual;

-- [9�� ����] Oracle 11g PARTITION OUTER JOIN ����
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

-- deptno, ename, sal, grade ��ȸ 
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
    , NVL(LISTAGG(ename, '\') WITHIN GROUP(ORDER BY ename), '�������')
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno=d.deptno
GROUP BY d.deptno;

-- GROUPING SETS ��
-- ��) GROUP BY exp1
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


-- emp���̺��� �޿��� ���� ���� �޴� ����� ����(empno, deptno, ename, pay) ��ȸ
SELECT deptno, empno, ename, sal+NVL(comm, 0) pay
FROM emp
--WHERE sal+NVL(comm, 0) >= ALL (SELECT sal+NVL(comm, 0) FROM emp);
WHERE sal+NVL(comm, 0) = (SELECT MAX(sal+NVL(comm, 0)) FROM emp);

-- RANK ���� �Լ�
-- [TOP-N �м�]
--  1) ORDER BY ���ĵ� �ζ��κ�
--  2) ROWNUM �ǻ��÷� - �ึ�� ������� ��ȣ�� �ο��ϴ� �÷�
--  3) n���� < �Ǵ� >=�� ����Ͽ� �����ϸ�, ��ȯ�� ���� ������ �����Ѵ�.

-- ROWID, ROWNUM -> �ǻ�(pseudo) �÷�
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
--WHERE ROWNUM BETWEEN 3 AND 5; -- Top���� n���� ������ �� �ִ�.
WHERE ROWNUM <= 3;
--WHERE ROWNUM=1;


-- RANK ���� �Լ�
-- 1) RANK()
-- 2) DENSE_RANK()
-- 3) PERCENT_RANK()
-- 4) FIRST(), LAST()
-- 5) ROW_NUMBER() ***

SELECT e.*
FROM(
    SELECT deptno, ename, sal+NVL(comm, 0) pay
        , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm, 0) DESC) �޿�����
    FROM emp
) e
WHERE �޿����� BETWEEN 3 AND 5;
--WHERE �޿����� = 1;

-- [����] emp���̺��� �� �μ��� �ְ�޿��� �޴� ����� ������ ��ȸ
-- (deptno, dname, ename, pay, hiredate, grade)
SELECT e.*
FROM(
    SELECT deptno, ename, sal+NVL(comm, 0) pay
        , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm, 0) DESC) �޿�����
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
        , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm, 0) DESC) �޿�����
   FROM dept d JOIN emp e ON d.deptno = e.deptno
               JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
) e
WHERE �޿����� = 1;

SELECT e.*
FROM (
    SELECT d.deptno, dname, ename, sal+NVL(comm, 0) pay, grade
        , ROW_NUMBER() OVER(PARTITION BY d.deptno ORDER BY sal+NVL(comm,0)) �޿�����
    FROM emp e, dept d, salgrade s
    WHERE e.deptno=d.deptno AND e.sal BETWEEN s.losal AND s.hisal
) e
WHERE �޿����� = 1;

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

-- [����] emp ���̺��� �� ��� �޿��� �μ� ����, �����ü�� ���� ��ȸ
SELECT empno, ename, deptno, sal
    , RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) "�μ� ����"
    , RANK() OVER (ORDER BY sal DESC) "�����ü ����"
FROM emp
ORDER BY deptno;

-- [����] insa ����� ���
-- ���ڻ���� : 31
-- ���ڻ���� : 29
-- ��ü      : 60

-- ROLLUP, CUBE �м��Լ� -- GROUP BY ���� ����� �� �ִ� �Լ�
SELECT DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '����', 0, '����', '��ü') || '�����' gender
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

-- [����] emp ���̺��� ���� ���� �Ի��� ����� ���� �ʰ�(�ֱ�)�� �Ի��� �����
-- ���� �ϼ�

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

-- [����] insa ���̺��� �� ������� �����̸� ����ؼ� ���
SELECT name, ssn
    , ABS(SUBSTR("�������", 0, 4) - EXTRACT(YEAR FROM SYSDATE)) + DECODE(SIGN(SUBSTR(�������, 5)-TO_CHAR(SYSDATE, 'MMDD')), 1, -1, 0) ������
FROM(
    SELECT name, ssn
        , CASE 
            WHEN SUBSTR(ssn, 8, 1) IN ('1','2','5','6') THEN 19
            WHEN SUBSTR(ssn, 8, 1) IN ('3','4','7','8') THEN 20
            ELSE 18
          END || SUBSTR(ssn,0,6) "�������"
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


-- Oracle : dbms_random ��Ű��
SELECT dbms_random.value
FROM dual;

SELECT dbms_random.value(0, 100) -- 0.0 <=   <100
FROM dual;

SELECT dbms_random.string('U', 5) -- UPPER �빮�� 5
FROM dual;

SELECT dbms_random.string('L', 5) -- LOWER �빮�� 5
FROM dual;

SELECT dbms_random.string('A', 5) -- �˹��� ��ҹ���
FROM dual;

SELECT dbms_random.string('X', 5) -- �빮�� + ���� 
FROM dual;

SELECT dbms_random.string('P', 5) -- ���ĺ� + Ư������
FROM dual;

SELECT TRUNC(dbms_random.value*101) -- 0<= score ���� <= 100
    , TRUNC(dbms_random.value(0, 45))+1 -- 1 <= lotto ���� <= 45
    , TRUNC(dbms_random.value(0, 200-150+1))+150 -- 150 <= v ���� <= 200
FROM dual;

-- [�Ǻ�(pivot) ����]
-- https://blog.naver.com/gurrms95/222697767118
-- �Ǻ�(pivot) : ���� �߽����� ȸ����Ű��.
SELECT job
FROM emp;

-- �� job(����) �� �� �ľ�
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
--FROM (�ǹ� ��� ������)
--PIVOT (�׷��Լ�(�����÷�) FOR �ǹ��÷� IN(�ǹ��÷� �� AS ��Ī...))

SELECT * 
FROM (SELECT job FROM emp)
PIVOT (COUNT(*) FOR job IN('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'));

SELECT * 
FROM (
    SELECT 
        job 
        , TO_CHAR(hiredate, 'FMMM') || '��' hire_month
    FROM emp
)
PIVOT(
    count(*)
    FOR hire_month IN ('1��', '2��')
);

-- [����] emp ���̺��� �� �μ����� + �� job ���� �ο����� ���� ���
-- �߰� ���� 40 0 0 0 0 0 ...
SELECT * 
FROM (SELECT deptno, job FROM emp)
PIVOT (COUNT(*) FOR job IN('CLERK', 'SALESMAN', 'PRESIDENT', 'MANAGER', 'ANALYST'))
ORDER BY deptno;

SELECT job, COUNT(*)OVER(ORDER BY job)
FROM emp;




