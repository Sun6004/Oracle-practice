2023-0206-01) 저장 프로시저(STORED PROCEDURE:PROCEDURE);
 - 반환 값이 없는 서브프로그렘
 - 컴파일되어 서버에 저장
 - 사용자가 만든 PL/SQL문을 저장해놓고 필요할때마다 다시 입력할 필요없이 호출해서 결과를 얻을 수 있음
 - 특징은 PL/SQL의 특징을 공유함
 
 (사용형식)
   CREATE [OR REPLACE] PROCEDURE 프로시저명[(
     매개변수 [IN|OUT|INOUT] 타입 [:=|DEFAULT 값][,]
                        :
     매개변수 [IN|OUT|INOUT] 타입 [:=|DEFAULT 값])]
    IS|AS 
     선언영역
    BEGIN
     실행영역
     [EXCEPTION
        예외처리]
    END;
    . 'IN|OUT|INOUT' : 매개변수가 입력용(IN),출력용(OUT),입출력공용(INOUT)여부 정의
      생략되면 IN으로 간주
    . '타입' : 매개변수의 타입으로 크기를 지정하지 않는다
    . ':=|DEFAULT값' : 매개변수에 값이 없는 경우 설정할 값
    
    => 프로시저는 반환값이 없기 떄문에 주로 DML 명령을 포함하는 모듈에 사용
    
(실행)
 EXECUTE|EXEC 프로시저명[(매개변수[,매개변수,...])];
 
OR
  프로시저명[(매개변수[,매개변수,...])]; ==> OUT 매개변수가 사용된 경우로 실행문 자체가 
  다른 블록 또는 프로시저 등의 내부에 존재해야 함.
  
사용예) 기간을 입력 받아 2020년 5월 매입집계를 구한 후 재고수불 테이블을 UPDATE 하는 프로시저를 작성하시오.
 CREATE OR REPLACE PROCEDURE PROC_UPDATE_REMAIN01(
    P_PERIOD IN VARCHAR2)
  IS
    L_START DATE := TO_DATE(P_PERIOD||'01');
    L_END  DATE := LAST_DAY(L_START);
    L_BID PROD.PROD_ID%TYPE; --상품코드
    L_QTY NUMBER:=0; --매입수량
    
    CURSOR CUR_SUM_BUYPROD IS
      SELECT BUY_PROD,SUM(BUY_QTY) AS BSUM
        FROM BUYPROD
       WHERE BUY_DATE BETWEEN  L_START AND L_END
       GROUP BY BUY_PROD;         
  BEGIN
    OPEN CUR_SUM_BUYPROD;
    LOOP
      FETCH CUR_SUM_BUYPROD INTO L_BID,L_QTY;
      EXIT WHEN CUR_SUM_BUYPROD%NOTFOUND;
      
      UPDATE REMAIN A
         SET A.REMAIN_I=A.REMAIN_I+L_QTY,
             A.REMAIN_J_99= A.REMAIN_J_99+L_QTY,
             A.REMAIN_DATE=L_END
       WHERE A.PROD_ID=L_BID;      
    END LOOP;
    COMMIT;
    CLOSE CUR_SUM_BUYPROD;
  END;
    
사용예) 회원테이블에서 마일리지가 3000이상인 회원번호를 입력 받아 이름과 주소를 반환하는
       프로시저를 작성하시오.
  CREATE OR REPLACE PROCEDURE PROC_MEMBER02(
    P_MIN IN MEMBER.MEM_ID%TYPE,
    P_NAME OUT VARCHAR2 --출력용이기때문에 OUT /VARCHAR2에 길이를 지정하면 오류
    P_EDDR OUT VARCHAR2);
  IS
  BEGIN
    BEGIN MEM_NAME,MEM_ADD1||' '||MEM_ADD2
     INTO P_NAME,P_ADDR
     FROM MEMBER
    WHERE MEM_ID=P_MID; 
  END;
  
(실행)
  DECLARE
    L_MID MEMBER.MEM_ID%TYPE;
    L_NAME VARCHAR2(80);
    L_ADDR VARCHAR2(255);
    
    CURSOR CUR_MEM03 IS
      SELECT MEM_ID
        FROM MEMBER
       WHERE MEM_MILEAGE>=3000; 
  BEGIN
    FOR REC IN CUR_MEM03 LOOP
      PROC_MEMBER02(REC.MEM_ID,L_NAME,L_ADDR);
      DBMS_OUTPUT.PUT_LINE(REC.MEM_ID||' '||L_NAME' '||L_ADDR);
    END LOOP;  
  END;
  
사용예) 2020년 4월 매입기준 상위5개 품목의 상품코드를 입력받아 상품명과 판매수량합계 및 판매금액 합계를
       출력하는 프로시저 작성
  CREATE OR REPLACE PROCEDURE PROC_CART02(P_PID IN PROD.PROD_ID%TYPE, P_PNAME OUT PROD.PROD_NAME%TYPE, 
                                          P_QTY OUT BUMBER, P_SUM OUT NUMBER)
  IS
    
  BEGIN
    SELECT A.PROD_NAME,SUM(B.CART_QTY),SUM(B.CART_QTY*A.PROD_PRICE)
      INTO P_PNAME, P_QTY, P_SUM
      FROM PROD A, CART B
     WHERE B.CART_NO LIKE '202004%'
       AND B.CART_PROD=A.PROD_ID
       AND B.CART_PROD=P_PID
     GROUP BY A.PROD_NAME;  
     
     EXCEPTION WHEN OTHER THEN
     DBMS_OUTPUT.PUT_LINE('오류발생: 자료가 없습니다.'||SQLERRM)
  END;
  
(실행 : 2020년 4월 매입액 기준 상위5개 품목의 상품코드)
  DECLARE
    L_PNAME PROD.PROD_NAME%TYPE;
    L_QTY NUMBER:=0;
    L_SUM NUMBER:=0;
    L_PID PROD.PROD_ID%TYPE;
  BEGIN
    FOR REC IN (SELECT TA.ABID AS TABID
                 FROM(SELECT A.BUY_PROD AS ABID,SUM(A.BUY_QTY*B.PROD_COST)
                 FROM BUYPROD A, PROD B
                WHERE A.BUY_PROD=PROD_ID
                  AND A.BUY_DATE BETWEEN TO_DATE('20200401')AND TO_DATE('20200430')
                GROUP BY A.BUY_PROD
                ORDER BY 2 DESC)TA
             WHERE ROWNUM <=5)
    LOOP
      PROC_CART02(REC.TABID,L_PNAME,L_QTY,L_SUM);
      DBMS_OUTPUT.PUT_LINE(REC.TABID||'  '||RPAD(L_PNAME,25)||'  '||TO_CHAR(L_QTY,'99,999')||TO_CHAR(L_SUM,'999,999,999'));
    END LOOP;
  END;  
 