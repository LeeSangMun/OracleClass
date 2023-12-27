-- 4���� ����
SELECT COUNT(DISTINCT job)
FROM emp;

SELECT DISTINCT job, (SELECT COUNT(DISTINCT job) FROM emp)
FROM emp;


SELECT ssn
        , SUBSTR(ssn, 1, 2) year
        , EXTRACT(MONTH FROM TO_DATE(SUBSTR(ssn, 1, 6))) month  
        , SUBSTR(ssn, 5, 2) "date"
        , SUBSTR(ssn, 8, 1) gender
FROM insa;

SELECT name, SUBSTR(ssn, 1, 8) || '******' rrn
FROM insa
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 1 AND ssn LIKE '7%';

SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_12%';

SELECT ename
        , NULLIF(ename, 'SMITH')
FROM emp;

-- COALESCE : �յ��ϴ�.
SELECT sal, comm
        , sal + NVL(comm, 0) pay
        , sal + NVL2(comm, comm, 0) pay
        , COALESCE(sal+comm, sal, 0) pay
FROM emp;

SELECT name, ssn
        , NVL2(NULLIF(SUBSTR(ssn, 8, 1), '2'), 'O', 'X')
        , NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1) gender
        , NVL2(NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1), '����', '����')
FROM insa;

SELECT SYSDATE
        , TO_CHAR(SYSDATE, 'CC') -- 21����
        , TO_CHAR(SYSDATE, 'SCC') -- 21����
FROM dual;

-- '05/01/10'
SELECT '05/01/10'
        , TO_CHAR( TO_DATE('05/01/10', 'RR/MM/DD'), 'YYYY') rr -- 2005
        , TO_CHAR( TO_DATE('05/01/10', 'YY/MM/DD'), 'YYYY') yy -- 2005
        , TO_CHAR( TO_DATE('97/01/10', 'RR/MM/DD'), 'YYYY') -- 1997
        , TO_CHAR( TO_DATE('97/01/10', 'YY/MM/DD'), 'YYYY') -- 2097
FROM dual;

SELECT ename, hiredate
        , TO_CHAR(hiredate, 'YYYY')
FROM emp;

SELECT ename, REPLACE(ename, UPPER('m'), '*')
FROM emp
WHERE ename LIKE '%'||UPPER('m')||'%';
--WHERE UPPER(ename) LIKE '%M%';

-- [����] emp ���̺��� ename 'la' ��ҹ��� ���о��� �ִ� ��� ��ȸ
SELECT ename
        , REPLACE(ename, 'LA', '<span style="color:red">LA</span>')
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i'); -- i�ɼ��� ��ҹ��� �������
-- match_option : i(��ҹ��� ����x), c(��ҹ��� ����o), m(��Ƽ ����), x(���鹮�� ����)
--WHERE ename LIKE '%la%' OR ename LIKE '%lA%' OR ename LIKE '%La%' OR ename LIKE '%LA%' ;

-- ������ �Լ�
SELECT COUNT(*)
FROM emp;

-- ������ �Լ�
SELECT LOWER(ename)
FROM emp;

-- insa ���̺��� ���ڻ����
--WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn,-7,1), 2) = 1;
SELECT ssn
FROM insa
WHERE REGEXP_LIKE(ssn, '^7.{6}[13579]');

-- [����] insa ���̺��� ���� �达, �̾��� ��ȸ
-- 1) LIKE
SELECT *
FROM insa
WHERE name LIKE '��%' OR name LIKE '��%';

-- 2) REGEXP_LIKE()
SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[����]');

-- [����] insa ���̺��� ���� �达, �̾��� ������ ��� ��ȸ
-- 1) LIKE
SELECT *
FROM insa
WHERE NOT (name LIKE '��%' OR name LIKE '��%');

-- 2) REGEXP_LIKE()
SELECT *
FROM insa
WHERE REGEXP_LIKE(name, '^[^����]');

SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
FROM emp
ORDER BY pay DESC;

-- SQL������ ALL ���
WITH temp AS (
    SELECT deptno, empno, ename, sal + NVL(comm, 0) pay
    FROM emp
)
SELECT *
FROM temp
--WHERE pay <= ALL (SELECT pay FROM temp); -- ���� ����
WHERE pay >= ALL (SELECT pay FROM temp); -- ���� ū

SELECT MAX(sal + NVL(comm, 0)) max_pay
        , MIN(sal + NVL(comm, 0)) min_pay
FROM emp;

SELECT deptno, ename, sal+NVL(comm, 0) pay
FROM emp
WHERE sal+NVL(comm, 0) = (SELECT MAX(sal + NVL(comm, 0)) max_pay FROM emp);
--WHERE sal+NVL(comm, 0) = 5000;

-------------------------------------------------------------------------

-- [���տ�����(Set Operator)]
-- 1) �� ���̺��� �÷� ���� ����, 
-- 2) �����Ǵ� �÷����� ������ Ÿ���� �����ؾ� �Ѵ�.
-- 3) �÷��̸��� �޶� ��� ������, 
-- 4) ���� ������ ����� ��µǴ� �÷��� �̸��� ù ��° select ���� �÷� �̸��� ������.
-- 5) ������ : UNION, UNION ALL
--    ������ : INTERSECT
--    ������ : MINUS

-- emp + insa ��� ��� ������ ��ȸ
SELECT empno, ename, hiredate
FROM emp
UNION
SELECT num, name, ibsadate
FROM insa;

-- [UNION�� UNION ALL�� ������]
-- 1) insa ���̺��� ���ߺ� ��ȸ
SELECT name, city, buseo
FROM insa
WHERE buseo='���ߺ�'
INTERSECT
SELECT name, city, buseo
FROM insa
WHERE city='��õ';
-- 3) INTERSECT
-- 4) ������
SELECT name, city, buseo
FROM insa
WHERE buseo='���ߺ�'
UNION ALL
-- 2) insa ���̺��� ������� : ��õ ��ȸ
SELECT name, city, buseo
FROM insa
WHERE city='��õ';

-- [����] insa ���̺��� ���� o,���� x
SELECT name,  NVL2(NULLIF(MOD(SUBSTR(ssn,-7, 1), 2), 1), 'X', 'O') gender
FROM insa;


-- ���տ�����()
-- 1) ���� ��ȸ
SELECT name
FROM insa
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 1;
-- 2) ���� ��ȸ
SELECT name, ssn, 'X' gender
FROM insa
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 1;

--IS NAN == NOT A number
--IS [NOT] INFINITE

---------------------------------------------------------

--1. ����Ŭ �Լ� ����
--2.      "���"
--3.      "����" 
_______________________________________________________________
--(1) �����Լ�
--    ROUND() - �ݿø��Լ�
SELECT ROUND(15.193) a
        , ROUND(15.193, 1)
--        , ROUND(15.193, n) -- �Ҽ��� n+1 �ڸ����� �ݿø�
        , ROUND(15.193, -1) -- �Ҽ����� ����. ���� �ڸ����� �ݿø�
        , ROUND(15.193, -2) -- ���� �ڸ����� �ݿø�
FROM dual;

--    CELL() - �ø��Լ�
-- ������ ���ں��� ���ų� ū ���� �߿� ���� �ּҰ�
SELECT CEIL(15.193)
        , CEIL(15.913)
FROM dual;

--    FLOOR() - �����Լ�, TRUNC()
-- ������ ���ں��� �۰ų� ���� ���� �߿� �ִ밪
SELECT FLOOR(15.193)
        , FLOOR(15.913)
FROM dual;

-- 15.193 ���ڸ� �Ҽ��� 2�ڸ����� ���� <- TRUNC(���� ��ġ) ���
SELECT FLOOR(15.8193)
        , FLOOR(15.8193*10)/10
        , TRUNC(15.8193, 1)
        , TRUNC(15.8193, 2)
        , TRUNC(15.8193, -1) -- ���� �ڸ����� ����
FROM dual;

-- �Ҽ��� 3�ڸ����� �ݿø��ؼ� �Ҽ��� 2�ڸ����� ���.
SELECT 10/3
        , ROUND(10/3, 2)
FROM dual;

-- ������ MOD(), REMAINDER()
SELECT MOD(19,4)
        , REMAINDER(19, 4)
FROM dual;

-- MOD(n2, n1)          = n2-n1*FLOOR(n2/n1)
-- REMAINDER(n2, n1)    = n2-n1*ROUND(n2/n1)

--ABS() - ����
SELECT ABS(100), ABS(-100)
        , SIGN(100), SIGN(-100)
        , SIGN(0)
        , POWER(2,3)
        , SQRT(2)
FROM dual;

--(2) �����Լ�
-- UPPER()
-- LOWER()
-- INITCAP()
-- CONCAT()
-- SUBSTR()

-- LENGTH()
SELECT DISTINCT job
        , LENGTH(job)
FROM emp;

-- emp ���̺��� ename�� M ���ڰ� �ִ� ��� ��ȸ
-- L ���ڰ� �ִ� ��ġ���� ��ȸ
SELECT ename, job, INSTR(ename, 'L')
FROM emp
WHERE REGEXP_LIKE(ename, 'L', 'i');
--WHERE ename LIKE '%M%';

-- INSTR()
SELECT INSTR('corporate floor','or') 
        , INSTR('corporate floor','or', 1, 3)
        , INSTR('corporate floor','or', -1, 3)
        , INSTR('corporate floor','or', 4) 
        , INSTR('corporate floor','or', 4, 2)
FROM dual;

-- RPAD() / LPAD()
-- PAD == �е�, �� ��� ��, �ſ� �ִ� ��
-- ����) RPAD(expr1, n[, expr2])

-- 100 #
SELECT ename, sal + NVL(comm, 0) pay
        , ROUND(sal + NVL(comm, 0), -2)
        , ROUND(sal + NVL(comm, 0), -2)/100
        , RPAD(' ', ROUND(sal + NVL(comm, 0), -2)/100+1, '#')
        , RPAD(ROUND(sal + NVL(comm, 0), -2)/100, ROUND(sal + NVL(comm, 0), -2)/100+LENGTH(TO_CHAR(ROUND(sal + NVL(comm, 0), -2)/100)), '#')
--        , LPAD(sal + NVL(comm, 0), 10, '*')
--        , RPAD(sal + NVL(comm, 0), 10, '*')
FROM emp;

-- RTRIM() / LTRIM(), TRIM()
SELECT '[' || '   admin   ' || ']'
        , '[' || LTRIM('   admin   ') || ']'
        , '[' || RTRIM('   admin   ') || ']'
        , '[' || TRIM('   admin   ') || ']'
        , '[' || LTRIM('xyxyadminxyxy', 'xy') || ']'
        , '[' || RTRIM('xyxyadminxyxy', 'xy') || ']'
FROM dual;

-- ASCII(), CHR()
SELECT ASCII('A'), ASCII('a'), ASCII('0')
        , CHR(65), CHR(97), CHR(48)
FROM dual;

-- GREATEST() / LEAST()
SELECT GREATEST(3,5,2,4,1)
        , LEAST(3,5,2,4,1)
        , GREATEST('MBC', 'TVC', 'SBS')
FROM dual;

-- REPLACE

-- VSIZE()
SELECT VSIZE('a'), VSIZE('��')
FROM dual;




--(3) ��¥�Լ�
--(4) ��ȯ�Լ�
--(5) �Ϲ��Լ� - ����ǥ���� �Լ�
--(6) �����Լ�
        

CREATE TABLE TEST (
    ID VARCHAR2(20) PRIMARY KEY,
    NAME VARCHAR2(20),
    EMAIL VARCHAR2(20)
);

INSERT INTO test(id, name, email)
VALUES(1, '�Ѷ��', '');
INSERT INTO test(id, name, email)
VALUES(2, '��λ�', '');
INSERT INTO test(id, name, email)
VALUES(3, '�ݰ���', '');

SELECT *
FROM test;

