2023-0127-01)
 6) OUTER JOIN
  - 내부조인은 조인조건을 만족하는 자료를 대상으로 연산하고 조인조건을 만족하지 않는 자료는 모두 무시함.
  - 외부조인은 자료의 종류가 많은 쪽을 기준으로 부족한 쪽의 테이블에 NULL 값의 행을 추가하여 조인 수행.
  
(사용형식: 일반 외부조인)
 SELECT 컬럼LIST
   FROM 테이블1 [별칭1],테이블2 [별칭2], 테이블3 [별칭3],...
   WHERE 별칭1.컬럼명=별칭2.컬럼명(+) -- 테이블2가 부족한 경우
                :
   . 조인대상 테이블 중 데이터가 부족한 테이블 조인조건(대상 테이블) 에 외부조인 연산자'(+)'를 붙인다.
   . 외부조인 조건이 여러 개인 경우 모두 '(+)'를 붙여야 함.
   . 양쪽 모두 부족한 경우 허용되지 않음
   . 한번에 한 테이블에만 외부조인 할 수 있다.
  EX) A,B,C, 테이블이 외부조인 하는 경우 A=B(+) AND C=B(+)는 허용되지 않음
   . (+)연산자는 OR 연산자, IN 연산자와 같이 사용할 수 없음
   . 외부조인조건과 일반조건을 같이 기술하면 외부조인 결과를 얻을 수 없다
     해결책으로 ANSI외부조인으로 수행, 또는 서브쿼리를 사용한 외부조인으로 구성
   

(사용형식: ANSI 외부조인)
 SELECT 컬럼LIST --무조건 많은쪽으로
   FROM 테이블1 [별칭1]
   LEFT|RIGHT|FULL OUTER JOIN 테이블2 [별칭2]ON(조인조건 [AND 일반조건])
                        :
   [WHERE 일반조건]
   . 'LEFT|RIGHT|FULL' : FROM절 쪽의 테이블의 자료가 더 많은 경우 LEFT
                       FROM절 쪽의 테이블의 자료가 더 적은 경우 RIGHT
                       양쪽 모두 부족한 경우 FULL
   . 'WHERE 일반조건' : 모든 테이블에 공통으로 적용될 조건 기술(내부조인 결과로 변형될 위험이 상존)
   . 그 외 특징은 INNER JOIN과 동일
   
사용예) HR계정의 테이블을 이용하여 모든 부서별 사원수와 평균급여를 조회하시오.
(일반 외부조인)
  SELECT A.DEPARTMENT_ID AS 부서코드,
         A.DEPARTMENT_NAME AS 부서명,
         COUNT(B.EMPLOYEE_ID) AS 사원수, 
         NVL(ROUND(AVG(B.SALARY)),0) AS 평균급여
  FROM HR.DEPARTMENTS A, HR.EMPLOYEES B
  WHERE B.DEPARTMENT_ID(+)=A.DEPARTMENT_ID -- 외부조인조건
  GROUP BY A.DEPARTMENT_ID,A.DEPARTMENT_NAME
  ORDER BY 1;

(ANSI JOIN)
  SELECT A.DEPARTMENT_ID AS 부서코드,
         A.DEPARTMENT_NAME AS 부서명,
         COUNT(B.EMPLOYEE_ID) AS 사원수, 
         NVL(ROUND(AVG(B.SALARY)),0) AS 평균급여
  FROM HR.DEPARTMENTS A
       FULL OUTER JOIN HR.EMPLOYEES B ON (B.DEPARTMENT_ID=A.DEPARTMENT_ID) -- 외부조인조건
  GROUP BY A.DEPARTMENT_ID,A.DEPARTMENT_NAME
  ORDER BY 1;
  
  
사용예) 상품테이블과 분류테이블을 사용하여 분류별 상품의 수를 조회하시오.
  SELECT COUNT(*) FROM LPROD;
  SELECT COUNT(DISTINCT PROD_LGU) FROM PROD;
 
(일반 외부 JOIN) 
  SELECT A.LPROD_GU AS 분류코드,
         A.LPROD_NM AS 분류명,
         COUNT(B.PROD_ID) AS "상품의 수"
  FROM LPROD A, PROD B
  WHERE A.LPROD_GU=B.PROD_LGU(+)
  GROUP BY A.LPROD_GU,A.LPROD_NM
  ORDER BY 1;
  

(ANSI JOIN)
  SELECT A.LPROD_GU AS 분류코드,
         A.LPROD_NM AS 분류명,
         COUNT(B.PROD_ID) AS "상품의 수"
  FROM PROD B
  RIGHT OUTER JOIN LPROD A ON(A.LPROD_GU=B.PROD_LGU)
  GROUP BY A.LPROD_GU,A.LPROD_NM
  ORDER BY 1;
  
  
사용예) 2020년 4월 모든 상품별 매입집계(수량집계,금액집계)를 조회하시오.
 (일반 외부조인)
    SELECT B.PROD_ID AS 상품코드,
           B.PROD_NAME AS 상품명,
           NVL(SUM(A.BUY_QTY),0) AS 매입수량합계,
           NVL(SUM(A.BUY_QTY*B.PROD_COST),0) AS 매입금액집계
    FROM BUYPROD A, PROD B
    WHERE A.BUY_PROD(+)=B.PROD_ID
    AND A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
    GROUP BY B.PROD_ID,B.PROD_NAME
    ORDER BY 1;
    
(ANSI JOIN)
   SELECT B.PROD_ID AS 상품코드,
           B.PROD_NAME AS 상품명,
           NVL(SUM(A.BUY_QTY),0) AS 매입수량합계,
           NVL(SUM(A.BUY_QTY*B.PROD_COST),0) AS 매입금액집계
    FROM BUYPROD A
    RIGHT OUTER JOIN PROD B ON(A.BUY_PROD(+)=B.PROD_ID AND
                     A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
    GROUP BY B.PROD_ID,B.PROD_NAME
    ORDER BY 1;
    
(서브쿼리를 이용한 외부조인)
(서브쿼리: 2020년 4월 매입집계 : 내부조인)
  SELECT A.BUY_PROD AS BID,
         SUM(A.BUY_QTY) AS SCMT,
         SUM(A.BUY_QTY*B.PROD_COST) AS SAMT
  FROM BUYPROD A, PROD B
  WHERE A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
  AND A.BUY_PROD=B.PROD_ID
  GROUP BY A.BUY_PROD;
  
(메인쿼리: 모든 상품에 대한 상품코드, 상품명, 매입수량합계, 매입금액합계)
  SELECT P.PROD_ID AS 상품코드,
         P.PROD_NAME AS 상품명,
         NVL(C.SCNT,0) AS 매입수량합계,
         NVL(C.SAMT,0) AS 매입금액합계
  FROM PROD P, (SELECT A.BUY_PROD AS BID, --별칭 한글사용시 인식 잘 안될 수 있음.
                SUM(A.BUY_QTY) AS SCNT,
                SUM(A.BUY_QTY*B.PROD_COST) AS SAMT
                 FROM BUYPROD A, PROD B
                 WHERE A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
                 AND A.BUY_PROD=B.PROD_ID
                GROUP BY A.BUY_PROD)C
    WHERE P.PROD_ID=C.BID(+)
    ORDER BY 1;
 
사용예) 2020년 4월 모든 상품별 매출집계(수량집계,금액집계)를 조회하시오.
   SELECT  B.PROD_ID AS 상품코드,
           B.PROD_NAME AS 상품명,
           NVL(SUM(A.CART_QTY),0) AS 매출수량합계,
           NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS 매출금액합계
  FROM CART A
    RIGHT OUTER JOIN PROD B ON(A.CART_PROD=B.PROD_ID AND A.CART_NO '202004%')
    GROUP BY B.PROD_ID,B.PROD_NAME
    ORDER BY 1;
    
(SUB)
 SELECT   B.PROD_ID AS BID,
           NVL(SUM(A.CART_QTY),0) AS SCNT,
           NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS SAMT
    FROM CART A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
    AND A.CART_NO LIKE '202004%'
    GROUP BY B.PROD_ID,B.PROD_NAME
    ORDER BY 1;
    
(MAIN)
  SELECT P.PROD_ID AS 상품코드,
         P.PROD_NAME AS 상품명,
         NVL(C.SCNT,0)매출수량합계,
         NVL(C.SAMT,0)매출금액합계
  FROM PROD P,( SELECT   B.PROD_ID AS BID,
                         NVL(SUM(A.CART_QTY),0) AS SCNT,
                         NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS SAMT
                  FROM CART A, PROD B
                 WHERE A.CART_PROD=B.PROD_ID
                   AND A.CART_NO '202004%'
                GROUP BY B.PROD_ID,B.PROD_NAME)C
    WHERE P.PROD_ID=C.BID(+)
    ORDER BY 1;
    
문제] 2020년 6월 모든 상품별 매입/매출 집계를 조회하시오.
(SUB)
SELECT A.BUY_PROD AS BID,
         SUM(A.BUY_QTY) AS SCMT,
         SUM(A.BUY_QTY*B.PROD_COST) AS SAMT,
         NVL(SUM(C.CART_QTY),0) AS SCNT2,
         NVL(SUM(C.CART_QTY*B.PROD_PRICE),0) AS SAMT2
         
  FROM BUYPROD A, PROD B, CART C
  WHERE A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
  AND A.BUY_PROD=B.PROD_ID
  GROUP BY A.BUY_PROD;
    

  
(MAIN)
   SELECT P.PROD_ID AS 상품코드,
          P.PROD_NAME AS 상품명,
          NVL(C.SCNT,0) AS 매입수량합계,
          NVL(D.SCNT,0) AS 매출수량합계,
          NVL(C.SAMT,0) AS 매입금액합계,
          NVL(D.SAMT,0) AS 매출금액합계
  FROM PROD P, ( SELECT A.BUY_PROD AS BID,
                 SUM(A.BUY_QTY) AS SCMT,
                 SUM(A.BUY_QTY*B.PROD_COST) AS SAMT
             FROM BUYPROD A, PROD B 
             WHERE A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
               AND A.BUY_PROD=B.PROD_ID
          GROUP BY A.BUY_PROD)C, --매입집계
          
                (SELECT   B.PROD_ID AS BID,
                          SUM(A.CART_QTY) AS SCNT,
                          SUM(A.CART_QTY*B.PROD_PRICE) AS SAMT
                    FROM CART A, PROD B
                 WHERE A.CART_PROD=B.PROD_ID
                 AND A.CART_NO LIKE '202004%'
                 GROUP BY B.PROD_ID,B.PROD_NAME)D --매출집계
    WHERE P.PROD_ID=C.BID(+)
      AND P.PROD_ID=D.BID(+)
      ORDER BY 1;

(ANSI JOIN)   
 
   SELECT P.PROD_ID AS 상품코드,
          P.PROD_NAME AS 상품명,
          NVL(SUM(B.BUY_QTY),0) AS 매입수량합계,
          NVL(SUM(A.CART_QTY),0) AS 매출수량합계,
          NVL(SUM(B.BUY_QTY*P.PROD_COST),0) AS 매입금액합계,
          NVL(SUM(A.CART_QTY*P.PROD_PRICE),0) AS 매출금액합계
    FROM PROD P
    LEFT OUTER JOIN CART A ON(A.CART_PROD=P.PROD_ID AND A.CART_NO LIKE '202006%')
    LEFT OUTER JOIN BUYPROD B ON(P.PROD_ID=B.BUY_PROD AND B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630'))
    GROUP BY P.PROD_ID, P.PROD_NAME
    ORDER BY 1;

