2023-0203-01)
1.IF문
 - 개발언어의 IF문과 동일기능 제공
(사용형식-1)
 IF 조건문 THEN
    명령문1;
[ELSE
    명령문2;]
 END IF;
 
(사용형식-2) 
 IF 조건문 THEN
    명령문1;
 ELSIF 조건문2 --ELSE IF = ELSIF 헷갈리지않게 주의 / 조건이 한개 이상이면 ELSIF사용
    명령문2;
       :
 ELSE
    명령문n
 END IF;
 
(사용형식-3) Nested IF: 중첩IF
 IF 조건문 THEN 
    IF 조건문2 --조건이 참이면 2번째 조건을 검색
       명령문1; --2번째 조건이 참이면 실행
    ELSE    
       명령문2 --2번째 조건이 틀렸을때 실행
    END IF;
 ELSE
    명령문n;
 END IF;
    
사용예) 키보드로 년도를 입력받아 윤년과 평년을 구별하여 출력하시오.(윤년: 4의배수이면서 100의배수가아니거나 또는 400의 배수)
  ACCEPT P_YEAR PROMPT '년도(YYYY): '
  DECLARE --선언부 : 변수, 상수를 선언
    L_YEAR NUMBER:=TO_NUMBER('&P_YEAR'); --입력년도를 숫자로 변환하여 저장
    L_RES VARCHAR2(100); --결과메세지
  BEGIN -- 실행부 : 제어,반복문, 함수등의 로직을 실행
    IF (MOD(L_YEAR,4)=0 AND MOD(L_YEAR,100)!=0) OR (MOD(L_YEAR,400)=0) THEN  --MOD함수 : 나머지를 반환( JAVA의 %)
        L_RES:=L_YEAR||'년은 윤년입니다.';
    ELSE
         L_RES:=L_YEAR||'년은 평년입니다.';
    END IF;
  
    DBMS_OUTPUT.PUT_LINE(L_RES);
  END; -- 실행된 로직의 종료를 선언
  
2. 커서
 - 넓은 의미의 커서는 SQL명령에 의해 영향받은 행들의 집합이고, 협의의 커서는 SELECT 의 결과 집합을 의미
 - 커서의 종류는 묵시적(IMPLICITE)커서와 명시적(EXPLICITE)커서로 구분
 1)묵시적 커서
  . 이름이 없는 커서
  . SELECT문의 결과 집합이 대표적
  . 생성과 동시에 CLOSE되어 개발자가 커서를 조작할 수 없음
  . 커서속성
  -------------------------------------------------------------
   속성               내용
  -------------------------------------------------------------
  SQL%ISOPEN        커서가 OPEN되어있으면 참(묵시적 커서는 항상 FALSE
  SQL%NOTFOUND      커서 내에 FETCH 할 자료가 없으면 TRUE, 있으면 FALSE
  SQL%FOUND         커서 내에 FETCH 할 자료가 있으면 TRUE, 있으면 FALSE
  SQL%ROWCOUNT      커서 집합의 행의 수 반환
  -------------------------------------------------------------
  
  
  2)명시적 커서
  . 이름을 부여하여 생성한 커서
 (사용형식)
  CURSOR 커서명 IS [(변수명 타입명[,변수명 타입명,...])] 
    SELECT ~;
  .변수명 타입명: 커서에서 사용할 변수 정의, 타입명만 기술해야 함(크기 기술하면 오류)--VARCHAR2(X)
                변수에 할당될 값은 OPEN 문에서 기술
  . 커서의 사용은 4단계를 수행해야 함(FOR문은 예외)
    커서선언(선언영역) => OPEN(실행영역) => FETCH(실행영역 내에서 반복문 내부에 기술) =>CLOSE
    (실행영역 내에서 반복문 밖에 기술)
    
  . 커서속성
  ----------------------------------------------------------------
   속성               내용
  ----------------------------------------------------------------
  커서명%ISOPEN        커서가 OPEN되어있으면 참(묵시적 커서는 항상 FALSE
  커서명%NOTFOUND      커서 내에 FETCH 할 자료가 없으면 TRUE, 있으면 FALSE
  커서명%FOUND         커서 내에 FETCH 할 자료가 있으면 TRUE, 있으면 FALSE
  커서명%ROWCOUNT      커서 집합의 행의 수 반환
  ----------------------------------------------------------------
  1) OPEN 문 사용형식
   OPEN 커서명[(매개변수[,매개변수,...])]; 
   . 매개변수: 커서문에 사용된 변수에 전달할 값
  2) FETCH 문
   . 커서 내부의 결과 값을 행단위로 읽어오는 기능 수행
  (사용형식)
   FETCH 커서명 INTO 변수명[,변수명,...];
    . '변수명' : 커서문에 사용된 SELECT문의 SELECT절의 컬럼값들을 전달받을 변수
    . 대부분의 FETCH 는 반복문 내부에서 기술
   3) CLOSE 문
    . 사용한 커서를 닫을 때 사용
    . OPEN 된 커서는 CLOSE 되지 않으면 재 OPEN 불가
  (사용형식)
    CLOSE 커서명;
  
3. 반복문
 1)LOOP
  -반복문의 기본 구조를 제공
  -무한루프를 수행
 (사용형식)
  LOOP
   반복명령문(들);
  [EXIT WHEN 조건];
        :
  END LOOP;
 .'EXIT WHEN 조건': 반복문을 벗어날 조건 기술
  '조건'이 참이면 반복을 벗어남
  
예) 구구단의 ?단을 출력하시오.
  DECLARE
    L_CNT NUMBER:=1;  
  BEGIN
    LOOP
      DBMS_OUTPUT.PUT_LINE('7 * ' ||L_CNT || '='||7*L_CNT);
      EXIT WHEN L_CNT>=9;
      L_CNT:=L_CNT+1;
    END LOOP;
  END;
  
사용예(커서사용) : 마일리지가 많은 5명의 2020년 5월 구매현황을 조회하시오 출력은 회원번호,회원명,구매금액합계;
  SELECT A.MEM_ID,A.MEM_NAME,A.MEM_MILEAGE
    FROM (SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
            FROM MEMBER
           ORDER BY MEM_MILEAGE DESC)A
  WHERE ROWNUM<=5;   
  
  ---------------------------
DECLARE
  L_HID  MEMBER.MEM_ID%TYPE;  --회원번호
  L_NAME VARCHAR2(80); --회원명;
  L_SUM  NUMBER := 0; --구매금액합계
  
  CURSOR CUR_MEM02 IS
    SELECT A.MEM_ID,A.MEM_NAME
      FROM (SELECT MEM_ID,MEM_NAME,MEM_MILEAGE
              FROM MEMBER
             ORDER BY MEM_MILEAGE DESC)A
     WHERE ROWNUM<=5;
BEGIN
  OPEN CUR_MEM02;
  
  LOOP
    FETCH CUR_MEM02 INTO L_HID,L_NAME;
    EXIT WHEN CUR_MEM02%NOTFOUND;
    --2020년 5월 L_HID회원의 구매금액합계=>L_SUM할당
    SELECT SUM(A.CART_QTY*B.PROD_PRICE) INTO L_SUM
      FROM CART A, PROD B
     WHERE A.CART_PROD=B.PROD_ID
       AND A.CART_NO LIKE '202005%'
       AND A.CART_MEMBER=L_HID;
      
    DBMS_OUTPUT.PUT_LINE (L_HID||' '||RPAD(L_NAME,12)||TO_CHAR(L_SUM,'99,999,999')); 
  END LOOP;
  CLOSE CUR_MEM02; 
END;
  

사용예) 부서번호를 하나 입력받아 해당부서에 소속된 사원들의 사원번호, 사원명, 입사일, 급여를 출력
  DECLARE
    L_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE;
    L_ENAME VARCHAR2(80);
    L_HDATE DATE;
    L_SAL NUMBER:=0;
    
    CURSOR CUR_EMP02(P_DID HR.DEPARTMENTS.DEPARTMENT_ID%TYPE) IS
      SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE,SALARY
        FROM HR.EMPLOYEES
       WHERE DEPARTMENT_ID=P_DID; 
  BEGIN
    OPEN CUR_EMP02(60);
    FETCH CUR_EMP02 INTO L_EID,L_ENAME,L_HDATE,L_SAL;
    --LOOP
    WHILE CUR_EMP02%FOUND LOOP
      FETCH CUR_EMP02 INTO L_EID,L_ENAME,L_HDATE,L_SAL;
     -- EXIT WHEN CUR_EMP02%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE (L_EID||' '||RPAD(L_ENAME,30)||' '||L_HDATE||
                            TO_CHAR(L_SAL,'999,999'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE ('=======================================================');
    DBMS_OUTPUT.PUT_LINE ('사원 수 : '||CUR_EMP02%ROWCOUNT);  
    CLOSE CUR_EMP02;
  END;
  
2) WHILE 문
 - 개발언어의 WHILE 문과 유사
 (사용형식)
 WHILE 조건 LOOP
   반복처리할 명령문(들);
 END LOOP;
 . WHILE 문은 '조건' 평가 결과가 참인경우에 반복 수행
 
 사용예) 구구단 7단을 출력
  DECLARE
    L_CNT NUMBER:=1;
  BEGIN
    WHILE L_CNT<=9 LOOP
      DBMS_OUTPUT.PUT_LINE('7 * ' ||L_CNT||' =  '||7*L_CNT);
      L_CNT:=L_CNT+1;
    END LOOP;
  END;
  

3) FOR 문
 - 개발언어의 FOR문과 유사
 - 반복횟수를 정확히 알고 있거나 반복횟수가 중요할 때
 (일반 FOR문 사용형식)
  FOR 인덱스 IN [REVERSE] 초기값.. 최종값 LOOP
    반복수행해야할 명령문(들);
            :
    END LOOP;
  . '인덱스' : 초기값부터 최종값까지를 보관하여 반복횟수를 제어하는 제어변수로 시스템에서 자동 설정해줌
  . [REVERSE] : 역순으로 반복
  
사용예) 구구단의 7단
  DECLARE
  BEGIN
    FOR I IN 1..9 LOOP
    DBMS_OUTPUT.PUT_LINE ('7*'||I||'='||7*I);
    END LOOP;
  END;
  
 (커서용 FOR문 사용형식)
  FOR 레코드명 IN 커서명|서브쿼리 LOOP
    반복수행해야할 명령문(들);
            :
    END LOOP;
  . '레코드명' : 커서의 첫번째 값부터 마지막 값까지를 참조하는 참조변수로 시스템에서 자동 설정해줌  
  . 커서내의 컬럼명 접근은 '레코드명'.커서컬럼명 형식을 사용함.
  . FOR문을 사용하면 OPEN, FETCH, CLOSE 문을 생략한다.
  
  사용예)부서번호를 하나 입력받아 해당부서에 소속된 사원들의 사원번호,사원명,입사일,급여를 
      출력하시오.
  DECLARE     
  BEGIN
   FOR REC IN (SELECT EMPLOYEE_ID,EMP_NAME,HIRE_DATE,SALARY
                 FROM HR.EMPLOYEES
                WHERE DEPARTMENT_ID=60) 
   LOOP
      DBMS_OUTPUT.PUT_LINE (REC.EMPLOYEE_ID||' '||RPAD(REC.EMP_NAME,30)||' '||
                            REC.HIRE_DATE||TO_CHAR(REC.SALARY,'999,999'));                      
   END LOOP;
   DBMS_OUTPUT.PUT_LINE ('=======================================================');
  END;  
  
  