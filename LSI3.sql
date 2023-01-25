2023-0112-01) ��Ÿ������
  -��Ÿ������ : in, any, some, all, exists, between, like ��

1) IN ������
 . �־��� �ڷ� �� ��� �ϳ��� ��ġ�ϸ� TRUE �� ��ȯ
 . �����ڿ� '='�ǹ̰� �����Ǿ� ����
(�������)
    EXPR IN (��1[,��2,...])
    - 'EXPR'(ǥ���� : �÷��̳� ����, �Լ� ��)�� ���� '��1' ~'��n' �� ��� �ϳ���
      ��ġ�ϸ� ��ü ����� TRUE �� ��
    - ���������� �ʰ� �ұ�Ģ�� ����� ���� �� �ַ� ���
    -'OR' �����ڷ� �ٲپ� �� �� ����.
    
    ��뿹) ��ǰ���̺�(PROD)���� �з��ڵ� 'P102','P201','P302'�� ���� ��ǰ��
           ��ǰ��ȣ, ��ǰ��, ���԰�, ���Ⱑ�� ��ȸ�Ͻÿ�. 
        
        select prod_id as ��ǰ��ȣ,
               prod_name as ��ǰ��,
               prod_cost as ���԰�,
               prod_lgu as �з��ڵ�,
               prod_price as ���Ⱑ
            from prod
        where prod_lgu = 'p102'
           or prod_lgu = 'p201'
           or prod_lgu = 'p302'
        order by 1;
        
(IN ������ ���)
     select prod_id as ��ǰ��ȣ,
               prod_name as ��ǰ��,
               prod_cost as ���԰�,
               prod_lgu as �з��ڵ�,
               prod_price as ���Ⱑ
            from prod
        where prod_lgu IN('P102','P201','P302')

        order by 1;
        
(ANY(SOME) ������ ���)
    select prod_id as ��ǰ��ȣ,
               prod_name as ��ǰ��,
               prod_cost as ���԰�,
               prod_lgu as �з��ڵ�,
               prod_price as ���Ⱑ
            from prod
        where prod_lgu =ANY('P102','P201','P302')

        order by 1;
        
2) ANY(SOME) ������
  .ANY�� SOME�� ���� ��ɰ� ���� ������� ������ ����
(�������)
  EXPR ���迬����ANY|SOME(��1,��2[��3,...])
   - 'EXPR'�� ���� ( )���� ��� �ϳ��� '���迬����'�� ������ �����ϸ� TRUE ��ȯ
   - ���迬���� '>'�� ���� ����ϸ� ( )���� �� �� �ּҰ� ���� ū �ڷḦ �˻��� �� ����
   
** ALTER ���
  .DCL�� ���� ������� ��ü�� ���� ���濡 ���
  1) TABLE �� �ɷ� �߰�, ����, ����
    - Į���� �߰�
      ALTER TABLE ���̺�� ADD(�÷��� ������Ÿ��[ũ��])
      
    - Į�� ����(������Ÿ�� ����,ũ�⺯��)
      ALTER TABLE ���̺�� MODIFY(�÷��� ������Ÿ��[ũ��]) --�̹� �����Ͱ� ����Ǿ����� ��, �� ����������� ����Ұ�
      
    - �÷� ����
      ALTER TABLE ���̺�� DROP COLUMN �÷���
      
    - �÷��� ����
      ALTER TABLE ���̺�� RENAME COLUMN OLD_�÷��� TO NEW_�÷���
  
  2) ���������� �߰�, ���濡 ��� 
    -��������(�⺻Ű OR �ܷ�Ű)�߰�
      ALTER TABLE ���̺�� ADD CONSTRAINT ���������̸� ��������
      
    -��������(�⺻Ű OR �ܷ�Ű)����(�������� �̸�����)
      ALTER TABLE ���̺�� RENAME CONSTRAINT OLD_�������Ǹ� TO NEW_�������Ǹ�
      
    -��������(�⺻Ű OR �ܷ�Ű)����
      ALTER TABLE ���̺�� DROP CONSTRAINT ���������̸�
      
  3) ���̺���� ���濡 ���
    - ALTER TABLE OLD_���̺�� RENAME TO NEW_���̺��

��뿹) HR ������ ENPLOYEES���̺� ���ο� �÷� EMP_NAME VARCHAR2(50)�� �߰��Ͻÿ�
    ALTER TABLE HR.EMPLOYEES ADD(EMP_NAME VARCHAR2(50));
    
��뿹) ������̺��� EMP_NAME�÷��� FIRST_NAME �� LAST_NAME�� ����� �ڷḦ �����Ͽ� ����Ͻÿ�.
  ** UPDATE ��
   - DML (INSERT, UPDATE, DELETE, MERGE)�� ���� ���
   - �����ϰ� �ִ� �ڷ��� ������ ����ó��
  (�������)
    UPDATE ���̺��
        SET �÷���1 = ��1[,]
            [�÷���2 = ��2[,]]
                   : 
            �÷���n = ��[n]
        [WHERE ����]
        
    UPDATE HR.EMPLOYEES
        SET EMP_NAME = FIRST_NAME||' '||LAST_NAME;
        
    SELECT FIRST_NAME, LAST_NAME, EMP_NAME
        FROM HR.EMPLOYEES;
        
    COMMIT;
��뿹) ������̺��� 100�� �μ��� ���� ����� �ּ� �޿����� ���� �޿��� �޴� �����
       �����ȣ, �����, �μ��ڵ�, �޿��� ��ȸ�Ͻÿ�.
       SELECT EMPLOYEE_ID AS �����ȣ,
              EMP_NAME AS �����,
              DEPARTMENT_ID AS �μ��ڵ�,
              SALARY AS �޿�
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
    (�������)
     EXPR ���迬���� ALL(��1, ��2[,��3,...])
      . EXPR�� ����� ���� ()���� ��� ���� ���迬���� ������ �����ϸ� TRUE ��ȯ
      . ����ϴ� ���迬���� �� '=' �� ����� �� ����
      . '>'�� ����� ALL �� '��1' ~'��n' ������ �� �� �ִ밪���� ū ����� ��� ���
      
��뿹) ������̺��� 100�� �μ��� ���� ����� �ִ� �޿����� ���� �޿��� �޴� �����
       �����ȣ, �����, �μ��ڵ�, �޿��� ��ȸ�Ͻÿ�.
     SELECT EMPLOYEE_ID AS �����ȣ,
            EMP_NAME AS �����, 
            DEPARTMENT_ID AS �μ��ڵ�,
            SALARY AS �޿�
        FROM HR.EMPLOYEES
        WHERE SALARY > ALL(SELECT SALARY
                            FROM HR.EMPLOYEES
                            WHERE DEPARTMENT_ID = 100)
            --AND DEPARTMENT_ID != 100 (��������)
        ORDER BY 4 DESC;
        
4) BETWEEN ������
   - �������̰ų� ��Ģ���� ������ �ִ� ������ ���Ҷ� ���
   - �ַ� ���� ������ ���
   - AND �����ڸ� ����� �� ����
  (�������)
    EXPR BETWEEN ��1 AND ��2
      . EXPR�� ���� '��1'~'��2' ������ ���̸� ��(TRUE)�� ��ȯ
      . EXPR >= ��1 AND EXPR <= ��2 �� ���پ� ����� �� ����
      . ��� ������ Ÿ�Կ��� ��밡��
      
��뿹) �������̺�(BUYPROD)���� 4�� 1�� ~ 4�� 20�� ��¥������ ���������� ��ȸ
    ALIAS �� ��¥, ��ǰ�ڵ�, ����, �ݾ�
    
    SELECT BUY_DATE AS ��¥,
           BUY_PROD AS ��ǰ�ڵ�,
           BUY_QTY AS ����,
           BUY_QTY*BUY_COST AS �ݾ�
      FROM BUYPROD
      WHERE BUY_DATE >= TO_DATE('20200401') AND BUY_DATE <= TO_DATE('20200430')
      ORDER BY 1;

(BETWEEN ������ ���)
    SELECT BUY_DATE AS ��¥,
           BUY_PROD AS ��ǰ�ڵ�,
           BUY_QTY AS ����,
           BUY_QTY*BUY_COST AS �ݾ�
      FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
      ORDER BY 1;

��뿹) ��ǰ���̺��� �з��ڵ� 'P200' ���뿡 ���� ��ǰ�� ��ǰ��ȣ, ��ǰ��, �ǸŰ�, ���԰��� ��ȸ
    SELECT PROD_ID AS ��ǰ��ȣ,
           PROD_NAME AS ��ǰ��,
           PROD_LGU AS �з��ڵ�,
           PROD_PRICE AS �ǸŰ�,
           PROD_COST AS ���԰�       
        FROM PROD
        WHERE PROD_LGU BETWEEN 'P200' AND 'P299'
        
��뿹) ȸ�����̺��� �������ϸ����� 2000~3000������ ȸ������ ȸ����ȣ, ȸ����, ����, ������ ��ȸ�Ͻÿ�
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           EXTRACT(YEAR FROM SYSDATE) -EXTRACT(YEAR FROM MEM_BIR) AS ����,
           CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN('2','4') THEN '����'
           ELSE '����' 
           END AS ����,
           MEM_MILEAGE AS ���ϸ���
        FROM MEMBER
        WHERE MEM_MILEAGE BETWEEN 2000 AND 3000
        
5) LIKE ������
  - ���Ϻ� ������
  - ���ڿ� �� ������ (���ڳ� ��¥ �񱳿� ��� ����)
  - ������ �����ϴ� ���ڷ� '%','_'(���ϵ�ī��)���
    .'%' : '%' �� ���� ������ ��� ���ڿ��� ����(���鵵 ������)
    . EX) '��%' : '��'�ڷ� �����ϴ� ��� ���ڿ��� ��(TRUE)�� ��ȯ
          '%��' : '��'�ڷ� ������ ��� ���ڿ��� ��(TRUE)�� ��ȯ
          '%��%': ���ڿ� ���ο� '��' �� ������ ��(TRUE)�� ��ȯ
           
    .'_' : '_' �� ���� ��ġ�� �ϳ��� ���ڿ��� ����
    . EX) '��_' : '��'�ڷ� �����ϰ� 2���� ���ڷ� ������ ���ڿ��� ��(TRUE)�� ��ȯ
          '_��' : '��'�ڷ� ������ 2���� ���ڷ� ������ ���ڿ��� ��(TRUE)�� ��ȯ
          '_��_': 3���� ���ڷ� �����ǰ� ���ڿ� ����� '��' �� ������ ��(TRUE)�� ��ȯ
          
(�������)
    �÷��� LIKE '���Ϲ��ڿ�'
    
��뿹) ȸ�����̺��� �������� �泲�� ȸ������ ȸ����ȣ, ȸ����, �ּҸ� ��ȸ�Ͻÿ�.
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_ADD1 || ' '|| MEM_ADD2 AS �ּ� 
        FROM MEMBER
        WHERE MEM_ADD1 LIKE '�泲%';
    
��뿹) ��ٱ��� ���̺��� 2020�� 6�� ���������� ��ȸ�Ͻÿ�
    SELECT CART_QTY AS ��������
        FROM CART_NO
        

��뿹) �������̺��� 2020�� 6�� ���������� ��ȸ�Ͻÿ�
    ALIAS�� ��¥, ��ǰ��ȣ, ���Լ���
    
    SELECT TO_DATE(SUBSTR(CART_NO,1,8)) AS ��¥,
           CART_PROD AS ��ǰ��ȣ,
           CART_QTY AS ���Լ���
        FROM CART
        WHERE CART_NO LIKE '202006%'
        ORDER BY 1;
        
��뿹) �������̺��� 2020�� 6�� ���������� ��ȸ�Ͻÿ�
        ALIAS�� ��¥, ��ǰ��ȣ, ���Լ���
      SELECT BUY_DATE AS ��¥,
             BUY_PROD AS ��ǰ��ȣ,
             BUY_QTY AS ���Լ���
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20200601') AND TO DATE('2000630')
        ORDER BY 1;
   

          
    