SELECT * FROM INFO;
SELECT * FROM AUTH;

-- INNER JOIN : 연결할 데이터가 없으면 나오지 않음.

SELECT *
    FROM INFO
    /*INNER*/ JOIN AUTH
    ON INFO.AUTH_ID = AUTH.AUTH_ID;
    
--테이블 Alias

SELECT *
    FROM INFO I
    JOIN AUTH A
    ON I.AUTH_ID = A.AUTH_ID;
    
--SELECT 구문의 선택 -- 동일한 컬럼명이 있는 경우에 참조테이블을 지칭해야 한다.

SELECT ID,
       TITLE,
       I.AUTH_ID,
       NAME
    FROM INFO I
    JOIN AUTH A
    ON I.AUTH_ID = A.AUTH_ID;

--USING ON 구문을 쓸 수도 있다. - 양측 테이블에 동일한 키 이름으로 연결할때 가능하다.

SELECT *
    FROM INFO I
    JOIN AUTH A
    USING (AUTH_ID);
    
--------------------------------------------------------------------------

--LEFT JOIN - 왼쪽테이블은 다나오고, 붙을 수 없는 값은 NULL로 처리
SELECT *
    FROM INFO I
    LEFT /*OUTER*/ JOIN AUTH A -- INNER와 마찬가지로 OUTER 생략 가능
    ON I.AUTH_ID = A.AUTH_ID;
    
--RIGHT JOIN - 오른쪽 테이블은 다 나오고, 붙을 수 없는 값은 NULL로 처리
SELECT *
    FROM INFO I
    RIGHT JOIN AUTH A
    ON I.AUTH_ID = A.AUTH_ID;
    
--------------------------------------------------------------------------

-- FULL OUTER JOIN - 양측 테이블 다 나온다.

SELECT *
    FROM INFO I
    FULL OUTER JOIN AUTH A
    ON I.AUTH_ID = A.AUTH_ID;
    
    
--------------------------------------------------------------------------


--CROSS JOIN - 잘못된 조인의 형태 (카티시안 프로덕트)

SELECT *
    FROM INFO
    CROSS JOIN AUTH;
    
--------------------------------------------------------------------------


SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM LOCATIONS;

-- 조인은 여러번 붙을 수 있다.
SELECT * 
    FROM EMPLOYEES E
    LEFT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID;


--------------------------------------------------------------------------


--오라클에서 사용하는 오라클 조인문법
--테이블을 from절에 , 로 적음
--WHERE에서 JOIN 조건을 적음

SELECT *
    FROM INFO I, AUTH A
    WHERE I.AUTH_ID = A.AUTH_ID; --INNER JOIN
    
SELECT *
    FROM INFO I, AUTH A
    WHERE I.AUTH_ID = A.AUTH_ID(+); --LEFT JOIN
    
SELECT *
    FROM INFO I, AUTH A
    WHERE I.AUTH_ID(+) = A.AUTH_ID; --RIGHT JOIN
    
-- FULL OUTER JOIN은 오라클에서 없다.

SELECT *
    FROM INFO I, AUTH A;
    
    
--------------------------------------------------------------------------


-- NON EQUALS JOIN
-- 두 테이블을 조인할 때 = 연산자 대신 >, >=, <> BETWEEN AND 등을 이용해서 조인을 하는 방법.
-- 보통 키관계가 없는 컬럼들을 붙여서 쓸 때 사용할 수 있다.
-- CROSS JOIN 을 기반으로 동작한다.

SELECT *
    FROM EMPLOYEES E
    CROSS JOIN JOBS J;
    
-- MIN_SALRAY의 한 행에 대해서 SALARY가 큰 사람들을 모두 출력. 중복 데이터가 많음.
SELECT *
    FROM EMPLOYEES E
    JOIN JOBS J
    ON E.SALARY >= J.MIN_SALARY; -- NON EQUALS JOIN
    
SELECT *
    FROM EMPLOYEES E
    JOIN JOBS J
    ON E.SALARY >= J.MIN_SALARY AND E.SALARY <= J.MAX_SALARY;
    
SELECT *
    FROM EMPLOYEES E
    JOIN JOBS J
    ON E.SALARY BETWEEN J.MIN_SALARY AND J.MAX_SALARY;