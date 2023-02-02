2023-0127-01)
 6) OUTER JOIN
  - ���������� ���������� �����ϴ� �ڷḦ ������� �����ϰ� ���������� �������� �ʴ� �ڷ�� ��� ������.
  - �ܺ������� �ڷ��� ������ ���� ���� �������� ������ ���� ���̺� NULL ���� ���� �߰��Ͽ� ���� ����.
  
(�������: �Ϲ� �ܺ�����)
 SELECT �÷�LIST
   FROM ���̺�1 [��Ī1],���̺�2 [��Ī2], ���̺�3 [��Ī3],...
   WHERE ��Ī1.�÷���=��Ī2.�÷���(+) -- ���̺�2�� ������ ���
                :
   . ���δ�� ���̺� �� �����Ͱ� ������ ���̺� ��������(��� ���̺�) �� �ܺ����� ������'(+)'�� ���δ�.
   . �ܺ����� ������ ���� ���� ��� ��� '(+)'�� �ٿ��� ��.
   . ���� ��� ������ ��� ������ ����
   . �ѹ��� �� ���̺��� �ܺ����� �� �� �ִ�.
  EX) A,B,C, ���̺��� �ܺ����� �ϴ� ��� A=B(+) AND C=B(+)�� ������ ����
   . (+)�����ڴ� OR ������, IN �����ڿ� ���� ����� �� ����
   . �ܺ��������ǰ� �Ϲ������� ���� ����ϸ� �ܺ����� ����� ���� �� ����
     �ذ�å���� ANSI�ܺ��������� ����, �Ǵ� ���������� ����� �ܺ��������� ����
   

(�������: ANSI �ܺ�����)
 SELECT �÷�LIST --������ ����������
   FROM ���̺�1 [��Ī1]
   LEFT|RIGHT|FULL OUTER JOIN ���̺�2 [��Ī2]ON(�������� [AND �Ϲ�����])
                        :
   [WHERE �Ϲ�����]
   . 'LEFT|RIGHT|FULL' : FROM�� ���� ���̺��� �ڷᰡ �� ���� ��� LEFT
                       FROM�� ���� ���̺��� �ڷᰡ �� ���� ��� RIGHT
                       ���� ��� ������ ��� FULL
   . 'WHERE �Ϲ�����' : ��� ���̺� �������� ����� ���� ���(�������� ����� ������ ������ ����)
   . �� �� Ư¡�� INNER JOIN�� ����
   
��뿹) HR������ ���̺��� �̿��Ͽ� ��� �μ��� ������� ��ձ޿��� ��ȸ�Ͻÿ�.
(�Ϲ� �ܺ�����)
  SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
         A.DEPARTMENT_NAME AS �μ���,
         COUNT(B.EMPLOYEE_ID) AS �����, 
         NVL(ROUND(AVG(B.SALARY)),0) AS ��ձ޿�
  FROM HR.DEPARTMENTS A, HR.EMPLOYEES B
  WHERE B.DEPARTMENT_ID(+)=A.DEPARTMENT_ID -- �ܺ���������
  GROUP BY A.DEPARTMENT_ID,A.DEPARTMENT_NAME
  ORDER BY 1;

(ANSI JOIN)
  SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
         A.DEPARTMENT_NAME AS �μ���,
         COUNT(B.EMPLOYEE_ID) AS �����, 
         NVL(ROUND(AVG(B.SALARY)),0) AS ��ձ޿�
  FROM HR.DEPARTMENTS A
       FULL OUTER JOIN HR.EMPLOYEES B ON (B.DEPARTMENT_ID=A.DEPARTMENT_ID) -- �ܺ���������
  GROUP BY A.DEPARTMENT_ID,A.DEPARTMENT_NAME
  ORDER BY 1;
  
  
��뿹) ��ǰ���̺�� �з����̺��� ����Ͽ� �з��� ��ǰ�� ���� ��ȸ�Ͻÿ�.
  SELECT COUNT(*) FROM LPROD;
  SELECT COUNT(DISTINCT PROD_LGU) FROM PROD;
 
(�Ϲ� �ܺ� JOIN) 
  SELECT A.LPROD_GU AS �з��ڵ�,
         A.LPROD_NM AS �з���,
         COUNT(B.PROD_ID) AS "��ǰ�� ��"
  FROM LPROD A, PROD B
  WHERE A.LPROD_GU=B.PROD_LGU(+)
  GROUP BY A.LPROD_GU,A.LPROD_NM
  ORDER BY 1;
  

(ANSI JOIN)
  SELECT A.LPROD_GU AS �з��ڵ�,
         A.LPROD_NM AS �з���,
         COUNT(B.PROD_ID) AS "��ǰ�� ��"
  FROM PROD B
  RIGHT OUTER JOIN LPROD A ON(A.LPROD_GU=B.PROD_LGU)
  GROUP BY A.LPROD_GU,A.LPROD_NM
  ORDER BY 1;
  
  
��뿹) 2020�� 4�� ��� ��ǰ�� ��������(��������,�ݾ�����)�� ��ȸ�Ͻÿ�.
 (�Ϲ� �ܺ�����)
    SELECT B.PROD_ID AS ��ǰ�ڵ�,
           B.PROD_NAME AS ��ǰ��,
           NVL(SUM(A.BUY_QTY),0) AS ���Լ����հ�,
           NVL(SUM(A.BUY_QTY*B.PROD_COST),0) AS ���Աݾ�����
    FROM BUYPROD A, PROD B
    WHERE A.BUY_PROD(+)=B.PROD_ID
    AND A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
    GROUP BY B.PROD_ID,B.PROD_NAME
    ORDER BY 1;
    
(ANSI JOIN)
   SELECT B.PROD_ID AS ��ǰ�ڵ�,
           B.PROD_NAME AS ��ǰ��,
           NVL(SUM(A.BUY_QTY),0) AS ���Լ����հ�,
           NVL(SUM(A.BUY_QTY*B.PROD_COST),0) AS ���Աݾ�����
    FROM BUYPROD A
    RIGHT OUTER JOIN PROD B ON(A.BUY_PROD(+)=B.PROD_ID AND
                     A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))
    GROUP BY B.PROD_ID,B.PROD_NAME
    ORDER BY 1;
    
(���������� �̿��� �ܺ�����)
(��������: 2020�� 4�� �������� : ��������)
  SELECT A.BUY_PROD AS BID,
         SUM(A.BUY_QTY) AS SCMT,
         SUM(A.BUY_QTY*B.PROD_COST) AS SAMT
  FROM BUYPROD A, PROD B
  WHERE A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
  AND A.BUY_PROD=B.PROD_ID
  GROUP BY A.BUY_PROD;
  
(��������: ��� ��ǰ�� ���� ��ǰ�ڵ�, ��ǰ��, ���Լ����հ�, ���Աݾ��հ�)
  SELECT P.PROD_ID AS ��ǰ�ڵ�,
         P.PROD_NAME AS ��ǰ��,
         NVL(C.SCNT,0) AS ���Լ����հ�,
         NVL(C.SAMT,0) AS ���Աݾ��հ�
  FROM PROD P, (SELECT A.BUY_PROD AS BID, --��Ī �ѱۻ��� �ν� �� �ȵ� �� ����.
                SUM(A.BUY_QTY) AS SCNT,
                SUM(A.BUY_QTY*B.PROD_COST) AS SAMT
                 FROM BUYPROD A, PROD B
                 WHERE A.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430')
                 AND A.BUY_PROD=B.PROD_ID
                GROUP BY A.BUY_PROD)C
    WHERE P.PROD_ID=C.BID(+)
    ORDER BY 1;
 
��뿹) 2020�� 4�� ��� ��ǰ�� ��������(��������,�ݾ�����)�� ��ȸ�Ͻÿ�.
   SELECT  B.PROD_ID AS ��ǰ�ڵ�,
           B.PROD_NAME AS ��ǰ��,
           NVL(SUM(A.CART_QTY),0) AS ��������հ�,
           NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS ����ݾ��հ�
  FROM CART A
    RIGHT OUTER JOIN PROD B ON(A.CART_PROD=B.PROD_ID AND A.CART_NO '202004%')
    GROUP BY B.PROD_ID,B.PROD_NAME
    ORDER BY 1;
    
(SUB)
 SELECT   B.PROD_ID AS BID,
           NVL(SUM(A.CART_QTY),0) AS SCNT,
           NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS SAMT
    FROM CART A, PROD B
    WHERE A.CART_PROD=B.PROD_ID
    AND A.CART_NO LIKE '202004%'
    GROUP BY B.PROD_ID,B.PROD_NAME
    ORDER BY 1;
    
(MAIN)
  SELECT P.PROD_ID AS ��ǰ�ڵ�,
         P.PROD_NAME AS ��ǰ��,
         NVL(C.SCNT,0)��������հ�,
         NVL(C.SAMT,0)����ݾ��հ�
  FROM PROD P,( SELECT   B.PROD_ID AS BID,
                         NVL(SUM(A.CART_QTY),0) AS SCNT,
                         NVL(SUM(A.CART_QTY*B.PROD_PRICE),0) AS SAMT
                  FROM CART A, PROD B
                 WHERE A.CART_PROD=B.PROD_ID
                   AND A.CART_NO '202004%'
                GROUP BY B.PROD_ID,B.PROD_NAME)C
    WHERE P.PROD_ID=C.BID(+)
    ORDER BY 1;
    
����] 2020�� 6�� ��� ��ǰ�� ����/���� ���踦 ��ȸ�Ͻÿ�.
(SUB)
SELECT A.BUY_PROD AS BID,
         SUM(A.BUY_QTY) AS SCMT,
         SUM(A.BUY_QTY*B.PROD_COST) AS SAMT,
         NVL(SUM(C.CART_QTY),0) AS SCNT2,
         NVL(SUM(C.CART_QTY*B.PROD_PRICE),0) AS SAMT2
         
  FROM BUYPROD A, PROD B, CART C
  WHERE A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
  AND A.BUY_PROD=B.PROD_ID
  GROUP BY A.BUY_PROD;
    

  
(MAIN)
   SELECT P.PROD_ID AS ��ǰ�ڵ�,
          P.PROD_NAME AS ��ǰ��,
          NVL(C.SCNT,0) AS ���Լ����հ�,
          NVL(D.SCNT,0) AS ��������հ�,
          NVL(C.SAMT,0) AS ���Աݾ��հ�,
          NVL(D.SAMT,0) AS ����ݾ��հ�
  FROM PROD P, ( SELECT A.BUY_PROD AS BID,
                 SUM(A.BUY_QTY) AS SCMT,
                 SUM(A.BUY_QTY*B.PROD_COST) AS SAMT
             FROM BUYPROD A, PROD B 
             WHERE A.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630')
               AND A.BUY_PROD=B.PROD_ID
          GROUP BY A.BUY_PROD)C, --��������
          
                (SELECT   B.PROD_ID AS BID,
                          SUM(A.CART_QTY) AS SCNT,
                          SUM(A.CART_QTY*B.PROD_PRICE) AS SAMT
                    FROM CART A, PROD B
                 WHERE A.CART_PROD=B.PROD_ID
                 AND A.CART_NO LIKE '202004%'
                 GROUP BY B.PROD_ID,B.PROD_NAME)D --��������
    WHERE P.PROD_ID=C.BID(+)
      AND P.PROD_ID=D.BID(+)
      ORDER BY 1;

(ANSI JOIN)   
 
   SELECT P.PROD_ID AS ��ǰ�ڵ�,
          P.PROD_NAME AS ��ǰ��,
          NVL(SUM(B.BUY_QTY),0) AS ���Լ����հ�,
          NVL(SUM(A.CART_QTY),0) AS ��������հ�,
          NVL(SUM(B.BUY_QTY*P.PROD_COST),0) AS ���Աݾ��հ�,
          NVL(SUM(A.CART_QTY*P.PROD_PRICE),0) AS ����ݾ��հ�
    FROM PROD P
    LEFT OUTER JOIN CART A ON(A.CART_PROD=P.PROD_ID AND A.CART_NO LIKE '202006%')
    LEFT OUTER JOIN BUYPROD B ON(P.PROD_ID=B.BUY_PROD AND B.BUY_DATE BETWEEN TO_DATE('20200601') AND TO_DATE('20200630'))
    GROUP BY P.PROD_ID, P.PROD_NAME
    ORDER BY 1;

