2023-0125-01) ROLLUP 과 CUBE함수
  - GROUP BY 절 안에서 사용되어 다양한 집계를 반환함
1. ROLLUP(col1,col2,***)
  - ROLLUP 에 사용된 칼럼명들로 레벨을 구성하고 각 레벨별 합계(중간 합계)를 반환
  - 레벨을 ROLLUP 절에 사용된 모든 컬럼이 적용된 경우가 최 하위레벨이고 이후에 
    오른쪽 컬럼부터 1개씩 제거한 값으로 레벨이 구성됨. 마지막에는 모든 칼럼이 제거된
    (전체테이블)전체 합계가 반환됨
  - 사용된 컬럼의 수가 n개이면P+1,가지의 집계가 반환됨
  - 일부의 컬럼만 ROLLUP 절 안에 기술되고 나머지 그룹기준 컬럼이 ROLLUP밖에 기술된 경우를 부분 ROLLUP이라함
  
  
사용예) 장바구니 테이블에서 2020년 월별,회원별,제품별,매출수량집계을 구하시오(GROUP BY절만 사용)
SELECT SUBSTR(CART_NO,5,2) AS 월,
       CART_MEMBER AS 회원별,
       CART_PROD AS 제품별,
       SUM(CART_QTY) AS 매출수량집계
  FROM CART
  WHERE SUBSTR(CART_NO,1,4)='2020'
  GROUP BY ROLLUP(SUBSTR(CART_NO,5,2),CART_MEMBER,CART_PROD)
  --GROUP BY SUBSTR(CART_NO,5,2),ROLLUP(CART_MEMBER,PROD_ID):부분ROLLUP(전체집계 안나옴)
   ORDER BY 1;
  
2. CUBE(col1,col2,...)
  - 사용된 컬럼명을 조합사용하여 나올 수 있는 모든 경우의 수만큼의 집계를 반환
  - 레벨을 사용하지 않음
  - 사용된 컬럼이 n개일때 반환되는 집계의 종류는 2^n가지임
  
  (CUBE함수 사용)
SELECT SUBSTR(CART_NO,5,2) AS 월,
       CART_MEMBER AS 회원별,
       PROD_ID AS 제품별,
       SUM(CART_QTY) AS 매출수량집계
  FROM CART
  WHERE SUBSTR(CART_NO,1,4)='2020'
  GROUP BY CUBE(SUBSTR(CART_NO,5,2),CART_MEMBER,PROD_ID)
  --GROUP BY SUBSTR(CART_NO,5,2),CUBE(CART_MEMBER,PROD_ID) 부분CUBE: CART_NO는 항상 포함시키고 CUBE로 묶은 컬럼을 조합
  ORDER BY 1;
  

조인(JOIN)
  - 필요한 데이터가 여러 테이블에 분산되어 있고 각 테이블들이 관계를 맺고 있을 때 수행하는 연산
  - 관계(RELATIONSHIP)을 이용한 연산
  - 구분
   . 조인 연산자에 따라 동등조인(Equi JOIN), 비동등조인(Non Equi JOIN)
   . 조인 대상에 따라 : 셀프조인(SELF JOIN)
   . 조인 조건에 따라 : 내부조인(INNER JOIN), 외부조인(OUTER JOIN), 카타시안(CARTASIAN, CROSS JOIN), 세미조인(SEMI JOIN)
   . 기타 : ANSI JOIN
1. 내부조인
  - 조인조건을 만족하는 행만 결과로 반환하고 조인조건을 만족하지 않는 데이터는 무시함.
 1) 카타시안(CARTASIAN, CROSS JOIN)
  - 조인조건이 없거나 조인조건을 잘못 기술한 경우
  - 반드시 필요한 경우가 아니면 수행하지 말아야 함
  - A(a행 b열) B 두 테이블에 카타시안 조인을 수행하면 결과는 최악의 경우(조인조건이 없는 경우)a*c 행 b+d열이 반환
사용예) 
  SELECT COUNT(*) FROM BUYPROD; -- 매입테이블의 모든 행의 수 
  SELECT COUNT(*) FROM CART; -- 매출테이블의 모든 행의 수
  SELECT COUNT(*) FROM PROD; -- 상품테이블의 모든 행의 수
  SELECT 148*207*74 FROM DUAL;
  
  SELECT COUNT(*)
    FROM BUYPROD, CART, PROD;--BUYPROD*CART*PROD
  SELECT * FROM BUYPROD, CART, PROD;
  
 1-2) CROSS JOIN
  . ANSI에서 제공하는 CARTESIAN PRODECT
(사용형식)
 SELECT 컬럼list
    FROM 테이블명1 [별칭1]
    CROSS JOIN 테이블명2 [별칭2] [ON(조인조건)][,]
                        :
    CROSS JOIN 테이블명n [별칭n] [ON(조인조건)]
    
사용예)
  SELECT COUNT(*)
    FROM BUYPROD A
  CROSS JOIN CART B
  CROSS JOIN PROD C; -- =카타시안
  
  
 2) 동등조인(Equi JOIN)
  - JOIN조건문에 사용하는 연산자가 '='인 조인
(사용형식:일반 조인)
 SELECT [테이블별칭.|테이블명]컬럼명 [AS 컬럼별칭][,]
                         :
        [테이블별칭.|테이블명]컬럼명 [AS 컬럼별칭]
    FROM 테이블명1 [별칭1], 테이블명2 [별칭2] [,테이블명3 [별칭3],...]
    WHERE JOIN조건
    [AND 일반조건]
    .'테이블별칭.테이블명' : 모든 컬럼명이 다르면 생략 가능
    . 사용된 테이블의 개수가 n개일때 '조인조건'의 개수는 적어도n-1개 이상이어야 함★
    
  (사용형식: ANSI INNER JOIN)
  SELECT [테이블별칭.|테이블명]컬럼명 [AS 컬럼별칭][,]
                         :
        [테이블별칭.|테이블명]컬럼명 [AS 컬럼별칭]
    FROM 테이블1 [별칭1]
    INNER JOIN 테이블2 [별칭2] ON(조인조건[AND 일반조건])
    INNER JOIN 테이블3 [별칭3] ON(조인조건[AND 일반조건])
                            :
    [WHERE 일반조건]
    . 테이블1과 테이블2 는 반드시 직접 조인 가능해야 함
    . '[AND 일반조건]' : 해당 테이블에만 적용되는 조건 기술
    . 'WHERE 일반조건' : 공통으로 적용된 일반조건 기술
    . 테이블1과 테이블2가 조인된 결과와 테이블 3이 조인됨
   
   
사용예) 사원테이블에서 20~40번 부서에 소속된 사원의 사원번호,사원명,부서번호,부서명,직무명을 조회하시오
(일반조인문) 
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_ID AS 부서번호,
           B.DEPARTMENT_NAME AS 부서명,
           C.JOB_TITLE AS 직무명
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C
      WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID --JOIN조건
      AND A.JOB_ID=C.JOB_ID --JOIN조건
      AND A.DEPARTMENT_ID BETWEEN 20 AND 40 --일반조건
      ORDER BY 3;

(ANSI JOIN)
  SELECT  A.EMPLOYEE_ID AS 사원번호,
          A.EMP_NAME AS 사원명,
          B.DEPARTMENT_ID AS 부서번호,
          B.DEPARTMENT_NAME AS 부서명,
          C.JOB_TITLE AS 직무명
      FROM HR.EMPLOYEES A
      INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID AND
                 A.DEPARTMENT_ID BETWEEN 20 AND 40)
      INNER JOIN HR.JOBS C ON(A.JOB_ID=C.JOB_ID)
      ORDER BY 3;
      
사용예)2020년 4월 상품별 매출집계를 조회하시오 Alias는 상품코드, 상품명, 매출수량합계, 매출금액합계
  SELECT A.CART_PROD AS 상품코드,
         B.PROD_NAME AS 상품명,
         SUM(A.CART_QTY) AS 매출수량합계,
         SUM(A.CART_QTY*B.PROD_PRICE) AS 매출금액합계
   FROM CART A
   INNER JOIN PROD B ON(A.CART_PROD=B.PROD_ID)--JOIN조건
   WHERE A.CART_NO LIKE '202004%'
   GROUP BY A.CART_PROD,B.PROD_NAME
   ORDER BY 1;
   
사용예) 2020년 1-6월 거래처별 매입집계를 조회하시오.Alias는 거래처코드, 거래처명, 매입금액 합계
    SELECT A.BUYER_ID AS 거래처코드,
             A.BUYER_NAME AS 거래처명,
             SUM(B.BUY_QTY*C.PROD_COST) AS "매입금액 합계"
    FROM BUYER A, BUYPROD B, PROD C
    WHERE B.BUY_PROD=C.PROD_ID --JOIN
     AND  C.PROD_BUYER=A.BUYER_ID --JOIN
     AND B.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
     GROUP BY A.BUYER_ID, A.BUYER_NAME
     ORDER BY 1;
     
(ANSI FORMAT)
    SELECT A.BUYER_ID AS 거래처코드,
             A.BUYER_NAME AS 거래처명,
             SUM(B.BUY_QTY*C.PROD_COST) AS "매입금액 합계"
    FROM BUYER A
    INNER JOIN PROD C ON(C.PROD_BUYER=A.BUYER_ID)
    INNER JOIN BUYPROD B ON(B.BUY_PROD=C.PROD_ID AND
      B.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630'))
     GROUP BY A.BUYER_ID, A.BUYER_NAME
     ORDER BY 1;
     
문제) HR계정에서 미국 이외의 국가에 있는 부서에 근무하는 사원들을 조회하시오
     Alias는 사원번호, 사원명, 부서코드, 부서명, 부서주소 (미국의 국가코드는 US)
     SELECT A.EMPLOYEE_ID AS 사원번호,
            A.EMP_NAME AS 사원명,
            B.DEPARTMENT_ID AS 부서코드,
            B.DEPARTMENT_NAME AS 부서명,
            C.STATE_PROVINCE || ' ' || C.CITY ||' '|| C.STREET_ADDRESS AS 부서주소
     FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID AND B.LOCATION_ID=C.LOCATION_ID
       AND C.COUNTRY_ID NOT IN('US')
       ORDER BY 3;

(ANSI FORMAT)
SELECT A.EMPLOYEE_ID AS 사원번호,
            A.EMP_NAME AS 사원명,
            B.DEPARTMENT_ID AS 부서코드,
            B.DEPARTMENT_NAME AS 부서명,
            C.STATE_PROVINCE || ' ' || C.CITY ||' '|| C.STREET_ADDRESS AS 부서주소
     FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
     INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID)
     INNER JOIN HR.LOCATIONS C ON(B.LOCATION_ID=C.LOCATION_ID AND C.COUNTRY_ID !='US')
     INNER JOIN HR.COUNTRIES ON(B.LOCATION_ID=C.LOCATION_ID)
     WHERE  AND B.LOCATION_ID=C.LOCATION_ID
       AND C.COUNTRY_ID NOT IN('US')
       ORDER BY 3;
     
     