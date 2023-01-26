2023-0118-01) 날자함수
  1) SYSDATE - '****', SYSTIMESTAMP - '***'
    - 현재의 날자와 시간을 DATE와 TIMESTAMP타입으로 반환
    
사용예)
    SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;
    
    SELECT SYSDATE+3, SYSDATE-19 FROM DUAL;
    
2) ADD_MONTHS(d, n) -**-
  - 주어진 날자 d에 n개월을 더한 날자를 반환
  - 반환되는 데이터 타입은 날자타입
  
사용예) HR계정의 사원테이블에서 입사일에 10년을 더한 날자로 변경하시오.
  . 현재 내용 보관
    CREATE TABLE T_EMP AS
      SELECT * FROM HR.EMPLOYEES;
  . 사원테이블 내용 변경
    UPDATE HR.EMPLOYEES
      SET HIRE_DATE=ADD_MONTHS(HIRE_DATE,120);
      
      COMMIT;
      
      SELECT EMP_NAME,HIRE_DATE
        FROM HR.EMPLOYEES;
        
3) MONTHS_BETWEEN(d1,d2) -'**'
  - 두 날자 자료 d1과 d2사이의 개월수를 반환
  - d1 > d2인 경우 양수의 개월수 반환
  - d1 < d2인 경우 음수의 개월수 반환
  
사용예)
  SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('20010415'))
    FROM DUAL;
  => 소수점을 없애려면
  SELECT ROUND(MONTHS_BETWEEN(SYSDATE, TO_DATE('20230101')))
    FROM DUAL;
사용예) 사원테이블에서 입사일을 활용하여 각 사원의 근속년수를 정확하게 XX년 XX월
       형식으로 조회하시오.
       Alias는 사원번호, 사원명, 입사일, 근속기간
       SELECT EMPLOYEE_ID AS 사원번호,
              FIRST_NAME || LAST_NAME AS 사원명,
              HIRE_DATE AS 입사일,
              ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))||'개월' AS 개월수,
              TRUNC(ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))/12) ||'년' ||
              MOD(ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)),12)||'개월' AS 근속기간
              
            FROM HR.EMPLOYEES;
            
 4) NEXT_DAY(d, 'fmt')
  - 기준일 d일 이후 처음 만나는'fmt' 요일에 해당하는 날자 반환
  - 'fmt' 는 날자표현 언어에 따라 달라짐
   . 날자표현언어가 영어인 경우 : SUNDAY, SUN..
   . 날자표현언어가 한글인 경우 : 일요일, 일,월, 화요일
   .요일의 INDEX값(1:일요일, 2:월요일,..7:토요일)
   
사용예)
  SELECT NEXT_DAY(SYSDATE,'수요일'),
         NEXT_DAY(SYSDATE,4) --일요일1부터시작하는 요일에 따른 INDEX값
    FROM DUAL;
    
5)LAST_DAY(d) - '***'
 - 주어진 날자 d에 표현된 월의 마지막일자를 반환
 - 주로 임의년도의 2월의 마지막일이 필요한 경우 또는 임의의 월을 입력받아
   해당월의 마지막일을 구할 때 사용

사용예)매입테이블에서 2020년 2월 제품별 매입수량과 매입금액 합계를 조회하시오.
    SELECT BUY_PROD AS 상품코드,
           SUM(BUY_QTY) AS 매입수량,
           SUM(BUY_QTY*BUY_COST) AS 매입금액
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND LAST_DAY(TO_DATE('20200201'))
        GROUP BY BUY_PROD;
        
 사용예) 키보드로 년도와 월을 6자리 문자로 입력받아 해당 기간동안 발생된 매입건수를 출력하시오.
    ACCEPT P_PERIOD PROMPT '기간 입력(YYYYMM) : '
    DECLARE
      L_SDATE DATE := TO_DATE('&P_PERIOD'||'01');
      L_SDATE DATE := LAST_DAY(L_SDATE);
      L_COUNT NUMBER := 0;
    BEGIN
      SELECT COUNT(*) INTO L_COUNT
        FROM BUYPROD
      WHERE BUY_DATE BETWEEN L_SDATE AND L_EDATE;
      
      DBMS_OUTPUT.PUT_LINE(SUBSTR('&P_PERIOD',4)||'년'||SUBSTR('&P_PERIOD',5)||
      '월 매입 건수: '|| L_COUNT);
    END;
    
            