SELECT empno, ename, job, mgr, hiredate
    , sal+NVL(comm, 0) pay 
    , deptno
FROM emp
WHERE sal+NVL(comm, 0) IN ((SELECT MAX(sal+NVL(comm, 0)) FROM emp), (SELECT MIN(sal+NVL(comm, 0)) FROM emp));

SELECT ename, sal, comm
FROM emp
WHERE comm <= 400 OR comm IS NULL;

-- LNNVL(���ǽ�)
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

-- TRUNC() - ���� �Լ�, ����, ��¥, Ư�� ��ġ
-- FLOOR() - ���� �Լ�, ����, �Ҽ��� 1��° �ڸ�
SELECT SYSDATE      -- ����Ŭ ��¥ DATE
    , SYSTIMESTAMP  -- ����Ŭ ��¥ TIMESTAMP
    , TRUNC(SYSDATE, 'YEAR')
    , TRUNC(SYSDATE, 'MONTH')
    , TRUNC(SYSDATE) -- �ð�, ��, �� ����
FROM dual;

SELECT ename, sal, comm, sal+NVL(comm, 0) pay
    , (SELECT ROUND(AVG(sal+NVL(comm, 0)), 5) FROM emp) avg_pay
    , (SELECT SUM(sal+NVL(comm, 0)) FROM emp)
FROM emp
WHERE sal+NVL(comm, 0) > (SELECT ROUND(AVG(sal+NVL(comm, 0)), 5) FROM emp);

--------------------------------------------------------------------
-- �� ������� �ѱ޿���
-- �� ������� ��
-- �� ������� ��ձ޿�
SELECT SUM(sal + NVL(comm, 0)) sum_pay -- 27125
    , COUNT(*) cnt
    , AVG(sal + NVL(comm, 0)) avg_pay
    , MAX(sal + NVL(comm, 0)) max_pay
    , MIN(sal + NVL(comm, 0)) min_pay
    , STDDEV(sal + NVL(comm, 0)) stddev_pay -- ǥ������ : �л��� ������
    , VARIANCE(sal + NVL(comm, 0)) variance_pay -- �л� : (�� ��� pay - avg_pay)^2�� ���
FROM emp;

-- [����] emp���̺��� pay ������ ��� �ű��
SELECT ename, pay
FROM (SELECT ename, sal+NVL(comm, 0) pay FROM emp ORDER BY pay DESC);

SELECT t.ename, t.pay, (SELECT COUNT(*)+1 FROM emp WHERE sal+NVL(comm,0)>t.pay) pay_rank
FROM (SELECT ename, sal+NVL(comm, 0) pay FROM emp) t
ORDER BY pay;

-- ��¥ �Լ�
-- 1) SYSDATE
SELECT SYSDATE 
    , TO_CHAR(SYSDATE, 'YYYY-MM-DD AM HH12:MI:SS')
    , TO_CHAR(SYSDATE, 'DL TS DY DAY WW W, IW')
FROM dual;

-- �� ��° �� : WW, W, IW

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
-- ��¥ + ���� = ��¥         ��¥�� �ϼ��� ���Ͽ� ��¥ ��� 
-- ��¥ - ���� = ��¥         ��¥�� �ϼ��� ���Ͽ� ��¥ ��� 
-- ��¥ + ����/24 = ��¥      ��¥�� �ð��� ���Ͽ� ��¥ ��� 
-- ��¥ - ��¥ = �ϼ�         ��¥�� ��¥�� ���Ͽ� �ϼ� ��� 
-- emp ���̺��� �� ������� �ٹ��� ��, �ٹ����� ��, �ٹ��� �� ��ȸ
SELECT ename
    , hiredate
    , SYSDATE
    , ROUND(SYSDATE - hiredate) �ٹ��ϼ�
    , ROUND(MONTHS_BETWEEN(SYSDATE, hiredate), 1) �ٹ�������
    , ROUND(MONTHS_BETWEEN(SYSDATE, hiredate)/12, 1) �ٹ����
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
    , NEXT_DAY(SYSDATE, '�ݿ���')
    , NEXT_DAY(SYSDATE, 'ȭ����')
FROM dual;

SELECT SYSDATE
    , CURRENT_DATE
FROM dual;

-- [����]  ������(23.7.13 (��))�κ��� 
SELECT TO_CHAR(TO_DATE('23.7.13 (��)', 'YY.MM.DD (DY)')+100, 'DL')
FROM dual;

-- [��ȯ�Լ�]
-- 1) TO_NUMBER
SELECT '100'+1
FROM dual;




-- [�Ϲ��Լ�]
-- 1) DECODE
--        - ���� ���� ������ �־� ??
--        - �񱳿��� = �� ��� ����
--        - FROM �� ��� x
--        - PL/SQL �ȿ��� ����� �� �ִ� �Լ�

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

-- ��) insa ���̺��� �ֹε�Ϲ�ȣ�� ������ "����", "����"��� ���
SELECT name, ssn, NVL2(NULLIF(MOD(SUBSTR(ssn, 8, 1), 2), 1), '����', '����') gender
FROM insa;

SELECT name, ssn, DECODE(MOD(SUBSTR(ssn, 8, 1), 2), 1, '����', '����') gender
FROM insa;

-- [����] emp ���̺��� 10�� �μ��� �޿� 15% , 20�� �μ��� 30%, 30�� �μ��� 5% �λ�
--       ��� �μ���ȣ, �����, �޿�, �λ��, �λ�� �޿�
SELECT deptno, ename
    , sal+NVL(comm, 0) pay
    , DECODE(deptno, 10, (sal+NVL(comm, 0))*0.15, 20, (sal+NVL(comm, 0))*0.2, (sal+NVL(comm, 0))*0.05) "�λ�"
    , DECODE(deptno, 10, (sal+NVL(comm, 0))*1.15, 20, (sal+NVL(comm, 0))*1.2, (sal+NVL(comm, 0))*1.05) "�λ�� �޿�"
FROM emp;

