-- 방명록
CREATE TABLE guestmessage (
    id NUMBER(8) PRIMARY KEY
    , name VARCHAR2(100)
    , message CLOB
    , creationTime DATE 
);

CREATE SEQUENCE seq_guestmessage;

SELECT sysdate
FROM dual;

SELECT *
FROM dept;

CREATE TABLE tbl_board
    (
      bno number(10)
      , title varchar2(200) not null
      , content varchar2(2000) not null
      , writer varchar2(50) not null
      , regdate date default sysdate
      , updatedate date default sysdate
    );
    
    alter table tbl_board add constraint pk_tblboard_bno primary key(bno);
    
     CREATE SEQUENCE seq_board;
     
SELECT *
       FROM tbl_board
       WHERE bno > 0
       ORDER BY bno DESC;
       
SELECT bno, title, content, writer, regdate, updatedate
      FROM (
               SELECT /*+INDEX_DESC(tbl_board pk_tblboard_bno )*/
                      rownum rn, bno, title, content, writer, regdate, updatedate
               FROM tbl_board 
               WHERE rownum <= #{ pageNum} * #{ amount }
            )
      WHERE rn > (#{ pageNum } - 1) * #{ amount };
      

CREATE TABLE NOTICES
(
	"SEQ" VARCHAR2(10 BYTE), -- 글번호
	"TITLE" VARCHAR2(200 BYTE), -- 제목
	"WRITER" VARCHAR2(50 BYTE), -- 
	"CONTENT" VARCHAR2(4000 BYTE), 
	"REGDATE" TIMESTAMP (6), 
	"HIT" NUMBER, 
	"FILESRC" VARCHAR2(500 BYTE)
);
SELECT NVL(MAX(TO_NUMBER(SEQ))+1, 1) FROM NOTICES;
DROP TABLE "MEMBER";

CREATE TABLE "MEMBER"
(	
    "ID" VARCHAR2(50 BYTE), 
    "PWD" VARCHAR2(100 BYTE), 
    "NAME" VARCHAR2(50 BYTE), 
    "GENDER" VARCHAR2(10 BYTE), 
    "BIRTH" VARCHAR2(10 BYTE), 
    "IS_LUNAR" VARCHAR2(10 BYTE), 
    "CPHONE" VARCHAR2(15 BYTE), 
    "EMAIL" VARCHAR2(200 BYTE), 
    "HABIT" VARCHAR2(200 BYTE), 
    "REGDATE" DATE
);


INSERT INTO NOTICES
(SEQ, TITLE, CONTENT, WRITER, REGDATE, HIT, FILESRC) 
VALUES( (SELECT NVL(MAX(TO_NUMBER(SEQ))+1, 1) FROM NOTICES)
    , '첫 번째 게시글', '테스트', 'mun', SYSDATE, 0, null);
commit;

SELECT *
FROM notices;

SELECT *
FROM member;

DESC notices;
DESC member;

ALTER TABLE member
ADD (point number(10) default(0));

ALTER TABLE notices
ADD CONSTRAINT ck_notices_title UNIQUE(title);

ALTER TABLE member
ADD CONSTRAINT ck_notices_point CHECK (point < 3);

SELECT *
FROM user_constraints
WHERE table_name = 'NOTICES';

ALTER TABLE member
DROP CONSTRAINT ck_notices_point;

ALTER TABLE notices
DROP CONSTRAINT ck_notices_title;


DELETE FROM member;


UPDATE member 
SET point = 1
WHERE id='mun';

COMMIT;

SELECT *
FROM dept;

SELECT *
FROM emp;


CREATE TABLE tbl_reply (
    rno NUMBER(10) -- 댓글번호
    , bno NUMBER(10) NOT NULL -- 게시글번호
    , reply VARCHAR2(1000) NOT NULL
    , replyer VARCHAR2(50) NOT NULL
    , replyDate DATE DEFAULT SYSDATE
    , updateDate DATE DEFAULT SYSDATE
);

CREATE SEQUENCE seq_reply;

ALTER TABLE tbl_reply
ADD CONSTRAINT pk_reply_rno PRIMARY KEY(rno);

ALTER TABLE tbl_reply
ADD CONSTRAINT fk_reply_bno FOREIGN KEY(bno) REFERENCES tbl_board(bno);

DESC tbl_board;

SELECT *
FROM tbl_reply;

SELECT *
FROM tbl_board;

SELECT *
FROM member;

ALTER TABLE member
ADD(enabled char(1) default '1');

ALTER TABLE member
ADD CONSTRAINT pk_member_id PRIMARY KEY(id);

CREATE TABLE member_authorities(
   username     varchar2(50) not null      
  , authority    varchar2(50) not null 
  , constraint fk_member_authorities_username 
               FOREIGN KEY(username) 
               REFERENCES member(id)
);

DESC member;

INSERT INTO member_authorities VALUES ( 'admin' , 'ROLE_MANAGER' );
INSERT INTO member_authorities VALUES ( 'admin' , 'ROLE_ADMIN' );
INSERT INTO member_authorities VALUES ( 'admin' , 'ROLE_USER' );
      
INSERT INTO member_authorities VALUES ( 'mun' , 'ROLE_MANAGER' );
INSERT INTO member_authorities VALUES ( 'mun' , 'ROLE_USER' );
      
INSERT INTO member_authorities VALUES ( 'hong' , 'ROLE_USER' );
COMMIT;

SELECT *
FROM member_authorities;

DESC member_authorities;

SELECT id, pwd, name, enabled, regdate, authority
FROM member m LEFT JOIN member_authorities auth ON m.id = auth.username
WHERE m.id = 'admin';
