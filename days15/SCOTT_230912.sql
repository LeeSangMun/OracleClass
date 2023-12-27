-- [Ʈ����]
-- 1) 
-- 2) ��ġ �ʴ� ����ڰ� ������ �ʴ� �۾��� ���� ���ϰ� �� �� �ִ�.
-- 3) ��) �ٹ��ð��̳� �ָ��� �۾��� ���ϰ� �� �� �ִ�.
-- 4) trigger�� � �۾���, �Ǵ� �۾� �� trigger�� ������ ������ �����Ű�� PL/SQL ���̴�.
--    trigger�� ���̺� �̸� ������ � �̺�Ʈ�� �߻��� �� Ȱ���ϵ����� ��ü�� �ǹ��Ѵ�.
-- 5) �����
--  1. BEFORE  ������ �����ϱ� ���� Ʈ���Ÿ� ����  
--  2. AFTER  ������ ������ �Ŀ� Ʈ���Ÿ� ���� 
--  3. FOR EACH ROW  �� Ʈ�������� �˸� 
--  4. REFERENCING  ����޴� ���� ���� ���� 
--  5. :OLD  ���� �� ���� �� 
--  6. :NEW  ���� �� ���� �� 


CREATE OR REPLACE TRIGGER test_trigger
BEFORE INSERT OR UPDATE OR DELETE ON tbl_emp
BEGIN
 IF TO_CHAR(sysdate,'DY') IN ('ȭ','��') THEN
  DBMS_OUTPUT.PUT_LINE('�ָ����� �����͸� ������ �� �����ϴ�...');
 END IF;
END;

SELECT *
FROM tbl_emp;

DELETE FROM tbl_emp
WHERE empno = 7566;

INSERT INTO tbl_emp(empno) VALUES(9999);

DROP TRIGGER test_trigger;

ROLLBACK;

CREATE TABLE EXAM1 (
    id NUMBER PRIMARY KEY
    , name VARCHAR2(20)
);

CREATE TABLE exam2 (
    memo VARCHAR2(100)
    , ilja DATE DEFAULT SYSDATE
);

-- ��) exam1 ���̺� DML �����ϸ� �ڵ����� exam2 ���̺� �α� ���
SELECT * FROM exam1;
SELECT * FROM exam2;

CREATE OR REPLACE TRIGGER ut_exam1 
AFTER INSERT OR UPDATE OR DELETE ON exam1
-- FOR EACH ROW ��Ʈ���� WHEN Ʈ���� ����
BEGIN
    IF INSERTING THEN
        INSERT INTO exam2(memo) VALUES('�߰�');
    ELSIF UPDATING THEN
        INSERT INTO exam2(memo) VALUES('����');
    ELSIF DELETING THEN
        INSERT INTO exam2(memo) VALUES('����');
    END IF;
END;

INSERT INTO exam1(id, name) VALUES(1, 'aaa');
INSERT INTO exam1(id, name) VALUES(2, 'bbb');
INSERT INTO exam1(id, name) VALUES(3, 'ccc');

UPDATE exam1
SET name = 'xxx'
WHERE id = 3;

DELETE FROM exam1; -- ���� ���� Ʈ����. ������ �����ص� ���� �αװ� �ѹ� ����

COMMIT;
ROLLBACK; -- exam1, exam2 �Ѵ� �ѹ�ȴ�.


CREATE OR REPLACE TRIGGER ut_Exam2
BEFORE INSERT OR DELETE OR UPDATE ON EXAM1
BEGIN 
   IF TO_CHAR(SYSDATE, 'DAY') IN ('�����', '�Ͽ���') OR
       TO_CHAR(SYSDATE, 'hh24')<12 OR
       TO_CHAR(SYSDATE, 'hh24')>=18 THEN
       raise_application_error(-20000, '������ �ڷ� �Է�(����, ����)�� �ȵǴ� �ð��Դϴ�!');
    END IF;
END;

DROP TRIGGER ut_exam1;
DROP TRIGGER ut_exam2;

--�� Ʈ���� �ۼ��� ���� ���̺� �ۼ�
CREATE TABLE test1 (
    hak VARCHAR2(10) PRIMARY KEY
    , name VARCHAR2(20)
    , kor NUMBER(3)
    , eng NUMBER(3)
    , mat NUMBER(3)
);

CREATE TABLE test2 (
    hak VARCHAR2(10) PRIMARY KEY
    , tot NUMBER(3)
    , ave NUMBER(4,1)
    , CONSTRAINT fk_test2_hak FOREIGN KEY(hak) REFERENCES TEST1(hak)
);


-- test1 ���̺� �� �л��� �й�, �̸�, ��, ��, �� INSERT -> test2 ��, �� INSERT Ʈ����

-- ORA-04082: NEW or OLD references not allowed in table level triggers
-- �� ���� Ʈ���ſ����� :NEW, :OLD ����� ��밡��
CREATE OR REPLACE TRIGGER ut_instest1
AFTER INSERT ON test1
FOR EACH ROW -- �� ���� Ʈ����
DECLARE
    vtot NUMBER(3);
    vavg NUMBER(5, 2);
BEGIN
    vtot := :NEW.kor + :NEW.eng + :NEW.mat;
    vavg := vtot/3;
    INSERT INTO test2(hak, tot, ave) VALUES(:NEW.hak, vtot, vavg);
END;

INSERT INTO TEST1(hak, NAME, kor, eng, mat) VALUES ('1', 'a', 100, 70, 80);
INSERT INTO TEST1(hak, NAME, kor, eng, mat) VALUES ('2', 'b', 80, 80, 80);
COMMIT;

SELECT * FROM test1;
SELECT * FROM test2;

UPDATE TEST1 SET kor=20, eng=20, mat=20 
WHERE hak=1;
COMMIT;

CREATE OR REPLACE TRIGGER ut_instest1
AFTER INSERT OR UPDATE ON test1
FOR EACH ROW -- �� ���� Ʈ����
DECLARE
    vtot NUMBER(3);
    vavg NUMBER(5, 2);
BEGIN
    vtot := :NEW.kor + :NEW.eng + :NEW.mat;
    vavg := vtot/3;
    IF INSERTING THEN
        INSERT INTO test2(hak, tot, ave) VALUES(:NEW.hak, vtot, vavg);
    ELSIF UPDATING THEN
        UPDATE test2
        SET tot = vtot, ave = vavg
        WHERE hak = :OLD.hak;
    END IF;
END;

DELETE FROM test1
WHERE hak = 1;
COMMIT;

CREATE OR REPLACE TRIGGER ut_deltest1
BEFORE DELETE ON test1
FOR EACH ROW -- �� ���� Ʈ����
BEGIN
    DELETE FROM test2
    WHERE hak = :OLD.hak;
END;

-- Ʈ���� �ǽ� ����
-- ��ǰ ���̺� �ۼ�
CREATE TABLE ��ǰ (
   ��ǰ�ڵ�        VARCHAR2(6) NOT NULL PRIMARY KEY
  , ��ǰ��           VARCHAR2(30)  NOT NULL
  , ������        VARCHAR2(30)  NOT NULL
  , �Һ��ڰ���  NUMBER
  , ������     NUMBER DEFAULT 0
);

-- �԰� ���̺� �ۼ�
CREATE TABLE �԰� (
   �԰��ȣ      NUMBER PRIMARY KEY
  , ��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  , �԰�����     DATE
  , �԰����      NUMBER
  , �԰�ܰ�      NUMBER
);

-- �Ǹ� ���̺� �ۼ�
CREATE TABLE �Ǹ� (
   �ǸŹ�ȣ      NUMBER  PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�Ǹ�����      DATE
  ,�Ǹż���      NUMBER
  ,�ǸŴܰ�      NUMBER
);

-- ��ǰ ���̺� �ڷ� �߰�
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('AAAAAA', '��ī', '���', 100000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('BBBBBB', '��ǻ��', '����', 1500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('CCCCCC', '�����', '���', 600000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('DDDDDD', '�ڵ���', '�ٿ�', 500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
         ('EEEEEE', '������', '���', 200000);
COMMIT;
SELECT * FROM ��ǰ;

-- 1) �԰� ���̺� ��ǰ�� �԰� �Ǹ� �ڵ����� ��ǰ ���̺��� �������� 
--      update �Ǵ� Ʈ���� ���� + Ȯ��
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER INSERT ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
END;

INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (1, 'AAAAAA', '2004-10-10', 5,   50000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (2, 'BBBBBB', '2004-10-10', 15, 700000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (3, 'AAAAAA', '2004-10-11', 15, 52000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (4, 'CCCCCC', '2004-10-14', 15,  250000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (5, 'BBBBBB', '2004-10-16', 25, 700000);
COMMIT;

SELECT * FROM ��ǰ;
SELECT * FROM �԰�;

-- [����] �԰��ȣ�� 5�� �԰� ������ �˰��� 30
UPDATE �԰�
SET �԰���� = 30
WHERE �԰��ȣ = 5;

CREATE OR REPLACE TRIGGER ut_upIpgo
AFTER UPDATE ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰���� + :NEW.�԰����
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
END;

-- [����] �԰� ���̺��� �԰� ��ҵǾ �԰� ����
--  ��ǰ ���̺��� ������ ����
DELETE FROM �԰�
WHERE �԰��ȣ = 5;
COMMIT;

CREATE OR REPLACE TRIGGER ut_delIpgo
AFTER DELETE ON �԰�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ - :OLD.�԰����
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
END;

-- 1) �Ǹ� ���̺� � ��ǰ�� �ǸŰ� �Ǹ� ��ǰ ���̺� �Ǹŵ� ��ǰ�� �������� ����.
-- ut_insPan

INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) 
VALUES(1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;

CREATE OR REPLACE TRIGGER ut_insPan
BEFORE INSERT ON �Ǹ�
FOR EACH ROW
DECLARE
    qty NUMBER;
BEGIN
    SELECT ������ INTO qty
    FROM ��ǰ
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;

    IF qty >= :NEW.�Ǹż��� THEN
        UPDATE ��ǰ
        SET ������ = ������ - :NEW.�Ǹż���
        WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    ELSE 
        RAISE_APPLICATION_ERROR(-20007, '������ �������� �Ǹ� ����');
    END IF;
END;

-- 2) AAAAAA 5 �Ǹ� -> 10 ����
UPDATE �Ǹ� 
SET �Ǹż��� = 10
WHERE �ǸŹ�ȣ = 1;
COMMIT;

CREATE OR REPLACE TRIGGER ut_upPan
BEFORE UPDATE ON �Ǹ�
FOR EACH ROW
DECLARE
    qty NUMBER;
BEGIN
    SELECT ������ INTO qty
    FROM ��ǰ
    WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;

    IF qty + :OLD.�Ǹż��� >= :NEW.�Ǹż��� THEN
        UPDATE ��ǰ
        SET ������ = ������ - :NEW.�Ǹż��� + :OLD.�Ǹż���
        WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
    ELSE 
        RAISE_APPLICATION_ERROR(-20007, '������ �������� �Ǹ� ����');
    END IF;
END;

-- 3) �Ǹ� 1�� �Ǹ� ���
CREATE OR REPLACE TRIGGER ut_delPan
AFTER DELETE ON �Ǹ�
FOR EACH ROW
BEGIN
    UPDATE ��ǰ
    SET ������ = ������ + :OLD.�Ǹż���
    WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
END;

DELETE FROM �Ǹ�
WHERE �ǸŹ�ȣ = 1;
COMMIT;

SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;
SELECT * FROM �԰�;

SELECT *
FROM user_triggers;


