2023-0126-01)
  4) SEMI JOIN
   - 서브쿼리를 사용하여 추출된 중간결과만 메인쿼리에서 추출하는 조인
   - IN과 EXISTS 연산자 사용
사용예) 사원테이블에서 급여가 10000이상되는 사원이 있는 부서정보를 조회하시오
       Alias는 부서코드, 부서명
  (EXISTS 연산자 사용)
  --EXISTS(서브 쿼리)는 서브 쿼리의 결과가 "한 건이라도 존재하면" TRUE 없으면 FALSE를 리턴한다.
  --EXISTS는 서브 쿼리에 일치하는 결과가 한 건이라도 있으면 쿼리를 더 이상 수행하지 않는다.
    SELECT A.DEPARTMENT_ID AS 부서코드,
           A.DEPARTMENT_NAME AS 부서명
    FROM HR.DEPARTMENTS A
    --EXISTS 뒤에 SUB쿼리가 와야함  서브 쿼리의 결과가 "한 건이라도 존재하면" TRUE 없으면 FALSE를 리턴
    --EXISTS는 서브 쿼리에 일치하는 결과가 한 건이라도 있으면 쿼리를 더 이상 수행하지 않는다.
    WHERE EXISTS(SELECT 1 -- 1은 아무의미없음
                    FROM HR.EMPLOYEES B
                    WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
                      AND B.SALARY>=10000) 
    ORDER BY 1;
    
  (IN 연산자 사용)--비동등 조인
  SELECT A.DEPARTMENT_ID AS 부서코드,
           A.DEPARTMENT_NAME AS 부서명
    FROM HR.DEPARTMENTS A
    WHERE A.DEPARTMENT_ID IN(SELECT DISTINCT DEPARTMENT_ID --DISTINCT : 중복 데이터 제거.
                             FROM HR.EMPLOYEES
                             WHERE SALARY >= 10000)
    ORDER BY 1;

(동등 조인) 
SELECT A.DEPARTMENT_ID AS 부서코드,
           A.DEPARTMENT_NAME AS 부서명
    FROM HR.DEPARTMENTS A,(SELECT DISTINCT DEPARTMENT_ID
                             FROM HR.EMPLOYEES
                             WHERE SALARY >= 10000)B
    WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
    ORDER BY 1;
    
5) NON EQUI JOIN (비동등 조인)
 - 조인조건에 '=' 이외의 연산자가 사용되는 조인(등가 조인)
 - 조인 조건이 "정확히" 일치하는 경우에만 사용
 
사용예)사원테이블에서 각 사원의 소속된 부서의 평균급여보다 더 많은 급여를 받는 사원의 사원번호,사원명,부서코드,입사일,급여를 조회하시오.
    
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           A.DEPARTMENT_ID AS 부서코드,
           (SELECT ROUND(AVG(SALARY))
             FROM HR.EMPLOYEES D
             WHERE D.DEPARTMENT_ID=A.DEPARTMENT_ID) AS 부서평균급여,
           A.HIRE_DATE AS 입사일,
           A.SALARY AS 급여
    FROM HR.EMPLOYEES A
    WHERE A.SALARY > (SELECT C.ASAL
                  FROM (SELECT B.DEPARTMENT_ID,
                          AVG(B.SALARY) AS ASAL
                         FROM HR.EMPLOYEES B               
                     GROUP BY B.DEPARTMENT_ID)C
                      WHERE A.DEPARTMENT_ID=C.DEPARTMENT_ID)
       ORDER BY 3,6 DESC;    
    
사용예) 회원테이블에서 마일리지가 많은 상위 3명이 2020년 5월 구매한 정보를
       조회하시오. Alias는 회원번호, 회원명, 구매금액 합계
(마일리지가 많은 3명)
  SELECT A.MEM_ID
    FROM (SELECT MEM_ID,MEM_MILEAGE
            FROM MEMBER
            ORDER BY MEM_MILEAGE DESC)A
    WHERE ROWNUM<=3;
    
(2020년 5월 구매한정보)
  SELECT M.MEM_ID AS 회원번호,
         M.MEM_NAME AS 회원명,
         SUM(C.CART_QTY*P.PROD_PRICE) AS "구매금액 합계"
  FROM CART C, MEMBER M, PROD P
  WHERE C.CART_NO LIKE '202005%'
  AND C.CART_PROD=P.PROD_ID
  AND M.MEM_ID=C.CART_MEMBER
  AND C.CART_MEMBER =ANY(SELECT A.MEM_ID
                           FROM (SELECT MEM_ID,MEM_MILEAGE
                      FROM MEMBER
                      ORDER BY MEM_MILEAGE DESC)A
                     WHERE ROWNUM<=3)
    GROUP BY M.MEM_ID, M.MEM_NAME;


   