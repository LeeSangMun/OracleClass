-- HR ������ �����ϰ� �ִ� ���̺� ���� ��ȸ
SELECT *
FROM tabs;

-- << HR�� ���̺� ���� >>

SELECT *
FROM employees;

DESC employees;

-- ��� ���� first_name, last_name, name(��ü�̸�) ��Ī������ ��ȸ
SELECT first_name, last_name
        , CONCAT(CONCAT(first_name, ' '), last_name) NAME
        , first_name || ' ' || last_name
FROM employees;

-- ����Ŭ '���ڿ�' // ���ڿ��� ''�� ���δ�.
-- '��¥����' // ��¥���ĵ� '' ����