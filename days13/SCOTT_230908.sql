CREATE TABLE tbl_dept
AS(
    SELECT *
    FROM dept
    WHERE 1 = 0
);

ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno);

SELECT *
FROM tbl_dept;

DROP TABLE tbl_depte;

-- [������(Sequence)]
-- �ڵ����� �Ϸù�ȣ ����

SELECT *
FROM user_sequences;
--FROM seq; // �ó��

CREATE SEQUENCE seq_deteno;

-- ������ Ű����
-- INCREMENT BY 1
-- START WITH 1
-- MAXVALUE 9999999999999999999999999999
-- MINVALUE 1
-- NOCYCLE]
-- CACHE 20;

DROP SEQUENCE seq_deptno;

-- dept ������
CREATE SEQUENCE seq_deptno
INCREMENT BY 10
START WITH 50
MAXVALUE 90
MINVALUE 1
NOCYCLE
NOCACHE;

INSERT INTO dept VALUES(seq_deptno.NEXTVAL, 'QC', NULL);

SELECT *
FROM dept;

SELECT seq_deptno.CURRVAL
FROM dual;

CREATE SEQUENCE seq_test;
-- ORA-08002: sequence SEQ_TEST.CURRVAL is not yet defined in this session
SELECT seq_test.CURRVAL
FROM dual;

ROLLBACK;

DROP SEQUENCE seq_test;

-- [PL/SQL]

-- ������ ���(����, ���)
-- ��� ������ �� ���

[DECLARE]
    1) ���� ��
BEGIN
    2) ���� ��
[EXCEPTION]
    3) ���� ó�� ��
END

-- PL/SQL �� 6���� ����
    1) �͸� ���ν���
    2) ���� ���ν��� ***
    3) ���� �Լ�
    4) ��Ű��
    5) Ʈ����
--    6) ��ü

DECLARE
    vname VARCHAR(20); 
    vpay NUMBER(81; 
BEGIN
    SELECT name, basicpay + sudang pay
    FROM insa
    WHERE num = 1001;
    
--EXCEPTION
END;

Oracle PL/SQL
    1) :=
    2) select, fetch��

DECLARE
--    vname VARCHAR2(20); 
--    vpay NUMBER(10); 
    vname INSA.name%TYPE;
    vpay NUMBER(10);
BEGIN
    SELECT name, basicpay + sudang
        INTO vname, vpay
    FROM insa
    WHERE num = 1001;
    
    DBMS_OUTPUT.PUT_LINE('�����=' || vname);
    DBMS_OUTPUT.PUT_LINE('�޿�=' || vpay);
--EXCEPTION
END;


DECLARE
  -- �Ϲݺ��� v, �Ű����� p
  -- ���� �� : ���� ����
  -- vname VARCHAR2(20);
  -- vpay  NUMBER(10);
  vname INSA.name%TYPE := '�͸�' ;  -- Ÿ���� ����
  vpay  NUMBER(10) := 0; 
  vpi CONSTANT NUMBER := 3.141592;
  vmessage VARCHAR2(100);
BEGIN
  -- ���� ��
  SELECT name, basicpay + sudang
       INTO vname, vpay
  FROM insa
  WHERE num = 1001;
  -- ���..
  -- Java : System.out.printf();
  --DBMS_OUTPUT.PUT_LINE( '�����='  || vname );
  --DBMS_OUTPUT.PUT_LINE( '�޿�='  || vpay );
  
  vmessage := vname || ', ' || vpay;
  DBMS_OUTPUT.PUT_LINE( '��� : '  || vmessage );
--EXCEPTION
END;


-- [����] 30�� �μ��� �������� ���ͼ�
--       10�� �μ��� ���������� ���� // �͸����ν����� �ۼ�
DECLARE
    vloc dept.loc%TYPE;
BEGIN
    SELECT loc INTO vloc
    FROM dept
    WHERE deptno = 30;
    
    UPDATE dept
    SET loc = vloc
    WHERE deptno = 10;
    
--    COMMIT;
--EXCEPTION
END;

-- [����] 10�� �μ��� �߿� �ְ� sal�� �޴� ����� ���� ��ȸ
-- 1) TOP-N ���
SELECT *
FROM(
    SELECT *
    FROM emp
    WHERE deptno = 10
    ORDER BY sal DESC
)
WHERE ROWNUM = 1;

-- 2) RANK �Լ�
SELECT *
FROM (
    SELECT emp.*
        , RANK() OVER(ORDER BY sal DESC) sal_rank
    FROM emp 
    WHERE deptno = 10
)
WHERE sal_rank = 1;

-- 3) ��������
SELECT *
FROM emp
WHERE deptno = 10 AND sal = (SELECT MAX(sal) FROM emp WHERE deptno = 10);

-- 4) �͸����ν��� ���
DECLARE
    vmax_sal_10 emp.sal%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
    vsal emp.sal%TYPE;
    vhiredate emp.hiredate%TYPE;
    vdeptno emp.deptno%TYPE;
BEGIN
    SELECT MAX(sal)
    INTO vmax_sal_10
    FROM emp
    WHERE deptno = 10;
    
    SELECT empno, ename, job, sal, hiredate, deptno
        INTO vempno, vename, vjob, vsal, vhiredate, vdeptno
    FROM emp
    WHERE deptno = 10 AND sal = vmax_sal_10;

    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || vempno);
    DBMS_OUTPUT.PUT_LINE('����� : ' || vename);
    DBMS_OUTPUT.PUT_LINE('�Ի����� : ' || vhiredate);
--EXCEPTION
END;

-- 4-2) %ROWTYPE�� ����
DECLARE
    vmax_sal_10 emp.sal%TYPE;
    vrow emp%ROWTYPE; -- ���ڵ��� ���� ����
BEGIN
    SELECT MAX(sal)
    INTO vmax_sal_10
    FROM emp
    WHERE deptno = 10;
    
    SELECT empno, ename, job, sal, hiredate, deptno
        INTO vrow.empno, vrow.ename, vrow.job, vrow.sal, vrow.hiredate, vrow.deptno
    FROM emp
    WHERE deptno = 10 AND sal = vmax_sal_10;

    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || vrow.empno);
    DBMS_OUTPUT.PUT_LINE('����� : ' || vrow.ename);
    DBMS_OUTPUT.PUT_LINE('�Ի����� : ' || vrow.hiredate);
--EXCEPTION
END;

-- PL/SQL���� ���� ���� ���ڵ带 �����ͼ� ó���ϱ� ���ؼ��� �ݵ�� Ŀ���� ����ؾ� �ȴ�.
-- ORA-01422: exact fetch returns more than requested number of rows
DECLARE
  vname INSA.name%TYPE := '�͸�' ;  
  vpay  NUMBER(10) := 0; 
  vmessage VARCHAR2(100);
BEGIN
  SELECT name, basicpay + sudang
       INTO vname, vpay
  FROM insa;
  
  vmessage := vname || ', ' || vpay;
  DBMS_OUTPUT.PUT_LINE( '��� : '  || vmessage );
END;

-- if��
IF(���ǽ�) THEN
END IF;

-- if - else ��
IF(���ǽ�) THEN
ELSE
END IF;

-- if else if
IF(���ǽ�) THEN
ELSIF(���ǽ�) THEN -- ���� ELSIF 
ELSIF(���ǽ�) THEN
ELSE
END IF;

-- [����] ������ �ϳ� �����ؼ� ������ �Է¹޾Ƽ� ¦��, Ȧ�� ���.
DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6) := 'Ȧ��';
BEGIN
    vnum := :bindNumber;
    IF(MOD(vnum, 2) = 0) THEN
        vresult := '¦��';
--    ELSE
--        vresult := 'Ȧ��';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vnum || '=' ||  vresult);
END;

-- [����] �������� �Է¹޾Ƽ� ��~�� ���
DECLARE
    vkor NUMBER(3) := 0;
    vgrade NCHAR := '��';
BEGIN
    vkor := :bindKorNum;
    
    IF(vkor BETWEEN 0 AND 100) THEN
        IF vkor >= 90 THEN 
            vgrade := '��';
        ELSIF vkor >= 80 THEN
            vgrade := '��';
        ELSIF vkor >= 70 THEN
            vgrade := '��';
        ELSIF vkor >= 60 THEN
            vgrade := '��';
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('0~100 �Է�');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vkor || ' ' || vgrade);
END;

DECLARE
    vkor NUMBER(3) := 0;
    vgrade NCHAR := '��';
BEGIN
    vkor := :bindKorNum;
    
    IF(vkor BETWEEN 0 AND 100) THEN
        CASE TRUNC(vkor/10)
            WHEN 10 THEN vgrade := '��';
            WHEN 9 THEN vgrade := '��';
            WHEN 8 THEN vgrade := '��';
            WHEN 7 THEN vgrade := '��';
            WHEN 6 THEN vgrade := '��';
            ELSE vgrade := '��';
        END CASE;
    ELSE
        DBMS_OUTPUT.PUT_LINE('0~100 �Է�');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vkor || ' ' || vgrade);
END;

DECLARE
    vkor NUMBER(3) := 0;
    vgrade NCHAR := '��';
BEGIN
    vkor := :bindKorNum;
    
    IF(vkor BETWEEN 0 AND 100) THEN
        vgrade := CASE TRUNC(vkor/10)
                    WHEN 10 THEN  '��'
                    WHEN 9 THEN  '��'
                    WHEN 8 THEN  '��'
                    WHEN 7 THEN  '��'
                    WHEN 6 THEN  '��'
                    ELSE  '��'
                  END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('0~100 �Է�');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vkor || ' ' || vgrade);
END;

-- Oracle �ݺ���
-- 1~10 = 55
DECLARE
    vi NUMBER := 1;
    vsum NUMBER := 0;
BEGIN
    LOOP
        IF vi = 10 THEN
            DBMS_OUTPUT.PUT(vi);
        ELSE 
            DBMS_OUTPUT.PUT(vi || '+');
        END IF;
        
        vsum := vsum + vi;
        EXIT WHEN vi = 10;
        vi := vi + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=' || vsum);
END;

-- [while��]
DECLARE
    vi NUMBER := 1;
    vsum NUMBER := 0;
BEGIN
    WHILE vi <= 10
    LOOP
        IF vi = 10 THEN
            DBMS_OUTPUT.PUT(vi);
        ELSE 
            DBMS_OUTPUT.PUT(vi || '+');
        END IF;
        
        vsum := vsum + vi;
        vi := vi + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=' || vsum);
END;

-- [FOR��]
DECLARE
    vsum NUMBER := 0;
BEGIN
    FOR i IN 1 .. 10
    LOOP
        IF i = 10 THEN
            DBMS_OUTPUT.PUT(i);
        ELSE 
            DBMS_OUTPUT.PUT(i || '+');
        END IF;
        
        vsum := vsum + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=' || vsum);
END;

DECLARE
    vsum NUMBER := 0;
BEGIN
    FOR i IN REVERSE 1 .. 10
    LOOP
        DBMS_OUTPUT.PUT(i || '+');        
        vsum := vsum + i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=' || vsum);
END;

-- [GOTO��]
BEGIN
    GOTO first_proc;
    <<second_proc>>
    DBMS_OUTPUT.PUT_LINE('> 2 ó��');
    GOTO third_proc;

    <<first_proc>>
    DBMS_OUTPUT.PUT_LINE('> 1 ó��');
    GOTO second_proc;
    
    <<third_proc>>
    DBMS_OUTPUT.PUT_LINE('> 3 ó��');
END;

-- ������ (2~9) ���
-- 1) WHILE LOOP ~ END LOOP ���
DECLARE
    i NUMBER(2) := 2;
    j NUMBER(2) := 1;
BEGIN
    WHILE i <= 9
    LOOP
        WHILE j <= 9
        LOOP
--            DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i*j);
            DBMS_OUTPUT.PUT(i || '*' || j || '=' || RPAD( i*j, 4, ' ' ));
            j := j + 1;
        END LOOP;
        j := 1;
        i := i+1;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;

-- 2) FOR LOOP ~ END LOOP ���
BEGIN
    FOR i IN 2 .. 9
    LOOP
        FOR j IN 1 .. 9
        LOOP
            DBMS_OUTPUT.PUT_LINE(i || '*' || j || '=' || i*j);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;










