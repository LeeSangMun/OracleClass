-- [문제] 책ID, 책제목, 단가, 판매수량, 서점(고객), 판매금액 조회

-- BOOK    : b_id, title, 
-- DANGA   : b_id, price
-- PANMAI  : b_id, p_su
-- GOGAEK  : g_name

SELECT b.b_id, title, price, p_su, g_name, price*p_su
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;
            
-- [문제] 출판된 책들이 각각 총 몇 권이 판매 되었는지 조회
SELECT b.b_id, title, price, SUM(p_su)
FROM book b JOIN panmai p ON b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
GROUP BY b.b_id, title, price
ORDER BY b.b_id;

-- [문제] 책 판매된 적이 있는 책ID, 제목 조회
-- [문제] 책 한 번도 판매된 적이 없는 책ID, 제목 조회
SELECT b_id, title
FROM book
WHERE b_id IN (
    SELECT b_id
    FROM panmai
    GROUP BY b_id
);

SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id IN (
    SELECT DISTINCT b_id
    FROM panmai
);

SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id NOT IN (
    SELECT b_id
    FROM panmai
    GROUP BY b_id
);


-- [문제] 출판된 책들이 각각 총 몇 권이 판매 되었는지 조회
-- + 판매된 적이 없는 책도 0으로

SELECT b.b_id, title, NVL(SUM(p_su), 0) "판매권수"
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, title
ORDER BY 판매권수 DESC;

-- [문제] 가장 판매권수가 많은 책에 대한 정보를 출력
-- (b_id, title, 총판매권수)

SELECT *
FROM(
    SELECT b.b_id, title, NVL(SUM(p_su), 0) "판매권수"
    FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
    GROUP BY b.b_id, title
    ORDER BY 판매권수 DESC
)
WHERE ROWNUM <= 3;

-- [문제] 년도별 월별 판매 현황 조회
-- (판매년도, 판매월, 판매금액(p_su * price))

SELECT TO_CHAR(p_date, 'YYYY') 판매년도, TO_CHAR(p_date, 'MM') 판매월, SUM(p_su*price) 판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
ORDER BY 판매년도, 판매월;


-- [문제] 년도별 서점별 판매 현황
-- 년도 / 서점ID / 서점명 / 총판매금액
SELECT TO_CHAR(p_date, 'YYYY') 판매년도, g.g_id, g_name, SUM(price*p_su)
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON p.g_id = g.g_id
GROUP BY TO_CHAR(p_date, 'YYYY'), g.g_id, g_name
ORDER BY 판매년도, g_name;

-- [문제] 올해 서점별 판매현황
-- 서점코드 / 서점명 / 판매금액합 / 비율(소수점 둘째반올림)
-- ??
SELECT g.g_id, g_name, SUM(price*p_su) 판매금액합
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON p.g_id = g.g_id
WHERE p_date LIKE TO_CHAR(SYSDATE, 'YY') || '%'
GROUP BY g.g_id, g_name;

-- [문제] 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
-- (책ID, 제목, 단가, 총판매권수, 총판매금액)
SELECT b.b_id, title, price, SUM(p_su) "총판매권수", SUM(price*p_su) "총판매금액"
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, title, price
HAVING SUM(price*p_su) >= 15000;

-- [문제] 책의 총판매권수가 10권 이상 팔린 책의 정보를 조회
-- (책ID, 제목, 가격, 총판매량)
SELECT b.b_id, title, price, SUM(p_su)
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, title, price
HAVING SUM(p_su) >= 10;


-- [뷰(view)]
-- 1) 가상테이블 : 한개 이상의 기본 테이블이나 다른 뷰를 이용하여 생성되는 가상 테이블
-- 2) 전체 데이터 중에서 일부만 접근할 수 있도록 제한하기 위한 기법
-- 3) 뷰는 데이터 사전 테이블에 뷰에 대한 정의만

SELECT *
FROM user_sys_privs;

-- 뷰 생성
-- 

SELECT b.b_id, title, price, p_su, g_name, price, p_su
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;

CREATE OR REPLACE VIEW  panView
AS (
    SELECT b.b_id, title, price, g.g_id, g_name, p_date, p_su
        , p_su*price amt
    FROM book b JOIN danga d ON b.b_id = d.b_id
                JOIN panmai p ON b.b_id = p.b_id
                JOIN gogaek g ON p.g_id = g.g_id
    ORDER BY p_date
);

SELECT *
FROM panview;

-- 편리성, 보안선 (장점)

-- 뷰 소스 확인 : DB 객체, 쿼리 저장
SELECT text
FROM user_views;

-- 뷰 수정 CREATE OR REPLACE VIEW 실행
-- 뷰 삭제
DROP VIEW panview;

-- [문제] 년도, 월, 고객코드, 고객명, 판매금액합(년도별 월)
--      (년도, 월 오름차순) // 뷰로 작성
CREATE OR REPLACE VIEW gogaekView
AS(
    SELECT TO_CHAR(p_date, 'YYYY') 판매년도, TO_CHAR(p_date, 'MM') 판매월, g.g_id, g_name, SUM(p_su*price) 총판매금액
    FROM panmai p JOIN danga d ON p.b_id = d.b_id
                  JOIN gogaek g ON g.g_id = p.g_id
    GROUP BY TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name
    
);

SELECT * 
FROM gogaekview;

SELECT *
FROM tab
WHERE tabtype = 'VIEW';

CREATE TABLE testa (
    aid NUMBER PRIMARY KEY
    , name VARCHAR2(20) NOT NULL
    , tel VARCHAR2(20) NOT NULL
    , memo VARCHAR2(100)
);

CREATE TABLE testb (
    bid NUMBER PRIMARY KEY
    , aid NUMBER CONSTRAINT fk_testb_aid REFERENCES testa(aid) ON DELETE CASCADE
    , score NUMBER(3)
);

INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');

INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

COMMIT;

SELECT * FROM testa;
SELECT * FROM testb;

DESC testa;

CREATE OR REPLACE VIEW aView AS(
    SELECT aid, name, memo
    FROM testa
);

-- [단순뷰를 사용해 INSERT]
INSERT INTO aView(aid, name, memo) VALUES (5, 'f', '5'); -- tell이 NOT NULL 이라 오류

CREATE OR REPLACE VIEW aView AS(
    SELECT aid, name, tel
    FROM testa
);

INSERT INTO aView(aid, name, tel) VALUES (5, 'f', '5'); -- tell이 NOT NULL
DELETE FROM aView
WHERE aid = 5;

DROP VIEW aView;

CREATE OR REPLACE VIEW abView
AS (
    SELECT a.aid, name, tel
    , bid, score
    FROM testa a JOIN testb b ON a.aid = b.aid
);
INSERT INTO abVIEW(aid, name, tel, bid, score)
VALUES(10, 'x', 55, 20, 70);

INSERT INTO abView(aid, name, tel) 
VALUES(5, 'f', '5);

UPDATE aView
SET score = 99
WHERE bid = 1;

SELECT * FROM testa;
SELECT * FROM testb;
--[- DELETE VASVADE ]


-- 점수가 90점 이상인 뷰 생성
CREATE OR REPLCE VIEW bView
AS(
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90
);

UPDATE bView 
ST score = 70
WHERE bid = 3;


SELECT *
FROM bView;

ROLLBACK;

CREATE OR REPLCE VIEW bView
AS(
    SELECT bid, aid, score
    FROM testb
    WHERE score >= 90
    WITH CHECK OPTION 
);

DROP VIEW ABVIEW;

-- MATERIALIZED VIEw(물리적 뷰)
-- 실제 데이터를 가지고 있는 뷰

-- [계층적 질의]
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 31;

-- 7698의 직속부하직원들
SELECT empno, ename, sal, LEVEL
FROM emp
WHERE mgr = 7698
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr; -- top-down 출력 형식

create table tbl_test(
    deptno number(3) not null primary key,
    dname varchar2(24) not null,
    college number(3),
    loc varchar2(10)
);

DROP TABLE tbl_test;

INSERT INTO tbl_test VALUES        ( 101,  '컴퓨터공학과', 100,  '1호관');
INSERT INTO tbl_test VALUES        (102,  '멀티미디어학과', 100,  '2호관');
INSERT INTO tbl_test VALUES        (201,  '전자공학과 ',   200,  '3호관');
INSERT INTO tbl_test VALUES        (202,  '기계공학과',    200,  '4호관');
INSERT INTO tbl_test VALUES        (100,  '정보미디어학부', 10 , null );
INSERT INTO tbl_test VALUES        (200,  '메카트로닉스학부',10 , null);
INSERT INTO tbl_test VALUES        (10,  '공과대학',null , null);
COMMIT;

SELECT *
FROM tbl_test;

SELECT deptno, dname, college, LEVEL
FROM tbl_test
START WITH deptno = 10
CONNECT BY PRIOR deptno = college;

SELECT LPAD(' ', (LEVEL-1)*3) || 'ㄴ' ||  dname
FROM tbl_test
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;

-- 계층구조에서 가지 제거
SELECT deptno,college,dname,loc,LEVEL
FROM tbl_test
WHERE dname != '정보미디어학부'
START WITH college IS NULL
CONNECT BY PRIOR deptno=college;

SELECT deptno,college,dname,loc,LEVEL
FROM tbl_test
START WITH college IS NULL
CONNECT BY PRIOR deptno=college
AND dname != '정보미디어학부';


1. START WITH 최상위조건 : 계층형 구조에서 최상위 계층의 행을 식별하는 조건
2. CONNECT BY 조건 : 계층형 구조가 어떤 식으로 연결되는지를 기술하는 구문.
   PRIOR : 계층형 쿼리에서만 사용할 수 있는 연산자, '앞서의, 직전의'
   
   SELECT e.empno
            , LPAD(' ', 4*(LEVEL-1)) || ename
            , SYS_CONNECT_BY_PATH(ename, '\')
   FROM emp e, dept d
   WHERE e.deptno = d.deptno
   START WITH e.mgr IS NULL
   CONNECT BY PRIOR e.empno = e.mgr
   ORDER SIBLINGS BY ename;
   
3. ORDER SIBLINGS BY : 부서명으로 정렬됨과 동시에 계층형 구조까지 보존
4. CONNECT_BY_ROOT : 계층형 ㅋ쿸커리에서 최상위 로우를 반환하는 연산자.
5. CONNECT_BY_ISLEAF : CONNECT BY 조건에 정의된 관계에 따라 
   해당 행이 최하위 자식행이면 1, 그렇지 안으면 0 을 반환하는 의사컬럼
6. SYS_CONNECT_BY_PATH(column, char)  : 루트 노드에서 시작해서 자신의 행까지 
   연결된 경로 정보를 반환하는 함수.
7. CONNECT_BY_ISCYCLE : 오라클의 계층형 쿼리는 루프(반복) 알고리즘을 사용한다. 
  그래서, 부모-자식 관계 잘못 정의하면 무한루프를 타고 오류 발생한다.   
  이때는 루프가 발생하는 원인을 찾아 잘못된 데이터를 수정해야 하는 데, 
  이를 위해서는 
    먼저  CONNECT BY절에 NOCYCLE 추가
    SELECT 절에 CONNECT_BY_ISCYCLE 의사 컬럼을 사용해 찾을 수 있다. 
  즉, 현재 로우가 자식을 갖고 있는 데 동시에 그 자식 로우가 부모로우 이면 1,
     그렇지 않으면 0 반환.
     
-- 1) 7566 JONES의 mgr을 7839에서 7369로  수정
UPDATE emp
SET mgr = 7369
WHERE empno = 7566;
-- 2)
SELECT  deptno, empno, LPAD(' ', 3*(LEVEL-1)) ||  ename
, LEVEL
, SYS_CONNECT_BY_PATH(ename, '/')
FROM emp   
START WITH  mgr IS NULL
CONNECT BY PRIOR  empno =  mgr   ;
-- 3)
ROLLBACK;
-- 4)
SELECT  deptno, empno, LPAD(' ', 3*(LEVEL-1)) ||  ename
, LEVEL
, SYS_CONNECT_BY_PATH(ename, '/')
, CONNECT_BY_ISCYCLE IsLoop
FROM emp   
START WITH  mgr IS NULL
CONNECT BY NOCYCLE PRIOR  empno =  mgr;








