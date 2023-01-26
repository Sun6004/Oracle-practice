2023-0118-01) �����Լ�
  1) SYSDATE - '****', SYSTIMESTAMP - '***'
    - ������ ���ڿ� �ð��� DATE�� TIMESTAMPŸ������ ��ȯ
    
��뿹)
    SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;
    
    SELECT SYSDATE+3, SYSDATE-19 FROM DUAL;
    
2) ADD_MONTHS(d, n) -**-
  - �־��� ���� d�� n������ ���� ���ڸ� ��ȯ
  - ��ȯ�Ǵ� ������ Ÿ���� ����Ÿ��
  
��뿹) HR������ ������̺��� �Ի��Ͽ� 10���� ���� ���ڷ� �����Ͻÿ�.
  . ���� ���� ����
    CREATE TABLE T_EMP AS
      SELECT * FROM HR.EMPLOYEES;
  . ������̺� ���� ����
    UPDATE HR.EMPLOYEES
      SET HIRE_DATE=ADD_MONTHS(HIRE_DATE,120);
      
      COMMIT;
      
      SELECT EMP_NAME,HIRE_DATE
        FROM HR.EMPLOYEES;
        
3) MONTHS_BETWEEN(d1,d2) -'**'
  - �� ���� �ڷ� d1�� d2������ �������� ��ȯ
  - d1 > d2�� ��� ����� ������ ��ȯ
  - d1 < d2�� ��� ������ ������ ��ȯ
  
��뿹)
  SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('20010415'))
    FROM DUAL;
  => �Ҽ����� ���ַ���
  SELECT ROUND(MONTHS_BETWEEN(SYSDATE, TO_DATE('20230101')))
    FROM DUAL;
��뿹) ������̺��� �Ի����� Ȱ���Ͽ� �� ����� �ټӳ���� ��Ȯ�ϰ� XX�� XX��
       �������� ��ȸ�Ͻÿ�.
       Alias�� �����ȣ, �����, �Ի���, �ټӱⰣ
       SELECT EMPLOYEE_ID AS �����ȣ,
              FIRST_NAME || LAST_NAME AS �����,
              HIRE_DATE AS �Ի���,
              ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))||'����' AS ������,
              TRUNC(ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE))/12) ||'��' ||
              MOD(ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)),12)||'����' AS �ټӱⰣ
              
            FROM HR.EMPLOYEES;
            
 4) NEXT_DAY(d, 'fmt')
  - ������ d�� ���� ó�� ������'fmt' ���Ͽ� �ش��ϴ� ���� ��ȯ
  - 'fmt' �� ����ǥ�� �� ���� �޶���
   . ����ǥ���� ������ ��� : SUNDAY, SUN..
   . ����ǥ���� �ѱ��� ��� : �Ͽ���, ��,��, ȭ����
   .������ INDEX��(1:�Ͽ���, 2:������,..7:�����)
   
��뿹)
  SELECT NEXT_DAY(SYSDATE,'������'),
         NEXT_DAY(SYSDATE,4) --�Ͽ���1���ͽ����ϴ� ���Ͽ� ���� INDEX��
    FROM DUAL;
    
5)LAST_DAY(d) - '***'
 - �־��� ���� d�� ǥ���� ���� ���������ڸ� ��ȯ
 - �ַ� ���ǳ⵵�� 2���� ���������� �ʿ��� ��� �Ǵ� ������ ���� �Է¹޾�
   �ش���� ���������� ���� �� ���

��뿹)�������̺��� 2020�� 2�� ��ǰ�� ���Լ����� ���Աݾ� �հ踦 ��ȸ�Ͻÿ�.
    SELECT BUY_PROD AS ��ǰ�ڵ�,
           SUM(BUY_QTY) AS ���Լ���,
           SUM(BUY_QTY*BUY_COST) AS ���Աݾ�
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20200201') AND LAST_DAY(TO_DATE('20200201'))
        GROUP BY BUY_PROD;
        
 ��뿹) Ű����� �⵵�� ���� 6�ڸ� ���ڷ� �Է¹޾� �ش� �Ⱓ���� �߻��� ���԰Ǽ��� ����Ͻÿ�.
    ACCEPT P_PERIOD PROMPT '�Ⱓ �Է�(YYYYMM) : '
    DECLARE
      L_SDATE DATE := TO_DATE('&P_PERIOD'||'01');
      L_SDATE DATE := LAST_DAY(L_SDATE);
      L_COUNT NUMBER := 0;
    BEGIN
      SELECT COUNT(*) INTO L_COUNT
        FROM BUYPROD
      WHERE BUY_DATE BETWEEN L_SDATE AND L_EDATE;
      
      DBMS_OUTPUT.PUT_LINE(SUBSTR('&P_PERIOD',4)||'��'||SUBSTR('&P_PERIOD',5)||
      '�� ���� �Ǽ�: '|| L_COUNT);
    END;
    
            