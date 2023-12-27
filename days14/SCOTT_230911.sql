
-- �͸����ν��� ����
-- 1) %TYPE�� ����
DECLARE 
    vdeptno NUMBER(2);
    vdname dept.dname%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vdeptno, vdname, vempno, vename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vdname || ', ' || vempno || ', ' || vename || ', ' || vpay);
--EXCEPTION
END;

-- 2) %ROWTYPE�� ����
DECLARE 
    vdrow dept%ROWTYPE;
    verow emp%ROWTYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vdrow.deptno || ', ' || vdrow.dname || ', ' || verow.empno || ', ' || verow.ename || ', ' || vpay);
--EXCEPTION
END;


-- 3) RECODE�� ����
DECLARE 
    -- ����� ���� ����ü Ÿ�� ����
    TYPE EmpDeptType IS RECORD (
        deptno NUMBER(2)
        , dname dept.dname%TYPE
        , empno emp.empno%TYPE
        , ename emp.ename%TYPE
        , pay NUMBER
    );
    
    vderow EmpDeptType;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
--EXCEPTION
END;

-- ORA-01422: exact fetch returns more than requested number of rows
-- 4) Ŀ���� �ʿ��ϴ�.
DECLARE 
    TYPE EmpDeptType IS RECORD (
        deptno NUMBER(2)
        , dname dept.dname%TYPE
        , empno emp.empno%TYPE
        , ename emp.ename%TYPE
        , pay NUMBER
    );
    
    vderow EmpDeptType;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        INTO vderow.deptno, vderow.dname, vderow.empno, vderow.ename, vderow.pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno;
--    WHERE empno = 7369;
    
    DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
--EXCEPTION
END;

-- 5) CURSOR(Ŀ��)
-- 1. pl/sql �� ������ ����Ǵ� select���� �ǹ��Ѵ�.
-- 2. ���� ���ڵ�� ������ �۾��������� sql���� �����ϰ� �� ����� �����ϱ� ���ؼ� cursor�� ����Ѵ�.
-- 3. Ŀ�� 2���� ����
--      1) ������(implicit) Ŀ�� - �ڵ������� �������
--      2) �����(explicit) Ŀ��
--          (1) ����� Ŀ�� ����ϴ� ����
--            ��. Ŀ�� ����    - SELECT���� �ۼ�
--            ��. Ŀ�� OPEN   - SELECT���� ����
--            ��. Ŀ�� FETCH  - ������� ���� �ִ� Ŀ���� ���� �������� -> �ݺ��� ����ؼ� ó��
--                             %NOTFOUND Ŀ���� �Ӽ� : Ŀ���� �� ������ ����
--                             %FOUND              : Ŀ���� �� �ִ��� ����
--                             %ISOPEN             : ���� Ŀ�� ����
--                             %ROWCOUNT           : Ŀ���� ����ؼ� ���� ���� ��
--            ��. Ŀ�� CLOSE

-- 5) CURSOR
DECLARE 
    TYPE EmpDeptType IS RECORD (
        deptno NUMBER(2)
        , dname dept.dname%TYPE
        , empno emp.empno%TYPE
        , ename emp.ename%TYPE
        , pay NUMBER
    );
    
    vderow EmpDeptType;
    -- 1) Ŀ�� ���� ����
    -- CURSOR Ŀ���� IS SELECT��;
    CURSOR edcursor IS (
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        FROM dept d JOIN emp e ON d.deptno = e.deptno
    );
BEGIN
    -- 2) Ŀ�� ���� OPEN
    -- ����) OPEN Ŀ����;
    OPEN edcursor;
   
    IF edcursor%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('OPEN O');
    ELSE
        DBMS_OUTPUT.PUT_LINE('OPEN X');
    END IF;
   
    -- 3) Ŀ�� FETCH
    LOOP
        FETCH edcursor INTO vderow;
        DBMS_OUTPUT.PUT_LINE(edcursor%ROWCOUNT);
        DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
        EXIT WHEN edcursor%NOTFOUND;
    END LOOP;
    
    -- 4) Ŀ�� ���� CLOSE
    -- ����) CLOSE Ŀ����;
    CLOSE edcursor;
--EXCEPTION
END;

-- 6) CURSOR
-- FOR�� ���
DECLARE 
    CURSOR edcursor IS (
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        FROM dept d JOIN emp e ON d.deptno = e.deptno
    );
BEGIN
    -- FOR�� ����
    -- �ڵ� OPEN, CLOSE�ȴ�.
    FOR vderow IN edcursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
    END LOOP;
--EXCEPTION
END;

-- 6-2)
BEGIN
    -- FOR�� ����
    -- �ڵ� OPEN, FETCH, CLOSE�ȴ�.
    -- CURSOR ���� �ʿ����.
    FOR vderow IN (
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        FROM dept d JOIN emp e ON d.deptno = e.deptno
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
    END LOOP;
--EXCEPTION
END;

-- ���� ���ν���(STORED PROCEDURE)
-- 1) PL/SQL�� ���� ��ǥ���� ����
-- 2) �����ͺ��̽� ��ü ����
-- 3) ����
CREATE OR REPLACE PROCEDURE up_���ν����� (
    -- �Ű�����, ����, p���λ�
)
IS
BEGIN
EXCEPTION
END;
-- 4) ���� ���ν����� �����ϴ� 3���� ���
--      1) EXEC
--      2) �͸� ���ν��� �ȿ��� ����
--      3) �� �ٸ� ���� ���ν��� �ȿ��� ����

CREATE TABLE tbl_emp
AS (
    SELECT *
    FROM emp
);

-- ��� ��ȣ�� �Է¹޾Ƽ� �ش� ����� �����ϴ� ����
DELETE FROM tbl_emp
WHERE empno = 7369;
COMMIT;

CREATE OR REPLACE PROCEDURE up_delEmp (
    -- ���� ���ν����� �Ķ���� ���� �� �ڷ����� ũ����̸� �ȵȴ�., %TYPE�� ���� ��밡��
    -- ���� �� ������ �����ڷ� �޸�(,) �����ڸ� ����.
    -- �Ķ���͸�� IN(�Է¿�) �⺻��, OUT(��¿�), IN OUT(����¿�)
--    pempno IN emp.empno%TYPE;
    pempno emp.empno%TYPE
)
IS
    -- ��������
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
END;

-- 1) EXCUTE��
EXECUTE up_delEmp(pempno=>7369);
SELECT *
FROM tbl_emp;

-- 2) �͸� ���ν��� �ȿ��� ���� ���ν��� ����
--DECLARE
BEGIN
    up_delEmp(7902);
END;

-- 3) �� �ٸ� ���� ���ν��� �ȿ��� ���� ���ν��� ����.
CREATE OR REPLACE PROCEDURE up_delemp_test
IS
BEGIN
    up_delEmp(7900);
END;
EXEC up_delemp_test();

SELECT *
FROM tbl_emp;

-- [����]
-- 1) dept�� �����ؼ� tbl_dept ����
-- 2) �μ���, �������� �Է¹޾Ƽ� ���ο� �μ��� �߰��ϴ� ���� ���ν����� ���� up_insertdept
-- 3) ���� ���ν��� ���� �׽�Ʈ

CREATE TABLE tbl_dept
AS (
    SELECT *
    FROM dept
);

CREATE SEQUENCE seq_tbldept
INCREMENT BY 10
START WITH 50
MAXVALUE 90
NOCYCLE
NOCACHE;

CREATE OR REPLACE PROCEDURE up_insertdept (
    pdname dept.dname%TYPE := NULL
    , ploc dept.loc%TYPE DEFAULT NULL
)
IS
BEGIN
    INSERT INTO tbl_dept
    VALUES(seq_tbldept.NEXTVAL, pdname, ploc);
END;

EXEC up_insertdept('QC', 'SEOUL');

BEGIN
    up_insertdept('QC', 'SEOUL');
END;

SELECT *
FROM tbl_dept;

-- �μ��� O, ������ X
EXEC up_insertdept('QC2');
EXEC up_insertdept('QC2', NULL);
EXEC up_insertdept(pdname => 'QC2');

-- �μ��� X, ������ O
EXEC up_insertdept(ploc => 'POHANG');
EXEC up_insertdept(NULL, 'POHANG');

-- [����] tbl_dept ���̺��� ���� : up_updateDept
-- 1) ������ �μ���ȣ
-- 2) �μ��� ����
-- 3) ������ ����
-- 4) �μ��� + ������ ��θ� ����

EXEC up_updateDept(50, 'X', 'Y');
EXEC up_updateDept(50, pdname => 'QC5');
EXEC up_updateDept(50, ploc => 'SEOUL');
EXEC up_updateDept(50, pdname => 'SM', ploc => 'PO');

SELECT *
FROM tbl_dept;

CREATE OR REPLACE PROCEDURE up_updateDept(
    pdeptno tbl_dept.deptno%TYPE 
    , pdname tbl_dept.dname%TYPE DEFAULT NULL
    , ploc tbl_dept.loc%TYPE DEFAULT NULL
)
IS
BEGIN
    UPDATE tbl_dept
    SET dname = NVL(pdname, dname), loc = NVL(ploc, loc)
    WHERE deptno = pdeptno;
    COMMIT;
END;

CREATE OR REPLACE PROCEDURE up_updateDept(
    pdeptno tbl_dept.deptno%TYPE 
    , pdname tbl_dept.dname%TYPE DEFAULT NULL
    , ploc tbl_dept.loc%TYPE DEFAULT NULL
)
IS
    vdname dept.dname%TYPE;
    vloc dept.loc%TYPE;
BEGIN
    SELECT dname, loc 
        INTO vdname, vloc
    FROM tbl_dept
    WHERE deptno = pdeptno;
    
    IF pdname IS NULL AND ploc IS NULL THEN
        UPDATE tbl_dept
        SET dname = vdname, loc = vloc
        WHERE deptno = pdeptno;
    ELSIF pdname IS NULL THEN
        UPDATE tbl_dept
        SET dname = vdname, loc = ploc
        WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THE
        UPDATE tbl_dept
        SET dname = pdname, loc = vloc
        WHERE deptno = pdeptno;
    ELSE
        UPDATE tbl_dept
        SET dname = vdname, loc = vloc
        WHERE deptno = pdeptno;
    END IF;

    UPDATE tbl_dept
    SET dname = NVL(pdname, dname), loc = NVL(ploc, loc)
    WHERE deptno = pdeptno;
    COMMIT;
END;

-- [������] ���� �μ��� ������ ��
EXEC up_updateDept(100);


-- [����] tbl_emp ���̺��� 
-- �μ���ȣ�� �Է¹޾Ƽ� �ش� �μ������� ������ ����ϴ� ���� ���ν���
-- up_selectEmp
CREATE OR REPLACE PROCEDURE up_selectEmp(
    pdeptno tbl_dept.deptno%TYPE DEFAULT TRUNC(DBMS_RANDOM.value(1, 5))*10
)
IS
BEGIN
    FOR verow IN (
        SELECT empno, ename, sal + NVL(comm, 0) pay, deptno
        FROM emp
        WHERE deptno = pdeptno
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(verow.deptno || ', ' || verow.empno || ', ' || verow.ename || ', ' || verow.pay);
    END LOOP;
--EXCEPTION
END;

EXEC up_selectEmp;

-- Ŀ�� �Ķ���͸� �̿��ϴ� ���
CREATE OR REPLACE PROCEDURE up_selectEmp(
    pdeptno tbl_dept.deptno%TYPE DEFAULT TRUNC(DBMS_RANDOM.value(1, 5))*10
)
IS
--    CURSOR curemp(cp tbl_dept.deptno%TYPE) IS (
        -- ��������
--    );  

BEGIN
    -- Ŀ�� �Ķ����
--    OPEN curemp(deptno);
    
    FOR verow IN (
        SELECT empno, ename, sal + NVL(comm, 0) pay, deptno
        FROM emp
        WHERE deptno = pdeptno
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(verow.deptno || ', ' || verow.empno || ', ' || verow.ename || ', ' || verow.pay);
    END LOOP;
--EXCEPTION
END;

-- FOR�� ���
CREATE OR REPLACE PROCEDURE up_selectEmp(
    pdeptno tbl_dept.deptno%TYPE DEFAULT TRUNC(DBMS_RANDOM.value(1, 5))*10
)
IS
BEGIN
    FOR verow IN (
        SELECT empno, ename, deptno
        FROM emp
        WHERE deptno = pdeptno
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(verow.deptno || ', ' || verow.empno || ', ' || verow.ename);
    END LOOP;
--EXCEPTION
END;

-- ��¿� �Ű�����
SELECT num, ssn
FROM insa;

-- IN num
-- OUT rrn 770830-1******

CREATE OR REPLACE PROCEDURE up_insarrn (
    pnum insa.num%TYPE
    , pname OUT insa.name%TYPE
    , prrn OUT VARCHAR2
)
IS
    vrrn insa.ssn%TYPE;
    vname insa.name%TYPE;
BEGIN
    SELECT ssn, name
        INTO vrrn, pname
    FROM insa
    WHERE num = pnum;
    
    prrn := SUBSTR(vrrn, 0, 8) || '******';
--EXCEPTION
END;

-- ��¿� �Ű����� �׽�Ʈ (�͸� ���ν���)
DECLARE
    vrrn insa.ssn%TYPE;
    vname insa.name%TYPE;
BEGIN
    up_insarrn(1001, vname, vrrn);
    DBMS_OUTPUT.PUT_LINE(vname || ', ' || vrrn);
--EXCEPTION
END;


-- ����¿�(IN OUT) �Ű������� ����ϴ� ���� ���ν��� ����
-- �ֹε�Ϲ�ȣ 14�ڸ��� �Է¿� �Ű����� -> �ֹε�Ϲ�ȣ ���ڸ� 6�ڸ��� ���
CREATE OR REPLACE PROCEDURE up_rrn(
    prrn IN OUT VARCHAR2
)
IS
BEGIN
    prrn := SUBSTR(prrn, 0, 6);
--EXCEPTION
END;

DECLARE
    vrrn VARCHAR2(14) := '771212-1234567';
BEGIN
    up_rrn(vrrn);
    DBMS_OUTPUT.PUT_LINE(vrrn);
END;

-- 1) ���� ���ν��� ���� ����
-- 2) ���� �Լ�(STORED FUNCTION)

CREATE TABLE tbl_score(
    num NUMBER(4) PRIMARY KEY
    , name VARCHAR2(20)
    , kor NUMBER(3)
    , eng NUMBER(3)
    , mat NUMBER(3)
    , tot NUMBER(3)
    , avg NUMBER(5, 2)
    , rank NUMBER(3)
    , grade CHAR(1 CHAR)
);

-- ��ȣ, �̸�, ��, ��, �� -> �Ķ����
CREATE OR REPLACE PROCEDURE up_insertScore (
    pnum NUMBER
    , pname VARCHAR2
    , pkor NUMBER
    , peng NUMBER
    , pmat NUMBER
)
IS
    vtot NUMBER(3);
    vavg NUMBER(5, 2);
    vrank NUMBER(4);
    vgrade CHAR(1 CHAR);
BEGIN
    vtot := pkor + peng + pmat;
    vavg := vtot / 3;
    IF vavg >= 90 THEN
        vgrade := 'A';
    ELSIF vavg >= 80 THEN
        vgrade := 'B';
    ELSIF vavg >= 70 THEN
        vgrade := 'C';
    ELSIF vavg >= 60 THEN
        vgrade := 'D';
    ELSE
        vgrade := 'F';
    END IF;
    
    INSERT INTO tbl_score(num, name, kor, eng, mat, tot, avg, rank, grade)
    VALUES(pnum, pname, pkor, peng, pmat, vtot, vavg, vrank, vgrade);
    
    -- ��� �л����� ��� �ű� �ٽ�
    UPDATE tbl_score a
    SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot);
    COMMIT;
--EXCEPTION
END;

EXEC up_insertScore(1001, 'ȫ�浿', 89, 44, 55);
EXEC up_insertScore(1002, 'ȫ�浿', 82, 64, 75);
EXEC up_insertScore(1003, 'ȫ�浿', 44, 34, 95);

SELECT *
FROM tbl_score;

-- ������ �й�, ��, ��, ��  up_updateScore
-- ��/��/��� 
EXEC up_updateScore( 1001, 100, 100, 100 );
EXEC up_updateScore( 1001, pkor =>34 );
EXEC up_updateScore( 1001, pkor =>34, pmat => 90 );
EXEC up_updateScore( 1001, peng =>45, pmat => 90 );

CREATE OR REPLACE PROCEDURE up_updateScore(
    pnum tbl_score.num%TYPE
    , pkor tbl_score.kor%TYPE DEFAULT NULL
    , peng tbl_score.eng%TYPE DEFAULT NULL
    , pmat tbl_score.mat%TYPE DEFAULT NULL
)
IS
    vtot NUMBER(3);
    vavg NUMBER(5, 2);
    vrank NUMBER(3);
    vgrade CHAR(1 CHAR);
    vkor NUMBER(3);
    veng NUMBER(3);
    vmat NUMBER(3);
BEGIN
    SELECT kor, eng, mat
        INTO vkor, veng, vmat
    FROM tbl_score
    WHERE num = pnum;

    vtot := NVL(pkor, vkor) + NVL(peng, veng) + NVL(pmat, vmat);
    vavg := vtot/3;
    IF vavg >= 90 THEN
        vgrade := 'A';
    ELSIF vavg >= 80 THEN
        vgrade := 'B';
    ELSIF vavg >= 70 THEN
        vgrade := 'C';
    ELSIF vavg >= 60 THEN
        vgrade := 'D';
    ELSE
        vgrade := 'F';
    END IF;

    UPDATE tbl_score
    SET kor=NVL(pkor, vkor), eng=NVL(peng, veng), mat=NVL(pmat, vmat), tot=vtot, avg=vavg, grade=vgrade
    WHERE num = pnum;
    COMMIT;
    
    UPDATE tbl_score a
    SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot);
    COMMIT;
END;

-- [����1] EXEC up_deletScore(1002); �й����� �л� ���� �� ��� �л� ��� �ٽ� �ű��

CREATE OR REPLACE PROCEDURE up_deletScore(
    pnum NUMBER
)
IS
BEGIN
    DELETE FROM tbl_score
    WHERE num = pnum;
    COMMIT;
    
    UPDATE tbl_score a
    SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot);
    COMMIT;
END;

EXEC up_deletScore(1002);

SELECT *
FROM tbl_score;

-- [����2] EXEC up_selectscore; -- ��� �л��� ���� ���.

CREATE OR REPLACE PROCEDURE up_selectscore
IS
    CURSOR tscursor IS (
        SELECT *
        FROM tbl_score
    );
    vrow tbl_score%ROWTYPE;
BEGIN
    OPEN tscursor;
    
    LOOP
        FETCH tscursor INTO vrow;
        DBMS_OUTPUT.PUT_LINE(vrow.num || ', ' || vrow.name || ', ' || vrow.kor || ', ' || vrow.eng || ', ' || vrow.mat || ', ' ||
            vrow.tot || ', ' || vrow.avg || ', ' || vrow.rank || ', ' || vrow.grade);
    EXIT WHEN tscursor%NOTFOUND;
    END LOOP;
    
    CLOSE tscursor;
END;

EXEC up_selectscore;

-- Stored �Լ�
CREATE OR REPLACE FUNCTION uf_�Լ���
()
RETURN �ڷ���
IS
BEGIN
RETURN ���Ѱ�
EXCEPTION
END;

SELECT num, name, ssn
    , uf_gender(ssn)
    , uf_age(ssn)
FROM insa;

-- ���� �Լ�(stored function)
CREATE OR REPLACE FUNCTION uf_gender (
    prrn VARCHAR2
)
RETURN VARCHAR2
IS
    vgender VARCHAR2(6);
BEGIN
    IF MOD(SUBSTR(prrn, -7, 1), 2) = 1 THEN
        vgender := '����';
    ELSE
        vgender := '����';
    END IF;
    RETURN vgender;
--EXCEPTION
END;

SELECT num, name, ssn
    , uf_gender(ssn)
    , uf_age(ssn)
FROM insa;

-- ������ �Լ�
-- �̰Ŵ� �ذ� ����
CREATE OR REPLACE FUNCTION uf_age (
    prrn VARCHAR2
)
RETURN NUMBER
IS
    vage NUMBER;
BEGIN
    vage := CASE
                WHEN SUBSTR(prrn,8,1) IN (1,2,5,6) THEN 1900
                WHEN SUBSTR(prrn,8,1) IN (3,4,7,8) THEN 2000
                ELSE 1800
            END + SUBSTR(prrn, 0, 2) + CASE SIGN(TRUNC(SYSDATE)-TO_DATE(SUBSTR(prrn, 3, 4)))
                                        WHEN -1 THEN -1
                                        ELSE 0
                                       END;
    RETURN vage;
--EXCEPTION
END;

-- [����] �ֹε�Ϲ�ȣ�κ��� ������� (1998.01.20(ȭ)) �� ��ȯ�ϴ� �����Լ��� ����� �׽�Ʈ uf_birth
CREATE OR REPLACE FUNCTION uf_birth (
    prrn VARCHAR2
)
RETURN VARCHAR2
IS
    vbirth VARCHAR2(20);
    vcentry NUMBER(2);
BEGIN
    vbirth := SUBSTR(prrn, 1, 6);
    vcentry := CASE
                WHEN SUBSTR(prrn, -7, 1) IN (1,2,5,6) THEN 19
                WHEN SUBSTR(prrn, -7, 1) IN (3,4,7,8) THEN 20
                ELSE 18
               END;
    vbirth := vcentry || vbirth;
    vbirth := TO_CHAR(TO_DATE(vbirth, 'YYYYMMDD'), 'YYYY.MM.DD(DY)');
           
    RETURN vbirth;
END;

SELECT name, ssn
    , uf_birth(ssn)
FROM insa;

-- 
CREATE OR REPLACE PROCEDURE up_selectInsa(
    pInsaCursor IN SYS_REFCURSOR
)
IS
    vname insa.name%TYPE;
    vcity insa.city%TYPE;
    vbasicpay insa.basicpay%TYPE;
BEGIN
    LOOP
        FETCH pInsaCursor INTO vname, vcity, vbasicpay;
        EXIT WHEN pInsaCursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vname || ', ' || vcity || ', ' || vbasicpay);
    END LOOP;
END;

-- up_selectInsa �׽�Ʈ
CREATE OR REPLACE PROCEDURE up_selectInsa_test
IS
    vInsaCursor SYS_REFCURSOR;
BEGIN
    -- OPEN Ŀ�� FOR ��
    OPEN vInsaCursor FOR
        SELECT name, city, basicpay
        FROM insa
    ;
    
    up_selectInsa(vInsaCursor);
    
    CLOSE vInsaCursor;
END;

EXEC up_selectInsa_test;

