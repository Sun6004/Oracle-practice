2023-0120-01) �׷��Լ�
  - ���̺��� Ư���÷��� �������� ���� ���� ���� �ڷ���� ������� ������ �׷��̶���
  - �� �׷�ȿ��� �հ�(SUM),���(AVG), �ڷ��� ��(COUNT), �ִ�/�ּ� ��(MAX/MIN)�� ��ȯ���ִ� �Լ�
  - ������ �Լ���
  - �����Լ��� �����Լ��� ������ �� ����(��, �Ϲ��Լ��� �����Լ��� ������ �� �ְ�, �����Լ��� �Ϲ��Լ��� ������ ������)
 (�������)
    SELECT [�÷���1 [AS �÷���Ī1 ,]   
                  :
            --SELECT���� �Ϲ��÷� ���� �׷��Լ��� �����ϸ� GROUP BY���� �ʿ���� /�Ϲ��÷��� �ϳ��� ���Ǹ� �׷��� �����̵Ǵ� �÷���
            SUM(col)|AVG(col)|COUNT(*|col)|MAX(col)|MIN(col) [,] --COUNT(*|col) * : NULL���� �ϳ��� ������ ��� 
                  :  --AVG�� �Ҽ����� ��� ���ü� �ֱ⶧���� ROUND�� TRUNC�� ���� ���
            [�÷���n [AS �÷���Īn]
        FROM ���̺��
    [WHERE ����] --�Ϲ�����(�׷��Լ��� ������ �ٴ°�� ���Ұ�)
    [GROUP BY �÷���[,�÷���,...]]
    [HAVING ����]
    [ORDER BY �÷���|�÷��ε��� [ASC|DESC],...]
    . SELECT ���� �׷��Լ��� �ƴ� �Ϲ��÷��� ����Ǹ� �ݵ�� GROUP BY���� ����ؾ� ��
      SELECT ���� �׷��Լ��� ������ GROUP BY���� ��������  
    . GROUP BY ������ SELECT ���� ����� �Ϲ��÷��� �ݵ�� ��� ����ؾ���.
      SELECT ���� ������� ���� �÷��� �ʿ��ϸ� ��� ����
    . �׷��Լ��� ������ �ο��Ǹ� �ݵ�� HAVING ���� ����ؾ� ��
    . GROUP BY ���� WHERE �� ������ ����ϰ�, HAVING ���� GROUP BY �� ������ ����ؾ���(���� ����)
    
��뿹) ������̺��� ��ü�����, ��ü����ӱ�, �ӱ��հ踦 ��ȸ�Ͻÿ�.
    SELECT COUNT(*) AS ��ü�����,
           ROUND(AVG(SALARY)) AS ��ü����ӱ�, 
           SUM(SALARY) AS �ӱ��հ�
        FROM HR.EMPLOYEES; 

��뿹) ������̺��� �μ��� �����, ����ӱ�, �Ա��հ踦 ��ȸ�Ͻÿ�.
    SELECT DEPARTMENT_ID AS �μ��ڵ�,
           COUNT(*) AS �����,
           ROUND(AVG(SALARY)) AS ����ӱ�,
           SUM(SALARY) AS �ӱ��հ�,
            -- �ִ�,�ּ� �ӱ��� ���������� �ϳ��� �������� �ۼ��Ұ�
           MAX(SALARY) AS �ִ��ӱ�,
           MIN(SALARY) AS �ּ��ӱ�
        FROM HR.EMPLOYEES
        GROUP BY DEPARTMENT_ID --�׷��Լ��� �Ϲ��÷��� ���� ���Ǿ��� ������ GROUP BY�� ����ؾ���!
        ORDER BY 1;
        
��뿹) �������̺��� 2020�� 1�� ��ü ���Աݾ� �հ踦 ��ȸ�Ͻÿ�.
    SELECT SUM(BUY_QTY * BUY_COST) AS "���Աݾ� �հ�", --�Ϲ��÷��� ���̻����� �ʾұ⶧���� GROUP BY ������
           COUNT(*) AS ���԰Ǽ�
       FROM BUYPROD
      WHERE BUY_DATE BETWEEN TO_DATE(20200101) AND TO_DATE('20200131');

��뿹) �������̺��� 2020�� ��ǰ�� ���Լ��� �հ�� ���Աݾ� �հ�, ���԰Ǽ��� ��ȸ�Ͻÿ�.
    SELECT BUY_PROD AS ��ǰ�ڵ�,
           SUM(BUY_QTY) AS "���Լ��� �հ�",
           SUM(BUY_QTY * BUY_COST) AS "���Աݾ� �հ�",
           COUNT(*) AS ���԰Ǽ�
      FROM BUYPROD
      WHERE EXTRACT(YEAR FROM BUY_DATE)=2020
      GROUP BY BUY_PROD
      ORDER BY 1;

��뿹) �������̺��� 2020�� ���� ���Աݾ� �հ�, ���԰Ǽ��� ��ȸ�Ͻÿ�.
    SELECT EXTRACT(MONTH FROM BUY_DATE)||'��' AS ��, --WHERE ������ ������ ����
           SUM(BUY_QTY * BUY_COST) AS "���Աݾ� �հ�",
           COUNT(*) AS ���԰Ǽ�
        FROM BUYPROD
        WHERE EXTRACT(YEAR FROM BUY_DATE)=2020 --WHERE��������
        GROUP BY EXTRACT(MONTH FROM BUY_DATE)
        ORDER BY 1;

��뿹) 2020�� ��ݱ� ��ǰ�� ������� �հ�� ����ݾ� �հ踦 ��ȸ�Ͻÿ�.
    SELECT CART.PROD_ID AS ��ǰ�ڵ�,
           SUM(CART.CART_QTY) AS ��������հ�,
           SUM(CART.CART_QTY*PROD.PROD_PRICE)"����ݾ��հ�"
      FROM CART, PROD
      WHERE CART.PROD_ID = PROD.PROD_ID
      AND SUBSTR(CART.CART_NO,1,6) BETWEEN '202001' AND '202006'
      GROUP BY CART.PROD_ID --CART���̺�� PROD ���̺��� PROD_ID�� ���� �̸��̱� ������ ������ ���� �տ� ���̺�.PROD_ID
      ORDER BY 1;
    
��뿹) �������̺��� 2020�� ���� ���Աݾ� �հ�, ���԰Ǽ��� ��ȸ�ϵ� ���Աݾ� �հ谡 1��� �̻��� ���� ��ȸ�Ͻÿ�.
    SELECT EXTRACT(MONTH FROM BUY_DATE)||'��' AS ��,
           SUM(BUY_QTY*BUY_COST) AS "���Աݾ� �հ�",
           COUNT(*) AS ���԰Ǽ�   
    FROM BUYPROD
    WHERE EXTRACT(YEAR FROM BUY_DATE) =2020
     GROUP BY EXTRACT(MONTH FROM BUY_DATE)
     HAVING SUM(BUY_QTY*BUY_COST) >= 100000000
        ORDER BY 1;
        
��뿹) �������̺��� 2020�� ���� ���Աݾ� �հ�, ���԰Ǽ��� ��ȸ�ϵ� ���Աݾ� �հ谡 ���� ���� ���� ����Ͻÿ�.
   SELECT A.AMON ||'��' AS ��,
          A.ASUM AS "���Աݾ� �հ�",
          A.ACNT AS ���԰Ǽ�
   FROM (SELECT EXTRACT(MONTH FROM BUY_DATE)|| AS AMON,
           --MAX(SUM(BUY_QTY*BUY_COST)) AS "���Աݾ� �հ�", -�׷��Լ��� �׷��Լ��� ���� �Ұ���
           SUM(BUY_QTY*BUY_COST) AS ASUM;
           COUNT(*) AS ACNT   
           FROM BUYPROD
           WHERE EXTRACT(YEAR FROM BUY_DATE) =2020
           GROUP BY EXTRACT(MONTH FROM BUY_DATE)
           ORDER BY 2 DESC)A
     WHERE ROWNUM=1;
     
PSEUDO �÷�: �ǻ��÷� => �ý����� ������ �÷�
 - ROWNUM: ���ȣ�� �����ϴ� �÷�

��뿹) 2020�� ��ݱ� ���� ��ǰ�� ������� �հ�� ����ݾ� �հ踦 ��ȸ�Ͻÿ�.
    SELECT SUBSTR(A.CART_NO,5,2)||'��' AS ��,
           A.PROD_ID AS ��ǰ�ڵ�,
           SUM(A.CART_QTY) AS "������� �հ�",
           SUM(A.CART_QTY * B.PROD_PRICE) AS  "����ݾ� �հ�"
    FROM CART A, PROD B
    WHERE A.PROD_ID = B.PROD_ID
    AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
    GROUP BY SUBSTR(A.CART_NO,5,2),A.PROD_ID --'��'�� ���� �׷����,��ǰ�ڵ��
    ORDER BY 1, 2;

��뿹) ȸ�����̺��� ���� ��� ���ϸ����� ��ȸ�Ͻÿ�.
    SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR 
                     SUBSTR(MEM_REGNO2,1,1)='3' THEN '����ȸ��'
                ELSE '����ȸ��'
           END AS ����,
           ROUND(AVG(MEM_MILEAGE)) AS "��� ���ϸ���"
      FROM MEMBER
    GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR 
                     SUBSTR(MEM_REGNO2,1,1)='3' THEN '����ȸ��'
                ELSE '����ȸ��'
           END;
           
��뿹) ȸ�����̺� ���ɴ뺰 ��ո��ϸ����� ��ȸ�Ͻÿ�.
    SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS ���ɴ�,
           ROUND(AVG(MEM_MILEAGE)) AS ��ո��ϸ���
           COUNT(*)AS ȸ����
        FROM MEMBER
      GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
      ORDER BY 1;