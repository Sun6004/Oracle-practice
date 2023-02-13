2023-0208-01) 함수(USER DEFINED FUNCTION)
 - 반환 값이 존재하는 서브 프로그램 (SELECT문의 SELECT절 WHERE절, INSERT문의 VALUES,WHERE절
   UPDATE문의 SET절,WHERE절에서 사용가능)
 - 그 밖의 특징은 프로시저와 동일
 
 (사용형식)
  CREATE [OR REPLACE] FUNCTION 함수명[(
    매개변수[IN|OUT|INPUT] 타입 [:=|DEFAULT값][,]
                    :
    매개변수[IN|OUT|INPUT] 타입 [:=|DEFAULT값][,]
    RETURN 타입명
  IS|AS
    선언영역
  BEGIN
    실행영역
    RETURN EXPR;
    
    [EXCEPTION
      예외처리]
  END;
  
  . 'RETURN 타입명' : 반환할 타입명만 기술
  . 'RETURN expr ' : 실행영역에서 반드시 하나 이상의 RETURN 문에 의하여 값을 반환해야 함
  . FUNCTION 에서는 OUT 매개변수를 사용하지 않음
  
사용예) 2020년 6월 판매된 상품코드를 입력받아 해당 상품의 매출금액을 반환하는 함수를 작성하시오.
  CREATE OR REPLACE FUNCTION FN_CART01(P_PID PROD.PROD_ID%TYPE)
    RETURN NUMBER
  IS
    L_SUM NUMBER:=0; --매출금액
  BEGIN
    SELECT SUM(A.CART_QTY*B.PROD_PRICE) INTO L_SUM
     FROM CART A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
      AND A.CART_PROD=P_PID;
      
    RETURN L_SUM; 
  END;

(실행)
  SELECT DISTINCT A.CART_PROD AS 상품코드,
                  B.PROD_NAME AS 상품명,
                  FN_CART01(A.CART_PROD) AS 매출액 --함수는 반환받을 값이 있는 경우 사용
    FROM CART A, PROD B
   WHERE A.CART_PROD=B.PROD_ID
     AND A.CART_NO LIKE '202006%'
   ORDER BY 1;  

사용예)기간과 상품코드를 입력받아 매출 수량을 조회하여 재고수불테이블을 갱신하는 프로시져와 함수를 작성하시오.
  (프로시져: 기간(년도, 월)과 상품코드를 입력받아 재고수불테이블을 갱신)
    CREATE OR REPLACE PROCEDURE PROC_REMAIN_UPDATE02(P_PERIOD IN VARCHAR2)--입력용
    
    IS
      L_PID PROD.PROD_ID%TYPE;
      L_QTY NUMBER:=0;
      L_LDATE DATE:=LAST_DAY(TODATE(P_PERIOD||'01'));
      
      CURSOR CUR_CART03 IS
        SELECT DISTINCT CART_PROD
          FROM CART
         WHERE CART_NO LIKE P_PERIOD||'%'; 
    BEGIN
      OPEN CUR_CART03;
      LOOP
        FETCH CUR_CART03 INTO L_PID;
        EXIT WHEN CUR_CART03%NOTFOUND;
        
        UPDATE REMAIN A
           SET A.REMAIN_O=A.REMAIN_O+함수,
           A.REMAIN_J_99=A.REMAIN_J_99-함수,
           A.REMAIN_DATE=L_LDATE
     WHERE A.PROD_ID=L.PID;
      END LOOP;
      
        EXCEPTION WHEN OTHERS THEN --JAVA의 EXCEPTION과 같음
    DBMS_OUTPUT.PUT_LINE('오류발생: '||SQLERRM);
    ROLLBACK;
    
    COMMIT;
    
    END;
      
  
  (함수 : 기간, 상품코드를 입력받아 매출수량 집계)
  CREATE OR REPLACE FUNCTION FN_CART01(P_PERIOD IN VARCHAR2, P_PID IN PROD.PROD_ID%TYPE)
    RETURN NUMBER
  IS
    L_SUM NUMBER:=01;
  BEGIN
    SELECT SUM(CART_QTY) INTO L_QTY
      FROM CART
     WHERE CART_PROD=PROD_ID
       AND CART_PROD=P_PID
       AND CART_NO LIKE P_PERIOD||'%';
       
     RETURN L_QTY;  
  END;
  
 (실행) 
  EXECUTE PROC_REMAIN_UPDATE02('202006');
  

2023-0208-02)트리거(Trigger)
 - 트리거는 특정 동작(이벤트)이 발생되면 자동으로 호출되어 실행되는 일종의 프로시져
 (사용형식)
  CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE|AFTER INSERT|DELETE|UPDATE ON 테이블명 --이벤트동작 /or를 사용해서 여러개 사용가능
    [FOR EACH ROW] --예약어/ 생략시 문장단위 트리거(오직 한번만 실행)
    [WHEN 조건] --기존 조건에 트리거 조건을 더할 수 있음
  [DECLARE --선언이 불필요하면 생략가능 (IS/AS 사용불가)
    선언영역] 
  BEGIN
   트리거 본문; --이벤트동작이 발동한후 자동으로 호출되어서 실행
   
   [EXCEPTION
     예외처리블록]
     
    END;
    
 . 'BEFORE|AFTER' : 트리거 본문이 실행될 시점으로(timing) EVENT(INSERT|DELETE|UPDATE)발생 전 또는
    발생 후를 설정
 . 'INSERT|DELETE|UPDATE' : 이벤트를 의미하며 'ON 테이블' 에 DML동작이 발생되기 전 또는 후에 트리거 본문이 실행되는 요인을 결정. 
    OR연산자로 복합사용가능
 . '[FOR EACH ROW]' : 행단위 트리거를 생성 
 . 'WHEN 조건' : EVENT발생시 트리거가 수행되는데 좀더 구체적으로 트리거 발생을 구체화 시킬때
    사용하며, 반드시 행단위 트리거에서만 사용가능
 ** 트리거 종류
  1)문장단위 트리거
   - 이벤트 결과집합의 행의 수에 관계없이 한 번만 트리거 발생
   - FOR EACH ROW가 생략되면 문장단위 트리거로 취급
   
  2) 행단위 트리거
  - FOR EACH ROW를 사용한 트리거
  - 이벤트의 결과 집합내의 행마다 트리거 본문 수행
  - 하나의 트리거가 완료되지 않은 상태에서 또 다른 트리거를 호출하거나,
    두 테이블이 서로 영향을 미치는 트리거는 실행 오류(mutable error)를 발생

사용예) 사원테이블에서 사원번호 125번 사원을 삭제(퇴직처리)하시오. 삭제 전 퇴직자 테이블에 
       사원번호,사원명,부서코드,직무코드를 입력하는 트리거를 작성하시오.
       
 CREATE OR REPLACE TRIGGER TG_DEL_EMP
   BEFORE DELETE ON T_EMP --DELETE 이벤트가 발생하기 전
   FOR EACH ROW 
 BEGIN
   INSERT INTO RETIRE VALUES(:OLD.EMPLOYEE_ID,:OLD.EMP_NAME);--RETIRE TABLE에 INSERT
 END; --트리거는 다른계정에서 처리불가
 
 DELETE FROM T_EMP
  WHERE EMPLOYEE_ID=149;
  
DROP TRIGGER SECURE_EMPLOYEES;
DROP TRIGGER UPDATE_JOB_HISTORY;
DROP TRIGGER TG_DEL_EMP;

사용예)LPROD 테이블에서LPROD_ID=10인 자료를 삭제한 후 '자료가 정상적으로 삭제되었습니다' 라는 문구를 출력하는 트리거
 --문장단위 트리거
 CREATE OR REPLACE TRIGGER TD_DEL_LPROD01
   AFTER DELETE ON LPROD
 BEGIN 
   DBMS_OUTPUT.PUT_LINE('자료가 정상적으로 삭제되었습니다');-- 문장 단위 트리거이기때문에 테이블 3개가 삭제되어도 한번만 실행
 END;
 
 DELETE FROM LPROD WHERE LPROD_ID>=7; 
 SELECT * FROM LPROD;
 
 
 ** ORDERS 테이블과 ORDER_DETAIL 테이블에 다음 자료를 입력하시오.
  
  [ORDERS 테이블]
  ------------------------------------------------
  ORDER_ID         ORDER_DATE         MEM_ID
  ------------------------------------------------
  20230209001     2023/02/09           b001
  20230209002     2023/02/09           f001   
  
  INSERT INTO ORDERS VALUES('20230209001',TO_DATE('20230209'),'b001');
  INSERT INTO ORDERS VALUES('20230209002',TO_DATE('20230209'),'f001');
  
   [ORDER_DETAIL 테이블]
  ------------------------------------------------
  ORDER_ID         PROD_ID           ORDER_QTY 
  ------------------------------------------------
  20230209001    P201000001             2
  20230209001    P201000010             5
  20230209001    P201000016             1
  20230209001    P202000001             2
  20230209002    P302000003             2
  20230209002    P102000005             1
  
  insert into order_detail(order_id,prod_id,order_qty)
    values('20230209001','P201000001',2);
  insert into order_detail(order_id,prod_id,order_qty)
    values('20230209001','P201000010',5);
  insert into order_detail(order_id,prod_id,order_qty)
    values('20230209001','P201000016',1);
  insert into order_detail(order_id,prod_id,order_qty)
    values('20230209001','P202000001',2);
  insert into order_detail(order_id,prod_id,order_qty)
    values('20230209002','P302000003',2);
  insert into order_detail(order_id,prod_id,order_qty)
    values('20230209002','P102000005',1);
    
  COMMIT;
  
  ** 트리거 의사레코드와 트리거 함수
  1) 트리거 의사레코드
  - 행단위 트리거에서만 사용
  -------------------------------------------------------------
  의사레코드         설명
  -------------------------------------------------------------
  :NEW           INSERT,UPDATE EVENT에 사용되며 데이터가 삽입(갱신)될때
                 새롭게 입력된 자료를 지칭함. DELETE에 사용하면 모든 칼럼이 NULL로 설정
  :OLD           INSERT,UPDATE EVENT에 사용되며 데이터가 삽입(갱신)될때
                 대상이 되는 자료를 지칭함. DELETE에 사용하면 모든 칼럼이 NULL로 설정
                 
2) 트리거 함수
 - 이벤트가 복수개 사용되는 트리거에 사용(이벤트를 OR연산자를 사용해 여러개 사용)
  -------------------------------------------------------------
   트리거 함수           설명
  -------------------------------------------------------------
  INSERTING          트리거 이벤트가 INSERT면 TRUE
  UPDATING           트리거 이벤트가 UPDATE면 TRUE
  DELETING           트리거 이벤트가 DELETE면 TRUE
  
사용예) ORDERS 테이블에서 오늘날짜의 주문 중 'B001'회원이 주문을 취소한 경우
       ORDERS와 ORDER_DETAIL테이블의 변동사항을 처리하는 트리거를 작성하시오.
    
  (트리거 작성)     
  CREATE OR REPLACE TRIGGER TG_DEL_ORDER
    BEFORE DELETE ON ORDERS
    FOR EACH ROW
  DECLARE
    L_ORDER_ID ORDERS.ORDER_ID%TYPE;
  BEGIN
    L_ORDER_ID:=(:OLD.ORDER_ID);
    
    DELETE FROM ORDER_DETAIL
     WHERE ORDER_ID=L_ORDER_ID;
  END;
  
  (자료삭제)
  DELETE FROM ORDERS WHERE ORDER_ID='20230209001'; --자식테이블인 ORDER_TABLE에 4개의행이 같이 삭제
  
사용예) 오늘이 2020년 6월 15일이라고 가정하고 다음 입고자료를 처리하는 트리거 작성
  [입고자료]
   ------------------------------------------------------------- 
   입고일         입고상품코드        수량       단가
   -------------------------------------------------------------
  2020-26-15    P102000004         10       990000    
  2020-06-15    P101000003         20       440000 
  2020-06-15    P202000009         15        28500 
  
create or replace trigger tg_update_buy
  after  insert or update or delete on buyprod
  for each row
declare
  l_qty number:=0;
  l_pid prod.prod_id%type;
  l_date date;
begin
  if inserting then
     l_qty:=(:new.buy_qty);
     l_pid:=(:new.buy_prod);
     l_date:=(:new.buy_date);
  elsif updating then
     l_qty:=(:new.buy_qty - :old.buy_qty);   --NEW로 늘어난 수량에서 기존수량을 (-)하기때문에 결과는 줄어든 수량
     l_pid:=(:new.buy_prod);
     l_date:=(:new.buy_date);  
  elsif deleting then
     l_qty:= -(:old.buy_qty);
     l_pid:=(:old.buy_prod);
     l_date:=(:old.buy_date);  
  end if;
  
  update remain a
     set a.REMAIN_I=a.REMAIN_I+l_qty,
         a.REMAIN_J_99=a.REMAIN_J_99+l_qty,
         a.REMAIN_DATE=l_date
   where a.prod_id=l_pid;
   
  exception when others then
    dbms_output.put_line('예외발생 : '||sqlerrm);
end;

  **함수생성
  - 장바구니번호(cart_no)를 자동으로 생성하는 함수
   
 create or replace function fn_create_cart_no(p_date in date, p_mem_id in member.mem_id%type)
  return varchar2
is
  l_cart_no cart.cart_no%type;
  l_flag number:=0;
  l_no varchar2(8):=to_char(p_date,'yyyymmdd');
  l_member member.mem_id%type;
begin
  select count(*) into l_flag
    from cart
   where cart_no  like l_no||'%';
  
  if l_flag=0 then
     l_cart_no:=l_no||trim('00001');
  else
     select max(cart_no) into l_cart_no
       from cart
      where cart_no like l_no||'%';
      
     select distinct cart_member into l_member
       from cart
      where cart_no=l_cart_no;
      
     if l_member!=p_mem_id then
        l_cart_no:=l_cart_no+1;
     end if; 
     
  end if;
  
  return l_cart_no;   
end;
 
사용예)오늘이 2020년 7월 28일인경우 다음 매출자료를 cart 테이블에 저장하는 프로시져를 
       작성하시오
  create or replace procedure proc_insert_cart(p_cmem  in member.mem_id%type,
    p_pid in prod.prod_id%type, p_qty number)
  is
  
  begin
    insert into cart values(p_cmem,fn_create_cart_no(to_date('20200730'),p_cmem),p_qty,p_pid);
    commit;
  end;
       
  -----------------------------------------------------
   회원번호    상품번호      수량
     b001      P102000005      1
     d001      P102000004      2
      ""       P101000003      1
      ""       P202000009      2

b001	2020072800004	2	P201000017
 
(실행)
   execute proc_insert_cart('b001','P102000005',5);
   execute proc_insert_cart('d001','P102000004',2);

[매출처리: 재고수불테이블 UPDATE, MEMBER 테이블 UPDATE => 트리거본문]

create or replace trigger tg_update_cart
  after  insert or update or delete on cart
  for each row
declare
  l_qty number:=0;
  l_pid prod.prod_id%type;
  l_date date;
  l_mileage number:=0;
  l_mem_id number.mem_id%type;
begin
  if inserting then
     l_qty:=(:new.cart_qty);
     l_pid:=(:new.cart_prod);
     l_date:=(to_date(substr(:new.cart_no,1,8)));
     l_mem_id:=(:new.cart_number);
  elsif updating then
     l_qty:=(:new.cart_qty - :old.cart_qty);   --NEW로 늘어난 수량에서 기존수량을 (-)하기때문에 결과는 줄어든 수량
     l_pid:=(:new.cart_prod);
     l_date:=(to_date(substr(:new.cart_no,1,8)));
     l_mem_id:=(:new.cart_number);
  elsif deleting then
     l_qty:= -(:old.cart_qty);
     l_pid:=(:old.cart_prod);
     l_date:=(to_date(substr(:new.cart_no,1,8))); 
     l_mem_id:=(:old.cart_number);
  end if;
 
 --재고처리 
  update remain a
     set a.REMAIN_I=a.REMAIN_O+l_qty,
         a.REMAIN_J_99=a.REMAIN_J_99-l_qty,
         a.REMAIN_DATE=l_date
   where a.prod_id=l_pid;
 --마일리지 변경
  select prod_mileage*l_qty into l_mileage
    from prod
   where prod_id=l_pid;
    
 update member
    set mem_mileage=mem_mileage+;_mileage
  where mem_id=l_mem_id;  
  
   
  exception when others then
    dbms_output.put_line('예외발생 : '||sqlerrm);
end;

** prod_mileage: (매출단가-매입단가)*0.1%
  select prod_id,
         round(prod_price-prod_cost)*0.001)
    from prod;   
  
  update prod
     set prod_mileage