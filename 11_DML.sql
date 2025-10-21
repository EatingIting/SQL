--DML
--INSERT(삽입)
--2가지 방법

DESC DEPARTMENTS;

-- INSERT INTO 테이블명(컬럼명) VALUES (값)
-- 1. 컬럼명을 정확히 일치 시키면 컬럼명 생략이 가능함.
INSERT INTO DEPARTMENTS VALUES(280, '개발자', NULL, 1700);
-- 2. 컬럼을 지정해서 넣는 경우
INSERT INTO DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
VALUES(290, '디자이너', 1700);

SELECT * FROM DEPARTMENTS ORDER BY DEPARTMENT_ID DESC;

-- 모든 DML문 트랜젝션이 반영됨
ROLLBACK;

-- INSERT도 서브쿼리 문장으로 넣을 수 있다.

CREATE TABLE EMPS AS (SELECT * FROM EMPLOYEES WHERE 1 = 2); -- 테이블 구조 복사

SELECT * FROM EMPS;

INSERT INTO EMPS(LAST_NAME,EMAIL,HIRE_DATE,JOB_ID)
(SELECT LAST_NAME, EMAIL, HIRE_DATE, JOB_ID FROM EMPLOYEES WHERE JOB_ID = 'SA_MAN');

INSERT INTO EMPS(LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
VALUES( (SELECT LAST_NAME FROM EMPLOYEES WHERE MANAGER_ID IS NULL),
        'TEST',
        SYSDATE,
        'TEST'
    );
    
-----------------------------------------------------------------------------------
-- UPDATE

SELECT * FROM EMPS;

UPDATE EMPS
SET SALARY = 1000; -- 전체 행 업데이트 (망함)

UPDATE EMPS
    SET SALARY = SALARY * 1.1,
        COMMISSION_PCT = 0.5,
        MANAGER_ID = 100
    WHERE LAST_NAME = 'Russell'; -- 보통 WHERE 절에는 KEY로 업데이트 진행함
    
SELECT * FROM EMPS;

-- UPDATE구문도 서브쿼리절이 허용된다.
UPDATE EMPS
    SET(MANAGER_ID, JOB_ID, DEPARTMENT_ID) = (
        SELECT MANAGER_ID, JOB_ID, DEPARTMENT_ID 
        FROM EMPLOYEES 
        WHERE EMPLOYEE_ID = 103
    )
    WHERE LAST_NAME = 'Russell';
    
SELECT * FROM EMPS;

-- WHERE 절에도 서브쿼리가 가능함

UPDATE EMPS
SET SALARY = 0
WHERE JOB_ID IN (
    SELECT JOB_ID FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG');
    
----------------------------------------------------------------------
DELETE FROM EMPS
WHERE JOB_ID = 'IT_PROG';

SELECT * FROM EMPS;

-- 모든 행이 삭제가 되는것은 아니다.테이블이 연관관계를 가지고 있다면, 참조무결성 제약에 위배되는 경우에 삭제되지 않는다.

SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENTS;

DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 90; -- 90번은 EMPLOYEES에서 사용중이기 때문에 삭제되지 않는다.

COMMIT;


----------------------------------------------------------------------

-- MERGE문 - 데이터를 비교해서 있으면 UPDATE, 없으면 INSERT 하는 형태로 사용됨.

SELECT * FROM EMPS;

-- 1ST
MERGE INTO EMPS E1 -- 타겟 테이블
USING (SELECT * FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG') E2 -- 병합할 서브쿼리 문장
ON (E1.EMPLOYEE_ID = E2.EMPLOYEE_ID) -- E1과 E2가 연결될 조건
WHEN MATCHED THEN -- 일치할 때 처리할 구문
    UPDATE SET E1.SALARY = E2.SALARY,
               E1.COMMISSION_PCT = E2.COMMISSION_PCT
               --...생략...
WHEN NOT MATCHED THEN -- 일치하지 않을 때 처리할 구문
    INSERT (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES (E2.EMPLOYEE_ID,
            E2.LAST_NAME,
            E2.EMAIL,
            E2.HIRE_DATE,
            E2.JOB_ID);
            
-- 2ST - 서브쿼리로 다른 테이블을 가져오는게 아니고, 직접 데이터를 병합하는 경우는 DUAL 테이블을 사용한다.
MERGE INTO EMPS E1
USING DUAL
ON (E1.EMPLOYEE_ID = 105) -- 고유한 대상을 지칭할 수 있는 키가 들어간다.
WHEN MATCHED THEN
    UPDATE SET E1.SALARY = 10000,
               E1.HIRE_DATE = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (EMPLOYEE_ID, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID)
    VALUES (200, 'TEST', 'TEST', SYSDATE, 'TEST');
    
SELECT * FROM EMPS;


----------------------------------------------------------------------
-- 테이블 복사 구문은, KEY는 복사하지 않는다.
CREATE TABLE EMPS2 AS (SELECT * FROM EMPS); -- 테이블 구조와 데이터 복사
DROP TABLE EMPS2;

CREATE TABLE EMPS2 AS (SELECT * FROM EMPS WHERE 1 = 2); -- 테이블 구조만 복사
SELECT * FROM EMPS2;