
-- 익명프로시저 선언
-- 1) %TYPE형 변수
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

-- 2) %ROWTYPE형 변수
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


-- 3) RECODE형 변수
DECLARE 
    -- 사용자 정의 구조체 타입 선언
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
-- 4) 커서가 필요하다.
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

-- 5) CURSOR(커서)
-- 1. pl/sql 블럭 내에서 실행되는 select문을 의미한다.
-- 2. 여러 레코드로 구성된 작업영역에서 sql문을 실행하고 그 결과를 저장하기 위해서 cursor를 사용한다.
-- 3. 커서 2가지 종류
--      1) 묵시적(implicit) 커서 - 자동적으로 만들어짐
--      2) 명시적(explicit) 커서
--          (1) 명시적 커서 사용하는 순서
--            ㄱ. 커서 선언    - SELECT문을 작성
--            ㄴ. 커서 OPEN   - SELECT문을 실행
--            ㄷ. 커서 FETCH  - 결과물을 갖고 있는 커서로 부터 가져오기 -> 반복문 사용해서 처리
--                             %NOTFOUND 커서의 속성 : 커서의 행 없는지 유무
--                             %FOUND              : 커서에 행 있는지 유무
--                             %ISOPEN             : 현재 커서 상태
--                             %ROWCOUNT           : 커서를 사용해서 읽인 행의 수
--            ㄹ. 커서 CLOSE

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
    -- 1) 커서 선언 형식
    -- CURSOR 커서명 IS SELECT문;
    CURSOR edcursor IS (
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        FROM dept d JOIN emp e ON d.deptno = e.deptno
    );
BEGIN
    -- 2) 커서 실행 OPEN
    -- 형식) OPEN 커서명;
    OPEN edcursor;
   
    IF edcursor%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('OPEN O');
    ELSE
        DBMS_OUTPUT.PUT_LINE('OPEN X');
    END IF;
   
    -- 3) 커서 FETCH
    LOOP
        FETCH edcursor INTO vderow;
        DBMS_OUTPUT.PUT_LINE(edcursor%ROWCOUNT);
        DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
        EXIT WHEN edcursor%NOTFOUND;
    END LOOP;
    
    -- 4) 커서 종료 CLOSE
    -- 형식) CLOSE 커서명;
    CLOSE edcursor;
--EXCEPTION
END;

-- 6) CURSOR
-- FOR문 사용
DECLARE 
    CURSOR edcursor IS (
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        FROM dept d JOIN emp e ON d.deptno = e.deptno
    );
BEGIN
    -- FOR문 변경
    -- 자동 OPEN, CLOSE된다.
    FOR vderow IN edcursor
    LOOP
        DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
    END LOOP;
--EXCEPTION
END;

-- 6-2)
BEGIN
    -- FOR문 변경
    -- 자동 OPEN, FETCH, CLOSE된다.
    -- CURSOR 선언 필요없다.
    FOR vderow IN (
        SELECT d.deptno, dname, empno, ename, sal + NVL(comm, 0) pay
        FROM dept d JOIN emp e ON d.deptno = e.deptno
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
    END LOOP;
--EXCEPTION
END;

-- 저장 프로시저(STORED PROCEDURE)
-- 1) PL/SQL의 가장 대표적인 구조
-- 2) 데이터베이스 객체 저장
-- 3) 형식
CREATE OR REPLACE PROCEDURE up_프로시저명 (
    -- 매개변수, 인자, p접두사
)
IS
BEGIN
EXCEPTION
END;
-- 4) 저장 프로시저를 실행하는 3가지 방법
--      1) EXEC
--      2) 익명 프로시저 안에서 실행
--      3) 또 다른 저장 프로시저 안에서 실행

CREATE TABLE tbl_emp
AS (
    SELECT *
    FROM emp
);

-- 사원 번호를 입력받아서 해당 사원을 삭제하는 업무
DELETE FROM tbl_emp
WHERE empno = 7369;
COMMIT;

CREATE OR REPLACE PROCEDURE up_delEmp (
    -- 저장 프로시저의 파라미터 선언 시 자료형의 크기붙이면 안된다., %TYPE형 변수 사용가능
    -- 여러 개 쓸때는 구분자로 콤마(,) 연산자를 쓴다.
    -- 파라미터모드 IN(입력용) 기본값, OUT(출력용), IN OUT(입출력용)
--    pempno IN emp.empno%TYPE;
    pempno emp.empno%TYPE
)
IS
    -- 변수선언
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
--EXCEPTION
END;

-- 1) EXCUTE문
EXECUTE up_delEmp(pempno=>7369);
SELECT *
FROM tbl_emp;

-- 2) 익명 프로시저 안에서 저장 프로시저 실행
--DECLARE
BEGIN
    up_delEmp(7902);
END;

-- 3) 또 다른 저장 프로시저 안에서 저장 프로시저 실행.
CREATE OR REPLACE PROCEDURE up_delemp_test
IS
BEGIN
    up_delEmp(7900);
END;
EXEC up_delemp_test();

SELECT *
FROM tbl_emp;

-- [문제]
-- 1) dept을 복사해서 tbl_dept 생성
-- 2) 부서명, 지역명을 입력받아서 새로운 부서를 추가하는 저장 프로시저를 생성 up_insertdept
-- 3) 저장 프로시저 실행 테스트

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

-- 부서명 O, 지역명 X
EXEC up_insertdept('QC2');
EXEC up_insertdept('QC2', NULL);
EXEC up_insertdept(pdname => 'QC2');

-- 부서명 X, 지역명 O
EXEC up_insertdept(ploc => 'POHANG');
EXEC up_insertdept(NULL, 'POHANG');

-- [문제] tbl_dept 테이블을 수정 : up_updateDept
-- 1) 수정할 부서번호
-- 2) 부서명만 수정
-- 3) 지역명만 수정
-- 4) 부서명 + 지역명 모두를 수정

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

-- [문제점] 없는 부서도 성공이 됨
EXEC up_updateDept(100);


-- [문제] tbl_emp 테이블에서 
-- 부서번호를 입력받아서 해당 부서원들의 정보를 출력하는 저장 프로시저
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

-- 커서 파라미터를 이용하는 방법
CREATE OR REPLACE PROCEDURE up_selectEmp(
    pdeptno tbl_dept.deptno%TYPE DEFAULT TRUNC(DBMS_RANDOM.value(1, 5))*10
)
IS
--    CURSOR curemp(cp tbl_dept.deptno%TYPE) IS (
        -- 서브쿼리
--    );  

BEGIN
    -- 커서 파라미터
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

-- FOR문 사용
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

-- 출력용 매개변수
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

-- 출력용 매개변수 테스트 (익명 프로시저)
DECLARE
    vrrn insa.ssn%TYPE;
    vname insa.name%TYPE;
BEGIN
    up_insarrn(1001, vname, vrrn);
    DBMS_OUTPUT.PUT_LINE(vname || ', ' || vrrn);
--EXCEPTION
END;


-- 입출력용(IN OUT) 매개변수를 사용하는 저장 프로시저 예제
-- 주민등록번호 14자리를 입력용 매개변수 -> 주민등록번호 앞자리 6자리만 출력
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

-- 1) 저장 프로시저 연습 문제
-- 2) 저장 함수(STORED FUNCTION)

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

-- 번호, 이름, 국, 영, 수 -> 파라미터
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
    
    -- 모든 학생들의 등수 매김 다시
    UPDATE tbl_score a
    SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > a.tot);
    COMMIT;
--EXCEPTION
END;

EXEC up_insertScore(1001, '홍길동', 89, 44, 55);
EXEC up_insertScore(1002, '홍길동', 82, 64, 75);
EXEC up_insertScore(1003, '홍길동', 44, 34, 95);

SELECT *
FROM tbl_score;

-- 수정할 학번, 국, 영, 수  up_updateScore
-- 총/평/등급 
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

-- [문제1] EXEC up_deletScore(1002); 학번으로 학생 삭제 후 모든 학생 등수 다시 매기기

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

-- [문제2] EXEC up_selectscore; -- 모든 학생들 정보 출력.

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

-- Stored 함수
CREATE OR REPLACE FUNCTION uf_함수명
()
RETURN 자료형
IS
BEGIN
RETURN 반한값
EXCEPTION
END;

SELECT num, name, ssn
    , uf_gender(ssn)
    , uf_age(ssn)
FROM insa;

-- 저장 함수(stored function)
CREATE OR REPLACE FUNCTION uf_gender (
    prrn VARCHAR2
)
RETURN VARCHAR2
IS
    vgender VARCHAR2(6);
BEGIN
    IF MOD(SUBSTR(prrn, -7, 1), 2) = 1 THEN
        vgender := '남자';
    ELSE
        vgender := '여자';
    END IF;
    RETURN vgender;
--EXCEPTION
END;

SELECT num, name, ssn
    , uf_gender(ssn)
    , uf_age(ssn)
FROM insa;

-- 만나이 함수
-- 이거는 해결 못함
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

-- [문제] 주민등록번호로부터 생년월일 (1998.01.20(화)) 을 반환하는 저장함수를 만들고 테스트 uf_birth
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

-- up_selectInsa 테스트
CREATE OR REPLACE PROCEDURE up_selectInsa_test
IS
    vInsaCursor SYS_REFCURSOR;
BEGIN
    -- OPEN 커서 FOR 문
    OPEN vInsaCursor FOR
        SELECT name, city, basicpay
        FROM insa
    ;
    
    up_selectInsa(vInsaCursor);
    
    CLOSE vInsaCursor;
END;

EXEC up_selectInsa_test;

