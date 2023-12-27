-- sys -- 
SELECT *
FROM v$sga;
FROM v$instance;

SELECT tablespace_name, file_name 
FROM dba_data_files;

-- ������ �� ������
show parameter db_block_size;

-- ���� ����Ŭ ������ �����ϴ� ���̺����̽��� �̸��� ��ȸ�ϴ� SQL
SELECT name 
FROM v$tablespace;

-- dba_extents : extent ���� ������ ��ȸ�ϴ� SQL
SELECT owner, segment_name, extent_id, bytes, blocks
FROM dba_extents;

-- 1 extent = 8*block(8192) = 65536
SELECT 8192*8
FROM dual;

-- dba_XXX <- �����ڸ� ��밡��
SELECT *
FROM dba_users;
