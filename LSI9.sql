2023-0119-01)NULL처리 함수
  - 오라클의 기본 초기화 값은 기억공간의 데이터 타입에 관계없이 NULL임
  - NULL타입의 자료와 어떤 타입의 자료가 연산(사칙,비교)되면 결과가 NULL임
  - NULL 처리를 위한 함수와 연산자 : IS [NOT] NULL, NVL, NVL2, NULLIF등이 제공
  
1. IS [NOT] NULL
 . 특정 컬럼이나 식의 값이 NULL인지 판별하여 TRUE OR FALSE 를 반환
 . 동등연산자 '='으로는 NULL을 판별할 수 없음
 
사용예) 상품테이블에서 색상정보(PROD_COLOR)가 없는 상품의 상품번호,상품명,크기,색상을 조회하시오.
        
    SELECT PROD_ID AS 상품번호,
           PROD_NAME AS 상품명,
           PROD_SIZE AS 크기,
           PROD_COLOR AS 색상
        FROM PROD
        WHERE PROD_COLOR IS NOT NULL;
        
2. NVL(expr,val)
  - 'expr'값이 NULL이면 'val'을 출력하고, NULL이 아니면 expr값을 출력
  - 'expr'과 'val'은 같은 타입이어야 함
  
사용예) 사원테이블에서 영업실적이 NULL이면 '영업실적없음'을, 영업실적이 있으면 영업실적을 비고란에 출력
       Alias는 사원번호, 사원명, 부서코드, 직무코드, 비고
    SELECT EMPLOYEE_ID AS 사원번호,
           EMP_NAME AS 사원명,
           DEPARTMENT_ID AS 부서코드,
           JOB_ID AS 직무코드,
           NVL(TO_CHAR(COMMISSION_PCT,'0.00'),'영업실적없음') AS 비고   
        FROM HR.EMPLOYEES;
        
**매입테이블에서 매입된 상품의 분류코드의 종류 및 매입수량 합계
  SELECT B.LPROD_GU AS 분류코드,
         SUM(A.BUY_QTY) AS 매입수량합계
    FROM BUYPROD A, LPROD B, PROD C
    WHERE A.BUY_PROD=C.PROD_ID
      AND C.PROD_LGU=B.LPROD_GU
      GROUP BY B.LPROD_GU
      ORDER BY 1;
    
사용예) 모든 분류코드별 평균매입가를 구하시오.
    SELECT LPROD_GU AS 분류코드,
           ROUND(AVG(A.PROD_COST)) AS 평균매입가
        FROM PROD A, LPROD B
    WHERE A.PROD_LGU(+)=B.LPROD_GU
    GROUP BY B.LPROD_GU
    ORDER BY 1;

**상품테이블에 사용하는 분류코드의 종류
  SELECT DISTINCT PROD_LGU
    FROM PROD;
  
3. NVL2(expr,val1,val2) --NULL이거나 아닐때, 서로 다른값을 출력하기 위해 사용.
  - 'expr'값이 NULL이면 val2를 반환하고, NULL이 아니면 val1을 반환함
  - val1과 val2는 반드시 같은 데이터 타입이어야 함
  - NVL2는 NVL을 포함할 수 있음
  
** 상품테이블에서 분류코드가 P301에 속한 상품들의 판매가를 매입가로 변경하시오.
  UPDATE PROD 
    SET PROD_PRICE = PROD_COST
    WHERE UPPER(PROD_LGU) = 'P301';
    
    COMMIT; --저장
    
    ROLLBACK;-- 실수로 잘못봐꿨을때 되돌림
    
사용예) 상품테이블에서 상품의 크기(PROD_SIZE)정보를 조회하여 크기정보가 없으면
       '크기 정보 없음'을 크기 정보가 있으면 '크기 : '문자열과 크기정보를 출력하시오
       Alias는 상품코드, 상품명, 크기, 비고     
    SELECT PROD_ID AS 상품코드,
           PROD_NAME AS 상품명,
           NVL2 (PROD_SIZE, '크기: ' || PROD_SIZE, '크기정보없음') AS 비고  
      FROM PROD;
    
사용예) 사원테이블에서 영업실적COMMISSION_PCT)을 조회하여 영업실적이 없으면 비고에 '실적없음'을 출력하고 
       영업실적이 있으면 해당 부서코드(DEPARTMENT_ID)를 출력하시오.
       Alias는 사원번호, 사원명, 입사일, 비고
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              HIRE_DATE AS 입사일,
              NVL2(COMMISSION_PCT, NVL(TO_CHAR(DEPARTMENT_ID),'부서없음'),'실적없음') AS 비고
        FROM HR.EMPLOYEES;
        
3. NULLIF(COL1,COL2)-'**'
  - COL1 과 COL2를 비교하여 같은 값이면 NULL을 반환하고 서로 다른값이면 COL1을 반환

사용예) 상품테이블에서 매출가와 매입가가 동일하면 수익란에'단종예정상품'을, 서로 다르면
       판매가에서 매입가를 뺀 이익금액을 출력하시오
       Alias는 상품코드, 상품명, 수익
   SELECT PROD_ID AS 상품코드,
          PROD_NAME AS 상품명,
          NVL2(NULLIF(PROD_COST,PROD_PRICE),TO_CHAR(PROD_PRICE-PROD_COST,'9,999,999'),'단종예정상품') AS 수익1,
     CASE WHEN NULLIF(PROD_COST,PROD_PRICE) IS NULL THEN '단종예정'
     ELSE TO_CHAR(PROD_PRICE-NULLIF(PROD_COST,PROD_PRICE),'9,999,999')
     END AS 수익2
     FROM PROD;
    
    
    
    
    
    
    
