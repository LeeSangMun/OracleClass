-- [동적 SQL]
-- 1. 동적 SQL을 사용하는 3가지 상황
--  1) 컴파일 시에 SQL문장이 확정되지 않은 경우
--      WHERE 조건절...
--  2) PL/SQL 블럭 안에서 DDL 문을 사용하는 경우
--      CREATE, ALTER, DROP
--      예) 여러 개 게시판 생성
--          저장할 컬럼(날짜, 내용, 제목)
--          체크한 컬럼으로 동적으로 게시판 생성.
--  3) PL/SQL 블럭 안에서
--      ALTER SYSTEM/SESSION 명령어를 사용할 경우

-- 2. PL/SQL 동적쿼리를 사용하는 2가지 방법
--  1) NDS(Native Dynamic SQL) = 원시 동적 쿼리
--      EXECUTE IMMEDIATE문 동적쿼리문
--          [INTO 변수명, 변수명...]
--          [USING IN/OUT/IN OUT 파라미터...]
--  2) DBMS_SQL 패키지

-- 3. 동적 쿼리 예제
--  1) 익명 프로시저
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

-- 저장 프로시저
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

-- 문제) dept 테이블에 새로운 부서 추가하는 동적 쿼리를 사용하는 저장 프로시저 생성 + 확인
SELECT *
FROM dept;
-- seq_dept 시퀀스 50, 10, nocache
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
    
    DBMS_OUTPUT.put_line('INSERT 성공!!!');
    COMMIT;
END;

EXEC up_ndsInsDept('QC', 'SEOUL');
SELECT *
FROM dept;

-- 사용자가 원하는 형태의 게시판을 생성(DDL 문) 동적쿼리
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

-- OPEN ~ FOR문 : SELECT 여러 개의 행 + 반복처리
-- OPEN 커서
-- FOR 커서 반복 처리
-- 동적 SQL를 실행 -> 결과물(여러개의 행) + 커서 처리

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

-- 동적 쿼리 검색 예제
-- [부서번호, 부서명, 지역명] 검색조건 선택
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
    psearchCondition NUMBER -- 1. 부서번호, 2. 사원명, 3. 잡
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