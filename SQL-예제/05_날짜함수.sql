-- 숫자 함수
-- ROUND 반올림, TRUNC 절삭
SELECT ROUND(45.923), ROUND(45.923, 2), ROUND(45.923, -1) FROM DUAL;
SELECT TRUNC(45.923), TRUNC(45.923, 2), TRUNC(45.923, -1) FROM DUAL;

--ABS 절대값, CEIL 올림, FLOOR 내림, MOD 나머지
SELECT ABS(-4), CEIL(3.14), FLOOR(3.14) FROM DUAL;

SELECT 5/2 AS 몫, MOD(5, 2) AS 나머지 FROM DUAL;

-- 날짜함수
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

-- 날짜는 연산이 가능
SELECT HIRE_DATE, HIRE_DATE + 10, HIRE_DATE - 10 FROM EMPLOYEES; -- 날짜 - 숫자 = 날짜

SELECT HIRE_DATE, SYSDATE - HIRE_DATE FROM EMPLOYEES; -- 날짜 - 날짜 = 숫자(일수)

SELECT (SYSDATE - HIRE_DATE) / 7 FROM EMPLOYEES; -- 입사일로부터 몇 주가 지났는지 알 수 있다.

SELECT (SYSDATE - HIRE_DATE) / 365 FROM EMPLOYEES; -- 입사일로부터 몇 년이 지났는지 알 수 있다.

-- ROUND(반올림), TRUNC(절삭)
SELECT TRUNC(SYSDATE) FROM DUAL; -- 일 기준 절삭 (오늘 기준 14일이기 때문에 14일들만 나옴)
SELECT TRUNC(SYSDATE, 'MONTH') FROM DUAL; -- 월 기준 절삭 (오늘 기준 10월 이기 때문에 10월들만 나옴)
SELECT TRUNC(SYSDATE, 'YEAR') FROM DUAL; -- 연도 기준 절삭 (오늘 기준 25년 이기 때문에 25년들만 나옴)

SELECT ROUND(SYSDATE) FROM DUAL; -- 일 기준 반올림 (오늘 기준 14일이기 때문에 14일들만 나옴)
SELECT ROUND(SYSDATE, 'MONTH') FROM DUAL; -- 월 기준 반올림 (오늘 기준 10월 이기 때문에 10월들만 나옴)
SELECT ROUND(SYSDATE, 'YEAR') FROM DUAL; -- 연도 기준 반올림 (오늘 기준 25년 이기 때문에 26년들만 나옴)
