-- scott

-- SQL ���� ���� ���� --
-- Opimizer �˻� --

-- HR ����(���� ����)

-- HR ������ ���� Ȯ��
-- �Ϲ� ����ڴ� dba_XXX ���Ұ�
SELECT *
FROM dba_users;

-- DQL�� : select --
-- 1) ������ �������� �� ����ϴ� SQL��
-- 2) ��� : ���̺�, ��
-- 3) ����ڰ� ������ ���̺� �̰ų� ��� ����
--       SELECT ����
       
SELECT *
FROM emp;

-- SELECT �� �� ����
--[WITH ��]            -- 1
--SECELT ��          --6
--FROM ��          -- 2 
--[WHERE ��]  -- 3
-- ���� �� hierarchical_query_cause
--[GROBP BY��]  -- 4
--[HAVING �� ]  -- 5
--[ORDER BY ��]  -- 7

INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-87', 'dd-MM-yy')-51,1100,NULL,20);  

INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-87', 'dd-MM-yy')-85,3000,NULL,20);

COMMIT;

-- scott ����ڰ� ������ ���̺� ���� ��ȸ
SELECT * -- * -> ��� ��� ��ȸ
FROM tabs; -- �� [������ ����]�� ����Ǿ�����

-- emp ���̺��� ��� ��� ������ȸ
SELECT *
FROM emp;

-- emp ���̺��� ���� Ȯ��
DESCRIBE emp;
DESC emp;

-- emp ���̺��� ��� ����(�����ȣ, �����, �Ի�����) ��ȸ
SELECT empno, ename, hiredate
FROM emp;

-- dept ���̺��� ���� Ȯ��
DESC dept;

-- dept ���̺��� ��� �÷��� ��ȸ
SELECT *
FROM dept;

-- emp ���̺��� job�� ��ȸ
-- �� ������� job�� ��ȸ
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


-- ������� job ������ ��ȸ // �ߺ�����
SELECT DISTINCT job
FROM emp;

--CLERK
--SALESMAN
--PRESIDENT
--MANAGER
--ANALYST

-- ������� job ������ ��ȸ�ؼ� ī��Ʈ
SELECT COUNT(DISTINCT job), COUNT(job)
FROM emp;

-- emp ���̺��� ������� �����, �Ի����� ��ȸ
-- 80(RR)/12(MM)/17(DD) ��/��/�� NLS
--  YY/MM/DD �ʹ� �ٸ���.
SELECT ENAME, HIREDATE
FROM emp;

--[����] emp ���̺��� ����� �μ���ȣ, �����, �޿�(sal+comm) ��ȸ
-- Ŀ�̼� ��Ȯ�ε� ��(null)�� 0���� ó�� -> null ó��
-- NULL�� ���´�.
-- � ���� null�� �����ϸ� null�� ���´�.
-- as(alias)
SELECT DEPTNO, ename
--        , NVL(comm, 0)+sal as "pay"
--        , NVL(comm, 0)+sal "pay"
--        , NVL(comm, 0)+sal my pay // ����
--        , NVL(comm, 0)+sal "my pay"
        , NVL(comm, 0)+sal my_pay
        , (NVL(comm, 0)+sal)*12 ����
FROM emp;

-- emp ���̺��� ��� ��������� ��ȸ
SELECT ENAME, HIREDATE
FROM emp;

-- emp ���̺��� deptno 30 �μ����鸸 ��ȸ (deptno, ename, job, hiredate, pay)
SELECT deptno, ename, job, hiredate
--        , NVL(sal+comm, sal) pay
        , sal + NVL(comm, 0) pay
FROM emp
WHERE deptno=30;

-- emp ���̺��� 20, 30 �μ����� ������ ��ȸ
-- SELECT deptno, * // ���� ����
-- SELECT deptno, emp.* // ok
SELECT deptno, ename, job, hiredate
FROM emp
WHERE deptno in (20,30);

SELECT deptno, ename, job, hiredate
FROM emp
WHERE deptno in 10 AND job='CLERK'; -- �˻���� ��ҹ��� ���� �ؾ� �Ѵ�.

-- scott ���� + insa.sql ��ũ��Ʈ���� ��� ���̺� ����, INSERT ��

desc insa;

-- 1) ���� ����� �̸�(name), ��ŵ�(city), �μ���(buseo), ����(jikwi) ��� 
-- + �̸������� �������� ����
-- + �μ����� 1�� �������� ���� 2�� �̸����� ��������
SELECT name, city, buseo, jikwi
FROM insa
where city='����'
ORDER BY buseo, name DESC;

-- 2) ��ŵ��� ���� ����̸鼭 �⺻���� 150���� �̻��� ��� ��� (name, city, basicpay, ssn) 
SELECT name, city, basicpay, ssn
FROM insa
where city='����' AND basicpay >= 1500000;

-- 3) ��ŵ��� ���� ����̰ų� �μ��� ���ߺ��� �ڷ� ��� (name, city, buseo) 
SELECT name, city, buseo
FROM insa
where city='����' OR buseo='���ߺ�';

-- 4) ��ŵ��� ����, ����� ����� ��� (name, city, buseo) 
SELECT name, city, buseo
FROM insa
where city in ('����', '���');

-- 5) �޿�(basicpay + sudang)�� 250���� �̻��� ���. �� �ʵ���� �ѱ۷� ���. (name, basicpay, sudang, basicpay+sudang)
-- SELECT ������ ó�� ���� ������ where������ ��Ī�� ������.
-- + pay ��������
SELECT name, basicpay, sudang, basicpay+sudang  pay
FROM insa
WHERE basicpay+sudang >= 2500000
ORDER BY pay DESC;

-- ���ӻ��(mgr)�� ���� ����� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- mgr �ڸ��� null -> BOSS �� ����
SELECT empno, ename, job, nvl(cast(mgr as varchar(4)) , 'BOSS'), hiredate
FROM emp
WHERE mgr IS NULL;
