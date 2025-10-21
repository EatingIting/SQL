-- 시퀀스

SELECT * FROM USER_SEQUENCES;

-- 생성
CREATE SEQUENCE DEPTS_SEQ; -- 시퀀스 기본값으로 생성
DROP SEQUENCE DEPTS_SEQ; -- 시퀀스 삭제

CREATE SEQUENCE DEPTS_SEQ
    INCREMENT BY 1
    START WITH 90
    MAXVALUE 100
    NOCYCLE -- 시퀀스가 MAX에 도달하면 다시 시작부터 하겠는가? - NO
    NOCACHE; -- 캐시에 스퀀스를 두지 않음.
    
-- 시퀀스는 일반적으로 PK에 자동증가하는 값으로 사용된다. (인조 식별자)

CREATE TABLE DEPTS(
    DEPT_NO NUMBER(3) CONSTRAINT DEPT_NO_PK PRIMARY KEY,
    DEPT_NAME VARCHAR2(30)
);
SELECT DEPTS_SEQ.CURRVAL FROM DUAL; -- NEXTVAL실행한 후 부터 사용이 가능하다. - 현재 몇의 값을 갖고 있는지 알 수 있다.
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL; -- 시퀀스의 다음 값

INSERT INTO DEPTS VALUES(DEPTS_SEQ.NEXTVAL, 'DEPT');
SELECT * FROM DEPTS;
-- 시퀀스 수정
ALTER SEQUENCE DEPTS_SEQ MAXVALUE 1000;
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 10 MINVALUE 1;

-- 주기적으로 시퀀스를 초기화 해야한다면?
-- 시퀀스가 이미 사용중인 경우라면, DROP 하면 안된다.

-- 시퀀스 증가값을 - 음수로 변경
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY -150 MINVALUE 0;
-- 시퀀스 전진
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL;
-- 시퀀스 증가값을 1로 변경
ALTER SEQUENCE DEPTS_SEQ INCREMENT BY 1;
-- 다음값은 초기화 된다.
SELECT DEPTS_SEQ.NEXTVAL FROM DUAL;

-------------------------------------------------------------

-- 인덱스
-- INDEX는 PK, UK 제약에서 자동으로 생성된다. 조회를 빠르게하는 HINT 역할을 한다.
-- INDEX 종류로는 고유인덱스, 비고유 인덱스가 있다.
-- 고유인덱스(UNIQUE) 유니크한 컬럼에만 지정될 수 있다.
-- 비고유인덱스 는 일반컬럼에 지정할 수 있다.

CREATE TABLE EMPS_IT AS (SELECT * FROM EMPLOYEES);

SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'David';
-- FIRST NAME에 인덱스 부착 (비고유 인덱스)`
CREATE INDEX EMPS_IT_IDX ON EMPS_IT(FIRST_NAME);
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'David';

-- 인덱스 삭제 (테이블 자체에 영향을 미치지 않는다.)
DROP INDEX EMPS_IT_IDX;

-- 인덱스는 여러 컬럼을 묶어서(결합 인덱스) 생성할 수도 있다.
CREATE INDEX EMPS_IT ON EMPS_IT(FIRST_NAME, LAST_NAME);

SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'David';
SELECT * FROM EMPS_IT WHERE FIRST_NAME = 'David' AND LAST_NAME = 'Lee'; -- 힌트를 받음
SELECT * FROM EMPS_IT WHERE LAST_NAME = 'Lee';

-- 인덱스는 조회를 빠르게 하지만, 무작위하게 많이 사용하는 것은 성능저하를 부를 수 있다.
-- 자주 수정, 삽입, 삭제가 일어나는 컬럼에는 인덱스를 피하는게 좋다.

------------------------ 연습 문제 ------------------------
--문제1.
--DEPTS_SEQ2테이블에 들어갈 수 있는 PK를 인조적으로 생성하려 합니다.
--값의 유형은
--2023-12-시퀀스값 입니다.
--1. DEPTS_SEQ2를 생성하세요.
--2. INSERT넣을 때 (2023-12-0000시퀀스) 일련번호 유형으로 들어갈 수 있도록 처리해보세요.
--	조건) 데이터는 (현재날짜-0000시퀀스) 유형입니다.
--	예시) 2023-12-00001, 2023-12-00002, 2023-12-00003......
--	힌트) SYSDATE, TO_CHAR, LPAD 사용
CREATE TABLE DEPTS(
    DEPT_NO VARCHAR2(20),
    DEPT_NAME VARCHAR2(20)
);

CREATE SEQUENCE DEPTS_SEQ2 NOCACHE;

INSERT INTO DEPTS VALUES(TO_CHAR(SYSDATE, 'YYYY-MM') || '-' || LPAD(DEPTS_SEQ2.NEXTVAL,5, 0),'신규부서');

SELECT * FROM DEPTS;

--문제2.
--해가 지나서 시퀀스 값을 2024-01-시퀀스 형태로 초기화 하려고 합니다.
--문제1 에서 만든 시퀀스를 다시 1부터 시작하도록 초기화 해보세요.
SELECT DEPTS_SEQ2.CURRVAL FROM DUAL;
ALTER SEQUENCE DEPTS_SEQ2 INCREMENT BY -5 MINVALUE 0;
SELECT DEPTS_SEQ2.NEXTVAL FROM DUAL;
ALTER SEQUENCE DEPTS_SEQ2 INCREMENT BY 1;