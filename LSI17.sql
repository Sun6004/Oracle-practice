2023-0202-01) 시퀀스(SEQUENCE)
 - 자동적으로 증가(감소)되는 값을 제공하는 객체 (자동으로 증감되기 때문에 중복되어질 일이 없음)
 - 테이블과 독립적으로 동작하므로 여러 테이블에서 공유할 수 있음
 - 한 테이블에서 사용중일 때 다른 테이블에서 동시에 사용은 불가
 - 시퀀스는 한번 지나간 값을 다시 사용할 수 없음
 - 사용되는 곳
  . 기본키로 설정할 컬럼이 존재하지 않는 경우
  . 자동적으로 증가하는 값이 필요한 경우
 - 사용예 : 게시판 번호

(사용형식)
 CREATE SEQUENCE 시퀀스이름
   [START WITH n] --시작 값(증감되는 값은 시작되는 값)설정을 생략하면 NINVALUE값이 설정 
   [INCREMENT BY n] -- 증가[감소]값
   [MINVALUE n|NOMINVALUE] --최소값 설정. defaulf(기본값)는 NOMINVALUE이며 생략되면 기본값은 1
   [MAXVALUE n|NOMAXVALUE] --최대값 설정. defaulf(기본값)는 NOMAXVALUE이며 사용할 수 있는 값은10^27 (최대 99999)
   [CYCLE|NOCYCLE] --최대[최소]값까지 도달 후 다시 시퀀스 생성할지 여부 default(기본값)는 NONCYCLE
   [CACHE n|NOCACHE] -- 캐쉬에 생성해놓을 시퀀스 개수. defult(기본값)는 CACHE20
   [ORDER|NOORDER] -- 정의한 대로 시퀀스 생성을 보증할지 여부. defult(기본값)는 NOORDER
   
** 시퀀스으 현재 값 및 다음 값 참조
 . 시퀀스명.NEXTVAL : 시퀀스의 다음 값 반환(시퀀스 값 증가시 사용)
 . 시퀀스명.CURRVAL : 시퀀스의 현재 값 반환
  => 시퀀스가 생성된 후 최초 명령은 "시퀀스명.NEXTVAL" 이어야 함
  => NEXTVAL,CURRVAL을 시퀀스의 의사컬럼(Pseudo Column)이라고 함
  
사용예)
  CREATE SEQUENCE seq_sample
    START WITH 10;
  
  SELECT seq_sample.CURRVAL FROM DUAL; --오류발생: 아직 정의되지 않은 시퀀스, NEXTVAL먼저 사용 후 사용가능
  SELECT seq_sample.NEXTVAL FROM DUAL; --실행시킬때마다 값 증가, **한번 동작되면 이전값으로 되돌릴수 없음

사용예) 분류테이블에 다음 자료를 삽입하시오.
      -------------------------------------
       LPROD_ID    LPROD_GU     LPROD_NM
      -------------------------------------
       시퀀스사용    p501         농산물
           "       p502         수산물 
           "       p503         임산물 
           
 (시퀀스 생성 : LPROD_ID에 사용)
 CREATE SEQUENCE seq_lprod
   START WITH 10;
 
 (자료 삽입)
 INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
   VALUES(seq_lprod.NEXTVAL,'P501','농산물');
   
  INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
   VALUES(seq_lprod.NEXTVAL,'P502','수산물');
   
   INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
   VALUES(seq_lprod.NEXTVAL,'P503','임산물');
   

2023-0202-02) 동의어(SYNONYM)
 - 오라클 객체에 부여된 또 다른 이름(별칭)
 - 테이블이나 컬럼의 별칭과의 차이점은 동의어는 모든 곳에서 독립적으로 적용(사용)됨
 - 테이블이나 컬럼의 별칭은 해당 SQL문에서만 사용가능
 - 주로 다른 계정의 테이블 등의 객체를 참조할때 '스키마명.객체명'을 사용해야 하므로 이를 줄여 사용하는데에 사용
 
(사용형식)
  CREATE [OR REPLACE] SYNONYM 객체별칭 FOR 원본객체명
  
사용예) HR계정의 EMPLOYEES테이블과 DEPARTMENTS테이블에 EMP 및 DEFT별칭을 부여하여 사용하시오.
  CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
  
  CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPARTMENTS;  
  
  SELECT * FROM DEPT;
  SELECT * FROM HR.DEPARTMENTS; -- 똑같음
  
  SELECT A.EMPLOYEE_ID,A.EMP_NAME,B.DEPARTMENT_ID,B.DEPARTMENT_NAME
    FROM EMP A, DEPT B -- JOIN FROM절에서 객체별칭 사용으로 줄여쓸수있음.
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID;
   
   
  CREATE OR REPLACE SYNONYM VMEM FOR V_MILEAGE; 
  SELECT * FROM VMEM;
  
  
2023-0202-03) 인덱스(INDEX)
 - 특정 자료의 검색효율을 높이기 위한 객체
 - DB SERVER의 성능을 결정하는 요소가 검색 능력이며, SERVER의 부하를 줄여 전체 성능을 향상
 - 단점으로
  . 생성에 시간 및 공간이 소요
  . 자료의 삽입, 삭제, 수정이 발생되면 인덱스도 변경이 요구됨
  . 인덱스를 유지관리하는데 많은 시간이 소요 (적당히 생성)
 - 종류
  . Unique Index, Non Unigue Index --NULL값도 허용됨(Unique에는 널값이 하나만 존재해야함)
  . Single, Composite
  . Nomal, Bitmap, Function Based Nomal...etc
  
사용형식)
  CREATE [UNIQUE|BITMAP] INDEX 인덱스명
      ON 테이블명(컬럼명[,컬럼명,...]) [ASC|DESC]
  . 'UNOQUE|BITMAP' : 생성될 인덱스의 종류, 기본은 NON_UNIQUE, NOMAL INDEX 임
  . '테이블명(컬럼명[,컬럼명,...])' : 인덱스가 적용될 테이블명과 인덱스 구성에 사용될 컬럼명(들) 기술
  . '[ASC|DESC]' : 인덱스 생성방식 기본은 ASC임

사용예) 
  SELECT MEM_ID,MEM_NAME,MEM_ADD1||' '||MEM_ADD2
    FROM MEMBER
   WHERE MEM_REGNO2='2458323';  --실행에 0.002초 걸림
   
  CREATE INDEX idx_mem_regno2
    ON MEMBER(MEM_REGNO2); --INDEX를 만들고 난 후 위SELECT가 0.001초로 빨라짐
    
(인덱스 삭제)    
  DROP INDEX idx_mem_regno2;
    

  CREATE TABLE TEMP
  AS
    SELECT * FROM CART,BUYPROD,MEMBER;
    
  SELECT * FROM TEMP;
  
  SELECT MEM_ID,MEM_NAME,CART_NO
    FROM TEMP
   WHERE MEM_ID='4382532'
     AND CART_PROD='P20200003'; --0.39초 => INDEX생성 후 0초
     
  CREATE INDEX idx_temp ON TEMP(MEM_ID,CART_PROD);
  
  DROP TABLE TEMP; --원본테이블이 없어지면 INDEX같이 삭제
  
**인덱스 재구성
 - 테이블의 저장위치가 변경된경우(테이블 스페이스 변경)
 - 자료의 삽입/삭제가 많이 발생된 경우
(사용형식)
 ALTER INDEX 인덱스명 REBUILD
 

 
  