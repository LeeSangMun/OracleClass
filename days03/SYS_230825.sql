SELECT *
FROM all_users
WHERE username = UPPER('hr'); -- �빮�ڷ� ��ȯ
-- WHERE username = 'HR';

-- (1) ����Ŭ ����� Ȯ�� - date ����� Ȯ��
SELECT *
FROM DICTIONARY
WHERE table_name LIKE '%WORDS%';

SELECT *
FROM V_$RESERVED_WORDS
WHERE keyword = 'DATE';

-- ��Ű��.��ü�� -> ���� �ó��
SELECT *
FROM scott.emp;

SELECT *
FROM dba_tables -- 
--FROM user_tables; -- ���� �����(user)�� ������ ���̺� ������ ��ȸ
--FROM all_tables; -- ���� ����� ������ ���̺� + ���� �ο��� ���̺� ������ ��ȸ
where TABLE_NAME='DUAL';


CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

SELECT *
FROM arirang;

GRANT SELECT ON arirang TO hr;

DROP PUBLIC SYNONYM arirang;

SELECT *
--FROM all_synonyms;
FROM user_synonyms;
