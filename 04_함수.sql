--문자열 다루기 함수
--LOWER, UPPER, INITCAP

SELECT LOWER('abc'), UPPER('abc'), INITCAP('abc') 
    FROM DUAL;
    
SELECT LOWER(FIRST_NAME) 
    FROM EMPLOYEES;

--LENGTH 길이. INSTR 문자열찾기
SELECT FIRST_NAME, LENGTH(FIRST_NAME), INSTR(FIRST_NAME,'a') 
    FROM EMPLOYEES; -- 찾는문자가 없다면 0을 반환
    
--SUBSTR 문자열 자르기, CONCAT 문자열 합치기
SELECT FIRST_NAME, SUBSTR(FIRST_NAME, 1, 4), SUBSTR(FIRST_NAME, 3) 
    FROM EMPLOYEES;    

SELECT CONCAT(FIRST_NAME, LAST_NAME)
    FROM EMPLOYEES;

--LPAD 왼쪽마스킹, RPAD 오른쪽마스킹
SELECT RPAD(FIRST_NAME,10, '*'), LPAD(SALARY, 7, '-') SALARY 
    FROM EMPLOYEES;

--TRIM 공백제거    
SELECT LTRIM('               HELLO WORLD            ')
    FROM DUAL;
    
SELECT RTRIM('               HELLO WORLD            ')
    FROM DUAL;
    
SELECT TRIM('          HELLO WORLD         ')
    FROM DUAL;

SELECT LTRIM('HELLO WORLD', 'H') FROM DUAL; --왼쪽에서 H제거

--REPLACE 문자열 바꾸기
SELECT REPLACE('피카츄 라이츄 파이리 꼬북이 버터플 야도란 피존투 또가스 서로생긴 모습은 달라도', '꼬북이', '어니부기') FROM DUAL;
SELECT REPLACE('피카츄 라이츄 파이리 꼬북이 버터플 야도란 피존투 또가스 서로생긴 모습은 달라도', ' ', '') FROM DUAL;

--함수의 중첩
SELECT REPLACE(REPLACE('서울 | 대전 | 대구 | 부산 | 찍고','|','->'),' ','') AS 지역 FROM DUAL;

--WHERE절에도 함수를 사용할 수 있음.
SELECT FIRST_NAME, LAST_NAME 
    FROM EMPLOYEES 
    WHERE UPPER(FIRST_NAME) = 'DAVID';

--
--문제 1.
--EMPLOYEES 테이블 에서 이름, 입사일자 컬럼으로 변경해서 이름순으로 오름차순 출력 합니다.
--조건 1) 이름 컬럼은 first_name, last_name을 붙여서 출력합니다.
--조건 2) 입사일자 컬럼은 xx/xx/xx로 저장되어 있습니다. xxxxxx형태로 변경해서 출력합니다.
SELECT CONCAT(FIRST_NAME, LAST_NAME) AS 이름, REPLACE(HIRE_DATE,'/','') AS 입사일자
    FROM EMPLOYEES ORDER BY 이름;

--문제 2.
--EMPLOYEES 테이블 에서 phone_numbe컬럼은 ###.###.####형태로 저장되어 있다
--여기서 처음 세 자리 숫자 대신 서울 지역변호 (02)를 붙여 전화 번호를 출력하도록 쿼리를 작성하세요
SELECT REPLACE(PHONE_NUMBER, SUBSTR(PHONE_NUMBER,1,4),'(02)') 
    FROM EMPLOYEES;
--
--문제 3. EMPLOYEES 테이블에서 JOB_ID가 it_prog인 사원의 이름(first_name)과 급여(salary)를 출력하세요.
--조건 1) 비교하기 위한 값은 소문자로 입력해야 합니다.(힌트 : lower 이용)
--조건 2) 이름은 앞 3문자까지 출력하고 나머지는 *로 출력합니다. 
--이 열의 열 별칭은 name입니다.(힌트 : rpad와 substr 또는 substr 그리고 length 이용)
--조건 3) 급여는 전체 10자리로 출력하되 나머지 자리는 *로 출력합니다. 
--이 열의 열 별칭은 salary입니다.(힌트 : lpad 이용)

SELECT RPAD(SUBSTR(FIRST_NAME,1,3),LENGTH(FIRST_NAME),'*') AS name, LPAD(SALARY,10,'*') AS salary 
    FROM EMPLOYEES 
    WHERE LOWER(JOB_ID) = 'it_prog';

