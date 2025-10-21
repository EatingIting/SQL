--6강 서브쿼리 연습문제
--문제 1.
--1) EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 데이터를 출력 하세요 ( AVG(컬럼) 사용)
SELECT FIRST_NAME || ' ' || LAST_NAME 이름,
       SALARY 급여
FROM EMPLOYEES
WHERE SALARY >= (SELECT AVG(SALARY)
                FROM EMPLOYEES);
--2) EMPLOYEES 테이블에서 모든 사원들의 평균급여보다 높은 사원들을 수를 출력하세요
SELECT 
    COUNT(*) AS 사원수
FROM 
    EMPLOYEES
WHERE
    SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEES);
--3) EMPLOYEES 테이블에서 job_id가 IT_PROG인 사원들의 평균급여보다 높은 사원들을 데이터를 출력하세요.
SELECT 
    FIRST_NAME || ' ' || LAST_NAME 이름,
    SALARY 급여,
    JOB_ID 직무
FROM
    EMPLOYEES
WHERE
    SALARY >= (SELECT AVG(SALARY) 평균급여
              FROM EMPLOYEES
              WHERE JOB_ID = 'IT_PROG');
                


--문제 2.
--DEPARTMENTS테이블에서 manager_id가 100인 사람의 department_id(부서아이디) 와
--EMPLOYEES테이블에서 department_id(부서아이디) 가 일치하는 모든 사원의 정보를 검색하세요.
SELECT 
    FIRST_NAME || ' ' || LAST_NAME 이름,
    DEPARTMENT_ID 부서번호
FROM
    EMPLOYEES
WHERE 
    DEPARTMENT_ID = (SELECT MANAGER_ID
                     FROM DEPARTMENTS
                     WHERE MANAGER_ID = 100);


--문제 3.
--EMPLOYEES테이블에서 “Pat”의 manager_id보다 높은 manager_id를 갖는 모든 사원의 데이터를 출력하세요
SELECT 
    FIRST_NAME || ' ' || LAST_NAME 이름,
    MANAGER_ID "매니저 아이디"
FROM
    EMPLOYEES
WHERE MANAGER_ID > (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Pat');
--EMPLOYEES테이블에서 “James”(2명)들의 manager_id와 같은 모든 사원의 데이터를 출력하세요.
SELECT 
    FIRST_NAME || ' ' || LAST_NAME 이름,
    MANAGER_ID "매니저 아이디"
FROM
    EMPLOYEES
WHERE 
    MANAGER_ID IN (SELECT MANAGER_ID FROM EMPLOYEES WHERE FIRST_NAME = 'James');
--Steven과 동일한 부서에 있는 사람들을 출력해주세요.
SELECT 
    FIRST_NAME || ' ' || LAST_NAME 이름,
    DEPARTMENT_ID 부서
FROM
    EMPLOYEES
WHERE
    DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');
--Steven의 급여보다 많은 급여를 받는 사람들은 출력하세요.
SELECT 
    FIRST_NAME || ' ' || LAST_NAME 이름,
    SALARY 급여
FROM
    EMPLOYEES
WHERE
    SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME = 'Steven');
--
--문제 4.
--EMPLOYEES테이블 DEPARTMENTS테이블을 left 조인하세요
--조건) 직원아이디, 이름(성, 이름), 부서아이디, 부서명 만 출력합니다.
--조건) 직원아이디 기준 오름차순 정렬
SELECT 
    EMPLOYEE_ID 직원아이디,
    CONCAT(FIRST_NAME,CONCAT(' ', LAST_NAME)) 이름,
    D.DEPARTMENT_ID 부서아이디,
    D.DEPARTMENT_NAME 부서명
FROM
    EMPLOYEES E
LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 직원아이디;


--문제 5.
--문제 4의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT EMPLOYEE_ID 직원아이디,
    CONCAT(FIRST_NAME,CONCAT(' ', LAST_NAME)) 이름,
    DEPARTMENT_ID 부서아이디,
    (SELECT 
        DEPARTMENT_NAME
    FROM
        DEPARTMENTS D
    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID) AS 부서명
    FROM EMPLOYEES E
    ORDER BY 직원아이디;
--문제 6.
--DEPARTMENTS테이블 LOCATIONS테이블을 left 조인하세요
--조건) 부서아이디, 부서이름, 주소(STREET_ADDRESS), 시티(CITY) 만 출력합니다
--조건) 부서아이디 기준 오름차순 정렬
SELECT 
    D.DEPARTMENT_ID "부서 아이디",
    D.DEPARTMENT_NAME "부서이름",
    L.STREET_ADDRESS "주소",
    L.CITY "시티"
FROM
    DEPARTMENTS D
LEFT JOIN LOCATIONS L
USING(LOCATION_ID)
ORDER BY "부서 아이디";


--문제 7.
--문제 6의 결과를 (스칼라 쿼리)로 동일하게 조회하세요
SELECT 
    DEPARTMENT_ID "부서 아이디",
    DEPARTMENT_NAME "부서이름",
    (SELECT STREET_ADDRESS FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) 주소,
    (SELECT CITY FROM LOCATIONS L WHERE D.LOCATION_ID = L.LOCATION_ID) 시티
FROM DEPARTMENTS D
ORDER BY "부서 아이디";

--문제 8.
--LOCATIONS테이블 COUNTRIES테이블을 스칼라 쿼리로 조회하세요.
--조건) 로케이션아이디, 주소, 시티, country_id, country_name 만 출력합니다
--조건) country_name기준 오름차순 정렬
SELECT
    LOCATION_ID "로케이션 아이디",
    STREET_ADDRESS 주소 ,
    CITY 시티,
    COUNTRY_ID 국가코드,
    (SELECT COUNTRY_NAME FROM COUNTRIES C WHERE L.COUNTRY_ID = C.COUNTRY_ID) 나라이름
FROM LOCATIONS L
ORDER BY 나라이름;


--------------------------------------------------------------------------------------------------
--문제 9.
--EMPLOYEES테이블 에서 first_name기준으로 내림차순 정렬하고, 41~50번째 데이터의 행 번호, 이름을 출력하세요
SELECT *
FROM (
    SELECT ROWNUM ROW_NUMBER,
           A.FIRST_NAME 이름
    FROM (
         SELECT *
            FROM EMPLOYEES
            ORDER BY FIRST_NAME DESC
    ) A
)
WHERE ROW_NUMBER BETWEEN 41 AND 50;
--
--문제 11.
--COMMITSSION을 적용한 급여를 새로운 컬럼으로 만들고, 이 데이터에서 10000보다 큰 사람들을 뽑아 보세요. (인라인뷰를 쓰면 됩니다)
SELECT *
FROM (
    SELECT FIRST_NAME || ' ' || LAST_NAME 이름,
           NVL2(COMMISSION_PCT, SALARY + SALARY * 12, SALARY) 급여
    FROM EMPLOYEES
)
WHERE 
    급여 >= 10000;


--문제 12.
--조인의 최적화
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS NAME,
       D.DEPARTMENT_ID
FROM EMPLOYEES E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE EMPLOYEE_ID = 200;
--
--이론적으로 위 구문의 실행방식은 EMPLOYEES - DEPARTMENTS 테이블을 먼저 조인하고, 후에 WHERE조건을 실행하게 됩니다.
--항상 이런것은 아닙니다. (이것은 데이터베이스 검색엔진(옵티마이저)에 의해 바뀔 수도 있습니다)
--그렇다면 200에 대한 인라인 뷰를 작성하고 JOIN을 붙이는 것도 가능하지 않을까요?

--=> 직원아이디가 200인 데이터를 인라인뷰로 조회한 후에 JOIN을 붙여보세요.
SELECT 
    CONCAT(E.FIRST_NAME, CONCAT(' ',E.LAST_NAME)) AS NAME,
    D.DEPARTMENT_ID
FROM (
    SELECT
            FIRST_NAME,
            LAST_NAME,
            DEPARTMENT_ID
        FROM
            EMPLOYEES
        WHERE
            EMPLOYEE_ID = 200
    ) E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-------------------------------------------------------------------------------------------------
--문제13
--EMPLOYEES테이블, DEPARTMENTS 테이블을 left조인하여, 입사일 오름차순 기준으로 10-20번째 데이터만 출력합니다.
--조건) rownum을 적용하여 번호, 직원아이디, 이름, 입사일, 부서이름 을 출력합니다.
--조건) hire_date를 기준으로 오름차순 정렬 되어야 합니다. rownum이 망가지면 안되요.
SELECT 
    *
FROM (
    SELECT
        ROWNUM AS 번호,
        A.*
    FROM (
        SELECT
            E.EMPLOYEE_ID 직원아이디,
            E.FIRST_NAME || ' ' || LAST_NAME 이름,
            E.HIRE_DATE 입사일,
            D.DEPARTMENT_NAME 부서이름
        FROM
            EMPLOYEES E
        LEFT JOIN
            DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
        ORDER BY
            E.HIRE_DATE ASC
    ) A
)
WHERE
    번호 BETWEEN 11 AND 20;

--문제14
--SA_MAN 사원의 급여 내림차순 기준으로 ROWNUM을 붙여주세요.
--조건) SA_MAN 사원들의 ROWNUM, 이름, 급여, 부서아이디, 부서명을 출력하세요.
SELECT 
    *
FROM(
    SELECT 
       ROWNUM RN,
       A.*
    FROM (
       SELECT
         E.FIRST_NAME || ' ' || E.LAST_NAME 이름,
         E.SALARY 급여,
         E.DEPARTMENT_ID 부서번호,
         D.DEPARTMENT_NAME 부서이름,
         E.JOB_ID 직책
        FROM 
            EMPLOYEES E
        JOIN 
            DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
        WHERE JOB_ID = 'SA_MAN'
        ORDER BY 급여
    ) A
);


--문제15
--DEPARTMENTS테이블에서 각 부서의 부서명, 매니저아이디, 부서에 속한 인원수 를 출력하세요.
--조건) 인원수 기준 내림차순 정렬하세요.
--조건) 사람이 없는 부서는 출력하지 않습니다.
--힌트) 부서의 인원수 먼저 구한다. 이 테이블을 조인한다.
SELECT
    D.DEPARTMENT_NAME 부서명,
    D.MANAGER_ID "매니저 아이디",
    COUNT(E.EMPLOYEE_ID) 인원수
FROM
    DEPARTMENTS D
JOIN
    EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY
    D.DEPARTMENT_NAME, D.MANAGER_ID
ORDER BY
    "인원수" DESC;