2023-0131-01) ���� ������
 - ���� ������ ����� ���� ���տ����� ����
 - ������(UNION, UNION ALL), ������(INTERSECT), ������(MINUS) ��� ��ȯ
 (���ǻ���)
 - ��� SELECT���� �÷��� ���� Ÿ���� �����ؾ���.
 - �÷��� ��Ī�� ù ��° SELECT ���� SELECT ���� ���� ����.
 - ORDER BY ���� �� ������ SELECT �������� ����.
 - CLOB,BLOB,BFILE Ÿ���� ��� �Ұ�
 
1. ������
 - UNION ALL : ������ �κ��� �ߺ� ��ȯ�Ǵ� ������ -- �����պκ� �ߺ����
 - UNION : �ߺ��� ������ ������ --�����պκ� �ѹ��� ���
 ��뿹)2020�� 4���� 5���� �Ǹŵ� ��� ��ǰ���� ����Ͻÿ�
   SELECT A.CART_PROD AS ��ǰ�ڵ�,
          B.PROD_NAME AS ��ǰ��,
          SUM(CART_QTY) AS �Ǹż���
     FROM CART A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
      AND A.CART_NO LIKE '202004%'
    GROUP BY A.CART_PROD, B.PROD_NAME
  UNION
   SELECT A.CART_PROD,
          B.PROD_NAME,
          SUM(A.CART_QTY)
     FROM CART A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
      AND A.CART_NO LIKE '202005%'
    GROUP BY A.CART_PROD, B.PROD_NAME  
     ORDER BY 1;
     
��뿹) ȸ�����̺� ������ �����ϴ� ȸ���� ������ �л��� ȸ���� ȸ����ȣ, ȸ����, ����, ������, ���ϸ����� ��ȸ�Ͻÿ�.
(������ ����� ���)
  SELECT A.MEM_ID AS ȸ����ȣ,
         A.MEM_NAME AS ȸ����,
         A.MEM_JOB AS ����, 
         A.MEM_ADD1 AS ������, 
         A.MEM_MILEAGE AS ���ϸ���
    FROM (SELECT *
            FROM MEMBER
           WHERE MEM_ADD1 LIKE '����%')A,
          (SELECT MEM_ID,MEM_JOB,MEM_ADD1
             FROM MEMBER
            WHERE MEM_JOB='�л�')B
    WHERE A.MEM_ID=B.MEM_ID(+);
       
(UNION ���)
 SELECT  MEM_ID AS ȸ����ȣ,
         MEM_NAME AS ȸ����,
         MEM_JOB AS ����, 
         MEM_ADD1 AS ������, 
         MEM_MILEAGE AS ���ϸ���
    FROM SELECT *
            FROM MEMBER
           WHERE MEM_ADD1 LIKE '����%'
  UNION
   SELECT MEM_ID,MEM_NAME,MEM_ADD1,MEM_MILEAGE
    FROM MEMBER
    WHERE MEM_JOB='�л�'
    GROUP BY 1;   
   
2. ������
 - �������� ���Ե� ���Ҹ� ��ȯ
 - INTERSECT ������ ���
 
��뿹) �������̺��� 1���� 4���� ��� ���Ե� ��ǰ������ ��ȸ�Ͻÿ�
       Alias�� ��ǰ�ڵ�, ��ǰ��, ���Դܰ�, ����ó
 (����)
  SELECT C.PROD_ID AS ��ǰ�ڵ�,
         C.PROD_NAME AS ��ǰ��, 
         C.PROD_COST AS ���Դܰ�, 
         C.PROD_BUYER AS ����ó
    FROM (SELECT DISTINCT BUY_PROD
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'))A,
         (SELECT DISTINCT BUY_PROD
           FROM BUYPROD
          WHERE BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY(TO_DATE('20200401')))B,
         PROD C
    WHERE C.PROD_ID=A.BUY_PROD
      AND C.PROD_ID=B.BUY_PROD
   ORDER BY 1;
   
(���տ����� INTERSECT ���)   
  SELECT BUY_PROD,PROD_NAME,PROD_COST,PROD_BUYER
    FROM BUYPROD A, PROD B
   WHERE A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
     AND A.BUY_PROD=B.PROD_ID
  INTERSECT 
  SELECT BUY_PROD,PROD_NAME,PROD_COST,PROD_BUYER
    FROM BUYPROD A, PROD B
   WHERE A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430') 
     AND A.BUY_PROD=B.PROD_ID
   ORDER BY 1;

��뿹) 2020�� 4���� 5�� ������� �հ谡 10�� �̻��� ��ǰ������ ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, ����ܰ�
       
  SELECT A.CART_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��, 
         B.PROD_PRICE AS ����ܰ�
    FROM(SELECT CART_PROD,
                SUM(CART_QTY)
           FROM CART
          WHERE CART_NO LIKE '202004%'
          GROUP BY CART_PROD
          HAVING SUM(CART_QTY)>=10)A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
  INTERSECT
   SELECT A.CART_PROD, B.PROD_NAME, B.PROD_PRICE
    FROM(SELECT CART_PROD,
                SUM(CART_QTY)
           FROM CART
          WHERE CART_NO LIKE '202005%'
          GROUP BY CART_PROD
          HAVING SUM(CART_QTY)>=10)A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
    ORDER BY 1;
    
3. ������
 - MINUS �����ڸ� ����Ͽ� Ư�� ��� ���տ��� �����ϴ� ��� ��ȯ
 
��뿹) �������̺��� 2020�� 1���� 4���� 1������ ���Ե� ��ǰ�� ��ǰ�ڵ�,��ǰ��,���Դܰ��� ���Ͻÿ�
  
 (2020�� 1�� ����)
  SELECT A.BUY_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         B.PROD_COST AS ���Դܰ�
    FROM BUYPROD A, PROD B
   WHERE A.BUY_PROD=B.PROD_ID
     AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
  MINUS
 --(2020�� 4�� ����)
 SELECT A.BUY_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��,
         B.PROD_COST AS ���Դܰ�
    FROM BUYPROD A, PROD B
   WHERE A.BUY_PROD=B.PROD_ID
     AND A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
    ORDER BY 1;
    
��뿹) 2020�� 6�� ���Ը��� �� ���Ը� �߻��� ��ǰ�� ��ǰ�ڵ�� ��ǰ���� ��ȸ�Ͻÿ�.
  SELECT A.BUY_PROD AS ��ǰ�ڵ�,
         B.PROD_NAME AS ��ǰ��
    FROM BUYPROD A, PROD B
   WHERE A.BUY_PROD=B.PROD_ID
     AND A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
   MINUS  
     SELECT A.CART_PROD AS ��ǰ�ڵ�,
            B.PROD_NAME AS ��ǰ��
    FROM CART A, PROD B
    WHERE A.CART_NO LIKE '202006%'
     AND A.CART_PROD=B.PROD_ID
     ORDER BY 1;
     
    
   
   
 