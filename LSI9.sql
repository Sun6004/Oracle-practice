2023-0119-01)NULLó�� �Լ�
  - ����Ŭ�� �⺻ �ʱ�ȭ ���� �������� ������ Ÿ�Կ� ������� NULL��
  - NULLŸ���� �ڷ�� � Ÿ���� �ڷᰡ ����(��Ģ,��)�Ǹ� ����� NULL��
  - NULL ó���� ���� �Լ��� ������ : IS [NOT] NULL, NVL, NVL2, NULLIF���� ����
  
1. IS [NOT] NULL
 . Ư�� �÷��̳� ���� ���� NULL���� �Ǻ��Ͽ� TRUE OR FALSE �� ��ȯ
 . ������� '='���δ� NULL�� �Ǻ��� �� ����
 
��뿹) ��ǰ���̺��� ��������(PROD_COLOR)�� ���� ��ǰ�� ��ǰ��ȣ,��ǰ��,ũ��,������ ��ȸ�Ͻÿ�.
        
    SELECT PROD_ID AS ��ǰ��ȣ,
           PROD_NAME AS ��ǰ��,
           PROD_SIZE AS ũ��,
           PROD_COLOR AS ����
        FROM PROD
        WHERE PROD_COLOR IS NOT NULL;
        
2. NVL(expr,val)
  - 'expr'���� NULL�̸� 'val'�� ����ϰ�, NULL�� �ƴϸ� expr���� ���
  - 'expr'�� 'val'�� ���� Ÿ���̾�� ��
  
��뿹) ������̺��� ���������� NULL�̸� '������������'��, ���������� ������ ���������� ������ ���
       Alias�� �����ȣ, �����, �μ��ڵ�, �����ڵ�, ���
    SELECT EMPLOYEE_ID AS �����ȣ,
           EMP_NAME AS �����,
           DEPARTMENT_ID AS �μ��ڵ�,
           JOB_ID AS �����ڵ�,
           NVL(TO_CHAR(COMMISSION_PCT,'0.00'),'������������') AS ���   
        FROM HR.EMPLOYEES;
        
**�������̺��� ���Ե� ��ǰ�� �з��ڵ��� ���� �� ���Լ��� �հ�
  SELECT B.LPROD_GU AS �з��ڵ�,
         SUM(A.BUY_QTY) AS ���Լ����հ�
    FROM BUYPROD A, LPROD B, PROD C
    WHERE A.BUY_PROD=C.PROD_ID
      AND C.PROD_LGU=B.LPROD_GU
      GROUP BY B.LPROD_GU
      ORDER BY 1;
    
��뿹) ��� �з��ڵ庰 ��ո��԰��� ���Ͻÿ�.
    SELECT LPROD_GU AS �з��ڵ�,
           ROUND(AVG(A.PROD_COST)) AS ��ո��԰�
        FROM PROD A, LPROD B
    WHERE A.PROD_LGU(+)=B.LPROD_GU
    GROUP BY B.LPROD_GU
    ORDER BY 1;

**��ǰ���̺� ����ϴ� �з��ڵ��� ����
  SELECT DISTINCT PROD_LGU
    FROM PROD;
  
3. NVL2(expr,val1,val2) --NULL�̰ų� �ƴҶ�, ���� �ٸ����� ����ϱ� ���� ���.
  - 'expr'���� NULL�̸� val2�� ��ȯ�ϰ�, NULL�� �ƴϸ� val1�� ��ȯ��
  - val1�� val2�� �ݵ�� ���� ������ Ÿ���̾�� ��
  - NVL2�� NVL�� ������ �� ����
  
** ��ǰ���̺��� �з��ڵ尡 P301�� ���� ��ǰ���� �ǸŰ��� ���԰��� �����Ͻÿ�.
  UPDATE PROD 
    SET PROD_PRICE = PROD_COST
    WHERE UPPER(PROD_LGU) = 'P301';
    
    COMMIT; --����
    
    ROLLBACK;-- �Ǽ��� �߸��������� �ǵ���
    
��뿹) ��ǰ���̺��� ��ǰ�� ũ��(PROD_SIZE)������ ��ȸ�Ͽ� ũ�������� ������
       'ũ�� ���� ����'�� ũ�� ������ ������ 'ũ�� : '���ڿ��� ũ�������� ����Ͻÿ�
       Alias�� ��ǰ�ڵ�, ��ǰ��, ũ��, ���     
    SELECT PROD_ID AS ��ǰ�ڵ�,
           PROD_NAME AS ��ǰ��,
           NVL2 (PROD_SIZE, 'ũ��: ' || PROD_SIZE, 'ũ����������') AS ���  
      FROM PROD;
    
��뿹) ������̺��� ��������COMMISSION_PCT)�� ��ȸ�Ͽ� ���������� ������ ��� '��������'�� ����ϰ� 
       ���������� ������ �ش� �μ��ڵ�(DEPARTMENT_ID)�� ����Ͻÿ�.
       Alias�� �����ȣ, �����, �Ի���, ���
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              HIRE_DATE AS �Ի���,
              NVL2(COMMISSION_PCT, NVL(TO_CHAR(DEPARTMENT_ID),'�μ�����'),'��������') AS ���
        FROM HR.EMPLOYEES;
        
3. NULLIF(COL1,COL2)-'**'
  - COL1 �� COL2�� ���Ͽ� ���� ���̸� NULL�� ��ȯ�ϰ� ���� �ٸ����̸� COL1�� ��ȯ

��뿹) ��ǰ���̺��� ���Ⱑ�� ���԰��� �����ϸ� ���Ͷ���'����������ǰ'��, ���� �ٸ���
       �ǸŰ����� ���԰��� �� ���ͱݾ��� ����Ͻÿ�
       Alias�� ��ǰ�ڵ�, ��ǰ��, ����
   SELECT PROD_ID AS ��ǰ�ڵ�,
          PROD_NAME AS ��ǰ��,
          NVL2(NULLIF(PROD_COST,PROD_PRICE),TO_CHAR(PROD_PRICE-PROD_COST,'9,999,999'),'����������ǰ') AS ����1,
     CASE WHEN NULLIF(PROD_COST,PROD_PRICE) IS NULL THEN '��������'
     ELSE TO_CHAR(PROD_PRICE-NULLIF(PROD_COST,PROD_PRICE),'9,999,999')
     END AS ����2
     FROM PROD;
    
    
    
    
    
    
    
