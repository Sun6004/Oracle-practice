2023-0112-01) 기타연산자
  -기타연산자 : in, any, some, all, exists, between, like 등

1) IN 연산자
 . 주어진 자료 중 어느 하나와 일치하면 TRUE 를 반환
 . 연산자에 '='의미가 내포되어 있음
(사용형식)
    EXPR IN (값1[,값2,...])
    - 'EXPR'(표현식 : 컬럼이나 수식, 함수 등)의 값이 '값1' ~'값n' 중 어느 하나와
      일치하면 전체 결과는 TRUE 가 됨
    - 연속적이지 않고 불규칙한 값들과 비교할 때 주로 사용
    -'OR' 연산자로 바꾸어 쓸 수 있음.
    
    사용예) 상품테이블(PROD)에서 분류코드 'P102','P201','P302'에 속한 상품의
           상품번호, 상품명, 매입가, 매출가를 조회하시오. 
        
        select prod_id as 상품번호,
               prod_name as 상품명,
               prod_cost as 매입가,
               prod_lgu as 분류코드,
               prod_price as 매출가
            from prod
        where prod_lgu = 'p102'
           or prod_lgu = 'p201'
           or prod_lgu = 'p302'
        order by 1;
        
(IN 연산자 사용)
     select prod_id as 상품번호,
               prod_name as 상품명,
               prod_cost as 매입가,
               prod_lgu as 분류코드,
               prod_price as 매출가
            from prod
        where prod_lgu IN('P102','P201','P302')

        order by 1;
        
(ANY(SOME) 연산자 사용)
    select prod_id as 상품번호,
               prod_name as 상품명,
               prod_cost as 매입가,
               prod_lgu as 분류코드,
               prod_price as 매출가
            from prod
        where prod_lgu =ANY('P102','P201','P302')

        order by 1;
        
2) ANY(SOME) 연산자
  .ANY와 SOME는 동일 기능과 동일 사용방법을 가지고 있음
(사용형식)
  EXPR 관계연산자ANY|SOME(값1,값2[값3,...])
   - 'EXPR'의 값이 ( )안의 어느 하나와 '관계연산자'의 조건을 만족하면 TRUE 반환
   - 관계연산자 '>'와 같이 사용하면 ( )안의 값 중 최소값 보다 큰 자료를 검색할 수 있음
   
** ALTER 명령
  .DCL에 속한 명령으로 객체의 구조 변경에 사용
  1) TABLE 의 걸럼 추가, 변경, 삭제
    - 칼럼의 추가
      ALTER TABLE 테이블명 ADD(컬럼명 데이터타입[크기])
      
    - 칼럼 수정(데이터타입 변경,크기변경)
      ALTER TABLE 테이블명 MODIFY(컬럼명 테이터타입[크기]) --이미 데이터가 저장되어있을 때, 더 작은사이즈로 변경불가
      
    - 컬럼 삭제
      ALTER TABLE 테이블명 DROP COLUMN 컬럼명
      
    - 컬럼명 변경
      ALTER TABLE 테이블명 RENAME COLUMN OLD_컬럼명 TO NEW_컬럼명
  
  2) 제약조건의 추가, 변경에 사용 
    -제약조건(기본키 OR 외래키)추가
      ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건이름 제약조건
      
    -제약조건(기본키 OR 외래키)변경(제약조건 이름변경)
      ALTER TABLE 테이블명 RENAME CONSTRAINT OLD_제약조건명 TO NEW_제약조건명
      
    -제약조건(기본키 OR 외래키)삭제
      ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름
      
  3) 테이블명의 변경에 사용
    - ALTER TABLE OLD_테이블명 RENAME TO NEW_테이블명

사용예) HR 계정의 ENPLOYEES테이블에 새로운 컬럼 EMP_NAME VARCHAR2(50)을 추가하시오
    ALTER TABLE HR.EMPLOYEES ADD(EMP_NAME VARCHAR2(50));
    
사용예) 사원테이블에서 EMP_NAME컬럼에 FIRST_NAME 과 LAST_NAME에 저장된 자료를 결합하여 사용하시오.
  ** UPDATE 문
   - DML (INSERT, UPDATE, DELETE, MERGE)에 속한 명령
   - 존재하고 있는 자료의 내용의 변경처리
  (사용형식)
    UPDATE 테이블명
        SET 컬럼명1 = 값1[,]
            [컬럼명2 = 값2[,]]
                   : 
            컬럼명n = 값[n]
        [WHERE 조건]
        
    UPDATE HR.EMPLOYEES
        SET EMP_NAME = FIRST_NAME||' '||LAST_NAME;
        
    SELECT FIRST_NAME, LAST_NAME, EMP_NAME
        FROM HR.EMPLOYEES;
        
    COMMIT;
사용예) 사원테이블에서 100번 부서에 속한 사원의 최소 급여보다 많은 급여를 받는 사원의
       사원번호, 사원명, 부서코드, 급여를 조회하시오.
       SELECT EMPLOYEE_ID AS 사원번호,
              EMP_NAME AS 사원명,
              DEPARTMENT_ID AS 부서코드,
              SALARY AS 급여
         FROM HR.EMPLOYEES
       WHERE SALARY > ANY(SELECT SALARY
                          FROM HR.EMPLOYEES
                          WHERE DEPARTMENT_ID = 100)
          AND DEPARTMENT_ID !=100
        ORDER BY 4 DESC;
       
    SELECT SALARY
      FROM HR.EMPLOYEES
    WHERE DEPARTMENT_ID=100
    
3) ALL
    (사용형식)
     EXPR 관계연산자 ALL(값1, 값2[,값3,...])
      . EXPR에 저장된 값이 ()안의 모든 값과 관계연산자 조건을 만족하면 TRUE 반환
      . 사용하는 관계연산자 중 '=' 는 사용할 수 없음
      . '>'를 사용한 ALL 은 '값1' ~'값n' 사이의 값 중 최대값보다 큰 경우의 결과 출력
      
사용예) 사원테이블에서 100번 부서에 속한 사원의 최대 급여보다 많은 급여를 받는 사원의
       사원번호, 사원명, 부서코드, 급여를 조회하시오.
     SELECT EMPLOYEE_ID AS 사원번호,
            EMP_NAME AS 사원명, 
            DEPARTMENT_ID AS 부서코드,
            SALARY AS 급여
        FROM HR.EMPLOYEES
        WHERE SALARY > ALL(SELECT SALARY
                            FROM HR.EMPLOYEES
                            WHERE DEPARTMENT_ID = 100)
            --AND DEPARTMENT_ID != 100 (생략가능)
        ORDER BY 4 DESC;
        
4) BETWEEN 연산자
   - 연속적이거나 규칙성을 가지고 있는 값들을 비교할때 사용
   - 주로 범위 설정에 사용
   - AND 연산자를 대신할 수 있음
  (사용형식)
    EXPR BETWEEN 값1 AND 값2
      . EXPR의 값이 '값1'~'값2' 사이의 값이면 참(TRUE)을 반환
      . EXPR >= 값1 AND EXPR <= 값2 로 봐꾸어 사용할 수 있음
      . 모든 데이터 타입에서 사용가능
      
사용예) 매입테이블(BUYPROD)에서 4월 1일 ~ 4월 20일 날짜순으로 매입정보를 조회
    ALIAS 는 날짜, 상품코드, 수량, 금액
    
    SELECT BUY_DATE AS 날짜,
           BUY_PROD AS 상품코드,
           BUY_QTY AS 수량,
           BUY_QTY*BUY_COST AS 금액
      FROM BUYPROD
      WHERE BUY_DATE >= TO_DATE('20200401') AND BUY_DATE <= TO_DATE('20200430')
      ORDER BY 1;

(BETWEEN 연산자 사용)
    SELECT BUY_DATE AS 날짜,
           BUY_PROD AS 상품코드,
           BUY_QTY AS 수량,
           BUY_QTY*BUY_COST AS 금액
      FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
      ORDER BY 1;

사용예) 상품테이블에서 분류코드 'P200' 번대에 속한 상품의 상품번호, 상품명, 판매가, 매입가를 조회
    SELECT PROD_ID AS 상품번호,
           PROD_NAME AS 상품명,
           PROD_LGU AS 분류코드,
           PROD_PRICE AS 판매가,
           PROD_COST AS 매입가       
        FROM PROD
        WHERE PROD_LGU BETWEEN 'P200' AND 'P299'
        
사용예) 회원테이블에서 보유마일리지가 2000~3000사이인 회원들의 회원번호, 회원명, 나이, 성별을 조회하시오
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           EXTRACT(YEAR FROM SYSDATE) -EXTRACT(YEAR FROM MEM_BIR) AS 나이,
           CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN('2','4') THEN '여성'
           ELSE '남성' 
           END AS 성별,
           MEM_MILEAGE AS 마일리지
        FROM MEMBER
        WHERE MEM_MILEAGE BETWEEN 2000 AND 3000
        
5) LIKE 연산자
  - 패턴비교 연산자
  - 문자열 비교 연산자 (숫자나 날짜 비교에 사용 자제)
  - 패턴을 구성하는 문자로 '%','_'(와일드카드)사용
    .'%' : '%' 가 사용된 이후의 모든 문자열과 대응(공백도 대응됨)
    . EX) '김%' : '김'자로 시작하는 모든 문자열은 참(TRUE)을 반환
          '%김' : '김'자로 끝나는 모든 문자열은 참(TRUE)을 반환
          '%김%': 문자열 내부에 '김' 이 있으면 참(TRUE)을 반환
           
    .'_' : '_' 가 사용된 위치의 하나의 문자열과 대응
    . EX) '김_' : '김'자로 시작하고 2개의 문자로 구성된 문자열은 참(TRUE)을 반환
          '_김' : '김'자로 끝나고 2개의 문자로 구성된 문자열은 참(TRUE)을 반환
          '_김_': 3개의 문자로 구성되고 문자열 가운데에 '김' 이 있으면 참(TRUE)을 반환
          
(사용형식)
    컬럼명 LIKE '패턴문자열'
    
사용예) 회원테이블에서 거주지가 충남인 회원들의 회원번호, 회원명, 주소를 조회하시오.
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1 || ' '|| MEM_ADD2 AS 주소 
        FROM MEMBER
        WHERE MEM_ADD1 LIKE '충남%';
    
사용예) 장바구니 테이블에서 2020년 6월 매출정보를 조회하시오
    SELECT CART_QTY AS 매출정보
        FROM CART_NO
        

사용예) 매입테이블에서 2020년 6월 매입정보를 조회하시오
    ALIAS는 날짜, 상품번호, 매입수량
    
    SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS 날짜,
           CART_PROD AS 상품번호,
           CART_QTY AS 매입수량
        FROM CART
        WHERE CART_NO LIKE '202006%'
        ORDER BY 1;
        
사용예) 매입테이블에서 2020년 6월 매입정보를 조회하시오
        ALIAS는 날짜, 상품번호, 매입수량
      SELECT BUY_DATE AS 날짜,
             BUY_PROD AS 상품번호,
             BUY_QTY AS 매입수량
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20200601') AND TO DATE('2000630')
        ORDER BY 1;
   

          
    