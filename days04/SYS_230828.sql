CREATE PUBLIC SYNONYM sdept
FOR scott.dept;

GRANT SELECT ON sdept TO hr;

DROP PUBLIC SYNONYM sdept;