2023-0125-01) ROLLUP �� CUBE�Լ�
  - GROUP BY �� �ȿ��� ���Ǿ� �پ��� ���踦 ��ȯ��
1. ROLLUP(col1,col2,***)
  - ROLLUP �� ���� Į������ ������ �����ϰ� �� ������ �հ�(�߰� �հ�)�� ��ȯ
  - ������ ROLLUP ���� ���� ��� �÷��� ����� ��찡 �� ���������̰� ���Ŀ� 
    ������ �÷����� 1���� ������ ������ ������ ������. ���������� ��� Į���� ���ŵ�
    (��ü���̺�)��ü �հ谡 ��ȯ��
  - ���� �÷��� ���� n���̸�P+1,������ ���谡 ��ȯ��
  - �Ϻ��� �÷��� ROLLUP �� �ȿ� ����ǰ� ������ �׷���� �÷��� ROLLUP�ۿ� ����� ��츦 �κ� ROLLUP�̶���
  
  
��뿹) ��ٱ��� ���̺��� 2020�� ����,ȸ����,��ǰ��,������������� ���Ͻÿ�(GROUP BY���� ���)
SELECT SUBSTR(CART_NO,5,2) AS ��,
       CART_MEMBER AS ȸ����,
       CART_PROD AS ��ǰ��,
       SUM(CART_QTY) AS �����������
  FROM CART
  WHERE SUBSTR(CART_NO,1,4)='2020'
  GROUP BY ROLLUP(SUBSTR(CART_NO,5,2),CART_MEMBER,CART_PROD)
  --GROUP BY SUBSTR(CART_NO,5,2),ROLLUP(CART_MEMBER,PROD_ID):�κ�ROLLUP(��ü���� �ȳ���)
   ORDER BY 1;
  
2. CUBE(col1,col2,...)
  - ���� �÷����� ���ջ���Ͽ� ���� �� �ִ� ��� ����� ����ŭ�� ���踦 ��ȯ
  - ������ ������� ����
  - ���� �÷��� n���϶� ��ȯ�Ǵ� ������ ������ 2^n������
  
  (CUBE�Լ� ���)
SELECT SUBSTR(CART_NO,5,2) AS ��,
       CART_MEMBER AS ȸ����,
       PROD_ID AS ��ǰ��,
       SUM(CART_QTY) AS �����������
  FROM CART
  WHERE SUBSTR(CART_NO,1,4)='2020'
  GROUP BY CUBE(SUBSTR(CART_NO,5,2),CART_MEMBER,PROD_ID)
  --GROUP BY SUBSTR(CART_NO,5,2),CUBE(CART_MEMBER,PROD_ID) �κ�CUBE: CART_NO�� �׻� ���Խ�Ű�� CUBE�� ���� �÷��� ����
  ORDER BY 1;
  

����(JOIN)
  - �ʿ��� �����Ͱ� ���� ���̺� �л�Ǿ� �ְ� �� ���̺���� ���踦 �ΰ� ���� �� �����ϴ� ����
  - ����(RELATIONSHIP)�� �̿��� ����
  - ����
   . ���� �����ڿ� ���� ��������(Equi JOIN), �񵿵�����(Non Equi JOIN)
   . ���� ��� ���� : ��������(SELF JOIN)
   . ���� ���ǿ� ���� : ��������(INNER JOIN), �ܺ�����(OUTER JOIN), īŸ�þ�(CARTASIAN, CROSS JOIN), ��������(SEMI JOIN)
   . ��Ÿ : ANSI JOIN
1. ��������
  - ���������� �����ϴ� �ุ ����� ��ȯ�ϰ� ���������� �������� �ʴ� �����ʹ� ������.
 1) īŸ�þ�(CARTASIAN, CROSS JOIN)
  - ���������� ���ų� ���������� �߸� ����� ���
  - �ݵ�� �ʿ��� ��찡 �ƴϸ� �������� ���ƾ� ��
  - A(a�� b��) B �� ���̺� īŸ�þ� ������ �����ϸ� ����� �־��� ���(���������� ���� ���)a*c �� b+d���� ��ȯ
��뿹) 
  SELECT COUNT(*) FROM BUYPROD; -- �������̺��� ��� ���� �� 
  SELECT COUNT(*) FROM CART; -- �������̺��� ��� ���� ��
  SELECT COUNT(*) FROM PROD; -- ��ǰ���̺��� ��� ���� ��
  SELECT 148*207*74 FROM DUAL;
  
  SELECT COUNT(*)
    FROM BUYPROD, CART, PROD;--BUYPROD*CART*PROD
  SELECT * FROM BUYPROD, CART, PROD;
  
 1-2) CROSS JOIN
  . ANSI���� �����ϴ� CARTESIAN PRODECT
(�������)
 SELECT �÷�list
    FROM ���̺��1 [��Ī1]
    CROSS JOIN ���̺��2 [��Ī2] [ON(��������)][,]
                        :
    CROSS JOIN ���̺��n [��Īn] [ON(��������)]
    
��뿹)
  SELECT COUNT(*)
    FROM BUYPROD A
  CROSS JOIN CART B
  CROSS JOIN PROD C; -- =īŸ�þ�
  
  
 2) ��������(Equi JOIN)
  - JOIN���ǹ��� ����ϴ� �����ڰ� '='�� ����
(�������:�Ϲ� ����)
 SELECT [���̺�Ī.|���̺��]�÷��� [AS �÷���Ī][,]
                         :
        [���̺�Ī.|���̺��]�÷��� [AS �÷���Ī]
    FROM ���̺��1 [��Ī1], ���̺��2 [��Ī2] [,���̺��3 [��Ī3],...]
    WHERE JOIN����
    [AND �Ϲ�����]
    .'���̺�Ī.���̺��' : ��� �÷����� �ٸ��� ���� ����
    . ���� ���̺��� ������ n���϶� '��������'�� ������ ���n-1�� �̻��̾�� �ԡ�
    
  (�������: ANSI INNER JOIN)
  SELECT [���̺�Ī.|���̺��]�÷��� [AS �÷���Ī][,]
                         :
        [���̺�Ī.|���̺��]�÷��� [AS �÷���Ī]
    FROM ���̺�1 [��Ī1]
    INNER JOIN ���̺�2 [��Ī2] ON(��������[AND �Ϲ�����])
    INNER JOIN ���̺�3 [��Ī3] ON(��������[AND �Ϲ�����])
                            :
    [WHERE �Ϲ�����]
    . ���̺�1�� ���̺�2 �� �ݵ�� ���� ���� �����ؾ� ��
    . '[AND �Ϲ�����]' : �ش� ���̺��� ����Ǵ� ���� ���
    . 'WHERE �Ϲ�����' : �������� ����� �Ϲ����� ���
    . ���̺�1�� ���̺�2�� ���ε� ����� ���̺� 3�� ���ε�
   
   
��뿹) ������̺��� 20~40�� �μ��� �Ҽӵ� ����� �����ȣ,�����,�μ���ȣ,�μ���,�������� ��ȸ�Ͻÿ�
(�Ϲ����ι�) 
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           B.DEPARTMENT_ID AS �μ���ȣ,
           B.DEPARTMENT_NAME AS �μ���,
           C.JOB_TITLE AS ������
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.JOBS C
      WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID --JOIN����
      AND A.JOB_ID=C.JOB_ID --JOIN����
      AND A.DEPARTMENT_ID BETWEEN 20 AND 40 --�Ϲ�����
      ORDER BY 3;

(ANSI JOIN)
  SELECT  A.EMPLOYEE_ID AS �����ȣ,
          A.EMP_NAME AS �����,
          B.DEPARTMENT_ID AS �μ���ȣ,
          B.DEPARTMENT_NAME AS �μ���,
          C.JOB_TITLE AS ������
      FROM HR.EMPLOYEES A
      INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID AND
                 A.DEPARTMENT_ID BETWEEN 20 AND 40)
      INNER JOIN HR.JOBS C ON(A.JOB_ID=C.JOB_ID)
      ORDER BY 3;
      
��뿹)2020�� 4�� ��ǰ�� �������踦 ��ȸ�Ͻÿ� Alias�� ��ǰ�ڵ�, ��ǰ��, ��������հ�, ����ݾ��հ�
  SELECT A.CART_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         SUM(A.CART_QTY) AS ��������հ�,
         SUM(A.CART_QTY*B.PROD_PRICE) AS ����ݾ��հ�
   FROM CART A
   INNER JOIN PROD B ON(A.CART_PROD=B.PROD_ID)--JOIN����
   WHERE A.CART_NO LIKE '202004%'
   GROUP BY A.CART_PROD,B.PROD_NAME
   ORDER BY 1;
   
��뿹) 2020�� 1-6�� �ŷ�ó�� �������踦 ��ȸ�Ͻÿ�.Alias�� �ŷ�ó�ڵ�, �ŷ�ó��, ���Աݾ� �հ�
    SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
             A.BUYER_NAME AS �ŷ�ó��,
             SUM(B.BUY_QTY*C.PROD_COST) AS "���Աݾ� �հ�"
    FROM BUYER A, BUYPROD B, PROD C
    WHERE B.BUY_PROD=C.PROD_ID --JOIN
     AND  C.PROD_BUYER=A.BUYER_ID --JOIN
     AND B.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
     GROUP BY A.BUYER_ID, A.BUYER_NAME
     ORDER BY 1;
     
(ANSI FORMAT)
    SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
             A.BUYER_NAME AS �ŷ�ó��,
             SUM(B.BUY_QTY*C.PROD_COST) AS "���Աݾ� �հ�"
    FROM BUYER A
    INNER JOIN PROD C ON(C.PROD_BUYER=A.BUYER_ID)
    INNER JOIN BUYPROD B ON(B.BUY_PROD=C.PROD_ID AND
      B.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630'))
     GROUP BY A.BUYER_ID, A.BUYER_NAME
     ORDER BY 1;
     
����) HR�������� �̱� �̿��� ������ �ִ� �μ��� �ٹ��ϴ� ������� ��ȸ�Ͻÿ�
     Alias�� �����ȣ, �����, �μ��ڵ�, �μ���, �μ��ּ� (�̱��� �����ڵ�� US)
     SELECT A.EMPLOYEE_ID AS �����ȣ,
            A.EMP_NAME AS �����,
            B.DEPARTMENT_ID AS �μ��ڵ�,
            B.DEPARTMENT_NAME AS �μ���,
            C.STATE_PROVINCE || ' ' || C.CITY ||' '|| C.STREET_ADDRESS AS �μ��ּ�
     FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
     WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID AND B.LOCATION_ID=C.LOCATION_ID
       AND C.COUNTRY_ID NOT IN('US')
       ORDER BY 3;

(ANSI FORMAT)
SELECT A.EMPLOYEE_ID AS �����ȣ,
            A.EMP_NAME AS �����,
            B.DEPARTMENT_ID AS �μ��ڵ�,
            B.DEPARTMENT_NAME AS �μ���,
            C.STATE_PROVINCE || ' ' || C.CITY ||' '|| C.STREET_ADDRESS AS �μ��ּ�
     FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
     INNER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID=B.DEPARTMENT_ID)
     INNER JOIN HR.LOCATIONS C ON(B.LOCATION_ID=C.LOCATION_ID AND C.COUNTRY_ID !='US')
     INNER JOIN HR.COUNTRIES ON(B.LOCATION_ID=C.LOCATION_ID)
     WHERE  AND B.LOCATION_ID=C.LOCATION_ID
       AND C.COUNTRY_ID NOT IN('US')
       ORDER BY 3;
     
     