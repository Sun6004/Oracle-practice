2023-0116-01) 함수
  - 득점 결과를 반환하는 모듈을 미리 작성하고 컴파일하여 실행 가능한 상태로 구성된
    반환값이 있는 서브 프로그램
  - 칼럼의 값이나 데이터 타입을 변경
  - 숫자, 날짜 자료의 출력 형식 변경
  - 특정 값을 기준으로 데이터를 그룹화하고 각 그룹에서 집계를 수행
  - 단일행/복수행 함수
  - 문자열 함수/ 숫자함수/ 날짜함수/ 변환함수/ 집계함수/ 분석함수 등으로 구분
  
1. 문자열 함수 '||'
  . 문자열 결합연산자
  . 자바의 문자열 연산자 '+'와 동일기능 수행

사용예) 회원테이블에서 대전에 거주하는 회원정보를 조회하시오.
       Alias 는 회원번호, 회원명,주민번호,주소이며 주민번호의 출력은'XXXXXX-XXXXXX'형태로,
       주소는 기본주소와 상세주소를 공백으로 연결하여 출력하시오.
       
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_REGNO1 ||'-'|| MEM_REGNO2 AS 주민번호,
           MEM_ADD1 ||'-'|| MEM_ADD2 AS 주소
      FROM MEMBER
      WHERE MEM_ADD1 LIKE '대전%';
      
2) CONCAT (C1,C2 ) - '**'
  . 문자열 C1과 C2를 결합하여 새로운 문자열로 반환
  . '||' 연산자와 동일 기능 제공
  
사용예) 회원테이블에서 대전에 거주하는 회원정보를 조회하시오.
       Alias 는 회원번호, 회원명,주민번호,주소이며 주민번호의 출력은'XXXXXX-XXXXXX'형태로,
       주소는 기본주소와 상세주소를 공백으로 연결하여 출력하시오.
       
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           CONCAT (CONCAT (MEM_REGNO1,'_'  ),MEM_REGNO2) AS 주민번호1,
           CONCAT (MEM_REGNO1, CONCAT ('_', MEM_REGNO2 )) AS 주민번호2,
           CONCAT (CONCAT (MEM_ADD1, '_'  ),MEM_ADD2) AS 주소 
        FROM MEMBER
        WHERE MEM_ADD1 LIKE '대전%';
3) CHR(N), ASCII(C) - '**'
  . CHR :  주어진 N에 담당하는 ASCII 코드의 문자 출력
  . ASCII : 주어진 문자열 C의 첫 글자에 대한 ASCII 코드값(정수) 출력
  

사용예)
  SELECT CHR(90), ASCII ('KOREA'), ASCII ('대한민국'),CHR(ASCII('KOREA')),
         CHR(ASCII('대한민국'))
    FROM DUAL;
    

4) LOWER(C), UPPER(C),INITCAP(C)
    . LOWER : 주어진 문자열 C에 포함된 모든 문자를 소문자로 변환
    . UPPER : 주어진 문자열 C에 포함된 모든 문자를 대문자로 변환
    . INITCAP : 단어의 첫 글자만 대문자로 변환
    
  SELECT * FROM MEMBER
    WHERE UPPER(MEM_ID) = 'T001';
    
  SELECT FIRST_NAME,
         LAST_NAME,
         INITCAP((LOWER(EMP_NAME))
    FROM HR.EMPLOYEES;
    
4) LPAD(C1, N [,C2]), RPAD(C1, N [,C2])
  . LPAD : N크기의 기억공간에 C1 문자열을 저장시키고 남는 왼쪽 기억공간에 C2 문자열을
           채움. C2가 생략되면 공백이 확장되어 채워짐
           수표보호문자로 사용되었음
  . RPAD : N크기의 기억공간에 C1 문자열을 저장시키고 남는 오른쪽 기억공간에 C2 문자열을
           채움. C2가 생략되면 공백이 확장되어 채워짐
           
시용예) 상품테이블에서 다음 자료를 주어진 조건에 맞추어 출력하시오.
       ALIAS는 상품코드, 상품명, 매입가격
       매입가격은 10자리에 출력하되 왼쪽 빈공간에 '*'를 확장하여 출력하고 
       상품명은 25자리에 오른쪽 정렬하여 출력하시오
       
       SELECT PROD_ID AS 상품코드,
              LPAD(TRIM(PROD_NAME),30) AS 상품명,
              LPAD (PROD_COST,10'*') AS 매입가격
         FROM PROD;
         
5) LTRIM(C1 [,C2[), RTRIM(C1 [,C2[) -'****'
  . LTRIM : 주어진문자열 C1의 완쪽 첫 글차부터 C2문자열과 일치하면 해당 문자열을 삭제
  . RTRIM : 주어진문자열 C1의 오른쪽 첫 글차부터 C2문자열과 일치하면 해당 문자열을 삭제
  . C2가 생략되면 공백이 제거됨
  
  사용예) HR계정의 사원테이블에서 사원들의 이름(EMP_NAME)의 데이터 타입을 VARCHAR2(50) 에서
         CHAR(50)으로 변경하시오.
         
  ALTER TABLE HR.EMPLOYEES MODIFY(EMP_NAME CHAR(50));
  SELECT EMPLOYEE_ID, EMP_NAME
    FROM HR.EMPLOYEES;
 ** 사원명 'STEVEN KING'사원의 사원번호, 사원명, 입사일, 직무코드 조회
    SELECT EMPLOYEE_ID AS 사원번호,
           RTRIM (EMP_NAME) AS 사원명,
           HIRE_DATE AS 입사일,
           JOB_ID AS 직무코드
        FROM HR.EMPLOYEES
        WHERE EMP_NAME = 'Steven King'
        
    SELECT LTRIM('APAPAPPLE PESIMMON BANNA', 'AP'),
           LTRIM('APAPAPPLE PESIMMON BANNA', 'APP')
           
        FROM DUAL;
    
6) TRIM(C1) - '***'
  . 주어진 문자열 C1의 앞, 뒤에 존재하는 공백을 제거
  . 문자열 내부의 공백은 제거하지 못함
  
사용예) HR계정의 사원테이블의 이름(EMP_NAME)의 컬럼의 자료형을 VARCHAR2(50)으로 복귀시키시오.
    ALTER TABLE HR.EMPLOYEES MODIFY(EMP_NAME VARCHAR2(50));
    
    
        UPDATE HR.EMPLOYEES
            SET EMP_NAME = TRIM(EMP_NAME);
            
        COMMIT;
        
    SELECT EMPLOYEE_ID, EMP_NAME, LENGTHB(EMP_NAME)
        FROM HR.EMPLOYEES;
        
7) SUBSTR(C, SIDX [,CNT]) - '*****'
  . 주어진 문자열 C에서 SIDX위치부터 CNT 개수만큼의 부분 문자열을 추출하여 반환
  . C의 문자수보다 큰 값의 CNT가 사용되거나 CNT가 생략되면 SIDX이후 모든 문자열을 반환
  . SIDX가 음수이면 오른쪽부터 처리
  
사용예)
    SELECT SUBSTR('대전시 중구 계룡로 846',3,5) AS COL1,
           SUBSTR('대전시 중구 계룡로 846',3) AS COL2,
           SUBSTR('대전시 중구 계룡로 846',3,35) AS COL3,
           SUBSTR('대전시 중구 계룡로 846',-10,5) AS COL4
           
        FROM DUAL;
        
 **표현식 : CASE WHEN THEN
   - 자바의 다중분기와 비슷한 기능 제공
   (사용형식-1)
   CASE WHEN 조건1 THEN
             값1
        WHEN 조건2 THEN
             값2
             :
        ELSE
             값N
        END
        . SELECT 문의 SELECT 절에서 사용
        . '조건1'이 참이면 값1을 반환하고 END 다음 명령 수행
        . '조건1'이 거짓이면 그 다음 조건들을 비교하며 모든 조건들이 거짓이면 ELSE 다음의 값N을 반환
        
     (사용형식-2)
   CASE 조건 WHEN 값1 THEN
             명령2
        WHEN 값2 THEN
             명령2
             :
        ELSE
             명령N
        END     
        
문제] 회원테이블에서 주민등록번호를 이용하여 나이를 계산하여 20대 회원만 조회하시오
    회원번호, 회원명, 주민번호, 나이, 마일리지
    
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_REGNO1 || '-' || MEM_REGNO2 AS 주민번호,
           EXTRACT(YEAR FROM SYSDATE)-
           CASE WHEN SUBSTR(MEM_REGNO2,1,1)IN('1','2') 
           THEN 1900+ TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))
           ELSE 2000+ TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)) END AS 나이, 
           MEM_MILEAGE AS 마일리지
        FROM MEMBER
        WHERE ( EXTRACT(YEAR FROM SYSDATE)-
           (CASE WHEN SUBSTR(MEM_REGNO2,1,1)IN('1','2') 
           THEN 1900+ TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))
           ELSE 2000+ TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)) END)) BETWEEN 20 AND 29;
         
2) REPLACE(C1,C2[,C3]) - '***'
  . 주어진 문자열 C1에서 C2문자열을 찾아 C3문자열로 대치
  . C3가 생략되면 찾은 C3를 삭제함
  . 문자열 내부 공백을 제거할 수 있음
  
사용예)
    SELECT REPLACE ('대우서비스센터','대우','APPLE'),
           REPLACE ('APPLE PERSSIOM','A'),
           REPLACE ('ORACLE MYSQL MSSQL',' ')
        FROM DUAL;
        
9) INSTR(C1,C2 [,M[,N]]) - '**'
  . C1 문자열에서 C2 문자열이 처음 나온 위치(INDEX)를 반환
  . M은 검색 시작위치 지정 값
  . N은 C2의 N번째 출현 위치를 반환 받을 때 사용
  
사용예)
  SELECT INSTR('APPLEPERSSIBANANAIMIOANCE','L'),
         INSTR('APPLEPERSSIBANANAIMIOANCE','A',3),
         INSTR('APPLEPERSSIBANANAIMIOANCE','A',10,2)
    FROM DUAL;
    
10) LENGTH(C), LENGTHB(C) - '***'
  . LENGTH : 주어진 문자열 C에 포함된 글자수 반환
  . LENGTHB : 주어진 문자열 C의 길이(BYTE 수) 반환
           
    

    
        