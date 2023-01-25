2023-0111-02) 데이터 검색 명령
  - 테이블의 자료를 추출할때 사용
  - sql명령 중 가장 많이 사용하는 명령
(사용형식)
  select [distinct] 칼럼명 | * [as 별칭][,]
         컬럼명 [as 별칭][,]
                :
         컬럼명 [as 별칭]--마지막엔, 없음
    from 테이블명
    [where 조건] --행을 제한하는 조건
    [group by 컬럼명[,컬럼명,...]]--특정 칼럼의 값이 같은것들끼리 모음
   [having 조건]
    [order by 컬럼명|컬럼 index [asc|desc][,컬럼명|컬럼index [asc|desc],...]]
    
    
    . select 절 : 출력할 컬럼 결정
    . where 절 : 출력할 행(row) 결정 --생략가능(생략시 모든 행이 참여)
    . 'distinct' : 컬럼 값 중 중복값을 배제시킴
    . 'as별칭' : 컬럼에 부여된 또 다른 이름
    . select 문은 select절, from절이 필수절임
    . 실행순서 : from 절 -> where 절 -> group by 절 -> having 절 -> select 절 
    
사용예) 회원테이블(member)의 모든자료를 조회하시오
    select * from member;

사용예) 회원테이블에서 '대전'에 거주하는 회원의 회원번호,회원명,직업,마일리지를 조회하시오.
       단, 마일리지가 많은 회원부터 출력하시오.
       select mem_id as 회원번호,
              mem_name as 회원명,
              mem_job as 직업,
              mem_mileage as 마일리지
         from member
        where mem_add1 like '대전%' --조건문
        order by 4 desc; --4번째 칼럼에쓰인 값을 기준으로 desc(내림차순)
        
사용예) 상품테이블(prod)에서 분류별 상품의 종류를 조회하시오.
       단, 출력은 상품의 종류가 많은 순으로 정렬하시오.
       
       select a.prod_lgu as 분류코드,
              b.lprod_nm as 분류명,
              count(*) as "상품종류의 수" --공백이나 별칭이나 특수문자를 쓰려면 " "사용
          from prod a, lprod b
        where a.prod_lgu = b.lprod_gu --조인조건
       
        group by a.prod_lgu, b.lprod_nm
        having count(*) >=10 --사용예3 상품의 수가 10개이상인 상품만 조회 group절에서 사용 
        order by count(*) desc; -- 상품의 종류가 많은순부터 조회

사용예) 상품테이블(prod)에서 분류별 상품의 종류를 조회하되 상품의 수가 10개 이상인
       상품만 조회하시오. 단, 출력은 분류번호 큰 분류부터 출력하시오.
       
 **테이블 temp01~ temp10을 삭제하시오
    drop table temp01;
    drop table temp02;
    drop table temp03;
    drop table temp04;
    drop table temp05;
    drop table temp06;
    drop table temp07;
    drop table temp08;
    drop table temp09;
    drop table temp10;
    
    commit;
    
1)연산자
  -사적연산자 : +, -, *, /
  
  사용예)HR계정의 사원테이블에서 보너스를 계산하고 보너스를 포함한 자금액을 조회하시오
    Alias 는 사원번호, 사원명, 급여, 보너스, 지급액
    보너스 = 급여(salary)*영업실적코드(commission_pct)
    지급액 = 급여 + 보너스
    
    select EMPLOYEE_ID as 사원번호,
        FIRST_NAME ||' '|| LAST_NAME AS 사원명, -- || : 문자열의 + 연산자
        SALARY AS 급여,
        NVL(SALARY*COMMISSION_PCT,0) AS 보너스, -- NVL( ,0) : 둘중 하나가 null이면 나머지를 그대로 출력
        SALARY + NVL(SALARY*COMMISSION_PCT ,0) AS 지급액 
        from HR.EMPLOYEES;
  
  -비교연산자(관계연산자) : 결과가 true/false 로 반환
    : >,  <, =, >=, <=, !=(<>)
    . 조건식에 사용
    . 조건식은 WHERE 절과 CASE WHEN - THEN(표현식: SELECT 절에 사용)의 조건식에 사용
    
사용예) 회원테이블에서 보유마일리지가 5000이상인 회원의 회원번호,회원명,직업,마일리지를
       조회하시오. 단, 마일리지가 많은 회원부터 출력하시오.
       
    SELECT mem_id AS 회원번호,
           mem_name AS 회원명,
           mem_job AS 직업,
           mem_mileage as 마일리지
    FROM member
    WHERE mem_mileage >= 5000 --select절보다 먼저실행
    ORDER BY mem_mileage DESC; -- mem_mileage대신 마일리지 사용가능
    
    --관계형 데이터베이스 의 관계를 이용한 연산 : JOIN
사용예) 매입테이블(BUYPROD)에서 2020년 1월 매입된 상품에서 매입수량의 합계가 50개 이상인
       매입정보를 조회하시오.
       ALIAS는 상품코드, 매입수량, 매입금액이며 매입금액이 많은 상품부터 출력하시오.
    SELECT BUY_PROD AS 상품코드,
           SUM(BUY_QTY) AS 매입수량,
           SUM(BUY_QTY*BUY_COST) AS 매입금액
        FROM BUYPROD 
        WHERE BUY_DATE >= '20200101' AND BUY_DATE <= '20200131'
        GROUP BY BUY_PROD
        HAVING SUM(BUY_QTY) >= 50
        ORDER BY 3 DESC; -- SELECT 문의 3번컬럼
    
  -논리연산자 : not, and, or
    
사용예) 회원테이블(MEMBER)에서 여성회원의 회원번호, 회원명,직업, 마일리지를 조회하시오
    SELECT 
           MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_REGNO2 AS 주민번호2,
           MEM_MILEAGE AS 마일리지
        FROM MEMBER
        --첫번째 자리에서 1글자 자르기/ OR : 둘중에 한가지 조건 만족
           WHERE SUBSTR(MEM_REGNO2,1,1) = '2' OR SUBSTR(MEM_REGNO2,1,1)='4';
           --WHERE SUBSTR(MEM_REGNO2,1,1) IN('2','4')
    
사용예)올해가 윤년인지 평년인지 구별하시오(윤년 =4의배수이면서 100의배수가 아니거나 400의 배수가 되는 해)
    SELECT CASE WHEN (MOD(EXTRACT(YEAR FROM SYSDATE),4) = 0 AND --MOD : 나머지
                      MOD(EXTRACT(YEAR FROM SYSDATE),100) != 0)OR
                      (MOD(EXTRACT(YEAR FROM SYSDATE),400) = 0) THEN
                      '올해는 윤년입니다.'
                 ELSE
                      '올해는 평년입니다.'
                END AS 결과 --컬럼명
            FROM DUAL; --DUAL :테이블은 불필요한데 문법상 테이블자리에 쓰는것
            

사용예) 사원들의 평균급여보다 적은급여를 받는 사원의 사원번호, 사원명, 급여를 조회하되
       NOT 연산자를 사용하시오.
    (평균급여)
    SELECT AVG(SALARY)
        FROM HR.EMPLOYEES;
        
    SELECT EMPLOYEE_ID AS 사원번호,
           FIRST_NAME ||' '|| LAST_NAME AS 사원명,
           SALARY AS 급여
        FROM HR.EMPLOYEES
        WHERE NOT SALARY >= (SELECT AVG(SALARY) FROM HR.EMPLOYEES)
        
        ORDER BY 3 DESC;

  
  
-기타연산자 : in, any, some, all, exists, between, like 등
  
       
                                                                 