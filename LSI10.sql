2023-0120-01) 그룹함수
  - 테이블에서 특정컬럼을 기준으로 같은 값을 갖는 자료들을 묶어놓은 집합을 그룹이라함
  - 이 그룹안에서 합계(SUM),평균(AVG), 자료의 수(COUNT), 최대/최소 값(MAX/MIN)을 반환해주는 함수
  - 다중행 함수임
  - 집계함수는 집계함수를 포함할 수 없음(단, 일반함수는 집계함수를 포함할 수 있고, 집계함수는 일반함수를 포함할 수있음)
 (사용형식)
    SELECT [컬럼명1 [AS 컬럼별칭1 ,]   
                  :
            --SELECT문에 일반컬럼 없이 그룹함수만 존재하면 GROUP BY절이 필요없음 /일반컬럼이 하나만 사용되면 그룹의 기준이되는 컬럼임
            SUM(col)|AVG(col)|COUNT(*|col)|MAX(col)|MIN(col) [,] --COUNT(*|col) * : NULL값도 하나의 행으로 취급 
                  :  --AVG는 소수점이 길게 나올수 있기때문에 ROUND나 TRUNC와 같이 사용
            [컬럼명n [AS 컬럼별칭n]
        FROM 테이블명
    [WHERE 조건] --일반조건(그룹함수에 조건이 붙는경우 사용불가)
    [GROUP BY 컬럼명[,컬럼명,...]]
    [HAVING 조건]
    [ORDER BY 컬럼명|컬럼인덱스 [ASC|DESC],...]
    . SELECT 절에 그룹함수가 아닌 일반컬럼이 기술되면 반드시 GROUP BY절을 기술해야 함
      SELECT 절에 그룹함수만 있으면 GROUP BY절은 생략가능  
    . GROUP BY 절에는 SELECT 절에 기술된 일반컬럼은 반드시 모두 기술해야함.
      SELECT 절에 기술되지 않은 컬럼도 필요하면 기술 가능
    . 그룹함수에 조건이 부여되면 반드시 HAVING 절에 기술해야 함
    . GROUP BY 절은 WHERE 절 다음에 기술하고, HAVING 절은 GROUP BY 절 다음에 기술해야함(순서 엄수)
    
사용예) 사원테이블에서 전체사원수, 전체평균임금, 임금합계를 조회하시오.
    SELECT COUNT(*) AS 전체사원수,
           ROUND(AVG(SALARY)) AS 전체평균임금, 
           SUM(SALARY) AS 임금합계
        FROM HR.EMPLOYEES; 

사용예) 사원테이블에서 부서별 사원수, 평균임금, 입금합계를 조회하시오.
    SELECT DEPARTMENT_ID AS 부서코드,
           COUNT(*) AS 사원수,
           ROUND(AVG(SALARY)) AS 평균임금,
           SUM(SALARY) AS 임금합계,
            -- 최대,최소 임금이 누구인지는 하나의 쿼리에서 작성불가
           MAX(SALARY) AS 최대임금,
           MIN(SALARY) AS 최소임금
        FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID --그룹함수와 일반컬럼이 같이 사용되었기 때문에 GROUP BY절 사용해야함!
        ORDER BY 1;
        
사용예) 매입테이블에서 2020년 1월 전체 매입금액 합계를 조회하시오.
    SELECT SUM(BUY_QTY * BUY_COST) AS "매입금액 합계", --일반컬럼이 같이사용되지 않았기때문에 GROUP BY 사용안함
           COUNT(*) AS 매입건수
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE(20200101) AND TO_DATE('20200131');

사용예) 매입테이블에서 2020년 제품별 매입수량 합계와 매입금액 합계, 매입건수를 조회하시오.
    SELECT BUY_PROD AS 상품코드,
           SUM(BUY_QTY) AS "매입수량 합계",
           SUM(BUY_QTY * BUY_COST) AS "매입금액 합계",
           COUNT(*) AS 매입건수
      FROM BUYPROD
      WHERE EXTRACT(YEAR FROM BUY_DATE)=2020
      GROUP BY BUY_PROD
      ORDER BY 1;

사용예) 매입테이블에서 2020년 월별 매입금액 합계, 매입건수를 조회하시오.
    SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월, --WHERE 실행후 월별로 나눔
           SUM(BUY_QTY * BUY_COST) AS "매입금액 합계",
           COUNT(*) AS 매입건수
        FROM BUYPROD
        WHERE EXTRACT(YEAR FROM BUY_DATE)=2020 --WHERE먼저실행
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
        ORDER BY 1;

사용예) 2020년 상반기 제품별 매출수량 합계와 매출금액 합계를 조회하시오.
    SELECT CART.PROD_ID AS 상품코드,
           SUM(CART.CART_QTY) AS 매출수량합계,
           SUM(CART.CART_QTY*PROD.PROD_PRICE)"매출금액합계"
      FROM CART, PROD
      WHERE CART.PROD_ID = PROD.PROD_ID
      AND SUBSTR(CART.CART_NO,1,6) BETWEEN '202001' AND '202006'
      GROUP BY CART.PROD_ID --CART테이블과 PROD 테이블의 PROD_ID가 같은 이름이기 때문에 구별을 위해 앞에 테이블.PROD_ID
      ORDER BY 1;
    
사용예) 매입테이블에서 2020년 월별 매입금액 합계, 매입건수를 조회하되 매입금액 합계가 1억원 이상인 월만 조회하시오.
    SELECT EXTRACT(MONTH FROM BUY_DATE)||'월' AS 월,
           SUM(BUY_QTY*BUY_COST) AS "매입금액 합계",
           COUNT(*) AS 매입건수   
    FROM BUYPROD
    WHERE EXTRACT(YEAR FROM BUY_DATE) =2020
     GROUP BY EXTRACT(MONTH FROM BUY_DATE)
     HAVING SUM(BUY_QTY*BUY_COST) >= 100000000
        ORDER BY 1;
        
사용예) 매입테이블에서 2020년 월별 매입금액 합계, 매입건수를 조회하되 매입금액 합계가 가장 많은 월을 출력하시오.
   SELECT A.AMON ||'월' AS 월,
          A.ASUM AS "매입금액 합계",
          A.ACNT AS 매입건수
   FROM (SELECT EXTRACT(MONTH FROM BUY_DATE)|| AS AMON,
           --MAX(SUM(BUY_QTY*BUY_COST)) AS "매입금액 합계", -그룹함수는 그룹함수를 포함 불가능
           SUM(BUY_QTY*BUY_COST) AS ASUM;
           COUNT(*) AS ACNT   
           FROM BUYPROD
           WHERE EXTRACT(YEAR FROM BUY_DATE) =2020
           GROUP BY EXTRACT(MONTH FROM BUY_DATE)
           ORDER BY 2 DESC)A
     WHERE ROWNUM=1;
     
PSEUDO 컬럼: 의사컬럼 => 시스템이 정의한 컬럼
 - ROWNUM: 행번호를 제공하는 컬럼

사용예) 2020년 상반기 월별 제품별 매출수량 합계와 매출금액 합계를 조회하시오.
    SELECT SUBSTR(A.CART_NO,5,2)||'월' AS 월,
           A.PROD_ID AS 제품코드,
           SUM(A.CART_QTY) AS "매출수량 합계",
           SUM(A.CART_QTY * B.PROD_PRICE) AS  "매출금액 합계"
    FROM CART A, PROD B
    WHERE A.PROD_ID = B.PROD_ID
    AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
    GROUP BY SUBSTR(A.CART_NO,5,2),A.PROD_ID --'월'로 먼저 그룹결정,제품코드순
    ORDER BY 1, 2;

사용예) 회원테이블에서 성별 평균 마일리지를 조회하시오.
    SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR 
                     SUBSTR(MEM_REGNO2,1,1)='3' THEN '남성회원'
                ELSE '여성회원'
           END AS 구분,
           ROUND(AVG(MEM_MILEAGE)) AS "평균 마일리지"
      FROM MEMBER
    GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR 
                     SUBSTR(MEM_REGNO2,1,1)='3' THEN '남성회원'
                ELSE '여성회원'
           END;
           
사용예) 회원테이블에 연령대별 평균마일리지를 조회하시오.
    SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS 연령대,
           ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지
           COUNT(*)AS 회원수
        FROM MEMBER
      GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
      ORDER BY 1;