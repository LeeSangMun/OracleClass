select employee_id, first_name, last_name,
manager_id, department_id
from employees
where department_id NOT IN(
    select department_id 
    from departments
    where location_id = 1700
);

SELECT *
FROM tabs;

SELECT *
FROM locations
WHERE location_id = 1700;



select * 
from departments d
where EXISTS(
    select * 
    from employees e
    where d.department_id = e.department_id and e.salary > 2500
);

