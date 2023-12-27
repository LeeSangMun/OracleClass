-- 2) NCHAR
CREATE TABLE test (
    aa CHAR(3)
    , bb CHAR(3 char)
    , cc NCHAR(3)
);

INSERT INTO test(aa, bb, cc)
VALUES('홍길동', '홍길동', '홍길동');
INSERT INTO test(aa, bb, cc)
VALUES('홍', '홍길동', '홍길동');

-- NUMBER
CREATE TABLE tbl_number (
    kor NUMBER(3, 0)
    , eng NUMBER(3, 0)
    , mat NUMBER(3, 0) 
    , tot NUMBER(3, 0)
    , avg NUMBER(5, 2)
);

INSERT INTO tbl_number(kor, eng, mat)
VALUES(90.89, 85, 100);
INSERT INTO tbl_number(kor, eng, mat)
VALUES(90, 85, -999);
INSERT INTO tbl_number(kor, eng, mat)
VALUES(80, 75, 30);

INSERT INTO tbl_number(kor, eng, mat)
VALUES(TRUNC(dbms_random.value(0, 101)), TRUNC(dbms_random.value(0, 101)), TRUNC(dbms_random.value(0, 101)));

UPDATE tbl_number 
SET avg = 99999
WHERE avg = 92;

SELECT *
FROM tbl_number;

DROP TABLE test;
DROP TABLE tbl_number;
DESC test;
ROLLBACK;
COMMIT;

DESC emp;
DESC dept;
--------------------------------------------------------------------------------

-- COUNT OVER() - 질의한 행의 누적된 결과값을 반환
SELECT buseo, name, basicpay
--    , COUNT(*) OVER(ORDER BY basicpay)
    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;

SELECT buseo, name, basicpay
--    , SUM(basicpay) OVER(ORDER BY basicpay)
    , SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;

-- 각 지역별 평균과 나의 급여액의 차이
SELECT city, name, basicpay
    , AVG(basicpay) OVER(PARTITION BY city ORDER BY city)
    , basicpay - AVG(basicpay) OVER(PARTITION BY city ORDER BY city)
FROM insa;

-- [테이블 생성, 수정, 삭제]
-- [테이블 레코드(행, row)를 추가, 수정, 삭제]


-- 1) 테이블 - 데이터 저장소
-- 2) DB 모델링 -> 테이블 생성

-- 예) 게시판의 게시글을 저장할 테이블 생성
--  1) 테이블명 : tbl_board
--  2) 컬럼명 - 글번호(PK)   seq        숫자(정수)     NUMBER(38)      NOT NULL  
--             작성자       writer     문자          VARCHAR2(20)    NOT NULL
--             비밀번호     passwd     문자           VARCHAR2(15)    NOT NULL
--             제목        title       문자          VARCHAR2(100)   NOT NULL
--             내용        content     문자          CLOB
--             작성일      regdate     날짜          DATE                         DEFAULT SYSDATE
--             등등
--  3) 게시글을 구분할 수 있는 고유한 키 : 글번호
--  4) 필수 입력 사항 : == NOT NULL 제약조건
--  5) 작성일은 현재 시스템의 날짜로 자동 입력

--【간단한형식】
--    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
--      ( 
--        열이름  데이터타입 [DEFAULT 표현식] [제약조건] 
--       [,열이름  데이터타입 [DEFAULT 표현식] [제약조건] ] 
--       [,...]  
--      ); 

CREATE TABLE tbl_board
( 
   seq NUMBER(38) NOT NULL PRIMARY KEY
   , writer VARCHAR2(20) NOT NULL
   , passwd VARCHAR2(15) NOT NULL
   , title VARCHAR2(100) NOT NULL
   , content CLOB
   , regdate DATE DEFAULT SYSDATE
); 

INSERT INTO tbl_board (seq, writer, passwd, title, content, regdate)
VALUES(1, 'admin', '1234', 'test-1', 'test-1', SYSDATE);
INSERT INTO tbl_board (seq, writer, passwd, title, content)
VALUES(2, 'hong', '1234', 'test-2', 'test-2');

SELECT *
FROM tbl_board;

-- tbl_board 테이블에 제약조건 모두 확인
SELECT *
FROM user_constraints
WHERE table_name LIKE UPPER('%board%');

INSERT INTO tbl_board
VALUES(3, 'hong', '1234', 'test-3', 'test-3', SYSDATE);

-- 컬럼 추가시 테이블의 행이 존재한다면
-- NULL값으로 채어짐
-- 조회수 컬럼 X - 테이블 생성 후 새로운 컬럼 추가
-- readed NUMBER
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0;
-- 칼럼을 새로 추가할 시 기존의 게시글(행)은 NULL로 초기화되는데
-- DEFAULT 값을 설정했다면 그 기본값으로 기존의 게시글(행)도 초기화가 된다.

-- 1) 게시글 작성
INSERT INTO tbl_board(writer, seq, title, passwd)
VALUES (
    'kenik'
    , (SELECT NVL(MAX(seq), 0)+1 FROM tbl_board)
    , 'test-4'
    , '1234'
);

-- content가 null인 경우 -> '냉무' 게시글 수정
UPDATE tbl_board 
SET content = '냉무'
WHERE content IS NULL;

COMMIT;

-- 3) kenik 작성자의 모든 게시글을 삭제
DELETE FROM tbl_board
WHERE writer = 'kenik';

-- 4) 컬럼의 자로형의 크기 수정
-- writer NOT NULL VARCHAR(20) -> 40
SELECT MAX(VSIZE(writer))
FROM tbl_board;

ALTER TABLE tbl_board
MODIFY writer VARCHAR(40);

-- 5) title 컬럼명 수정 : subject 컬럼명으로
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;

-- 6) bigo 컬럼을 추가 후 삭제
ALTER TABLE tbl_board
ADD bigo VARCHAR(100);

ALTER TABLE tbl_board
DROP COLUMN bigo;

DROP TABLE tbl_board;

-- 7) 테이블 명을 수정
--RENAME 테이블명1 TO 테이블명2

-- 2) 테이블 생성하는 방법 : 서브쿼리를 이용한
--    ㄱ. 이미 기존에 테이블 존재 + 여러 레코드(행) 존재
--    ㄴ. subquery 사용해서 테이블 생성.
--    ㄷ. (1) 테이블생성 + (2) 데이터 복사 + (3) 제약조건 복사 x(NN O)

CREATE table tbl_emp(empno, ename, job, hiredate, mgr, pay, deptno)
AS
    SELECT empno, ename, job, hiredate, mgr, sal+NVL(comm, 0) pay, deptno
    FROM emp
;

SELECT *
FROM emp;
-- 제약조건 복사 x

SELECT *
FROM user_constraints
WHERE table_name = 'TBL_EMP';

--  서브쿼리를 이용해서 테이블 생성 + 데이터 x (테이블의 구조만 복사해서)
CREATE TABLE tbl_emp
AS SELECT *
FROM emp
WHERE 1 = 0;
--
DESC tbl_emp;
--
SELECT *
FROM tbl_emp;

-- [문제] deptno, dname, empno, ename, hiredate, pay, grade 
-- tbl_empgrade 테이블명
CREATE TABLE tbl_empgrade
AS (
    SELECT d.deptno, dname, empno, ename, hiredate, sal+NVL(comm, 0) pay, grade
    FROM emp e JOIN dept d ON e.deptno=d.deptno
               JOIN salgrade s ON sal BETWEEN s.losal AND s.hisal
);

SELECT *
FROM tbl_empgrade;

--------------------------------------------------------------------------------
-- [INSERT 문]
--INSERT INTO 테이블명 [(컬럼명)] VALUES (컬럼 값);

-- 멀티 인설트 문 (Multi + Table + INSERT)
-- 1) unconditional insert all 


Unconditional insert all 문은 조건과 상관없이 기술되어진 여러 개의 테이블에 데이터를 입력한다.

? 서브쿼리로부터 한번에 하나의 행을 반환받아 각각 insert 절을 수행한다.
? into 절과 values 절에 기술한 컬럼의 개수와 데이터 타입은 동일해야 한다.

【형식】
	INSERT ALL | FIRST
	  [INTO 테이블1 VALUES (컬럼1,컬럼2,...)]
	  [INTO 테이블2 VALUES (컬럼1,컬럼2,...)]
	  .......
	Subquery;

여기서 
 ALL : 서브쿼리의 결과 집합을 해당하는 insert 절에 모두 입력
 FIRST : 서브쿼리의 결과 집합을 해당하는 첫 번째 insert 절에 입력
 subquery : 입력 데이터 집합을 정의하기 위한 서브쿼리는 한 번에 하나의 행을 반환하여 각 insert 절 수행
 
 -- 예)
CREATE TABLE dept_10 AS (SELECT * FROM dept WHERE 1 = 0);
CREATE TABLE dept_20 AS (SELECT * FROM dept WHERE 1 = 0);
CREATE TABLE dept_30 AS (SELECT * FROM dept WHERE 1 = 0);
CREATE TABLE dept_40 AS (SELECT * FROM dept WHERE 1 = 0);
 
INSERT ALL
    INTO dept_10 VALUES(deptno, dname, loc)
    INTO dept_20 VALUES(deptno, dname, loc)
    INTO dept_30 VALUES(deptno, dname, loc)
    INTO dept_40 VALUES(deptno, dname, loc)
SELECT deptno, dname, loc FROM dept;

SELECT *
FROM dept_40;

ROLLBACK;

DROP TABLE dept_10;
DROP TABLE dept_20;
DROP TABLE dept_30;
DROP TABLE dept_40;

-- 2) conditional insert all 

-- emp 테이블에서 각 부서별로 채워 넣을 때

CREATE TABLE emp_10 AS (SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_20 AS (SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_30 AS (SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_40 AS (SELECT * FROM emp WHERE 1=0);

INSERT ALL
--INSERT FIRST
    WHEN deptno = 10 THEN
    INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 20 THEN
    INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 30 THEN
    INTO emp_30 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 40 THEN
    INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * 
FROM emp;

SELECT *
FROM emp_10;
SELECT *
FROM emp_20;

ROLLBACK;

-- 3) conditional first insert 

INSERT FIRST
    WHEN deptno = 10 THEN
    INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 20 THEN
    INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 30 THEN
    INTO emp_30 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
    WHEN deptno = 40 THEN
    INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT * 
FROM emp;

-- [INSERT ALL / INSERT FIRST] 차이점 설명
-- ALL은 조건을 만족하면 수행을 하지만 
-- FIRST는 조건1에서 만족을 하면 다음조건에는 포함되지 않는다.

INSERT FIRST 
WHEN deptno = 10 THEN
    INTO emp_10 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
WHEN job = 'CLERK' THEN
    INTO emp_20 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
ELSE
    INTO emp_40 VALUES(empno, ename, job, mgr, hiredate, sal, comm, deptno)
SELECT *
FROM emp;

-- 4) pivoting insert 

create table sales(
employee_id       number(6),
week_id            number(2),
sales_mon          number(8,2),
sales_tue          number(8,2),
sales_wed          number(8,2),
sales_thu          number(8,2),
sales_fri          number(8,2)
);

insert into sales values(1101,4,100,150,80,60,120);

insert into sales values(1102,5,300,300,230,120,150);

COMMIT;

create table sales_data(
employee_id        number(6),
week_id            number(2),
sales              number(8,2));

insert all
into sales_data values(employee_id, week_id, sales_mon)
into sales_data values(employee_id, week_id, sales_tue)
into sales_data values(employee_id, week_id, sales_wed)
into sales_data values(employee_id, week_id, sales_thu)
into sales_data values(employee_id, week_id, sales_fri)
select employee_id, week_id, sales_mon, sales_tue, sales_wed,
sales_thu, sales_fri
from sales;

SELECT *
FROM sales_data;

-- 1) emp_10 테이블의 모든 행 삭제 + COMMIT, ROLLBACK
DELETE FROM emp_10;
SELECT *
FROM emp_20;

-- 2) emp_20 테이블의 모든 행 삭제 + 자동 커밋
TRUNCATE TABLE emp_20;
SELECT *
FROM emp_20;

-- 3) 테이블 자체를 삭제
DROP TABLE emp_30;
--------------------------------------------------------------------------------

-- [문제] insa 테이블에서 num, name 컬럼만을 복사해서 새로운 tbl_score 테이블 생성
-- (num <= 1005)
CREATE TABLE tbl_score
AS (
    SELECT num, name
    FROM insa
    WHERE num <= 1005
);

SELECT *
FROM tbl_score;

-- [문제] tbl_score 테이블에 kor, eng, mat, tot, avg, grade, rank 컬럼 추가
-- (조건 국, 영, 수, 총점은 기본값 0)
ALTER TABLE tbl_score
ADD (
    kor NUMBER(3) DEFAULT 0
    , eng NUMBER(3) DEFAULT 0
    , mat NUMBER(3) DEFAULT 0
    , tot NUMBER(3) DEFAULT 0
    , avg NUMBER(5,2)
    , grade CHAR
    , rank NUMBER(3)
);

DESC tbl_score;

-- [문제] 1001~1005 5명 학생의 kor, eng, mat 점수를 임의의 점수로 수정
UPDATE tbl_score 
SET kor = TRUNC(dbms_random.value(0, 101))
    , eng = TRUNC(dbms_random.value(0, 101))
    , mat = TRUNC(dbms_random.value(0, 101));

-- [문제] 1005 학생의 k,e,m -> 1001 학생의 점수로 수정
UPDATE tbl_score 
SET kor = (SELECT kor FROM tbl_score WHERE num = 1005)
    , eng = (SELECT eng FROM tbl_score WHERE num = 1005)
    , mat = (SELECT mat FROM tbl_score WHERE num = 1005)
WHERE num=1001;
    
UPDATE tbl_score
SET (kor, eng, mat) = (SELECT kor, eng, mat FROM tbl_score WHERE num = 1005)
WHERE num = 1001;

-- [문제] 모든 학생의 총점, 평균을 수정
UPDATE tbl_score
SET tot = kor+eng+mat, avg = (kor+eng+mat)/3;

-- [문제] 등급(grade) 'A', 'B', 'C', 'D', 'F'
UPDATE tbl_score
SET grade = CASE 
            WHEN avg>=90 THEN 'A'
            WHEN avg>=80 THEN 'B'
            WHEN avg>=70 THEN 'C'
            WHEN avg>=60 THEN 'D'
            ELSE 'F'
            END;
            
-- [문제] tbl_score 테이블의 등수 처리
UPDATE tbl_score t
SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE avg > t.avg);

UPDATE tbl_score p
SET rank = (
        SELECT t.r
        FROM(
            SELECT num, tot, RANK() OVER(ORDER BY tot DESC) r
            FROM tbl_score
        ) t
        WHERE p.num = t.num
);


-- [문제] 모든 학생들의 영어 점수를 20점 증가
UPDATE tbl_score
SET eng = CASE
            WHEN eng >= 80 THEN 100
            ELSE eng + 20
            END;


-- [문제] 국,영,수 점수가 또 수정되면 수정된 학생들의 총점, 평균, 전체학생들의 등수도 달라짐
-- 트리거 -> PL/SQL 5가지의 한 종류


-- [문제] 여학생들만 국어 점수를 5점씩 증가 시키는 쿼리 작성
UPDATE tbl_score
SET kor = CASE
            WHEN kor >= 95 THEN 100
            ELSE kor + 5
          END
WHERE num IN (
    SELECT t.num
    FROM tbl_score t JOIN insa i ON t.num = i.num
    WHERE MOD(SUBSTR(ssn, 8, 1), 2) = 0
);

SELECT *
FROM tbl_score;

ROLLBACK;
COMMIT;

-- [merge]

CREATE TABLE tbl_emp(
    id NUMBER PRIMARY KEY, -- NOT NULL 을 따로 주기도 한다. PK를 회수할 때 NOT NULL이 사라지기 때문 
    name VARCHAR2(10) NOT NULL,
    salary  NUMBER,
    bonus NUMBER DEFAULT 100
);

insert into tbl_emp(id,name,salary) values(1001,'jijoe',150);
insert into tbl_emp(id,name,salary) values(1002,'cho',130);
insert into tbl_emp(id,name,salary) values(1003,'kim',140);
select * from tbl_emp;

create table tbl_bonus(
    id number
    , bonus number default 100
);

insert into tbl_bonus(id)
(select e.id from tbl_emp e);

INSERT INTO tbl_bonus VALUES(1004, 50);

SELECT *
FROM tbl_bonus;

-- tbl_emp 와 tbl_bonus 병합
MERGE INTO tbl_bonus b
USING (SELECT id, salary FROM tbl_emp) e
ON (b.id = e.id)
WHEN MATCHED THEN UPDATE SET b.bonus = b.bonus + e.salary*0.01
WHEN NOT MATCHED THEN INSERT (b.id, b.bonus) VALUES (e.id, e.salary*0.01);

SELECT *
FROM tbl_bonus;

SELECT *
FROM tbl_emp;


DESC tbl_emp;





