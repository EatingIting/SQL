-- 사용자 계정 생성
-- 최고관리자 DBA계정에서 수행해야 한다.
SELECT * FROM ALL_USERS; -- 유저확인

-- 계정 생성
CREATE USER USER01 IDENTIFIED BY USER01; -- 앞 아이디, 뒤 비밀번호

--권한 부여
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE TO USER01;

-- 이 계정이 사용하는 테이블스페이스(데이터가 저장되는 물리적 공간)을 연결
ALTER USER USER01 DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS; -- USERS가 미리 만들어져있는 테이블스페이스명
ALTER USER USER01 DEFAULT TABLESPACE MYDBF QUOTA UNLIMITED ON MYDBF; -- MYDBF 테이블스페이스로 연결
-- 보기 탭 -> DBA클릭
-- 테이블스페이스를 직접 만드는 방법

--권한 회수
REVOKE CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE FROM USER01;

-- 계정 삭제
DROP USER USER01 /*CASCADE*/; -- 계정과 연결된 DB스키마를 전부 삭제하면서 유저 삭제

--------------------------------------------------------------------------------------------------

-- 롤을 이용해서 권한부여
GRANT CONNECT, RESOURCE TO USER01; -- CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE, CREATE PROCEDURE의 집합
ALTER USER USER01 DEFAULT TABLESPACE MYDBF QUOTA UNLIMITED ON MYDBF; -- MYDBF 테이블스페이스로 연결

-- 이 과정이 마우스로도 됨.