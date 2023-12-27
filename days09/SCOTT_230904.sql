-- 2) NCHAR
CREATE TABLE test (
    aa CHAR(3)
    , bb CHAR(3 char)
    , cc NCHAR(3)
);

INSERT INTO test(aa, bb, cc)
VALUES('ȫ�浿', 'ȫ�浿', 'ȫ�浿');
INSERT INTO test(aa, bb, cc)
VALUES('ȫ', 'ȫ�浿', 'ȫ�浿');

-- NUMBER
CREATE TABLE tbl_number (
    kor NUMBER(3, 0)
    , eng NUMBER(3, 0)
    , mat NUMBER(3, 0) 
    , tot NUMBER(3, 0)
    , avg NUMBER(5, 2)
);

INSERT INTO tbl_number(kor, eng, mat)
VALUES(90.89, 85, 100);
INSERT INTO tbl_number(kor, eng, mat)
VALUES(90, 85, -999);
INSERT INTO tbl_number(kor, eng, mat)
VALUES(80, 75, 30);

INSERT INTO tbl_number(kor, eng, mat)
VALUES(TRUNC(dbms_random.value(0, 101)), TRUNC(dbms_random.value(0, 101)), TRUNC(dbms_random.value(0, 101)));

UPDATE tbl_number 
SET avg = 99999
WHERE avg = 92;

SELECT *
FROM tbl_number;

DROP TABLE test;
DROP TABLE tbl_number;
DESC test;
ROLLBACK;
COMMIT;

DESC emp;
DESC dept;
--------------------------------------------------------------------------------

-- COUNT OVER() - ������ ���� ������ ������� ��ȯ
SELECT buseo, name, basicpay
--    , COUNT(*) OVER(ORDER BY basicpay)
    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;

SELECT buseo, name, basicpay
--    , SUM(basicpay) OVER(ORDER BY basicpay)
    , SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;

-- �� ������ ��հ� ���� �޿����� ����
SELECT city, name, basicpay
    , AVG(basicpay) OVER(PARTITION BY city ORDER BY city)
    , basicpay - AVG(basicpay) OVER(PARTITION BY city ORDER BY city)
FROM insa;

-- [���̺� ����, ����, ����]
-- [���̺� ���ڵ�(��, row)�� �߰�, ����, ����]


-- 1) ���̺� - ������ �����
-- 2) DB �𵨸� -> ���̺� ����

-- ��) �Խ����� �Խñ��� ������ ���̺� ����
--  1) ���̺�� : tbl_board
--  2) �÷��� - �۹�ȣ(PK)   seq        ����(����)     NUMBER(38)      NOT NULL  
--             �ۼ���       writer     ����          VARCHAR2(20)    NOT NULL
--             ��й�ȣ     passwd     ����           VARCHAR2(15)    NOT NULL
--             ����        title       ����          VARCHAR2(100)   NOT NULL
--             ����        content     ����          CLOB
--             �ۼ���      regdate     ��¥          DATE                         DEFAULT SYSDATE
--             ���
--  3) �Խñ��� ������ �� �ִ� ������ Ű : �۹�ȣ
--  4) �ʼ� �Է� ���� : == NOT NULL ��������
--  5) �ۼ����� ���� �ý����� ��¥�� �ڵ� �Է�

--�����������ġ�
--    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
--      ( 
--        ���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] 
--       [,���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] ] 
--       [,...]  
--      ); 

CREATE TABLE tbl_board
( 
   seq NUMBER(38) NOT NULL PRIMARY KEY
   , writer VARCHAR2(20) NOT NULL
   , passwd VARCHAR2(15) NOT NULL
   , title VARCHAR2(100) NOT NULL
   , content CLOB
   , regdate DATE DEFAULT SYSDATE
); 

INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES(1, 'admin', '1234', 'test-1', 'test-1', SYSDATE);
INSERT INTO tbl_board (seq, writer, passwd, title, content)
VALUES(2, 'hong', '1234', 'test-2', 'test-2');

SELECT *
FROM tbl_board;

-- tbl_board ���̺� �������� ��� Ȯ��
SELECT *
FROM user_constraints
WHERE table_name LIKE UPPER('%board%');

INSERT INTO tbl_board
VALUES(3, 'hong', '1234', 'test-3', 'test-3', SYSDATE);

-- �÷� �߰��� ���̺��� ���� �����Ѵٸ�
-- NULL������ ä����
-- ��ȸ�� �÷� X - ���̺� ���� �� ���ο� �÷� �߰�
-- readed NUMBER
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0;
-- Į���� ���� �߰��� �� ������ �Խñ�(��)�� NULL�� �ʱ�ȭ�Ǵµ�
-- DEFAULT ���� �����ߴٸ� �� �⺻������ ������ �Խñ�(��)�� �ʱ�ȭ�� �ȴ�.

-- 1) �Խñ� �ۼ�
INSERT INTO tbl_board(writer, seq, title, passwd)
VALUES (
    'kenik'
    , (SELECT NVL(MAX(seq), 0)+1 FROM tbl_board)
    , 'test-4'
    , '1234'
);

-- content�� null�� ��� -> '�ù�' �Խñ� ����
UPDATE tbl_board 
SET content = '�ù�'
WHERE content IS NULL;

COMMIT;

-- 3) kenik �ۼ����� ��� �Խñ��� ����
DELETE FROM tbl_board
WHERE writer = 'kenik';

-- 4) �÷��� �ڷ����� ũ�� ����
-- writer NOT NULL VARCHAR(20) -> 40
SELECT MAX(VSIZE(writer))
FROM tbl_board;

ALTER TABLE tbl_board
MODIFY writer VARCHAR(40);

-- 5) title �÷��� ���� : subject �÷�������
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;

-- 6) bigo �÷��� �߰� �� ����
ALTER TABLE tbl_board
ADD bigo VARCHAR(100);

ALTER TABLE tbl_board
DROP COLUMN bigo;

DROP TABLE tbl_board;

-- 7) ���̺� ���� ����
--RENAME ���̺��1 TO ���̺��2

-- 2) ���̺� �����ϴ� ��� : ���������� �̿���
--    ��. �̹� ������ ���̺� ���� + ���� ���ڵ�(��) ����
--    ��. subquery ����ؼ� ���̺� ����.
--    ��. (1) ���̺���� + (2) ������ ���� + (3) �������� ���� x(NN O)

CREATE table tbl_emp(empno, ename, job, hiredate, mgr, pay, deptno)
AS
    SELECT empno, ename, job, hiredate, mgr, sal+NVL(comm, 0) pay, deptno
    FROM emp
;

SELECT *
FROM emp;
-- �������� ���� x

SELECT *
FROM user_constraints
WHERE table_name = 'TBL_EMP';

--  ���������� �̿��ؼ� ���̺� ���� + ������ x (���̺��� ������ �����ؼ�)
CREATE TABLE tbl_emp
AS SELECT *
FROM emp
WHERE 1 = 0;
--
DESC tbl_emp;
--
SELECT *
FROM tbl_emp;

-- [����] deptno, dname, empno, ename, hiredate, pay, grade 
-- tbl_empgrade ���̺��
CREATE TABLE tbl_empgrade
AS (
    SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm, 0) pay, grade
    FROM emp e JOIN dept d ON e.deptno=d.deptno
               JOIN salgrade s ON sal BETWEEN s.losal AND s.hisal
);

SELECT *
FROM tbl_empgrade;

--------------------------------------------------------------------------------
-- [INSERT ��]
--INSERT INTO ���̺�� [(�÷���)] VALUES (�÷� ��);

-- ��Ƽ �μ�Ʈ �� (Multi + Table + INSERT)
-- 1) unconditional insert all 


Unconditional insert all ���� ���ǰ� ������� ����Ǿ��� ���� ���� ���̺� �����͸� �Է��Ѵ�.

? ���������κ��� �ѹ��� �ϳ��� ���� ��ȯ�޾� ���� insert ���� �����Ѵ�.
? into ���� values ���� ����� �÷��� ������ ������ Ÿ���� �����ؾ� �Ѵ�.

�����ġ�
	INSERT ALL | FIRST
	  [INTO ���̺�1 VALUES (�÷�1,�÷�2,...)]
	  [INTO ���̺�2 VALUES (�÷�1,�÷�2,...)]
	  .......
	Subquery;

���⼭ 
 ALL : ���������� ��� ������ �ش��ϴ� insert ���� ��� �Է�
 FIRST : ���������� ��� ������ �ش��ϴ� ù ��° insert ���� �Է�
 subquery : �Է� ������ ������ �����ϱ� ���� ���������� �� ���� �ϳ��� ���� ��ȯ�Ͽ� �� insert �� ����
 
 -- ��)
CREATE TABLE dept_10 AS (SELECT * FROM dept WHERE 1 = 0);
CREATE TABLE dept_20 AS (SELECT * FROM dept WHERE 1 = 0);
CREATE TABLE dept_30 AS (SELECT * FROM dept WHERE 1 = 0);
CREATE TABLE dept_40 AS (SELECT * FROM dept WHERE 1 = 0);
 
INSERT ALL
    INTO dept_10 VALUES(deptno, dname, loc)
    INTO dept_20 VALUES(deptno, dname, loc)
    INTO dept_30 VALUES(deptno, dname, loc)
    INTO dept_40 VALUES(deptno, dname, loc)
SELECT deptno, dname, loc FROM dept;

SELECT *
FROM dept_40;

ROLLBACK;

DROP TABLE dept_10;
DROP TABLE dept_20;
DROP TABLE dept_30;
DROP TABLE dept_40;

-- 2) conditional insert all 

-- emp ���̺��� �� �μ����� ä�� ���� ��

CREATE TABLE emp_10 AS (SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_20 AS (SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_30 AS (SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_40 AS (SELECT * FROM emp WHERE 1=0);

INSERT ALL
--INSERT FIRST
    WHEN deptno = 10 THEN
    INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 20 THEN
    INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 30 THEN
    INTO emp_30 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 40 THEN
    INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * 
FROM emp;

SELECT *
FROM emp_10;
SELECT *
FROM emp_20;

ROLLBACK;

-- 3) conditional first insert 

INSERT FIRST
    WHEN deptno = 10 THEN
    INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 20 THEN
    INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 30 THEN
    INTO emp_30 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 40 THEN
    INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * 
FROM emp;

-- [INSERT ALL / INSERT FIRST] ������ ����
-- ALL�� ������ �����ϸ� ������ ������ 
-- FIRST�� ����1���� ������ �ϸ� �������ǿ��� ���Ե��� �ʴ´�.

INSERT FIRST 
WHEN deptno = 10 THEN
    INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
WHEN job = 'CLERK' THEN
    INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
ELSE
    INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT *
FROM emp;

-- 4) pivoting insert 

create table sales(
employee_id       number(6),
week_id            number(2),
sales_mon          number(8,2),
sales_tue          number(8,2),
sales_wed          number(8,2),
sales_thu          number(8,2),
sales_fri          number(8,2)
);

insert into sales values(1101,4,100,150,80,60,120);

insert into sales values(1102,5,300,300,230,120,150);

COMMIT;

create table sales_data(
employee_id        number(6),
week_id            number(2),
sales              number(8,2));

insert all
into sales_data values(employee_id, week_id, sales_mon)
into sales_data values(employee_id, week_id, sales_tue)
into sales_data values(employee_id, week_id, sales_wed)
into sales_data values(employee_id, week_id, sales_thu)
into sales_data values(employee_id, week_id, sales_fri)
select employee_id, week_id, sales_mon, sales_tue, sales_wed,
sales_thu, sales_fri
from sales;

SELECT *
FROM sales_data;

-- 1) emp_10 ���̺��� ��� �� ���� + COMMIT, ROLLBACK
DELETE FROM emp_10;
SELECT *
FROM emp_20;

-- 2) emp_20 ���̺��� ��� �� ���� + �ڵ� Ŀ��
TRUNCATE TABLE emp_20;
SELECT *
FROM emp_20;

-- 3) ���̺� ��ü�� ����
DROP TABLE emp_30;
--------------------------------------------------------------------------------

-- [����] insa ���̺��� num, name �÷����� �����ؼ� ���ο� tbl_score ���̺� ����
-- (num <= 1005)
CREATE TABLE tbl_score
AS (
    SELECT num, name
    FROM insa
    WHERE num <= 1005
);

SELECT *
FROM tbl_score;

-- [����] tbl_score ���̺� kor, eng, mat, tot, avg, grade, rank �÷� �߰�
-- (���� ��, ��, ��, ������ �⺻�� 0)
ALTER TABLE tbl_score
ADD (
    kor NUMBER(3) DEFAULT 0
    , eng NUMBER(3) DEFAULT 0
    , mat NUMBER(3) DEFAULT 0
    , tot NUMBER(3) DEFAULT 0
    , avg NUMBER(5,2)
    , grade CHAR
    , rank NUMBER(3)
);

DESC tbl_score;

-- [����] 1001~1005 5�� �л��� kor, eng, mat ������ ������ ������ ����
UPDATE tbl_score 
SET kor = TRUNC(dbms_random.value(0, 101))
    , eng = TRUNC(dbms_random.value(0, 101))
    , mat = TRUNC(dbms_random.value(0, 101));

-- [����] 1005 �л��� k,e,m -> 1001 �л��� ������ ����
UPDATE tbl_score 
SET kor = (SELECT kor FROM tbl_score WHERE num = 1005)
    , eng = (SELECT eng FROM tbl_score WHERE num = 1005)
    , mat = (SELECT mat FROM tbl_score WHERE num = 1005)
WHERE num=1001;
    
UPDATE tbl_score
SET (kor, eng, mat) = (SELECT kor, eng, mat FROM tbl_score WHERE num = 1005)
WHERE num = 1001;

-- [����] ��� �л��� ����, ����� ����
UPDATE tbl_score
SET tot = kor+eng+mat, avg = (kor+eng+mat)/3;

-- [����] ���(grade) 'A', 'B', 'C', 'D', 'F'
UPDATE tbl_score
SET grade = CASE 
            WHEN avg>=90 THEN 'A'
            WHEN avg>=80 THEN 'B'
            WHEN avg>=70 THEN 'C'
            WHEN avg>=60 THEN 'D'
            ELSE 'F'
            END;
            
-- [����] tbl_score ���̺��� ��� ó��
UPDATE tbl_score t
SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE avg > t.avg);

UPDATE tbl_score p
SET rank = (
        SELECT t.r
        FROM(
            SELECT num, tot, RANK() OVER(ORDER BY tot DESC) r
            FROM tbl_score
        ) t
        WHERE p.num = t.num
);


-- [����] ��� �л����� ���� ������ 20�� ����
UPDATE tbl_score
SET eng = CASE
            WHEN eng >= 80 THEN 100
            ELSE eng + 20
            END;


-- [����] ��,��,�� ������ �� �����Ǹ� ������ �л����� ����, ���, ��ü�л����� ����� �޶���
-- Ʈ���� -> PL/SQL 5������ �� ����


-- [����] ���л��鸸 ���� ������ 5���� ���� ��Ű�� ���� �ۼ�
UPDATE tbl_score
SET kor = CASE
            WHEN kor >= 95 THEN 100
            ELSE kor + 5
          END
WHERE num IN (
    SELECT t.num
    FROM tbl_score t JOIN insa i ON t.num = i.num
    WHERE MOD(SUBSTR(ssn, 8, 1), 2) = 0
);

SELECT *
FROM tbl_score;

ROLLBACK;
COMMIT;

-- [merge]

CREATE TABLE tbl_emp(
    id NUMBER PRIMARY KEY, -- NOT NULL �� ���� �ֱ⵵ �Ѵ�. PK�� ȸ���� �� NOT NULL�� ������� ���� 
    name VARCHAR2(10) NOT NULL,
    salary  NUMBER,
    bonus NUMBER DEFAULT 100
);

insert into tbl_emp(id,name,salary) values(1001,'jijoe',150);
insert into tbl_emp(id,name,salary) values(1002,'cho',130);
insert into tbl_emp(id,name,salary) values(1003,'kim',140);
select * from tbl_emp;

create table tbl_bonus(
    id number
    , bonus number default 100
);

insert into tbl_bonus(id)
(select e.id from tbl_emp e);

INSERT INTO tbl_bonus VALUES(1004, 50);

SELECT *
FROM tbl_bonus;

-- tbl_emp �� tbl_bonus ����
MERGE INTO tbl_bonus b
USING (SELECT id, salary FROM tbl_emp) e
ON (b.id = e.id)
WHEN MATCHED THEN UPDATE SET b.bonus = b.bonus + e.salary*0.01
WHEN NOT MATCHED THEN INSERT (b.id, b.bonus) VALUES (e.id, e.salary*0.01);

SELECT *
FROM tbl_bonus;

SELECT *
FROM tbl_emp;


DESC tbl_emp;





