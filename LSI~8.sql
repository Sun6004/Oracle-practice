2023-0118-02)변환함수
  - 데이터 타입을 변환하는 함수
  - TO_CHAR, TO_NUMBER, TO_DATE, CAST 등이 제공됨
  1)CAST(EXPR AS 타입명)
   -'EXPR'에 저장된 데이터를 AS 다음에 기술한 '타입'으로 반환
   
사용예)
  SELECT BUY_DATE AS COL1,
         CAST(BUY_DATE AS CHAR(20)) AS COL2
         --CAST(BUY_PROD AS NUMBER(20)) AS CPL3 : 숫자로 변환될수 없는 영문이 포함되어있기때문에 변환불가
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200115');
    
    SELECT CAST(1234.56 AS VARCHAR2(7)) FROM DUAL; --소수점(.)까지 포함되는 자리수를 지정해야함
    
2) TO_CHAR(data [,'FMT']) - '*****'
  - 주어진 데이터('data')를 형식지정문자열('fmt')에 마추어 문자로 변환
  - 'data'로 사용될 수 있는 자료의 타입은
   . 문자열(CHAR, CLOB) => VARCHAR2로 변환
   . 숫자타입 => 문자열 타입으로 변환
   . 날짜타입 => 문자열 타입으로 변환
 
  - 날자 형식지정 문자열
  --------------------------------------------------------------------------------------
  FORMAT          설명              예
  --------------------------------------------------------------------------------------
  BC, AD         서기(기원전)       SELECT TO_CHAR(SYSDATE, 'BC') FROM DUAL;
  CC             세기              SELECT TO_CHAR(SYSDATE, 'BC CC') FROM DUAL;
  YYYY,YYY,
  YY,Y           연도              SELECT TO_CHAR(SYSDATE, 'YYYY YYY YY Y') FROM DUAL;
  RM,MM,
  MONTH, MON     월                SELECT TO_CHAR(SYSDATE, 'YYYY-MM'), TO_CHAR(SYSDATE,'YYYY-RM'),
                                          TO_CHAR(SYSDATE,'YYYY-MONTH'),TO_CHAR(SYSDATE,'YYYY-MON') FROM DUAL;
  DD,DDD,D       일                SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DY'),TO_CHAR(SYSDATE, 'YYYY-MM-DD'),
                                          TO_CHAR(SYSDATE, 'YYYY-MM-D'), 
                                          TO_CHAR(SYSDATE, 'YYYY-MM-DD WW'),TO_CHAR(SYSDATE, 'YYYY-MM-DD W')
                                             FROM DUAL;
  DAY,DY         요일
  WW, W          주                     
  
  A.M. , P.M.    오전/오후          SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DAY AM'),TO_CHAR(SYSDATE, 'YYYY-MM-DAY PM') FROM DUAL;
  HH,HH12,HH24   시간              SELECT TO_CHAR(TO_DATE('20210213133127','YYYYMMDDHH24MISS'),'YYYY/MM/DD HH:MI:SS') FROM DUAL;
  MI             분                
  SS,SSSSS       초 --하루 86400초를 계산하기위해 S가 5자리
  "문자열"        사용자 지정 문자열   SELECT TO_CHAR(SYSDATE,'YYYY"년" MM"월" DD"일"') FROM DUAL;
  
  
   - 숫자 형식지정 문자열
   --------------------------------------------------------------------------------------
   FORMAT         설명                                      예
   --------------------------------------------------------------------------------------
    9         출력자리수 결정 및 유효숫자와                  
              대응하여 유효숫자 출력 무효의0은
              공백처리
    0         출력자리수 결정 및 유효숫자와                  SELECT TO_CHAR(12345.789,'99999.9'),
              대응하여 유효숫자 출력 무효의0은                      TO_CHAR(12345.789,'99999.99'),--실수부분은 자리수가 부족하면 반올림되서 저장됨
              '0'을 출력                                        TO_CHAR(12345.789,'99999'),
                                                               TO_CHAR(12345.789,'00000.0'),
                                                               TO_CHAR(12345.789,'00000.09'),
                                                               TO_CHAR(12345.789,'00000') FROM DUAL;
   
    $,L       화폐기호를 숫자 왼쪽에 출력                  SELECT TO_CHAR(123456,'$9,999,999'),TO_CHAR(123456,'L9,999,999')   FROM DUAL;   
    MI        '-'부호를 숫자 오른쪽에 출력                SELECT TO_CHAR(-123456,'9,999,999MI'),TO_CHAR(123456,'9,999,999MI')   FROM DUAL;     
    PR        음수자료는'<>'안에 출력                     SELECT TO_CHAR(-123456,'9,999,999PR'),TO_CHAR(123456,'9,999,999PR')   FROM DUAL;
   ,(comma)   3자리마다 자리점 출력
              무효의','는 공백출력(9 MODE)
   .(dot)     소수점 출력
   
3) TO_DATE(expr [,'FMT']) -'***'
  - 날짜로 변환 가능한 'expr'(문자열 또는 숫자)를 날짜타입으로 변환
  - 날짜로 변환할 수 없는 문자열이 포함된 경우 해당 문자열이 출력되기 위하여 필요한 형식지정문자열을 기술해야 함
  - 'fmt'는 TO_CHAR에 사용되는 날짜형식 지정 문자열과 동일
  
사용예):
  SELECT TO_DATE('20221217'),
         TO_DATE(20221217),
         TO_DATE('2022-12-17 14:27:45','YYYY-MM-DD HH24:MI:SS'),
         TO_DATE('2022.12.17','YYYY.MM.DD')
    FROM DUAL;
    
사용예) 장바구니테이블에서 2020년 6월 1일부터 6월 15일까지 발생된 매출자료를 조회하시오
       Alias는 일자, 상품코드, 판매수량이다
       SELECT TO_DATE (SUBSTR (CART_NO,1,8))AS 일자,
              CART_PROD AS 상품코드,
              CART_QTY AS 판매수량
         FROM CART
         WHERE TO_DATE (SUBSTR (CART_NO,1,8)) BETWEEN '20200601' AND '20200615';
    
4) TO_NUMBER(expr [,'fmt'9]) -'***'
  - 숫자로 변환 가능한 'expr'(문자열)을 숫자타입으로 변환
  - 숫자로 변환할 수 없는 문자열이 포함된 경우 해당 문자열이 출력되기 위하여 필요한 형식지정문자열을 기술해야 함
  - 'fmt'는 TO_CHAR에 사용되는 숫자형식 지정 문자열과 동일
  
사용예)
  SELECT TO_NUMBER('12345'),
         TO_NUMBER('12345.9'),
         TO_NUMBER('12,345','99,999'),
         TO_NUMBER('￦12,345','L00,000'),
         TO_NUMBER('<12345>','99999PR')
    FROM DUAL;
    
사용예) 오늘이 2020년 7월 1일이라고 가정하고 새로운 장바구니번호를 생성하는 SQL을 작성하시오
  SELECT --TO_CHAR(SYSDATE, 'YYYYMMDD')||TRIM(TO_CHAR(TO_NUMBER(SUBSTR (MAX(CART_NO),9))+1,'00000'))
         MAX(CART_NO)+1
    FROM CART
    WHERE CART_NO LIKE '20200701%';
                     
      
    