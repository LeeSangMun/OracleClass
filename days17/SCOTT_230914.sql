-- [���� SQL]
-- 1. ���� SQL�� ����ϴ� 3���� ��Ȳ
--  1) ������ �ÿ� SQL������ Ȯ������ ���� ���
--      WHERE ������...
--  2) PL/SQL �� �ȿ��� DDL ���� ����ϴ� ���
--      CREATE, ALTER, DROP
--      ��) ���� �� �Խ��� ����
--          ������ �÷�(��¥, ����, ����)
--          üũ�� �÷����� �������� �Խ��� ����.
--  3) PL/SQL �� �ȿ���
--      ALTER SYSTEM/SESSION ��ɾ ����� ���

-- 2. PL/SQL ���������� ����ϴ� 2���� ���
--  1) NDS(Native Dynamic SQL) = ���� ���� ����
--      EXECUTE IMMEDIATE�� ����������
--          [INTO ������, ������...]
--          [USING IN/OUT/IN OUT �Ķ����...]
--  2) DBMS_SQL ��Ű��

-- 3. ���� ���� ����
--  1) �͸� ���ν���
DECLARE
    vsql VARCHAR2(2000);
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job';
    vsql := vsql || ' FROM emp';
    vsql := vsql || ' WHERE empno=7369';
    EXECUTE IMMEDIATE vsql
        INTO vdeptno, vempno, vename, vjob;
        
    DBMS_OUTPUT.put_line(vdeptno || ', ' || vempno || ', ' || vename || ', ' || vjob);
END;

-- ���� ���ν���
CREATE OR REPLACE PROCEDURE up_ndsemp(
    pempno emp.empno%TYPE 
)
IS
    vsql VARCHAR2(2000);
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job';
    vsql := vsql || ' FROM emp';
    vsql := vsql || ' WHERE empno=:pempno';
    EXECUTE IMMEDIATE vsql
        INTO vdeptno, vempno, vename, vjob
        USING IN pempno;
        
    DBMS_OUTPUT.put_line(vdeptno || ', ' || vempno || ', ' || vename || ', ' || vjob);
END;

EXEC UP_NDSEMP(7369);

-- ����) dept ���̺� ���ο� �μ� �߰��ϴ� ���� ������ ����ϴ� ���� ���ν��� ���� + Ȯ��
SELECT *
FROM dept;
-- seq_dept ������ 50, 10, nocache
CREATE SEQUENCE seq_dept
MINVALUE 1
MAXVALUE 90
START WITH 50
NOCYCLE 
NOCACHE;

CREATE OR REPLACE PROCEDURE up_ndsInsDept
(
    pdname dept.dname%TYPE := NULL
    , ploc dept.loc%TYPE DEFAULT NULL
)
IS
    vsql VARCHAR(2000);
BEGIN
    vsql := 'INSERT INTO dept(deptno, dname, loc)';
    vsql := vsql || ' VALUES(seq_dept.NEXTVAL, :pdname, :ploc)';
    
    EXECUTE IMMEDIATE vsql
    USING pdname, ploc;
    
    DBMS_OUTPUT.put_line('INSERT ����!!!');
    COMMIT;
END;

EXEC up_ndsInsDept('QC', 'SEOUL');
SELECT *
FROM dept;

-- ����ڰ� ���ϴ� ������ �Խ����� ����(DDL ��) ��������
DECLARE 
    vtablename VARCHAR2(100);
    vsql VARCHAR2(2000);
BEGIN
    vtablename := 'tbl_board';
    vsql := 'CREATE TABLE ' || vtablename;
--    vsql := 'CREATE TABLE :ptablename';
    vsql := vsql || '(';
    vsql := vsql || ' id NUMBER PRIMARY KEY ';
    vsql := vsql || ' , name VARCHAR(20) ';
    vsql := vsql || ')';
    DBMS_OUTPUT.PUT_LINE(vsql);
    
    EXECUTE IMMEDIATE vsql;
END;

DESC tbl_board;

-- OPEN ~ FOR�� : SELECT ���� ���� �� + �ݺ�ó��
-- OPEN Ŀ��
-- FOR Ŀ�� �ݺ� ó��
-- ���� SQL�� ���� -> �����(�������� ��) + Ŀ�� ó��

CREATE OR REPLACE PROCEDURE up_ndsSelEmp
(
    pdeptno emp.deptno%TYPE
)
IS
    vsql VARCHAR2(2000);
    vcur SYS_REFCURSOR; -- 9i REF CURSOR
    vrow emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE deptno = :pdeptno ';
    
    OPEN vcur FOR vsql
    USING pdeptno;
    
    LOOP
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.empno || ', ' || vrow.ename);
    END LOOP;
    
    CLOSE vcur;
END;

EXEC up_ndsSelEmp(30);

-- ���� ���� �˻� ����
-- [�μ���ȣ, �μ���, ������] �˻����� ����
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
    psearchCondition NUMBER -- 1. �μ���ȣ, 2. �����, 3. ��
    , psearchWord VARCHAR2
)
IS
    vsql VARCHAR2(2000);
    vcur SYS_REFCURSOR; -- 9i REF CURSOR
    vrow emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    
    IF psearchCondition = 1 THEN
        vsql := vsql || ' WHERE deptno = :psearchWord ';
    ELSIF psearchCondition = 2 THEN
        vsql := vsql || ' WHERE REGEXP_LIKE(ename, :psearchWord, ''i'')';
    ELSIF psearchCondition = 3 THEN
        vsql := vsql || ' WHERE job = :psearchWord ';
    END IF;
    
    OPEN vcur FOR vsql
    USING psearchWord;
    
    LOOP
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.empno || ', ' || vrow.ename || ', ' || vrow.job);
    END LOOP;
    
    CLOSE vcur;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20004, '> DATA NOT FOUND...');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, '> OTHER ERROR...');
END;

EXEC up_ndsSearchEmp;