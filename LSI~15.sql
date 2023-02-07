2023-0131-01) 집합 연산자
 - 여러 쿼리의 결과에 대한 집합연산을 수행
 - 합집합(UNION, UNION ALL), 교집합(INTERSECT), 차집합(MINUS) 결과 반환
 (주의사항)
 - 모든 SELECT절의 컬럼의 수와 타입은 동일해야함.
 - 컬럼의 별칭은 첫 번째 SELECT 문의 SELECT 절의 것이 사용됨.
 - ORDER BY 절은 맨 마지막 SELECT 문에서만 사용됨.
 - CLOB,BLOB,BFILE 타입은 사용 불가
 
1. 합집합
 - UNION ALL : 교집합 부분은 중복 반환되는 합집합 -- 교집합부분 중복출력
 - UNION : 중복이 배제된 합집합 --교집합부분 한번만 출력
 사용예)2020년 4월과 5월에 판매된 모든 상품명을 출력하시오
   SELECT A.CART_PROD AS 상품코드,
          B.PROD_NAME AS 상품명,
          SUM(CART_QTY) AS 판매수량
     FROM CART A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
      AND A.CART_NO LIKE '202004%'
    GROUP BY A.CART_PROD, B.PROD_NAME
  UNION
   SELECT A.CART_PROD,
          B.PROD_NAME,
          SUM(A.CART_QTY)
     FROM CART A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
      AND A.CART_NO LIKE '202005%'
    GROUP BY A.CART_PROD, B.PROD_NAME  
     ORDER BY 1;
     
사용예) 회원테이블에 대전에 거주하는 회원과 직업이 학생인 회원의 회원번호, 회원명, 직업, 거주지, 마일리지를 조회하시오.
(조인을 사용한 경우)
  SELECT A.MEM_ID AS 회원번호,
         A.MEM_NAME AS 회원명,
         A.MEM_JOB AS 직업, 
         A.MEM_ADD1 AS 거주지, 
         A.MEM_MILEAGE AS 마일리지
    FROM (SELECT *
            FROM MEMBER
           WHERE MEM_ADD1 LIKE '대전%')A,
          (SELECT MEM_ID,MEM_JOB,MEM_ADD1
             FROM MEMBER
            WHERE MEM_JOB='학생')B
    WHERE A.MEM_ID=B.MEM_ID(+);
       
(UNION 사용)
 SELECT  MEM_ID AS 회원번호,
         MEM_NAME AS 회원명,
         MEM_JOB AS 직업, 
         MEM_ADD1 AS 거주지, 
         MEM_MILEAGE AS 마일리지
    FROM SELECT *
            FROM MEMBER
           WHERE MEM_ADD1 LIKE '대전%'
  UNION
   SELECT MEM_ID,MEM_NAME,MEM_ADD1,MEM_MILEAGE
    FROM MEMBER
    WHERE MEM_JOB='학생'
    GROUP BY 1;   
   
2. 교집합
 - 공통으로 포함된 원소만 반환
 - INTERSECT 연산자 사용
 
사용예) 매입테이블에서 1월과 4월에 모두 매입된 상품정보를 조회하시오
       Alias는 상품코드, 상품평, 매입단가, 매입처
 (조인)
  SELECT C.PROD_ID AS 상품코드,
         C.PROD_NAME AS 상품명, 
         C.PROD_COST AS 매입단가, 
         C.PROD_BUYER AS 매입처
    FROM (SELECT DISTINCT BUY_PROD
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'))A,
         (SELECT DISTINCT BUY_PROD
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY(TO_DATE('20200401')))B,
         PROD C
    WHERE C.PROD_ID=A.BUY_PROD
      AND C.PROD_ID=B.BUY_PROD
   ORDER BY 1;
   
(집합연산자 INTERSECT 사용)   
  SELECT BUY_PROD,PROD_NAME,PROD_COST,PROD_BUYER
    FROM BUYPROD A, PROD B
   WHERE A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
     AND A.BUY_PROD=B.PROD_ID
  INTERSECT 
  SELECT BUY_PROD,PROD_NAME,PROD_COST,PROD_BUYER
    FROM BUYPROD A, PROD B
   WHERE A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430') 
     AND A.BUY_PROD=B.PROD_ID
   ORDER BY 1;

사용예) 2020년 4월과 5월 매출수량 합계가 10개 이상인 상품정보를 조회하시오.
       Alias는 상품코드, 상품명, 매출단가
       
  SELECT A.CART_PROD AS 상품코드,
         B.PROD_NAME AS 상품명, 
         B.PROD_PRICE AS 매출단가
    FROM(SELECT CART_PROD,
                SUM(CART_QTY)
           FROM CART
          WHERE CART_NO LIKE '202004%'
          GROUP BY CART_PROD
          HAVING SUM(CART_QTY)>=10)A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
  INTERSECT
   SELECT A.CART_PROD, B.PROD_NAME, B.PROD_PRICE
    FROM(SELECT CART_PROD,
                SUM(CART_QTY)
           FROM CART
          WHERE CART_NO LIKE '202005%'
          GROUP BY CART_PROD
          HAVING SUM(CART_QTY)>=10)A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
    ORDER BY 1;
    
3. 차집합
 - MINUS 연산자를 사용하여 특정 결과 집합에만 존재하는 결과 반환
 
사용예) 매입테이블에서 2020년 1월과 4월중 1월에만 매입된 상품의 상품코드,상품명,매입단가를 구하시오
  
 (2020년 1월 매입)
  SELECT A.BUY_PROD AS 상품코드,
         B.PROD_NAME AS 상품명,
         B.PROD_COST AS 매입단가
    FROM BUYPROD A, PROD B
   WHERE A.BUY_PROD=B.PROD_ID
     AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
  MINUS
 --(2020년 4월 매입)
 SELECT A.BUY_PROD AS 상품코드,
         B.PROD_NAME AS 상품명,
         B.PROD_COST AS 매입단가
    FROM BUYPROD A, PROD B
   WHERE A.BUY_PROD=B.PROD_ID
     AND A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
    ORDER BY 1;
    
사용예) 2020년 6월 매입매출 중 매입만 발생된 상품의 상품코드와 상품명을 조회하시오.
  SELECT A.BUY_PROD AS 상품코드,
         B.PROD_NAME AS 상품명
    FROM BUYPROD A, PROD B
   WHERE A.BUY_PROD=B.PROD_ID
     AND A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
   MINUS  
     SELECT A.CART_PROD AS 상품코드,
            B.PROD_NAME AS 상품명
    FROM CART A, PROD B
    WHERE A.CART_NO LIKE '202006%'
     AND A.CART_PROD=B.PROD_ID
     ORDER BY 1;
     
    
   
   
 