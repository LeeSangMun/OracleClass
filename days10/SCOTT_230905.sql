-- [제약조건]
-- 제약조건은 data integrity(데이터 무결성)을 위해서
-- 무결성 종류
--  ? 1) 개체 무결성(Entity Integrity)
--  ? 2) 참조 무결성(Relational Integrity)
--  ? 3) 도메인 무결성(domain integrity)

-- ORA-02449: unique/primary keys in table referenced by foreign keys
DROP TABLE dept;

SELECT *
FROM emp;

UPDATE emp
SET deptno=NULL
WHERE ename='KING';


-- 제약조건을 설정하는 방법
-- 1) 컬럼 레벨 방식 (IN-LINE 방식)
-- 2) 테이블 레벨 방식 (OUT-OF-LINE 방식)

--CREATE TABLE sample(
--    컬럼들 ...
--    , CONSTRAINT 제약조건설정
--    , CONSTRAINT id NOT NULL // x NOT NULL 제약조건은 칼럼레벨로 설정해야 한다.
--    , CONSTRAINT id + pwd 복합키로 설정(복합키는 칼럼레벨로 설정할 수 없다.)
--    , CONSTRAINT 제약조건설정
--);


-- 제약조건을 설정하는 시점
-- 1) 테이블 생성할 때 - CREATE TABLE 문
-- 2) 테이블 수정할 때 - ALTER TABLE 문


-- 제약조건 종류 5가지
-- PRIMARY KEY(PK) - 해당 컬럼 값은 반드시 존재해야 하며, 유일해야 함 (NOT NULL과 UNIQUE 제약조건을 결합한 형태) 
-- FOREIGN KEY(FK) - 해당 컬럼 값은 참조되는 테이블의 컬럼 값 중의 하나와 일치하거나 NULL을 가짐 
-- UNIQUE KEY(UK) - 테이블내에서 해당 컬럼 값은 항상 유일해야 함 
-- NOT NULL - 컬럼은 NULL 값을 포함할 수 없다. 
-- CHECK(CK) - 해당 컬럼에 저장 가능한 데이터 값의 범위나 조건 지정 

-- 실습) tbl_contraint
-- 1) 컬럼 레벨 제약조건 설정
CREATE TABLE tbl_constraint1 (
    empno NUMBER(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR(20)
    , deptno NUMBER(2) CONSTRAINT FK_tblconstraint1_deptno REFERENCES dept(deptno)
    , kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100)       
    , email VARCHAR2(250) CONSTRAINT UK_tblconstraint1_email UNIQUE-- 유일한 값, 유일성 제약조건(UK)
    , city VARCHAR2(20) CONSTRAINT CK_tblconstraint1_city CHECK(city IN ('서울', '부산', '대구', '대전'))  
);

SELECT *
FROM user_constraints
WHERE table_name = UPPER('tbl_constraint1');

DROP TABLE tbl_constraint1;

--ALTER TABLE 테이블명 
--DROP [CONSTRAINT constraint명 | PRIMARY KEY | UNIQUE(컬럼명)]
--[CASCADE];

-- ㄱ. 
ALTER TABLE tbl_constraint1
DROP CONSTRAINT SYS_C007038;

ALTER TABLE tbl_constraint1
DROP CONSTRAINT PK_tbl_constraint1_empno;

-- ㄴ. PK 제역조건명을 몰라도 제거할 수 있다.
ALTER TABLE tbl_constraint1
DROP PRIMARY KEY;

-- 2) 테이블 레벨 제약조건 설정
CREATE TABLE tbl_constraint2 (
    empno NUMBER(4) NOT NULL
    , ename VARCHAR2(20)
    , dete NUMBER(2)
    , kor NUMBER(3)
    , email VARCHAR2(250)
    , city VARCHAR2(20)
    , CONSTRAINT PK_tblconstraint2_empno PRIMARY KEY(empno)
    , CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deotno) REFERENCES dept(deptno)
    , CONSTRAINT CK_tblconstraint2_kor CHECK(kor BETWEEN 0 AND 100)
    , CONSTRAINT UK_tblconstraint2_email UNIQUE(email)
    , CONSTRAINT CK_tblconstraint1_city CHECK(city IN ('서울', '부산', '대구', '대전'))  
);


-- 3) 테이블 생성 후에 PK 제약조건 설정
DROP TABLE tbl_constraint3;
CREATE TABLE tbl_constraint3 (
    emp NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);

ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tbl_constraint3_empno PRIMARY KEY(empno);

ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tbl_constraint3_empno F KEY(empno);

-- 제약조건 비활성화 / 활성화
ALTER TABLE 테이블명
ENABLE CONSTRAINT 제약조건명;

ALTER TABLE 테이블명
DISABLE CONSTRAINT 제약조건명;



-- 테이블과 그 테이블을 참조하는 포린키를 동시에 삭제
DROP TABLE 테이블명 CASCADE CONSTRAINT;
DROP TABLE 테이블명;    -- 복구 가능
DROP TABLE 테이블명 PURGE; -- 휴지통에 넣지 않고 완전 삭제

--【컬럼레벨의 형식】
--        컬럼명 데이터타입 CONSTRAINT constraint명
--	REFERENCES 참조테이블명 (참조컬럼명) 
--             [ON DELETE CASCADE | ON DELETE SET NULL]
deptno NUMBER(2) CONSTRAINT FK_EMP_DEPTNO 
REFERENCES dept(deptno) 
ON DELETE SET NULL; -- 30번 부서를 삭제할 때 emp테이블의 30번 사원들의 depteno의 값은 null로 설정된다.
ON DELETE CASCADE; -- 30번 부서를 삭제할 때 emp테이블의 30번 사원들도 같이 삭제된다.

DELETE FROM dept
WHERE deptno = 30;

-- 실습)
CREATE TABLE tbl_emp AS (SELECT * FROM emp);
CREATE TABLE tbl_dept AS (SELECT * FROM dept);

-- emp, dept 테이블의 제약조건을 확인
-- PK, FK 추가
-- FK + ON DELETE 옵션 추가
SELECT *
FROM user_constraints
WHERE table_name = UPPER('emp');
SELECT *
FROM user_constraints
WHERE table_name = UPPER('dept');

ALTER TABLE tbl_dept
ADD (CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno));

ALTER TABLE tbl_emp
ADD (CONSTRAINT pk_tblemp_empno PRIMARY KEY(empno));

ALTER TABLE tbl_emp
ADD (CONSTRAINT fk_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno) ON DELETE SET NULL);

DESC dept;
DESC emp;

SELECT *
FROM tbl_emp;
SELECT *
FROM tbl_dept;
DELETE FROM tbl_dept 
WHERE deptno=30;

ALTER TABLE tbl_emp
DROP CONSTRAINT fk_tblemp_deptno;


-- [조인(join)]

CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title      VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;

CREATE TABLE danga(
      b_id  VARCHAR2(10)  NOT NULL  -- PK , FK  // 식별 관계
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);

INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT;

SELECT *
FROM danga;

 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;
          
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   

-- JOIN 종류
-- 1) EQUL JOIN
-- 두 개 이상의 테이블에 관계되는 컬럼들의 값들이 일치하는 경우에 사용하는 가장 일반적인 join 형태임,
-- WHERE 절에 '='(등호)를 사용한다.
-- 흔히 primary key, foreign key 관계를 이용한다.
-- 오라클에서는 NATURAL JOIN이 EQUI JOIN과 동일하다.
-- 또는 USING 절을 사용하여 EQUI JOIN과 동일한 결과를 출력한다


-- [문제] 책ID, 책제목, 출판사(c_name), 단가 출력
-- 1)
SELECT book.b_id, book.title, book.c_name, danga.price
FROM book, danga
WHERE book.b_id = danga.b_id;

-- 2)
??

-- 3)
SELECT book.b_id, book.title, b.c_name, d.price
FROM book b JOING  danga d on b.b_id = d.b_id;

-- 4) USING 절 사용 - 객체명.칼럼명 X 또는 별칭명.컬렴명 X
SELECT b_id, title n_name, price
FROM book JOIN gdanga USING;

-- 5) 책ID, 책제목, 판매수량, 단가, 서점명, 판매근액 출력
--  ㄱ) 

SELECT b.b_id, title, p_su, price, g_name, p_su*price 판매금액
FROM book b, danga d, panmai p , gogaek g
WHERE b.b_id = d.b_id AND b.b_id = p.b_id AND p.g_id = g.g_id;

--  ㄴ) JOIN 사용

SELECT b.b_id, title, p_su, price, g_name, p_su*price 판매금액
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;

--  ㄷ) Using
SELECT b_id, title, p_su, price, g_name, p_su*price 판매금액
FROM book JOIN danga USING (b_id)
          JOIN panmai USING (b_id)
          JOIN gogaek USING (g_id);

SELECT *
FROM au_book;

-- 2) NON EQUL JOIN

-- 3) INNER JOIN : 둘 이상의 테이블에서 조인조건을 만족하는 행만 반환
SELECT d.deptno
FROM emp e, dept d
WHERE d.deptno = e.deptno;

-- 4) OUTER JOIN
-- LEFT OUTER JOIN
SELECT d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno(+);

SELECT d.deptno
FROM emp e LEFT JOIN dept d ON e.deptno = d.deptno;

-- RIGHT OUTER JOIN
SELECT d.deptno
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno;

SELECT d.deptno
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno;

-- FULL OUTER JOIN
SELECT d.deptno
FROM emp e FULL JOIN dept d ON e.deptno = d.deptno;

-- 5) SELF JOIN
-- deptno/empno/ename 조인하고 직속상사의 부서번호/사원번호/사원명
SELECT e1.deptno, e1.empno, e1.ename, e2.deptno, e1.mgr, e2.empno, e2.ename
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno;

-- 6) CROSS JOIN
SELECT d.deptno, dname, empno, ename
FROM emp e, dept d;

SELECT d.deptno, dname, empno, ename
FROM emp e CROSS JOIN dept d;

-- 7) ANTIJOIN
-- 서브쿼리에 NOT IN한 컬럼만 반환

-- 8) semijoin
-- 서브쿼리에 EXISTS하는 컬럼만 반환






