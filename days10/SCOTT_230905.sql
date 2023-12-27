-- [��������]
-- ���������� data integrity(������ ���Ἲ)�� ���ؼ�
-- ���Ἲ ����
--  ? 1) ��ü ���Ἲ(Entity Integrity)
--  ? 2) ���� ���Ἲ(Relational Integrity)
--  ? 3) ������ ���Ἲ(domain integrity)

-- ORA-02449: unique/primary keys in table referenced by foreign keys
DROP TABLE dept;

SELECT *
FROM emp;

UPDATE emp
SET deptno=NULL
WHERE ename='KING';


-- ���������� �����ϴ� ���
-- 1) �÷� ���� ��� (IN-LINE ���)
-- 2) ���̺� ���� ��� (OUT-OF-LINE ���)

--CREATE TABLE sample(
--    �÷��� ...
--    , CONSTRAINT �������Ǽ���
--    , CONSTRAINT id NOT NULL // x NOT NULL ���������� Į�������� �����ؾ� �Ѵ�.
--    , CONSTRAINT id + pwd ����Ű�� ����(����Ű�� Į�������� ������ �� ����.)
--    , CONSTRAINT �������Ǽ���
--);


-- ���������� �����ϴ� ����
-- 1) ���̺� ������ �� - CREATE TABLE ��
-- 2) ���̺� ������ �� - ALTER TABLE ��


-- �������� ���� 5����
-- PRIMARY KEY(PK) - �ش� �÷� ���� �ݵ�� �����ؾ� �ϸ�, �����ؾ� �� (NOT NULL�� UNIQUE ���������� ������ ����) 
-- FOREIGN KEY(FK) - �ش� �÷� ���� �����Ǵ� ���̺��� �÷� �� ���� �ϳ��� ��ġ�ϰų� NULL�� ���� 
-- UNIQUE KEY(UK) - ���̺����� �ش� �÷� ���� �׻� �����ؾ� �� 
-- NOT NULL - �÷��� NULL ���� ������ �� ����. 
-- CHECK(CK) - �ش� �÷��� ���� ������ ������ ���� ������ ���� ���� 

-- �ǽ�) tbl_contraint
-- 1) �÷� ���� �������� ����
CREATE TABLE tbl_constraint1 (
    empno NUMBER(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR(20)
    , deptno NUMBER(2) CONSTRAINT FK_tblconstraint1_deptno REFERENCES dept(deptno)
    , kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)       
    , email VARCHAR2(250) CONSTRAINT UK_tblconstraint1_email UNIQUE-- ������ ��, ���ϼ� ��������(UK)
    , city VARCHAR2(20) CONSTRAINT CK_tblconstraint1_city CHECK(city IN ('����', '�λ�', '�뱸', '����'))  
);

SELECT *
FROM user_constraints
WHERE table_name = UPPER('tbl_constraint1');

DROP TABLE tbl_constraint1;

--ALTER TABLE ���̺�� 
--DROP [CONSTRAINT constraint�� | PRIMARY KEY | UNIQUE(�÷���)]
--[CASCADE];

-- ��. 
ALTER TABLE tbl_constraint1
DROP CONSTRAINT SYS_C007038;

ALTER TABLE tbl_constraint1
DROP CONSTRAINT PK_tbl_constraint1_empno;

-- ��. PK �������Ǹ��� ���� ������ �� �ִ�.
ALTER TABLE tbl_constraint1
DROP PRIMARY KEY;

-- 2) ���̺� ���� �������� ����
CREATE TABLE tbl_constraint2 (
    empno NUMBER(4) NOT NULL
    , ename VARCHAR2(20)
    , dete NUMBER(2)
    , kor NUMBER(3)
    , email VARCHAR2(250)
    , city VARCHAR2(20)
    , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY(empno)
    , CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deotno) REFERENCES dept(deptno)
    , CONSTRAINT CK_tblconstraint2_kor CHECK(kor BETWEEN 0 AND 100)
    , CONSTRAINT UK_tblconstraint2_email UNIQUE(email)
    , CONSTRAINT CK_tblconstraint1_city CHECK(city IN ('����', '�λ�', '�뱸', '����'))  
);


-- 3) ���̺� ���� �Ŀ� PK �������� ����
DROP TABLE tbl_constraint3;
CREATE TABLE tbl_constraint3 (
    emp NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);

ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tbl_constraint3_empno PRIMARY KEY(empno);

ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tbl_constraint3_empno F KEY(empno);

-- �������� ��Ȱ��ȭ / Ȱ��ȭ
ALTER TABLE ���̺��
ENABLE CONSTRAINT �������Ǹ�;

ALTER TABLE ���̺��
DISABLE CONSTRAINT �������Ǹ�;



-- ���̺�� �� ���̺��� �����ϴ� ����Ű�� ���ÿ� ����
DROP TABLE ���̺�� CASCADE CONSTRAINT;
DROP TABLE ���̺��;    -- ���� ����
DROP TABLE ���̺�� PURGE; -- �����뿡 ���� �ʰ� ���� ����

--���÷������� ���ġ�
--        �÷��� ������Ÿ�� CONSTRAINT constraint��
--	REFERENCES �������̺�� (�����÷���) 
--             [ON DELETE CASCADE | ON DELETE SET NULL]
deptno NUMBER(2) CONSTRAINT FK_EMP_DEPTNO 
REFERENCES dept(deptno) 
ON DELETE SET NULL; -- 30�� �μ��� ������ �� emp���̺��� 30�� ������� depteno�� ���� null�� �����ȴ�.
ON DELETE CASCADE; -- 30�� �μ��� ������ �� emp���̺��� 30�� ����鵵 ���� �����ȴ�.

DELETE FROM dept
WHERE deptno = 30;

-- �ǽ�)
CREATE TABLE tbl_emp AS (SELECT * FROM emp);
CREATE TABLE tbl_dept AS (SELECT * FROM dept);

-- emp, dept ���̺��� ���������� Ȯ��
-- PK, FK �߰�
-- FK + ON DELETE �ɼ� �߰�
SELECT *
FROM user_constraints
WHERE table_name = UPPER('emp');
SELECT *
FROM user_constraints
WHERE table_name = UPPER('dept');

ALTER TABLE tbl_dept
ADD (CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno));

ALTER TABLE tbl_emp
ADD (CONSTRAINT pk_tblemp_empno PRIMARY KEY(empno));

ALTER TABLE tbl_emp
ADD (CONSTRAINT fk_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno) ON DELETE SET NULL);

DESC dept;
DESC emp;

SELECT *
FROM tbl_emp;
SELECT *
FROM tbl_dept;
DELETE FROM tbl_dept 
WHERE deptno=30;

ALTER TABLE tbl_emp
DROP CONSTRAINT fk_tblemp_deptno;


-- [����(join)]

CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- åID
      ,title      VARCHAR2(100) NOT NULL  -- å ����
      ,c_name  VARCHAR2(100)    NOT NULL     -- c �̸�
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK��(��) �����Ǿ����ϴ�.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

COMMIT;

SELECT *
FROM book;

CREATE TABLE danga(
      b_id  VARCHAR2(10)  NOT NULL  -- PK , FK  // �ĺ� ����
      ,price  NUMBER(7) NOT NULL    -- å ����
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);

INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT;

SELECT *
FROM danga;

 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * 
FROM au_book;
          
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   

-- JOIN ����
-- 1) EQUL JOIN
-- �� �� �̻��� ���̺� ����Ǵ� �÷����� ������ ��ġ�ϴ� ��쿡 ����ϴ� ���� �Ϲ����� join ������,
-- WHERE ���� '='(��ȣ)�� ����Ѵ�.
-- ���� primary key, foreign key ���踦 �̿��Ѵ�.
-- ����Ŭ������ NATURAL JOIN�� EQUI JOIN�� �����ϴ�.
-- �Ǵ� USING ���� ����Ͽ� EQUI JOIN�� ������ ����� ����Ѵ�


-- [����] åID, å����, ���ǻ�(c_name), �ܰ� ���
-- 1)
SELECT book.b_id, book.title, book.c_name, danga.price
FROM book, danga
WHERE book.b_id = danga.b_id;

-- 2)
??

-- 3)
SELECT book.b_id, book.title, b.c_name, d.price
FROM book b JOING  danga d on b.b_id = d.b_id;

-- 4) USING �� ��� - ��ü��.Į���� X �Ǵ� ��Ī��.�÷Ÿ� X
SELECT b_id, title n_name, price
FROM book JOIN gdanga USING;

-- 5) åID, å����, �Ǹż���, �ܰ�, ������, �Ǹűپ� ���
--  ��) 

SELECT b.b_id, title, p_su, price, g_name, p_su*price �Ǹűݾ�
FROM book b, danga d, panmai p , gogaek g
WHERE b.b_id = d.b_id AND b.b_id = p.b_id AND p.g_id = g.g_id;

--  ��) JOIN ���

SELECT b.b_id, title, p_su, price, g_name, p_su*price �Ǹűݾ�
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;

--  ��) Using
SELECT b_id, title, p_su, price, g_name, p_su*price �Ǹűݾ�
FROM book JOIN danga USING (b_id)
          JOIN panmai USING (b_id)
          JOIN gogaek USING (g_id);

SELECT *
FROM au_book;

-- 2) NON EQUL JOIN

-- 3) INNER JOIN : �� �̻��� ���̺��� ���������� �����ϴ� �ุ ��ȯ
SELECT d.deptno
FROM emp e, dept d
WHERE d.deptno = e.deptno;

-- 4) OUTER JOIN
-- LEFT OUTER JOIN
SELECT d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno(+);

SELECT d.deptno
FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno;

-- RIGHT OUTER JOIN
SELECT d.deptno
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno;

SELECT d.deptno
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno;

-- FULL OUTER JOIN
SELECT d.deptno
FROM emp e FULL JOIN dept d ON e.deptno = d.deptno;

-- 5) SELF JOIN
-- deptno/empno/ename �����ϰ� ���ӻ���� �μ���ȣ/�����ȣ/�����
SELECT e1.deptno, e1.empno, e1.ename, e2.deptno, e1.mgr, e2.empno, e2.ename
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno;

-- 6) CROSS JOIN
SELECT d.deptno, dname, empno, ename
FROM emp e, dept d;

SELECT d.deptno, dname, empno, ename
FROM emp e CROSS JOIN dept d;

-- 7) ANTIJOIN
-- ���������� NOT IN�� �÷��� ��ȯ

-- 8) semijoin
-- ���������� EXISTS�ϴ� �÷��� ��ȯ






