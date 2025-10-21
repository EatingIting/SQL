--문제 1.
--EMPLOYEES, DEPARTMENTS 테이블을 엘리어스를 이용해서 조인해보세요.
--조건) 각각 INNER, LEFT, RIGHT 조인 해보세요.
SELECT * 
    FROM EMPLOYEES E, DEPARTMENTS D
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT *
    FROM EMPLOYEES E, DEPARTMENTS D
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+);
    
SELECT *
    FROM EMPLOYEES E, DEPARTMENTS D
    WHERE E.DEPARTMENT_ID(+) = D.DEPARTMENT_ID;

--문제 2.
--EMPLOYEES, DEPARTMENTS 테이블을 INNER JOIN하세요.
--조건)employee_id가 200인 사람의 이름, department_id를 출력하세요
--조건)이름 컬럼은 first_name과 last_name을 합쳐서 출력합니다
SELECT CONCAT(FIRST_NAME,CONCAT(' ',LAST_NAME)) AS 이름, E.DEPARTMENT_ID AS 부서번호
    FROM EMPLOYEES E, DEPARTMENTS D
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID AND EMPLOYEE_ID = 200;

--문제 3.
--EMPLOYEES, JOBS테이블을 INNER JOIN하세요
--조건) 모든 사원의 이름과 직무아이디, 직무 타이틀을 출력하고, 이름 기준으로 오름차순 정렬
--HINT) 어떤 컬럼으로 서로 연결되 있는지 확인
SELECT CONCAT(FIRST_NAME,CONCAT(' ',LAST_NAME)) AS "NAME",
       J.JOB_ID 직무아이디,
       JOB_TITLE 타이틀
    FROM EMPLOYEES E, JOBS J
    WHERE E.JOB_ID = J.JOB_ID
    ORDER BY "NAME";

--문제 4.
--JOBS테이블과 JOB_HISTORY테이블을 조인하세요.
--조건) JOB_HISTORY테이블에 알맞는 부서명도 출력하세요.
--힌트) 조인 2번
SELECT DEPARTMENTS.DEPARTMENT_NAME 부서명
    FROM JOBS, JOB_HISTORY,DEPARTMENTS
    WHERE JOBS.JOB_ID = JOB_HISTORY.JOB_ID(+) AND JOB_HISTORY.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID(+);

--문제 5.
--Steven King의 부서명을 출력하세요.
SELECT CONCAT(FIRST_NAME,CONCAT(' ',LAST_NAME)) AS 이름, DEPARTMENT_NAME AS 부서명
    FROM EMPLOYEES E, DEPARTMENTS D
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID AND UPPER(CONCAT(FIRST_NAME,CONCAT(' ',LAST_NAME))) = 'STEVEN KING';


--문제 6.
--EMPLOYEES 테이블과 DEPARTMENTS 테이블을 Cartesian Product(Cross join)처리하세요
SELECT *
    FROM EMPLOYEES, DEPARTMENTS;

-------------------------------------------------------------------------------------
--문제 7.
--EMPLOYEES 테이블과 DEPARTMENTS 테이블의 부서번호를 조인하고 SA_MAN 사원만의 사원번호, 이름, 
--급여, 부서명, 근무지를 출력하세요. (Alias를 사용)
SELECT E.EMPLOYEE_ID AS 사원번호, 
       E.FIRST_NAME || ' ' || LAST_NAME AS 이름,
       E.SALARY 급여,
       D.DEPARTMENT_NAME 부서명,
       L.STREET_ADDRESS 근무지
    FROM EMPLOYEES E
    LEFT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
    WHERE JOB_ID = 'SA_MAN';

--문제 8.
--employees, jobs 테이블을 조인 지정하고 job_title이 'Stock Manager', 'Stock Clerk'인 직원 정보만
--출력하세요.
SELECT EMPLOYEE_ID,
       FIRST_NAME,
       JOB_TITLE
    FROM EMPLOYEES E, JOBS J
    WHERE E.JOB_ID = J.JOB_ID AND JOB_TITLE IN('Stock Manager', 'Stock Clerk');


--문제 9.
--departments 테이블에서 직원이 없는 부서를 찾아 출력하세요.
SELECT D.DEPARTMENT_NAME 부서
    FROM DEPARTMENTS D
    LEFT JOIN EMPLOYEES E
    USING(DEPARTMENT_ID)
    WHERE D.MANAGER_ID IS NULL;
    
---------------------------------------------------------------
--문제 10. 
--join을 이용해서 사원의 이름과 그 사원의 매니저 이름을 출력하세요
--힌트) EMPLOYEES 테이블과 EMPLOYEES 테이블을 조인하세요.    
SELECT E.FIRST_NAME AS 사원명,
       E2.FIRST_NAME AS 매니저명
    FROM EMPLOYEES E
    LEFT JOIN EMPLOYEES E2
    ON E.MANAGER_ID = E2.EMPLOYEE_ID;


--문제 11. 
--EMPLOYEES 테이블에서 left join하여 (사원, 매니저)의 이름, 매니저의 급여 까지 출력하세요
--조건) 매니저 아이디가 없는 사람은 배제하고 급여는 역순으로 출력하세요

SELECT CONCAT(E1.FIRST_NAME,CONCAT(' ',E1.LAST_NAME)) AS 사원이름,
       E1.SALARY 사원급여,
       CONCAT(E2.FIRST_NAME,CONCAT(' ',E2.LAST_NAME)) AS 매니저이름,
       E2.SALARY 매니저급여
    FROM EMPLOYEES E1
    LEFT JOIN EMPLOYEES E2
    ON E1.MANAGER_ID = E2.EMPLOYEE_ID
    WHERE E1.MANAGER_ID IS NOT NULL
    ORDER BY 매니저급여 DESC;