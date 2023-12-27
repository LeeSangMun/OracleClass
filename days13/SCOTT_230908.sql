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

-- [시퀀스(Sequence)]
-- 자동으로 일련번호 생성

SELECT *
FROM user_sequences;
--FROM seq; // 시노님

CREATE SEQUENCE seq_deteno;

-- 시퀀스 키본값
-- INCREMENT BY 1
-- START WITH 1
-- MAXVALUE 9999999999999999999999999999
-- MINVALUE 1
-- NOCYCLE]
-- CACHE 20;

DROP SEQUENCE seq_deptno;

-- dept 시퀀스
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

-- 절차적 언어(변수, 제어문)
-- 블록 구조로 된 언어

[DECLARE]
    1) 선언 블럭
BEGIN
    2) 실행 블럭
[EXCEPTION]
    3) 예외 처리 블럭
END

-- PL/SQL 의 6가지 종류
    1) 익명 프로시저
    2) 저장 프로시저 ***
    3) 저장 함수
    4) 패키지
    5) 트리거
--    6) 객체

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
    2) select, fetch절

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
    
    DBMS_OUTPUT.PUT_LINE('사원명=' || vname);
    DBMS_OUTPUT.PUT_LINE('급여=' || vpay);
--EXCEPTION
END;


DECLARE
  -- 일반변수 v, 매개변수 p
  -- 선언 블럭 : 변수 선언
  -- vname VARCHAR2(20);
  -- vpay  NUMBER(10);
  vname INSA.name%TYPE := '익명' ;  -- 타입형 변수
  vpay  NUMBER(10) := 0; 
  vpi CONSTANT NUMBER := 3.141592;
  vmessage VARCHAR2(100);
BEGIN
  -- 실행 블럭
  SELECT name, basicpay + sudang
       INTO vname, vpay
  FROM insa
  WHERE num = 1001;
  -- 출력..
  -- Java : System.out.printf();
  --DBMS_OUTPUT.PUT_LINE( '사원명='  || vname );
  --DBMS_OUTPUT.PUT_LINE( '급여='  || vpay );
  
  vmessage := vname || ', ' || vpay;
  DBMS_OUTPUT.PUT_LINE( '결과 : '  || vmessage );
--EXCEPTION
END;


-- [문제] 30번 부서의 지역명을 얻어와서
--       10번 부서의 지역명으로 설정 // 익명프로시저로 작성
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

-- [문제] 10번 부서원 중에 최고 sal를 받는 사원의 정보 조회
-- 1) TOP-N 방식
SELECT *
FROM(
    SELECT *
    FROM emp
    WHERE deptno = 10
    ORDER BY sal DESC
)
WHERE ROWNUM = 1;

-- 2) RANK 함수
SELECT *
FROM (
    SELECT emp.*
        , RANK() OVER(ORDER BY sal DESC) sal_rank
    FROM emp 
    WHERE deptno = 10
)
WHERE sal_rank = 1;

-- 3) 서브쿼리
SELECT *
FROM emp
WHERE deptno = 10 AND sal = (SELECT MAX(sal) FROM emp WHERE deptno = 10);

-- 4) 익명프로시저 사용
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

    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || vempno);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || vename);
    DBMS_OUTPUT.PUT_LINE('입사일자 : ' || vhiredate);
--EXCEPTION
END;

-- 4-2) %ROWTYPE형 변수
DECLARE
    vmax_sal_10 emp.sal%TYPE;
    vrow emp%ROWTYPE; -- 레코드형 변수 선언
BEGIN
    SELECT MAX(sal)
    INTO vmax_sal_10
    FROM emp
    WHERE deptno = 10;
    
    SELECT empno, ename, job, sal, hiredate, deptno
        INTO vrow.empno, vrow.ename, vrow.job, vrow.sal, vrow.hiredate, vrow.deptno
    FROM emp
    WHERE deptno = 10 AND sal = vmax_sal_10;

    DBMS_OUTPUT.PUT_LINE('사원번호 : ' || vrow.empno);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || vrow.ename);
    DBMS_OUTPUT.PUT_LINE('입사일자 : ' || vrow.hiredate);
--EXCEPTION
END;

-- PL/SQL에서 여러 개의 레코드를 가져와서 처리하기 위해서는 반드시 커서를 사용해야 된다.
-- ORA-01422: exact fetch returns more than requested number of rows
DECLARE
  vname INSA.name%TYPE := '익명' ;  
  vpay  NUMBER(10) := 0; 
  vmessage VARCHAR2(100);
BEGIN
  SELECT name, basicpay + sudang
       INTO vname, vpay
  FROM insa;
  
  vmessage := vname || ', ' || vpay;
  DBMS_OUTPUT.PUT_LINE( '결과 : '  || vmessage );
END;

-- if문
IF(조건식) THEN
END IF;

-- if - else 문
IF(조건식) THEN
ELSE
END IF;

-- if else if
IF(조건식) THEN
ELSIF(조건식) THEN -- 주의 ELSIF 
ELSIF(조건식) THEN
ELSE
END IF;

-- [문제] 변수를 하나 선언해서 정수를 입력받아서 짝수, 홀수 출력.
DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6) := '홀수';
BEGIN
    vnum := :bindNumber;
    IF(MOD(vnum, 2) = 0) THEN
        vresult := '짝수';
--    ELSE
--        vresult := '홀수';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vnum || '=' ||  vresult);
END;

-- [문제] 국어점수 입력받아서 수~가 출력
DECLARE
    vkor NUMBER(3) := 0;
    vgrade NCHAR := '가';
BEGIN
    vkor := :bindKorNum;
    
    IF(vkor BETWEEN 0 AND 100) THEN
        IF vkor >= 90 THEN 
            vgrade := '수';
        ELSIF vkor >= 80 THEN
            vgrade := '우';
        ELSIF vkor >= 70 THEN
            vgrade := '미';
        ELSIF vkor >= 60 THEN
            vgrade := '양';
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('0~100 입력');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vkor || ' ' || vgrade);
END;

DECLARE
    vkor NUMBER(3) := 0;
    vgrade NCHAR := '가';
BEGIN
    vkor := :bindKorNum;
    
    IF(vkor BETWEEN 0 AND 100) THEN
        CASE TRUNC(vkor/10)
            WHEN 10 THEN vgrade := '수';
            WHEN 9 THEN vgrade := '수';
            WHEN 8 THEN vgrade := '우';
            WHEN 7 THEN vgrade := '미';
            WHEN 6 THEN vgrade := '양';
            ELSE vgrade := '가';
        END CASE;
    ELSE
        DBMS_OUTPUT.PUT_LINE('0~100 입력');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vkor || ' ' || vgrade);
END;

DECLARE
    vkor NUMBER(3) := 0;
    vgrade NCHAR := '가';
BEGIN
    vkor := :bindKorNum;
    
    IF(vkor BETWEEN 0 AND 100) THEN
        vgrade := CASE TRUNC(vkor/10)
                    WHEN 10 THEN  '수'
                    WHEN 9 THEN  '수'
                    WHEN 8 THEN  '우'
                    WHEN 7 THEN  '미'
                    WHEN 6 THEN  '양'
                    ELSE  '가'
                  END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('0~100 입력');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(vkor || ' ' || vgrade);
END;

-- Oracle 반복문
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

-- [while문]
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

-- [FOR문]
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

-- [GOTO문]
BEGIN
    GOTO first_proc;
    <<second_proc>>
    DBMS_OUTPUT.PUT_LINE('> 2 처리');
    GOTO third_proc;

    <<first_proc>>
    DBMS_OUTPUT.PUT_LINE('> 1 처리');
    GOTO second_proc;
    
    <<third_proc>>
    DBMS_OUTPUT.PUT_LINE('> 3 처리');
END;

-- 구구단 (2~9) 출력
-- 1) WHILE LOOP ~ END LOOP 사용
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

-- 2) FOR LOOP ~ END LOOP 사용
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










