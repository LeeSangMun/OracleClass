-- 1. PL/SQL�� ��Ű��?
--     - ����Ǵ� Ÿ��, ���α׷� ��ü, �������α׷�(procedure, function)�� �������� ���� ���� ��
-- 2. ��Ű����
--     ��. specification
--     ��. body
-- 3. ����Ŭ���� �⺻������ �����ϴ� ��Ű���� ������, ������ �̸� �̿��ϸ� ���ϴ�.
-- 4. specification �κ� : type, constant, variable, exception, cursor, subprogram�� ����ȴ�. 
-- 5. body �κ� : cursor, subprogram ������ �����Ѵ�.
-- 6. ȣ���� �� '��Ű��_�̸�.���ν���_�̸�' ������ ������ �̿��ؾ� �Ѵ�. 


-- ��)
-- 1. �� �κ�
CREATE OR REPLACE PACKAGE employee_pkg 
AS
    procedure print_ename(p_empno number); 
    procedure print_sal(p_empno number); 
END employee_pkg; 

CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS
    PROCEDURE print_ename
    (
        p_empno number
    ) 
    IS 
        l_ename emp.ename%type; 
    BEGIN 
        select ename 
        into l_ename 
        from emp 
        where empno = p_empno; 
        dbms_output.put_line(l_ename); 
    EXCEPTION 
        when NO_DATA_FOUND then 
        dbms_output.put_line('Invalid employee number'); 
    END print_ename; 
    
    PROCEDURE print_sal
    (
    p_empno number
    )
    IS 
        l_sal emp.sal%type; 
    BEGIN 
        select sal 
        into l_sal 
        from emp 
        where empno = p_empno; 
        dbms_output.put_line(l_sal); 
    EXCEPTION  
        when NO_DATA_FOUND then 
        dbms_output.put_line('Invalid employee number'); 
    END print_sal; 
END employee_pkg; 

EXECUTE employee_pkg.print_ename(7782); 



















