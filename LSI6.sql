2023-0117-01) 숫자함수
 1) 수학적 함수
   - ABS, SIGN, SQRT, POWER 등 제공
     . ABS(n) : n의 절대값 반환
     . SIGN(n) : n의 부호에 따라 양수면1, 음수면 크기에 관계없이 -1, 0이면 0을반환
     . SQRT(n) : n의 평반근 값 반환
     . POWER(e,n):e의 n승값 반환
   - 이 밖에도 수학적으로 사용되는 많은 함수가 존재(EXP, LOG 등)
   
2) GREATEST(n1, n2, ...), LEAST(n1, n2, ...)
  - GREATEST : 주어진 숫자자료 n1, n2, ... 중 가장 큰 값 반환
  - LEAST : 주어진 숫자자료 n1, n2, ... 중 가장 작은 값 반환
  - MAX, MIN 함수와의 차이점은 GREATEST와 LEAST는 한행에서 여러 열 값 중 최대 최소값을
    반환하는 함수이고, MAX, MIN함수는 하나의 열 내부에서 최대 최소값을 반환하는 함수
    ex)50명의 국어, 영어, 수학, 과학 시험점수가 저장된 테이블에서 
       각 학생의 4과목 중 최고/최저 점수 과목검색은 GREATEST와 LEAST
       각 과목의 최고,최저점을 기록한 학생을 검색은 MAX,MIN 함수
       
사용예)
  SELECT GREATEST (120,50,70), LEAST(120,50,70),
         GREATEST ('A','홍길동',256), LEAST('송아지','망아지','개새끼'),
         GREATEST ('홍길동','홍길순','홍길남'), LEAST('홍길동','홍길순','홍길남')
    FROM DUAL;
    
사용예2) 회원테이블에서 마일리지가 1000 미만인 회원의 마일리지를 1000으로 부여하여 조회하시오
        1000이상인 회원은 그대로 출력
        Alias 는 회원번호, 회원명, 원본 마일리지, 변환 마일리지
        
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_MILEAGE AS 원본마일리지,
           GREATEST(MEM_MILEAGE, 1000) AS 변환마일리지
        FROM MEMBER;
        
3) ROUND(n [,loc]), TRUNC(n [,loc])
  - 제시된 수n에서 소숫점 이하 loc+1번째 자리에서 반올림(ROUND) 또는 자리버림(TRUNC) 하여 loc자리까지 반환
  - loc가 생략되면 0으로 간주됨
  - loc가 음수이면 양수쪽 loc 위치에서 반올림 또는 자리버림
  
사용예)
  SELECT ROUND(12345.6789,2),
         TRUNC(12345.6789,2),
         ROUND(12345.6789),
         TRUNC(12345.6789),
         ROUND(12365.6789,-2),
         TRUNC(12365.6789,-2)
     FROM DUAL;
     
사용예) 회원테이블에서 연령대별(GROUP) 평균마일리지, 회원수를 구하시오.
  SELECT  
        TRUNC (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS 연령대,
        AVG(MEM_MILEAGE) AS 평균마일리지,
        COUNT(*) AS 회원수
         
   FROM MEMBER
    GROUP BY TRUNC (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
    ORDER BY 1;
    
4) FLOOR(n), CEIL(n) - '**'
    -FLOOR : n과 같거나 작은쪽에서 가장 큰 정수(왼쪽에서 가장 가까운 정수)
    -CEIL : n과 같거나 큰쪽에서 가장 작은 정수(오른쪽에서 가장 가까운 정수)
    - 금액과 관련된 계산에 주로 사용

사용예)
    SELECT FLOOR(20), FLOOR(20.567), FLOOR(-20.567),
           CEIL(20), CEIL(20.567), CEIL(-20.567)
        FROM DUAL;
    
5) MOD(n,c)-'***', REMAINDER(n,c)-'*'
    -나머지를 반환
    -내부에 적용하는 함수가 MOD와 REMAINDER는 다름
    ex) a를 b로 나눈 나머지
        MOD : a-b * FLOOR(a/b)
  REMAINDER : a-b * ROUND(a/b)
  
    ex) MOD(27,5) : 27-5*FLOOR(27/5)
                    27-5*FLOOR(5.4)
                    27-5*5
                    27-25
                    2(나머지)
        REMAINDER(27,5) : 27-5*ROUND(27/5)
                          27-5*ROUND(5.4)
                          27-5*5
                          2(나머지)
                          
사용예) 키보드로 년도를 입력받아 그 해가 윤년인지 평년인지 판별하시오
       윤년 : 4의 배수이면서 100의 배수가 아니면서 400의 배수인 해
       
    ACCEPT P_YEAR PROMPT '년도입력(4자리수) :'
    DECLARE
      L_YEAR NUMBER := '&P_YEAR';
      L_RES VARCHAR2(200);
    BEGIN
      IF (MOD(L_YEAR,4)=0 AND MOD(L_YEAR,100)!=0) OR MOD(L_YEAR,400)=0 THEN
          L_RES:=L_YEAR|| '년은 윤년입니다.';
          ELSE
          L_RES:=L_YEAR|| '년은 평년입니다.';
          END IF;
          DBMS_OUTPUT.PUT_LINE(L_RES); -- JAVA의 Print문
          END;
    
6) WIDTH_BUCKET(n, min_val, max_val, b)
  -  min_val에서 max_val까지를 b개의 구간으로 나눌 때 n이 어느 구간에 속하는지
     속한 구간의 인덱스를 반환
  - 구간의 상한 값은 포함되지 않음 (n이 포함된 구간값은 max_val <= n < max_val)
  - 사용하는 구간의 수는 b+2개임(하한값 보다 작은 구간, b개의 구간, 상한값보다 크거나 같은 구간)
  
사용예) 회원테이블에서 마일리지를 1000-8000을 3개의 구간으로 구분하고 회원들의 마일리지가 어느 구간에 속하는지 나타내시오.
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_MILEAGE AS 마일리지,
           5-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,3) AS 구간값,
           CASE WHEN 5-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,3)IN(1,2) THEN '우수회원'
           WHEN 5-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,3) IN(3,4) THEN '보통회원'
           ELSE '초심회원'
           END AS 비고
        FROM MEMBER;
    
  