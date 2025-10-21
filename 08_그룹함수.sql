-- 그룹함수
-- AVG, SUM, MAX, MIN, COUNT(*) COUNT(컬럼)

SELECT SUM(SALARY) AS 합계,
       AVG(SALARY) AS 평균,
       MAX(SALARY) AS 최대값,
       MIN(SALARY) AS 최솟값,
       COUNT(SALARY) AS 갯수 --35행
FROM EMPLOYEES WHERE JOB_ID LIKE 'SA%';

-- MIN, MAX는 날짜타입, 문자에도 적용될 수 있다.
SELECT MIN(HIRE_DATE) AS "가장 오래 일한 사람의 입사일", MAX(HIRE_DATE) AS "가장 적게 일한 사람의 입사일" FROM EMPLOYEES;

SELECT MIN(FIRST_NAME), MAX(FIRST_NAME) FROM EMPLOYEES;

--COUNT() 사용방법 2가지
SELECT COUNT(*) AS "전체 행 수", COUNT(COMMISSION_PCT) AS "NULL이 제외된 COMMISSION_PCT 행의 갯수" FROM EMPLOYEES;

-- 그룹함수를 사용할 때 자주하는 실수 - 일반컬럼, 그룹함수를 같이 사용할수 없다.
SELECT FIRST_NAME, SUM(SALARY) FROM EMPLOYEES; -- 불가능 - FIRST_NAME -> 107행, SUM(SALARY) -> 1행

--WINDOW절을 사용하면 - 일반컬럼 옆에 그룹함수 값을 동시에 붙여서 출력을 할 수 있다.
SELECT FIRST_NAME AS 이름, 
        SUM(SALARY) OVER() AS "급여 합계", 
        AVG(SALARY) OVER() AS "급여 평균",
        COUNT(*) OVER() AS "전체 행 갯수"
    FROM EMPLOYEES;

    
--GROUP BY 구문 - WHERE절 다음 ORDER절 이전
SELECT DEPARTMENT_ID, 
       SUM(SALARY),
       AVG(SALARY),
       COUNT(*),
       MAX(SALARY),
       MIN(SALARY)
    FROM EMPLOYEES 
    GROUP BY DEPARTMENT_ID
    ORDER BY DEPARTMENT_ID;
-- 주의할점 - 그룹화하지 않은 컬럼을 SELECT절에 바로 넣을 수는 없다. -> 이것도 WINDOW절로 해결은 가능하다.


-- 2개 이상의 그룹화
SELECT DEPARTMENT_ID,
       JOB_ID,
       SUM(SALARY),
       COUNT(*)
    FROM EMPLOYEES
    GROUP BY DEPARTMENT_ID, JOB_ID
    ORDER BY DEPARTMENT_ID;

-- 평균급여가 6000달러 이상인 부서만 출력 -> X, GROUP BY의 조건을 쓰는곳은 HAVING이 따로 있음.

SELECT DEPARTMENT_ID,
       AVG(SALARY)
    FROM EMPLOYEES
    WHERE AVG(SALARY) >= 6000
    GROUP BY DEPARTMENT_ID; -- 불가능


-- HAVING 그룹바이절의 조건을 작성하는 곳
SELECT DEPARTMENT_ID,
       AVG(SALARY)
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID IS NOT NULL
    GROUP BY DEPARTMENT_ID
    HAVING AVG(SALARY) >= 6000;


-- 셀러리맨이 아닌 사람들의, 직무별 급여평균이 6000이상인 데이터,평균 , 합계, 평균내림차순으로 정렬
SELECT JOB_ID,
       TRUNC(AVG(SALARY)) AS 평균,
       SUM(SALARY) AS 합계
    FROM EMPLOYEES
    WHERE JOB_ID NOT LIKE 'SA%'
    GROUP BY JOB_ID
    HAVING AVG(SALARY) >= 6000
    ORDER BY 평균 DESC;


-- ROLLUP, CUBE, GROUPING -> 시험에 반드시 나옴
SELECT DEPARTMENT_ID, SUM(SALARY)
    FROM EMPLOYEES
    GROUP BY ROLLUP(DEPARTMENT_ID); -- 그룹의 총계
    
SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY)
    FROM EMPLOYEES
    GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID) -- 그룹의 총계 + 소계
    ORDER BY DEPARTMENT_ID;
    
-- CUBE
SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY)
    FROM EMPLOYEES
    GROUP BY CUBE(DEPARTMENT_ID, JOB_ID) -- ROLLUP + 서브그룹의 총계 까지 추가
    ORDER BY DEPARTMENT_ID;

-- GROUPING - 그룹바이로 생성되었으면 0반환, ROLLUP OR CUBE로 생성되었으면 1반환
SELECT DECODE(GROUPING(DEPARTMENT_ID),1,'총계', DEPARTMENT_ID), 
       DECODE(GROUPING(JOB_ID),1,'소계', JOB_ID), 
       SUM(SALARY),
       GROUPING(DEPARTMENT_ID),
       GROUPING(JOB_ID)
    FROM EMPLOYEES
    GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
    ORDER BY DEPARTMENT_ID;
    
    
------------------------------------------------
-- 연습문제
--문제 1.
--사원 테이블에서 JOB_ID별 사원 수, 월급의 평균, 가장빠른 입사일을 구하세요. 
--월급의 평균 순으로 내림차순 정렬하세요.
SELECT JOB_ID,
       COUNT(*) AS "사원 수",
       AVG(SALARY) AS "급여평균",
       MIN(HIRE_DATE) AS "최초입사일"
    FROM EMPLOYEES
    GROUP BY JOB_ID
    ORDER BY 급여평균 DESC;


--문제 2.
--사원 테이블에서 입사 년도 별 사원 수를 구하세요.
SELECT TO_CHAR(HIRE_DATE, 'YYYY') AS "입사 년도",
       COUNT(*) AS 사원수
    FROM EMPLOYEES
    GROUP BY TO_CHAR(HIRE_DATE, 'YYYY');
--
--문제 3.
--급여가 1000 이상인 사원들의 부서별 평균 급여를 출력하세요. 단 부서 평균 급여가 2000이상인 부서만 출력
SELECT DEPARTMENT_ID,
       ROUND(AVG(SALARY)) AS "부서별 평균 급여"
    FROM EMPLOYEES
    WHERE SALARY >= 1000
    GROUP BY DEPARTMENT_ID
    HAVING AVG(SALARY) >= 2000;

--문제 4.
--사원 테이블에서 commission_pct(커미션) 컬럼이 null이 아닌 사람들의
--department_id(부서별) salary(월급)의 평균, 합계, count를 구합니다.
--조건 1) 월급의 평균은 커미션을 적용시킨 월급입니다.
--조건 2) 평균은 소수 2째 자리에서 절삭 하세요.
SELECT DEPARTMENT_ID,
       TRUNC(AVG(SALARY + (SALARY * COMMISSION_PCT)),2) AS "평균월급",
       SUM(SALARY) AS "월급합계",
       COUNT(SALARY) AS "사원 수"
    FROM EMPLOYEES
    WHERE COMMISSION_PCT IS NOT NULL
    GROUP BY DEPARTMENT_ID;
--문제 5.
--부서아이디가 NULL이 아니고, 입사일은 05년도 인 사람들의 부서 급여평균과, 급여합계를 평균기준 내림차순합니다
--조건) 평균이 10000이상인 데이터만
SELECT DEPARTMENT_ID,
       AVG(SALARY) AS 급여평균,
       FLOOR(SUM(SALARY)) AS 급여합계
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID IS NOT NULL AND HIRE_DATE LIKE '05%'
    GROUP BY DEPARTMENT_ID
    HAVING AVG(SALARY) >= 10000
    ORDER BY 급여합계 DESC;
--문제 6.
--직업별 월급합, 총합계를 출력하세요
SELECT DECODE(GROUPING(JOB_ID),1,'합계', JOB_ID) AS JOB_ID,
       SUM(SALARY)
    FROM EMPLOYEES
    GROUP BY ROLLUP(JOB_ID)
    ORDER BY JOB_ID;

--문제 7.
--부서별, JOB_ID를 그룹핑 하여 사원수 , 급여 합계를 출력하세요.
--GROUPING() 을 이용하여 소계 합계를 표현하세요
SELECT DECODE(GROUPING(DEPARTMENT_ID),1,'합계',DEPARTMENT_ID) AS DEPARTMENT_ID,
       DECODE(GROUPING(JOB_ID), 1, '소계', JOB_ID) AS JOB_ID,
       COUNT(*) AS TOTAL,
       SUM(SALARY) AS SUM
    FROM EMPLOYEES
    GROUP BY ROLLUP(DEPARTMENT_ID, JOB_ID)
    ORDER BY SUM;
