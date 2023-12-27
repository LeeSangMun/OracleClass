select last_name "employee", CONNECT_BY_ISCYCLE "Cycle",
    LEVEL, SYS_CONNECT_BY_PATH(last_name, '/') "Path"
from employees
where LEVEL <=3 and department_id = 80
START WITH last_name ='King'
CONNECT BY NOCYCLE PRIOR employee_id = manager_id and LEVEL <= 4
ORDER BY "employee", "Cycle", LEVEL, "Path";
