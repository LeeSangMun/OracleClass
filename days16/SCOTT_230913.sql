-- [예외처리]
-- 1) 미리 정의된 예외 처리 방법
SELECT ename, sal
FROM emp
WHERE sal = 6000;

CREATE OR REPLACE PROCEDURE up_emplist (
    psal emp.sal%TYPE
)
IS
    vename emp.ename%TYPE;
    vsal emp.ename%TYPE;
BEGIN
    SELECT ename, sal INTO vename, vsal
    FROM emp
    WHERE sal = psal;
    DBMS_OUTPUT.PUT_LINE(vename || ', ' || vsal);
EXCEPTION
    WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20002, '> QUERY DATA NOT FOUND');
    WHEN too_many_rows THEN
        RAISE_APLICATION_ERROR(-20003, '> QUERY TOO MANY DATA');
    WHEN OTHERS THEN -- 그 외 모든 예외 발생 경우
        RAISE_APPLICATION_ERROR(-20004, '> QUERY OTHERS EXCEPTION FOUND');
END;

EXEC up_emplist(5000);
EXEC up_emplist(6000); -- ORA-01403: no data found
EXEC up_emplist(1250); -- ORA-01422: exact fetch returns more than requested number of rows

-- 2) 미리 정의되지 않은 에러 처리 방법
SELECT *
FROM dept;

INSERT INTO dept VALUES(40, 'QC', 'SEOUL');

INSERT INTO emp(empno, ename, deptno)
VALUES(9999, 'admin', 90);

CREATE OR REPLACE PROCEDURE up_insemp (
    pempno emp.empno%TYPE
    , pename emp.ename%TYPE
    , pdeptno emp.deptno%TYPE
)
IS
    NO_FK_FOUND exception;
    PRAGMA EXCEPTION_INIT(NO_FK_FOUND, -02291);
BEGIN
    INSERT INTO emp(empno, ename, deptno)
    VALUES(pempno, pename, pdeptno);
EXCEPTION
    WHEN no_data_found THEN
        RAISE_APPLICATION_ERROR(-20002, '> QUERY PK 위배.');
    WHEN NO_FK_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, '> QUERY deptno FK 위배');
    WHEN OTHERS THEN -- 그 외 모든 예외 발생 경우
        RAISE_APPLICATION_ERROR(-20004, '> QUERY OTHERS EXCEPTION FOUND');
END;

EXEC up_insemp(9999, 'admin', 90);

-- 3) 사용자가 정의하는 에러 처리 방법
-- 예) psal a~b범위 입력 -> 사원수가 0이라면 강제로 예외 발생

CREATE OR REPLACE PROCEDURE up_empexception(
    psal emp.sal%TYPE
)
IS
    vempcount NUMBER;
    NO_EMP_EXCEPTION EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO vempcount
    FROM emp
    WHERE sal BETWEEN psal-100 AND psal+100;
    
    IF vempcount = 0 THEN
        RAISE NO_EMP_EXCEPTION;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('> 사원 수 : ' || vempcount);
EXCEPTION 
    WHEN NO_EMP_EXCEPTION THEN
        RAISE_APPLICATION_ERROR(-20002, '> QUERY EMP COUNT 0');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, '> QUERY OTHERS EXCEPTION FOUND');
END;

EXEC up_empexception(900);
EXEC up_empexception(6000);

