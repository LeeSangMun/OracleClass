-- sys -- 
SELECT *
FROM v$sga;
FROM v$instance;

SELECT tablespace_name, file_name 
FROM dba_data_files;

-- 데이터 블럭 사이즈
show parameter db_block_size;

-- 현재 오라클 서버에 존재하는 테이블스페이스의 이름을 조회하는 SQL
SELECT name 
FROM v$tablespace;

-- dba_extents : extent 설정 정보를 조회하는 SQL
SELECT owner, segment_name, extent_id, bytes, blocks
FROM dba_extents;

-- 1 extent = 8*block(8192) = 65536
SELECT 8192*8
FROM dual;

-- dba_XXX <- 관리자만 사용가능
SELECT *
FROM dba_users;
