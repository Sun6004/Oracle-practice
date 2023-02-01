2023-0126-01)
  4) SEMI JOIN
   - ���������� ����Ͽ� ����� �߰������ ������������ �����ϴ� ����
   - IN�� EXISTS ������ ���
��뿹) ������̺��� �޿��� 10000�̻�Ǵ� ����� �ִ� �μ������� ��ȸ�Ͻÿ�
       Alias�� �μ��ڵ�, �μ���
  (EXISTS ������ ���)
  --EXISTS(���� ����)�� ���� ������ ����� "�� ���̶� �����ϸ�" TRUE ������ FALSE�� �����Ѵ�.
  --EXISTS�� ���� ������ ��ġ�ϴ� ����� �� ���̶� ������ ������ �� �̻� �������� �ʴ´�.
    SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
           A.DEPARTMENT_NAME AS �μ���
    FROM HR.DEPARTMENTS A
    --EXISTS �ڿ� SUB������ �;���  ���� ������ ����� "�� ���̶� �����ϸ�" TRUE ������ FALSE�� ����
    --EXISTS�� ���� ������ ��ġ�ϴ� ����� �� ���̶� ������ ������ �� �̻� �������� �ʴ´�.
    WHERE EXISTS(SELECT 1 -- 1�� �ƹ��ǹ̾���
                    FROM HR.EMPLOYEES B
                    WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
                      AND B.SALARY>=10000) 
    ORDER BY 1;
    
  (IN ������ ���)--�񵿵� ����
  SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
           A.DEPARTMENT_NAME AS �μ���
    FROM HR.DEPARTMENTS A
    WHERE A.DEPARTMENT_ID IN(SELECT DISTINCT DEPARTMENT_ID --DISTINCT : �ߺ� ������ ����.
                             FROM HR.EMPLOYEES
                             WHERE SALARY >= 10000)
    ORDER BY 1;

(���� ����) 
SELECT A.DEPARTMENT_ID AS �μ��ڵ�,
           A.DEPARTMENT_NAME AS �μ���
    FROM HR.DEPARTMENTS A,(SELECT DISTINCT DEPARTMENT_ID
                             FROM HR.EMPLOYEES
                             WHERE SALARY >= 10000)B
    WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID
    ORDER BY 1;
    
5) NON EQUI JOIN (�񵿵� ����)
 - �������ǿ� '=' �̿��� �����ڰ� ���Ǵ� ����(� ����)
 - ���� ������ "��Ȯ��" ��ġ�ϴ� ��쿡�� ���
 
��뿹)������̺��� �� ����� �Ҽӵ� �μ��� ��ձ޿����� �� ���� �޿��� �޴� ����� �����ȣ,�����,�μ��ڵ�,�Ի���,�޿��� ��ȸ�Ͻÿ�.
    
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           A.DEPARTMENT_ID AS �μ��ڵ�,
           (SELECT ROUND(AVG(SALARY))
             FROM HR.EMPLOYEES D
             WHERE D.DEPARTMENT_ID=A.DEPARTMENT_ID) AS �μ���ձ޿�,
           A.HIRE_DATE AS �Ի���,
           A.SALARY AS �޿�
    FROM HR.EMPLOYEES A
    WHERE A.SALARY > (SELECT C.ASAL
                  FROM (SELECT B.DEPARTMENT_ID,
                          AVG(B.SALARY) AS ASAL
                         FROM HR.EMPLOYEES B               
                     GROUP BY B.DEPARTMENT_ID)C
                      WHERE A.DEPARTMENT_ID=C.DEPARTMENT_ID)
       ORDER BY 3,6 DESC;    
    
��뿹) ȸ�����̺��� ���ϸ����� ���� ���� 3���� 2020�� 5�� ������ ������
       ��ȸ�Ͻÿ�. Alias�� ȸ����ȣ, ȸ����, ���űݾ� �հ�
(���ϸ����� ���� 3��)
  SELECT A.MEM_ID
    FROM (SELECT MEM_ID,MEM_MILEAGE
            FROM MEMBER
            ORDER BY MEM_MILEAGE DESC)A
    WHERE ROWNUM<=3;
    
(2020�� 5�� ����������)
  SELECT M.MEM_ID AS ȸ����ȣ,
         M.MEM_NAME AS ȸ����,
         SUM(C.CART_QTY*P.PROD_PRICE) AS "���űݾ� �հ�"
  FROM CART C, MEMBER M, PROD P
  WHERE C.CART_NO LIKE '202005%'
  AND C.CART_PROD=P.PROD_ID
  AND M.MEM_ID=C.CART_MEMBER
  AND C.CART_MEMBER =ANY(SELECT A.MEM_ID
                           FROM (SELECT MEM_ID,MEM_MILEAGE
                      FROM MEMBER
                      ORDER BY MEM_MILEAGE DESC)A
                     WHERE ROWNUM<=3)
    GROUP BY M.MEM_ID, M.MEM_NAME;


   