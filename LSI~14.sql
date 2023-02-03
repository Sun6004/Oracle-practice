2023-0130-01) 서브쿼리(SUBQUERY)  --알려지지 않은 조건을 산출하기 위함
 - 서브쿼리는 쿼리안에 존재하는 또 다른 쿼리를 의미 함.
 - 주로 알려지지 않은 조건에 의존하여 질의를 처리해야 하는 경우 사용함
 - 서브쿼리는 '( )' 안에 기술해야함
 - INSERT 에 사용되는 서브쿼리는 '( )' 사용하지 않음
 - 연산자와 함께 사용할 때는 반드시 연산자 오른쪽에 위치
 - 서브쿼리의 실행 순서는 서브쿼리가 기술된 절의 순서에서 가장먼저 수행됨
 - 서브쿼리안에 서브쿼리를 사용가능
 - 서브쿼리의 종류
  . 메인쿼리와의 연관성 여부에 따라
   - 관련성있는 서브쿼리, 관련성 없는 서브쿼리
  . 기술된 위치에 따라
   - 일반서브쿼리(SELECT 절), 인라인 뷰 서브쿼리(FROM 절), 중첩서브쿼리(WHERE 절)

1. 관련성(연관) 없는 서브쿼리
 - 서브쿼리에 사용된 테이블과 메인쿼리에 사용된 테이블이 조인으로 연결되지 않은 서브쿼리
 
사용예) 사원테이블에서 사원들의 평균급여보다 더 많은 급여를 받는 사원수를 조회하시오.
  (메인쿼리 : 사원수)
   SELECT COUNT(*)
     FROM HR.EMPLOYEES
    WHERE SALARY >= (서브쿼리: 평균급여)
    
  (서브쿼리: 평균급여)
  SELECT AVG(SALARY)
    FROM HR.EMPLOYEES;
 
  (결합)
   SELECT COUNT(*)
     FROM HR.EMPLOYEES
    WHERE SALARY >= (SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES);
                       
  (연관성 있는 서브쿼리)
    SELECT COUNT(*)
     FROM HR.EMPLOYEES A, (SELECT AVG(SALARY) AS  ASAL
                             FROM HR.EMPLOYEES)B
    WHERE SALARY >= B.ASAL;
                       
사용예) 상품테이블에서 상품이 'P200'대의 분류에 속하며 크기정보가 없는 상품정보를 조회하시오
       Alias는 상품코드, 상품명, 분류코드, 분류명
  
(메인쿼리: 상품의 상품코드, 상품명, 분류코드, 분류명을 출력)
  SELECT 상품코드, 상품명, 분류코드, 분류명
  FROM PROD A, LPROD B
  WHERE PROD_LGU LIKE 'P2%'
  AND A. P.PRPOD_LGU = PROD_GU
  AND A.PROD_ID = (서브쿼리 : 크기정보를 보유하지 않은 상품)
  
(서브쿼리 : 크기정보를 보유하지 않은 상품
 SELECT PROD_ID
   FROM PROD
  WHERE PROD_SIZE IS NULL;
  
  (결합)
  (IN연산자사용)
  SELECT PROD_ID AS 상품코드,
         PROD_NAME AS 상품명,
         PROD_LGU AS 분류코드
   FROM PROD
  WHERE PROD_LGU LIKE 'P1%'
    AND PROD_ID IN (SELECT PROD_ID
                      FROM PROD
                     WHERE PROD_SIZE IS NULL);
                     
(EXISTS 연산자 사용 -> 연관성 있는 서브쿼리)
  SELECT A.PROD_ID AS 상품코드,
         A.PROD_NAME AS 상품명,
         A.PROD_LGU AS 분류코드
  FROM PROD A
  WHERE A.PROD_LGU LIKE 'P1%'
  AND EXISTS (SELECT 1
                FROM PROD B
               WHERE B.PROD_SIZE IS NULL
               AND A.PROD_ID=B.PROD_ID);
               

2. 연관성 있는 서브쿼리
 - 메인쿼리와 서브쿼리 사이에 조인연산이 존재하는 경우
 
사용예) 직무변동테이블(JOB_HISTORY)의 자료를 이용하여 직무변동사원 정보를 조회하시오.
       Alias는 사원번호, 사원명, 부서번호, 부서명
       
  SELECT A.EMPLOYEE_ID AS 사원번호,
        (SELECT B.EMP_NAME
            FROM HR.EMPLOYEES B
           WHERE B.EMPLOYEE_ID=A.EMPLOYEE_ID) AS 사원명,
         A.DEPARTMENT_ID AS 부서번호,
         (SELECT C.DEPARTMENT_NAME
           FROM HR.DEPARTMENTS C
           WHERE C.DEPARTMENT_ID=A.DEPARTMENT_ID) AS 부서명
    FROM HR.JOB_HISTORY A
    ORDER BY 1;
    
사용예) 2020년 상반기 상품별 매입수량을 조회하여 상위 5개상품의 상품코드,상품명,매입수량합계를 조회하시오.
  (메인쿼리 : 상위 5개상품의 상품코드, 상품명, 매입수량합계)
    SELECT P.PROD_ID AS 상품코드,
           P.PROD_NAME AS 상품명, 
           A.매입수량합계
      FROM PROD P, (서브쿼리)A
     WHERE P.PROD_ID=A.상품코드
       AND ROWNUM<=5;
  
  (서브쿼리 : 2020년 상반기 상품별 매입수량을 조회하여 매입수량을 기준으로 내림차순으로 출력)
    SELECT BUY_PROD AS 상품코드,
           SUM(BUY_QTY) AS BSUM
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
        GROUP BY BUY_PROD
        ORDER BY 2 DESC;
        
  (결합)
  SELECT   A.BUY_PROD AS 상품코드,
           P.PROD_NAME AS 상품명, 
           A.BSUM AS 매입수량합계
      FROM PROD P, (SELECT BUY_PROD,
                       SUM(BUY_QTY) AS BSUM
                    FROM BUYPROD
                    WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
                    GROUP BY BUY_PROD
                    ORDER BY 2 DESC)A
     WHERE P.PROD_ID=A.BUY_PROD
       AND ROWNUM<=5;
       
 ***다음 조건을 만족하는 재고 수불테이블을 생성하시오.
  1) 테이블명 : REMAIN
  2) 컬럼명세
   -------------------------------------------------------------------------------------
    컬럼명               데이터타입           N.N           PK&FK            DEFAULT VALUE
   ------------------------------------------------------------------------------------- 
   REMAIN_YEAR          CHAR(4)                           PK
   PROD_ID             VARCHAR2(10)                      PK&FK
   REMAIN_J_00          NUMBER(5)                                             0--기초재고
   REMAIN_J_I           NUMBER(5)                                             0--매입집계
   REMAIN_J_0           NUMBER(5)                                             0--출고수량집계          
   REMAIN_J_99          NUMBER(5)                                             0--현재고  
   REMAIN_DATE        DATE
  ---------------------------------------------------------------------------------------
  
  3. DML 명령과 서브쿼리
   1)INSERT 문
   - 삽입할 자료를 서브쿼리로 정의
 (사용형식)
   INSERT INTO 테이블명[(컬럼list)]
    서브쿼리;
  . INSERT 문에서 서브쿼리를 사용할 경우 VALUES 절을 생략하고 '( )'를 생략함
  . '서브쿼리' 내의 SELECT 절에 기술하는 컬럼의 개수, 순서, 타입과 '테이블명[(컬럼list)]'의
    컬럼list의 컬럼의 개수, 순서, 타입은 일치해야 함
    
사용예) 생성한 재고수불 테이블에 다음 자료를 입력하시오
    [자료]
    . 년도 : '2020'
    . 상품코드 : PROD테이블의 상품코드
    . 기초재고 : 상품테이블의 PROD_PROPERSTOCK의 값
    . 매입/매출 수량 : 없음
    . 기말재고 : 상품테이블의 PROD_PROPERSTOCK의 값
    . 날짜 : 2020년 1월 1일
  INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID,REMAIN_J_00,REMAIN_J_99,REMAIN_DATE)
    SELECT '2020',PROD_ID,PROD_PROPERSTOCK,PROD_PROPERSTOCK,TO_DATE('20200101') 
     FROM PROD;
     
    SELECT * FROM REMAIN;
    COMMIT;
    
2) UPDATE 
 - SET 절에 필요한 자료를 서브쿼리를 이용하는 경우
 (사용형식)
 UPDATE 테이블명 [별칭]
    SET (컬럼명[,컬럼명,...])=(서브쿼리)
  [WHERE 조건];
  . (컬럼명[,컬럼명,...]) : 변경시킬 자료가 저장될 컬럼명으로 복수개가 기술될 수 있다.
  . 복수개가 기술될 컬럼명의 개수,순서,타입은 서브쿼리의 SELECT 절에 기술되는 컬럼명의 개수,순서,타입과 일치해야 함.

사용예) 2020년 1월 제품별 매입수량합계를 구하여 재고수불테이블을 갱신하시오.

(서브쿼리 : 2020년 1월 제품별 매입수량합계)
  
  SELECT BUY_PROD,--필요없음
         SUM(BUY_QTY)
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
    GROUP BY BUY_PROD;
    
(메인쿼리)
UPDATE REMAIN A
  SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) =        
      (SELECT A.REMAIN_I+B.SAMT, A.REMAIN_J_99+B.SAMT, TO_DATE('20200331')--새로운 매입수량을 기존매입수량에 더해야해서 +매입수량 한번 더 기술
        FROM (SELECT BUY_PROD,SUM(BUY_QTY) AS SAMT
                FROM BUYPROD
               WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200331')
               GROUP BY BUY_PROD)B
        WHERE A.PROD_ID=B.BUY_PROD)
   WHERE A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                       FROM BUYPROD
                       WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200331'));
        
ROLLBACK;
COMMIT;

사용예) 2020년 4월 제품별 매입수량합계와 매출수량합게를 구하여 재고수불테이블을 갱신하시오.

 (서브쿼리 : 2020년 4월 제품별 매입수량합계와 매출수량합계)
   SELECT C.PROD_ID AS 제품코드,
          NVL(SUM(B.BUY_QTY),0) AS 매입수량합계,
          NVL(SUM(A.CART_QTY),0) AS 매출수량합계
     FROM CART A
     RIGHT OUTER JOIN PROD C ON(A.CART_PROD=C.PROD_ID AND A.CART_NO LIKE '202004%')
     LEFT OUTER JOIN BUYPROD B ON(C.PROD_ID=B.BUY_PROD
     AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))          
    GROUP BY C.PROD_ID;      
    
  -- 4월에 발생된 매입상품
  SELECT DISTINCT(BUY_PROD)
    FROM BUYPROD
   WHERE BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430');
   
  --4월에 발생된 매출상품
  SELECT DISTINCT(CART_PROD)
    FROM CART
   WHERE CART_NO LIKE '202004%';
   
(메인쿼리 : 재고수불테이블을 갱신)
  UPDATE REMAIN R
     SET (R.REMAIN_I, R.REMAIN_O, R.REMAIN_J_99, R.REMAIN_DATE)=
         (SELECT R.REMAIN_I+D.SIMT,R.REMAIN_O+D.SOMT,R.REMAIN_J_99+D.SIMT-D.SOMT,
                 TO_DATE('20200430')
            FROM(SELECT C.PROD_ID AS CPID,
                        NVL(SUM(B.BUY_QTY),0) AS SIMT,
                        NVL(SUM(A.CART_QTY),0) AS SOMT
                   FROM CART A
                  RIGHT OUTER JOIN PROD C ON(A.CART_PROD=C.PROD_ID AND A.CART_NO LIKE '202004%')
                   LEFT OUTER JOIN BUYPROD B ON(C.PROD_ID=B.BUY_PROD
                    AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))          
                    GROUP BY C.PROD_ID)D   
            WHERE D.CPID=R.PROD_ID);