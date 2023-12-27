SELECT COUNT(*) "총 게시글 수"
    , COUNT(*)/10 "총 페이지 수"
    , CEIL(COUNT(*)/10)
FROM tbl_cstvsboard;

SELECT *
FROM tbl_cstvsboard
ORDER BY seq DESC;

SELECT *
FROM(
    SELECT ROWNUM no, t.*
    FROM (
        SELECT seq, writer, email, title, readed, writedate
        FROM tbl_cstvsboard
        ORDER BY seq DESC
    ) t
) b
WHERE b.no BETWEEN ? AND ?; -- 1 페이지


CREATE TABLE SURVEY (
	SURVEY_ID NUMBER PRIMARY KEY NOT NULL 
	, USER_ID NVARCHAR2(20)
	, TITLE VARCHAR2(100) NOT NULL
	, SURVEY_CNT NUMBER(10) DEFAULT 0 
	, OPTION_cnt NUMBER(3) DEFAULT 0
	, START_DATE DATE DEFAULT SYSDATE NOT NULL
	, END_DATE DATE NOT NULL
	--, STATE VARCHAR(20) DEFAULT '일반'
	--, CONSTRAINT FK_SURVEY_USER_ID FOREIGN KEY(USER_ID) REFERENCES USER_INFO(user_id) ON DELETE SET NULL
	, REGDATE DATE DEFAULT SYSDATE
);

CREATE TABLE SURVEY_OPTION (
	op_seq NUMBER
	, SURVEY_ID NUMBER NOT NULL
	, OPTION_CONTENT VARCHAR2(20)
	, CONSTRAINT FK_OPTION_SURVEY_ID FOREIGN KEY(SURVEY_ID) REFERENCES SURVEY(SURVEY_ID) ON DELETE CASCADE
	, CONSTRAINT PK_survey_option_seq PRIMARY KEY(op_seq)
);

CREATE TABLE vote(
	vote_seq NUMBER
	, user_id NVARCHAR2(20)
	, SURVEY_ID NUMBER(4) NOT NULL 
	, OPTION_ID NUMBER NOT NULL     
	, FOREIGN KEY (OPTION_ID) REFERENCES SURVEY_OPTION(op_seq)
	, FOREIGN KEY (SURVEY_ID) REFERENCES SURVEY(SURVEY_ID)
	, CONSTRAINT vote_pk PRIMARY KEY(vote_seq)
);

DROP SEQUENCE op_seq;

CREATE SEQUENCE survey_seq
NOCACHE;
CREATE SEQUENCE vote_seq
NOCACHE;
CREATE SEQUENCE op_seq
NOCACHE;

SELECT * 
FROM survey;

SELECT *
FROM VOTE;

SELECT *
FROM survey_option;

DELETE FROM survey_option;

COMMIT;

SELECT COUNT(*)
FROM tbl_cstvsboard
WHERE writer = '홍길동';

SELECT *
FROM tbl_cstvsboard;

CREATE TABLE member (
   id VARCHAR2(30) NOT NULL, /* 새 컬럼 */
   passwd VARCHAR2(30), /* 새 컬럼2 */
   name VARCHAR2(30), /* 새 컬럼3 */
   registerdate DATE DEFAULT SYSDATE, /* 새 컬럼4 */
   email VARCHAR2(30) /* 새 컬럼5 */
);
ALTER TABLE member
   ADD
      CONSTRAINT PK_member
      PRIMARY KEY (
         id
      );

select *
FROM member;




1. 테이블 , 시퀀스 생성
    create table filetest(          
     num number not null primary key  
     , subject varchar2(50) not null     
     
     , filesystemname varchar2(100) -- 실제 저장되는 파일명       a1.txt
     , originalfilename varchar2(100) -- 저장할 때 파일명             a.txt
     , filelength number  -- 파일크기
    );
    
   create sequence seq_filetest;


select *
FROM filetest;

 -  ref, step, depth 컬럼 추가.
 CREATE SEQUENCE SEQ_REPLYBOARD;
 
 CREATE TABLE "SCOTT"."REPLYBOARD" 
   (   
    "NUM" NUMBER PRIMARY KEY NOT NULL ENABLE,     -- 글번호
   "WRITER" VARCHAR2(12 BYTE) NOT NULL ENABLE,  --작성자 
   "EMAIL" VARCHAR2(30 BYTE) NOT NULL ENABLE,   --이메일
   "SUBJECT" VARCHAR2(50 BYTE) NOT NULL ENABLE,  --제목
   "PASS" VARCHAR2(10 BYTE) NOT NULL ENABLE,  --비밀번호
   "READCOUNT" NUMBER(5,0) DEFAULT 0 NOT NULL ENABLE,  --조회수 
   "REGDATE" DATE DEFAULT sysdate NOT NULL ENABLE,   --작성일
   "CONTENT" CLOB NOT NULL ENABLE,  --글내용
   "IP" VARCHAR2(20 BYTE) NOT NULL ENABLE, --IP주소 
   
   "REF" NUMBER(5,0) DEFAULT 0 NOT NULL ENABLE,  --그룹 
   "STEP" NUMBER(3,0) DEFAULT 1 NOT NULL ENABLE,  --순번
   "DEPTH" NUMBER(3,0) DEFAULT 0 NOT NULL ENABLE  --깊이
   );
      

desc replyboard;


select rownum rnum, num,writer,email,subject,pass, regdate,readcount,ref,step,depth,content,ip 
				, case when ( sysdate - regdate ) < 0.041667  then  'true' else 'false' end  new 
				 from replyboard  order by ref desc, step asc



create table member
(
  memberid varchar2(50) primary key
  , name varchar2(50) not null
  , password varchar2(10) not null
  , regdate date not null 
);

create table article
(
  article_no number primary key
  , writer_id varchar2(50) not null
  , writer_name varchar2(50) not null
  , title varchar2(255) not null
  , regdate date not null
  , moddate date not null
  , read_cnt number
);
create sequence seq_article;

create table article_content
(
  article_no number primary key
  , content clob
  , constraint fk_article_content_article_no foreign key(article_no) references article(article_no)
);





