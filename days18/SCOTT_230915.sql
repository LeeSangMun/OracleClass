-- 1. PL/SQL의 패키지?
--     - 관계되는 타입, 프로그램 객체, 서브프로그램(procedure, function)을 논리적으로 묶어 놓은 것
-- 2. 패키지는
--     ㄱ. specification
--     ㄴ. body
-- 3. 오라클에서 기본적으로 제공하는 패키지가 있으며, 간단히 이를 이용하면 편리하다.
-- 4. specification 부분 : type, constant, variable, exception, cursor, subprogram이 선언된다. 
-- 5. body 부분 : cursor, subprogram 따위가 존재한다.
-- 6. 호출할 때 '패키지_이름.프로시저_이름' 형식의 참조를 이용해야 한다. 


-- 예)
-- 1. 명세 부분
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



















