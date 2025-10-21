-- DDL문장 (트랜잭션이 없다.)
-- CREATE, ALTER, DROP TRUNCATE

DROP TABLE DEPTS;

CREATE TABLE DEPTS( 
    DEPT_NO NUMBER(2), --정수 2자리
    DEPTS_NAME VARCHAR(30), -- 30BYTE 까지 저장 (한글 15글자, 영어 30글자)
    DEPT_YN CHAR(1), -- 고정문자열 1BYTE (VARCHAR로 대체 가능)
    DEPT_DATE DATE,
    DEPT_BONUS NUMBER(10, 2), -- 전체 유효자리는 10자리, 소수점 2자리까지 사용할 수 있음.
    DEPT_CONTENTS LONG
);

DESC DEPTS;
INSERT INTO DEPTS VALUES(99, 'HELLO', 'Y', SYSDATE, 3.14, 'HELLO WORLD');
INSERT INTO DEPTS VALUES(100, 'HELLO', 'Y', SYSDATE, 3.14, 'HELLO WORLD~~~~'); -- DEPT_NO 초과
INSERT INTO DEPTS VALUES(10, 'HELLO', '가', SYSDATE, 3.14, 'HELLO WORLD'); -- DEPT_YN 초과
---------------------------------------------------------------------------------
-- 컬럼추가 ADD
ALTER TABLE DEPTS ADD(DEPT_COUNT NUMBER(3));
DESC DEPTS;

-- 컬럼이름변경 RENAME COLUMN ~ TO
ALTER TABLE DEPTS RENAME COLUMN DEPT_COUNT TO DEPT_CNT;

-- 컬럼 수정하기 MODIFY
ALTER TABLE DEPTS MODIFY (DEPT_CNT NUMBER(10));
ALTER TABLE DEPTS MODIFY (DEPT_NAME VARCHAR2(1)); -- 기존데이터가 변경할 크기를 넘어가는 경우는 줄일 수 없다.

-- 컬럼 삭제 DROP
ALTER TABLE DEPTS DROP COLUMN DEPT_CNT;

-- 테이블 삭제
DROP TABLE DEPTS;

DROP TABLE DEPARTMENTS; -- FK제약이 걸려있기 때문에 삭제가 안된다.
DROP TABLE DEPARTMENTS CASCADE 제약조건명; --걸려있는 제약을 삭제하면서 테이블을 드랍(위험)

-- TRUNCATE
-- 테이블의 행을 삭제, 테이블의 기억공간을 해제 해서 사용하지 못하도록 한다.

------------------------------- 연습 문제 -----------------------------------
--테이블명 DEPT2
--1. 테이블을 생성하세요.
--DEPT_NO 숫자타입 3글자
--DEPT_NAME 가변형문자 15바이트
--LOCA_NUMBER 숫자타입 4글자
--DEPT_GENDER 고정문자 1글자
--REG_DATE 날짜타입
--DEPT_BONUS 실수 5자리까지
CREATE TABLE DEPT2 (
    DEPT_NO NUMBER(3),
    DEPT_NAME VARCHAR(15),
    LOCA_NUMBER NUMBER(4),
    DEPT_GENDER CHAR(1),
    REG_DATE DATE,
    DEPT_BONUS NUMBER(10, 5)
);
--2. DEPT_BONUS를 DEPT_CMT로 변경하세요
ALTER TABLE DEPT2
RENAME COLUMN DEPT_BONUS TO DEPT_CMT;
--3. DEPT_ADDR를 추가하세요.
ALTER TABLE DEPT2
ADD (DEPT_ADDR VARCHAR2(50));
--4. INSERT를 1행만 진행하세요.
DESC DEPT2;
INSERT INTO DEPT2 VALUES(1,'김의재',2000,'M',SYSDATE,1.8,'서울시 송파구');
SELECT * FROM DEPT2;
--5. 테이블을 드랍하세요. 
DROP TABLE DEPT2;