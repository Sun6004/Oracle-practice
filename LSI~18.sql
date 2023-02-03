2023-0202-03) PL/SQL(Procedual Language SQL)
 - 기본 SQL 이 구조적 언어이기 때문에 변수,반복,분기 등의 기능이 제거되어 제공
 - 기본 SQL 에 절차적 언어의 특징을 추가한 SQL 을 PLSQL 이라고 함(기존SQL의 단점을 보완)
 - 미리 작성되어 컴파일한 형태로 서버에 저장됨 - 실행속도 향상과 네트웍 트래픽 감소
 - 블록 구조로 복수개의 SQL 문을 한번에 실행할 수 있음.
 - 모듈화, 캡슐화 기능 제공
 - 익명블록(Anonymous Block), Stored Procedure, User Defined Function,
   Trigger, Package 등이 제공됨
 - PL/SQL 안에 또 PL/SQL이 올수도 있음

1. 익명블록(Anonymous Block)
 - PL/SQL의 기본 구조 제공
 - 이름이 없어 실행파일로 저장되지 않음
 (기본 구조)
  DECLARE
    선언영역 : 변수,상수,커서 선언
  BEGIN
    실행영역 : 처리할 (SQL)명령문들을 구조에 맞게 절차적으로 기술
    
    [EXCEPTION
      예외처리 영역
    ]
  END;   
  
사용예) 키보드로 부서번호를 하나 입력 받아 해당부서에 가장 먼저 입사한 사원정보를 출력하는 블록을 작성하시오.
       출력은 사원번호, 사원명, 입사일, 직무명이다.
  ACCEPT P_DID PROMPT '부서번호 입력(10~110) : '
  DECLARE
    L_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE;
    L_NAME VARCHAR2(80);
    L_HDATE DATE;
    L_JTITLE HR.JOBS.JOB_TITLE%TYPE;
    L_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE:=TO_NUMBER('&P_DID');
  BEGIN
    SELECT TA.AEID, TA.AENAME, TA.AHDATE, TA.BJT
     INTO L_EID, L_NAME, L_HDATE, L_JTITLE 
      FROM (SELECT A.EMPLOYEE_ID AS AEID, A.EMP_NAME AS AENAME, A.HIRE_DATE AS AHDATE, B.JOB_TITLE AS BJT
              FROM HR.EMPLOYEES A, HR.JOBS B
             WHERE A.DEPARTMENT_ID =L_DID
               AND A.JOB_ID=B.JOB_ID
             ORDER BY 3)TA  --서브쿼리
     WHERE ROWNUM=1;
   --DBMS_OUTPUT.PUT_LINE =SYSTEM.OUT.PRINTLN    
   DBMS_OUTPUT.PUT_LINE('부서번호 : '|| L_DID);
   DBMS_OUTPUT.PUT_LINE('사원번호 : '|| L_EID);
   DBMS_OUTPUT.PUT_LINE('사원명 : '|| L_NAME);
   DBMS_OUTPUT.PUT_LINE('입사일 : '|| L_HDATE);
   DBMS_OUTPUT.PUT_LINE('직무명 : '|| L_JTITLE);
   
   EXCEPTION
     WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('에러발생 : '||SQLERRM);
     
  END;
  
1)변수
 - 개발언어의 변수와 같은 기능
 - 종류 : SCLAER, REFERENCE, COMPOSITE, BIND변수
 - 사용하는 데이터 타입 : SQL에서 사용하는 데이터 타입,
   PLS_INTEGER, BINARY_INTEGER => 4BYTE 정수(2147483637 ~ -2147483638) --실행속도가 빠른대신 너무작아서 NUMBER를 주로 사용
   BOOLEAN(TRUE,FALSE,NULL) 
   
선언형식)
  변수명 [CONSTANT] 데이터타입|참조타입 [:=초기값]
  . 'CONSTANT' : 상수 선언시 사용 --선언시 단 한번만 사용가능
  . 참조타입 : 
     테이블명.컬럼명%TYPE: 선언할 변수의 자료형과 크기가 '테이블의 칼럼'과 동일하게 설정
     테이블명%ROWTYPE: 해당 테이블의 한 행과 동일한 타입(레코드 형)
  . ':=초기값': 초기값이 필요한 경우 기술(NUMBER타입은 필수로 초기화 해야함)
  
사용예) 10~110번 사이의 임의의 부서코드를 생성하여 해당 부서의 부서명과 인원수를 조회하여 출력하는 익명블록 작성
  DECLARE
    L_DNAME DEPT.DEPARTMENT_NAME%TYPE;
    L_CNT NUMBER:=0;
    L_DID HR.EMPLOYEES.DEPARTMENT_ID%TYPE;
  BEGIN
    L_DID:=TRUNC(DBMS_RANDOM.VALUE(10,119),-1); --RANDOM난수발생(시작값,최종값)/ 최종값을119로 설정해야 나머지와 동일한 확률
    SELECT A.DEPARTMENT_NAME AS DNAME,
           COUNT(*) AS CNT
      INTO L_DNAME, L_CNT
      FROM HR.DEPARTMENTS A, HR.EMPLOYEES B
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
       AND A.DEPARTMENT_ID=L_DID
     GROUP BY A.DEPARTMENT_NAME;  
     
     DBMS_OUTPUT.PUT('부서코드 : '||L_DID);
     DBMS_OUTPUT.PUT(',부서명 : '||L_DNAME);
     DBMS_OUTPUT.PUT('인원수 : '||L_CNT);
     DBMS_OUTPUT.PUT_LINE(); --DBMS_OUTPUT.PUT는 DBMS_OUTPUT.PUT_LINE를 만나야 실행됨
  END;
    
사용예) 10~110번 사이의 임의의 부서코드를 생성하여 해당부서에 소속된 사원의 사원번호, 사원명, 입사일, 급여를 출력하는 익명블록
 DECLARE
   L_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE; --사원번호
   L_ENAME VARCHAR2(80);  --사원명
   L_HDATE DATE; --입사일
   L_SALARY NUMBER:=0; --급여
   L_DNAME VARCHAR2(100); --부서명
   L_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE;
   CURSOR CUR_EMP01(P_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE) IS
     SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE,SALARY
       FROM HR.EMPLOYEES
      WHERE DEPARTMENT_ID=P_DID;
  BEGIN
   L_DID:=TRUNC(DBMS_RANDOM.VALUE(10,119),-1);
   SELECT DEPARTMENT_NAME INTO L_DNAME
     FROM HR.DEPARTMENTS
    WHERE DEPARTMENT_ID=L_DID;
   DBMS_OUTPUT.PUT_LINE('부서번호 : '||L_DID||'('||L_DNAME||')');
   
   OPEN CUR_EMP01(L_DID);
   LOOP
      FETCH CUR_EMP01 INTO L_EID,L_ENAME,L_HDATE,L_SALARY;
      EXIT WHEN CUR_EMP01%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(L_EID||' '||RPAD(L_ENAME,25)||L_HDATE||' '||
                      TO_CHAR(L_SALARY,'999,999'));      
      DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('전체 직원 수 : '||CUR_EMP01%ROWCOUNT);
   
   CLOSE CUR_EMP01; 
  END; 
