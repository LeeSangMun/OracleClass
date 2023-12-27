-- [����] åID, å����, �ܰ�, �Ǹż���, ����(��), �Ǹűݾ� ��ȸ

-- BOOK    : b_id, title, 
-- DANGA   : b_id, price
-- PANMAI  : b_id, p_su
-- GOGAEK  : g_name

SELECT b.b_id, title, price, p_su, g_name, price*p_su
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;
            
-- [����] ���ǵ� å���� ���� �� �� ���� �Ǹ� �Ǿ����� ��ȸ
SELECT b.b_id, title, price, SUM(p_su)
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
GROUP BY b.b_id, title, price
ORDER BY b.b_id;

-- [����] å �Ǹŵ� ���� �ִ� åID, ���� ��ȸ
-- [����] å �� ���� �Ǹŵ� ���� ���� åID, ���� ��ȸ
SELECT b_id, title
FROM book
WHERE b_id IN (
    SELECT b_id
    FROM panmai
    GROUP BY b_id
);

SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id IN (
    SELECT DISTINCT b_id
    FROM panmai
);

SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id NOT IN (
    SELECT b_id
    FROM panmai
    GROUP BY b_id
);


-- [����] ���ǵ� å���� ���� �� �� ���� �Ǹ� �Ǿ����� ��ȸ
-- + �Ǹŵ� ���� ���� å�� 0����

SELECT b.b_id, title, NVL(SUM(p_su), 0) "�ǸűǼ�"
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, title
ORDER BY �ǸűǼ� DESC;

-- [����] ���� �ǸűǼ��� ���� å�� ���� ������ ���
-- (b_id, title, ���ǸűǼ�)

SELECT *
FROM(
    SELECT b.b_id, title, NVL(SUM(p_su), 0) "�ǸűǼ�"
    FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
    GROUP BY b.b_id, title
    ORDER BY �ǸűǼ� DESC
)
WHERE ROWNUM <= 3;

-- [����] �⵵�� ���� �Ǹ� ��Ȳ ��ȸ
-- (�Ǹų⵵, �Ǹſ�, �Ǹűݾ�(p_su * price))

SELECT TO_CHAR(p_date, 'YYYY') �Ǹų⵵, TO_CHAR(p_date, 'MM') �Ǹſ�, SUM(p_su*price) �Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
ORDER BY �Ǹų⵵, �Ǹſ�;


-- [����] �⵵�� ������ �Ǹ� ��Ȳ
-- �⵵ / ����ID / ������ / ���Ǹűݾ�
SELECT TO_CHAR(p_date, 'YYYY') �Ǹų⵵, g.g_id, g_name, SUM(price*p_su)
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON p.g_id = g.g_id
GROUP BY TO_CHAR(p_date, 'YYYY'), g.g_id, g_name
ORDER BY �Ǹų⵵, g_name;

-- [����] ���� ������ �Ǹ���Ȳ
-- �����ڵ� / ������ / �Ǹűݾ��� / ����(�Ҽ��� ��°�ݿø�)
-- ??
SELECT g.g_id, g_name, SUM(price*p_su) �Ǹűݾ���
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON p.g_id = g.g_id
WHERE p_date LIKE TO_CHAR(SYSDATE, 'YY') || '%'
GROUP BY g.g_id, g_name;

-- [����] å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
-- (åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ�)
SELECT b.b_id, title, price, SUM(p_su) "���ǸűǼ�", SUM(price*p_su) "���Ǹűݾ�"
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, title, price
HAVING SUM(price*p_su) >= 15000;

-- [����] å�� ���ǸűǼ��� 10�� �̻� �ȸ� å�� ������ ��ȸ
-- (åID, ����, ����, ���Ǹŷ�)
SELECT b.b_id, title, price, SUM(p_su)
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, title, price
HAVING SUM(p_su) >= 10;


-- [��(view)]
-- 1) �������̺� : �Ѱ� �̻��� �⺻ ���̺��̳� �ٸ� �並 �̿��Ͽ� �����Ǵ� ���� ���̺�
-- 2) ��ü ������ �߿��� �Ϻθ� ������ �� �ֵ��� �����ϱ� ���� ���
-- 3) ��� ������ ���� ���̺� �信 ���� ���Ǹ�

SELECT *
FROM user_sys_privs;

-- �� ����
-- 

SELECT b.b_id, title, price, p_su, g_name, price, p_su
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;

CREATE OR REPLACE VIEW  panView
AS (
    SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
        , p_su*price amt
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id
                JOIN gogaek g ON p.g_id = g.g_id
    ORDER BY p_date
);

SELECT *
FROM panview;

-- ����, ���ȼ� (����)

-- �� �ҽ� Ȯ�� : DB ��ü, ���� ����
SELECT text
FROM user_views;

-- �� ���� CREATE OR REPLACE VIEW ����
-- �� ����
DROP VIEW panview;

-- [����] �⵵, ��, ���ڵ�, ����, �Ǹűݾ���(�⵵�� ��)
--      (�⵵, �� ��������) // ��� �ۼ�
CREATE OR REPLACE VIEW gogaekView
AS(
    SELECT TO_CHAR(p_date, 'YYYY') �Ǹų⵵, TO_CHAR(p_date, 'MM') �Ǹſ�, g.g_id, g_name, SUM(p_su*price) ���Ǹűݾ�
    FROM panmai p JOIN danga d ON p.b_id = d.b_id
                  JOIN gogaek g ON g.g_id = p.g_id
    GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name
    
);

SELECT * 
FROM gogaekview;

SELECT *
FROM tab
WHERE tabtype = 'VIEW';

CREATE TABLE testa (
    aid NUMBER PRIMARY KEY
    , name VARCHAR2(20) NOT NULL
    , tel VARCHAR2(20) NOT NULL
    , memo VARCHAR2(100)
);

CREATE TABLE testb (
    bid NUMBER PRIMARY KEY
    , aid NUMBER CONSTRAINT fk_testb_aid REFERENCES testa(aid) ON DELETE CASCADE
    , score NUMBER(3)
);

INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');

INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

COMMIT;

SELECT * FROM testa;
SELECT * FROM testb;

DESC testa;

CREATE OR REPLACE VIEW aView AS(
    SELECT aid, name, memo
    FROM testa
);

-- [�ܼ��並 ����� INSERT]
INSERT INTO aView(aid, name, memo) VALUES (5, 'f', '5'); -- tell�� NOT NULL �̶� ����

CREATE OR REPLACE VIEW aView AS(
    SELECT aid, name, tel
    FROM testa
);

INSERT INTO aView(aid, name, tel) VALUES (5, 'f', '5'); -- tell�� NOT NULL
DELETE FROM aView
WHERE aid = 5;

DROP VIEW aView;

CREATE OR REPLACE VIEW abView
AS (
    SELECT a.aid, name, tel
    , bid, score
    FROM testa a JOIN testb b ON a.aid = b.aid
);
INSERT INTO abVIEW(aid, name, tel, bid, score)
VALUES(10, 'x', 55, 20, 70);

INSERT INTO abView(aid, name, tel) 
VALUES(5, 'f', '5);

UPDATE aView
SET score = 99
WHERE bid = 1;

SELECT * FROM testa;
SELECT * FROM testb;
--[- DELETE VASVADE ]


-- ������ 90�� �̻��� �� ����
CREATE OR REPLCE VIEW bView
AS(
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90
);

UPDATE bView 
ST score = 70
WHERE bid = 3;


SELECT *
FROM bView;

ROLLBACK;

CREATE OR REPLCE VIEW bView
AS(
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90
    WITH CHECK OPTION 
);

DROP VIEW ABVIEW;

-- MATERIALIZED VIEw(������ ��)
-- ���� �����͸� ������ �ִ� ��

-- [������ ����]
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 31;

-- 7698�� ���Ӻ���������
SELECT empno, ename, sal, LEVEL
FROM emp
WHERE mgr = 7698
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr; -- top-down ��� ����

create table tbl_test(
    deptno number(3) not null primary key,
    dname varchar2(24) not null,
    college number(3),
    loc varchar2(10)
);

DROP TABLE tbl_test;

INSERT INTO tbl_test VALUES        ( 101,  '��ǻ�Ͱ��а�', 100,  '1ȣ��');
INSERT INTO tbl_test VALUES        (102,  '��Ƽ�̵���а�', 100,  '2ȣ��');
INSERT INTO tbl_test VALUES        (201,  '���ڰ��а� ',   200,  '3ȣ��');
INSERT INTO tbl_test VALUES        (202,  '�����а�',    200,  '4ȣ��');
INSERT INTO tbl_test VALUES        (100,  '�����̵���к�', 10 , null );
INSERT INTO tbl_test VALUES        (200,  '��īƮ�δн��к�',10 , null);
INSERT INTO tbl_test VALUES        (10,  '��������',null , null);
COMMIT;

SELECT *
FROM tbl_test;

SELECT deptno, dname, college, LEVEL
FROM tbl_test
START WITH deptno = 10
CONNECT BY PRIOR deptno = college;

SELECT LPAD(' ', (LEVEL-1)*3) || '��' ||  dname
FROM tbl_test
START WITH dname = '��������'
CONNECT BY PRIOR deptno = college;

-- ������������ ���� ����
SELECT deptno,college,dname,loc,LEVEL
FROM tbl_test
WHERE dname != '�����̵���к�'
START WITH college IS NULL
CONNECT BY PRIOR deptno=college;

SELECT deptno,college,dname,loc,LEVEL
FROM tbl_test
START WITH college IS NULL
CONNECT BY PRIOR deptno=college
AND dname != '�����̵���к�';


1. START WITH �ֻ������� : ������ �������� �ֻ��� ������ ���� �ĺ��ϴ� ����
2. CONNECT BY ���� : ������ ������ � ������ ����Ǵ����� ����ϴ� ����.
   PRIOR : ������ ���������� ����� �� �ִ� ������, '�ռ���, ������'
   
   SELECT e.empno
            , LPAD(' ', 4*(LEVEL-1)) || ename
            , SYS_CONNECT_BY_PATH(ename, '\')
   FROM emp e, dept d
   WHERE e.deptno = d.deptno
   START WITH e.mgr IS NULL
   CONNECT BY PRIOR e.empno = e.mgr
   ORDER SIBLINGS BY ename;
   
3. ORDER SIBLINGS BY : �μ������� ���ĵʰ� ���ÿ� ������ �������� ����
4. CONNECT_BY_ROOT : ������ ���kĿ������ �ֻ��� �ο츦 ��ȯ�ϴ� ������.
5. CONNECT_BY_ISLEAF : CONNECT BY ���ǿ� ���ǵ� ���迡 ���� 
   �ش� ���� ������ �ڽ����̸� 1, �׷��� ������ 0 �� ��ȯ�ϴ� �ǻ��÷�
6. SYS_CONNECT_BY_PATH(column, char)  : ��Ʈ ��忡�� �����ؼ� �ڽ��� ����� 
   ����� ��� ������ ��ȯ�ϴ� �Լ�.
7. CONNECT_BY_ISCYCLE : ����Ŭ�� ������ ������ ����(�ݺ�) �˰����� ����Ѵ�. 
  �׷���, �θ�-�ڽ� ���� �߸� �����ϸ� ���ѷ����� Ÿ�� ���� �߻��Ѵ�.   
  �̶��� ������ �߻��ϴ� ������ ã�� �߸��� �����͸� �����ؾ� �ϴ� ��, 
  �̸� ���ؼ��� 
    ����  CONNECT BY���� NOCYCLE �߰�
    SELECT ���� CONNECT_BY_ISCYCLE �ǻ� �÷��� ����� ã�� �� �ִ�. 
  ��, ���� �ο찡 �ڽ��� ���� �ִ� �� ���ÿ� �� �ڽ� �ο찡 �θ�ο� �̸� 1,
     �׷��� ������ 0 ��ȯ.
     
-- 1) 7566 JONES�� mgr�� 7839���� 7369��  ����
UPDATE emp
SET mgr = 7369
WHERE empno = 7566;
-- 2)
SELECT  deptno, empno, LPAD(' ', 3*(LEVEL-1)) ||  ename
, LEVEL
, SYS_CONNECT_BY_PATH(ename, '/')
FROM emp   
START WITH  mgr IS NULL
CONNECT BY PRIOR  empno =  mgr   ;
-- 3)
ROLLBACK;
-- 4)
SELECT  deptno, empno, LPAD(' ', 3*(LEVEL-1)) ||  ename
, LEVEL
, SYS_CONNECT_BY_PATH(ename, '/')
, CONNECT_BY_ISCYCLE IsLoop
FROM emp   
START WITH  mgr IS NULL
CONNECT BY NOCYCLE PRIOR  empno =  mgr;








