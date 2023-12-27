-- 2���� ���� 
-- 11��
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

-- �ζ��� ��(INLINE VIEW)
SELECT *
FROM (
        SELECT buseo, name, basicpay+sudang pay
        FROM insa
     ) 
WHERE pay BETWEEN 2000000 AND 2500000;

-- 12��
SELECT empno, ename, hiredate
FROM emp
--WHERE hiredate >= '81/1/1' AND hiredate <= '81/12/31'
--WHERE hiredate BETWEEN '81/1/1' AND '81/12/31'
ORDER BY hiredate;


SELECT *
FROM dual;

DESC dual;

-- ���� ��¥ ��ȸ
SELECT SYSDATE 
    , EXTRACT(YEAR FROM SYSDATE) year
    , EXTRACT(MONTH FROM SYSDATE) month
    , EXTRACT(DAY FROM SYSDATE) day
    , TO_CHAR(SYSDATE, 'YY')
FROM dual;

-- �� ����� ����
DELETE 
FROM emp
where empno IN (7876,7788);
--ROLLBACK;
COMMIT;
SELECT empno, ename, hiredate
    , EXTRACT(YEAR FROM hiredate) h_year  
FROM emp
WHERE SUBSTR(hiredate, 1, 2) = '81'
--WHERE TO_CHAR(hiredate, 'YY') = 81 -- ������ �ȳ���. ���� �ڵ��� �ƴϴ�.
--WHERE TO_CHAR(hiredate, 'YY') = '81'
--WHERE EXTRACT(YEAR FROM hiredate) = 1981
ORDER BY hiredate ;

-- SUBSTR �Լ� ����
SELECT SUBSTR('abcdesfg', 3,2)
        , SUBSTR('abcdefg',3)
        , SUBSTR('abcdefg', -3,2)
FROM dual; 


-- 14-3�� ����
-- number -> char
SELECT empno, ename, job
--        , NVL(comm, 'CEO') mgr
        , NVL(TO_CHAR(mgr), 'CEO') mgr
        , hiredate, sal, comm, deptno
FROM emp;

SELECT 'ABCd', UPPER('AbCd'), LOWER('AbCd'), INITCAP('AbCd')
FROM dual;

SELECT name
    -- ���� ������ ����, ������ ������ ����
    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang) pay
    , TO_CHAR(basicpay + sudang, 'L99,999,999') pay, ibsadate
FROM insa;

------------------------------------------------------------------------------

-- [����] insa ���̺��� �̸�, �ֹε�Ϲ�ȣ, �⵵, ��, ��, ����, ���� ��ȸ
-- ����� 721217-1****
SELECT name, SUBSTR(ssn, 0, 8) || '******' rrn, SUBSTR(ssn, 1, 2) �⵵, SUBSTR(ssn, 3, 2) ��, SUBSTR(ssn, 5, 2) ��, SUBSTR(ssn, 8, 1) ����
FROM insa;

SELECT name, SUBSTR(ssn, 0, 8) || '******' rrn
            , SUBSTR(ssn, 1, 2) "year"
            , SUBSTR(ssn, 3, 2) "month"
            , SUBSTR(ssn, 5, 2) "date" 
            , SUBSTR(ssn, 8, 1) gender
            , SUBSTR(ssn, -1)
FROM insa;

-- ����Ŭ ������
1) ��� ������ + - * /
SELECT 1+2
        , 1-2
        , 1*2
        , 1/2
        -- , 2/0
        -- , 3.14/0
        -- , 1%2
        , MOD(1, 2)
FROM dual;

-- 2)���� ������(??) 

-- 3) ����� ���� ������  CREATE OPERATOR ������ �����ڸ� ������ �� ����

-- 4) ������ ���� ������ 

-- 5) �� ������    =   !=  <>  ^=  >   <   >=  <=
    -- ANY, SOME, ALL
SELECT deptno
FROM dept;

SELECT *
FROM emp
WHERE deptno > ANY (SELECT deptno FROM dept);
--WHERE deptno <= ANY (SELECT deptno FROM dept);
--WHERE deptno <= ALL (SELECT deptno FROM dept); -- 10�� �μ��� ��µ�
--WHERE deptno <= 20;

-- 6) �� ������ : AND OR NOT

-- 7) SQL ������
--  1) [NOT] IN (���)
--  2) [NOT] BETWEEN a AND b
--  3) IS [NOT] NULL
--  4) ANY, SOME, ALL + WHERE �� ��������
--  5) EXISTS ��� ��������
--  6) ���� ���� �˻��� ��
--      [NOT] LIKE  -   ������
--        - ���� ���� �˻��� �� ���ȴ�.
--        - ���Ͽ� ���Ǵ� ��ȣ -> ���ϵ� ī�� : % _
--        - ���ϵ� ī�带 �Ϲ� ����ó�� ����ϰ� ���� �� ESCAPE �ɼ��� ���
--        REGEXP_LIKE     -   �Լ�

-- emp ������̺� R���ڷ� �����ϴ� ����� �˻�
-- insa ���̺� ������� '��'���� ����� �˻�
-- insa ���̺� ������� ' �� '���� ����� �˻�
-- insa ���̺� ������� �������� '��'���� ����� �˻�
SELECT *
FROM insa
WHERE name LIKE '%��';
--WHERE name LIKE '%��%';
--WHERE name LIKE '��%';
--WHERE SUBSTR(name, 1, 1)='��';

-- insa ���̺� 81��� ��� ���� ��ȸ
SELECT *
FROM insa
WHERE ssn LIKE '81%';

-- insa ���̺��� ���ڻ���� ��ȸ
SELECT *
FROM insa
WHERE ssn LIKE '______-1%';

-- �̸��� �� ��° ���ڰ� '��'
SELECT *
FROM insa
WHERE name LIKE '_��%';

SELECT *
FROM dept;

-- ���ο� �μ��� �߰�
INSERT INTO dept (deptno, dname, loc) 
VALUES(50, '�ѱ�_����', 'SEOUL');
INSERT INTO dept (deptno, dname, loc) 
VALUES(60, '��100%��', 'SEOUL');
COMMIT;

-- �μ��� '_��' �˻�
SELECT *
FROM dept
WHERE dname LIKE '%\_��%' ESCAPE '\';

-- �μ��� % �μ��� �˻�
SELECT *
FROM dept
WHERE dname LIKE '%\%%' ESCAPE '\';

DESC dept;

-- UPDATE
--UPDATE ���̺�� SET �÷���=�÷��� [WHERE ������] 
UPDATE dept 
SET loc='KOREA'
WHERE loc='SEOUL';

DELETE FROM dept
WHERE deptno >= 50;
COMMIT;

ROLLBACK;

-- [dual] ? PUBLIC SYNONYM 
-- scott ����ڰ� �����ϰ� �ִ� ���̺� ���� ��ȸ
SELECT *
FROM tabs;
SELECT *
FROM all_tables;

SELECT *
FROM arirang;


-- [����Ŭ �Լ�]
