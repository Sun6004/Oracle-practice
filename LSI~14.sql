2023-0130-01) ��������(SUBQUERY)  --�˷����� ���� ������ �����ϱ� ����
 - ���������� �����ȿ� �����ϴ� �� �ٸ� ������ �ǹ� ��.
 - �ַ� �˷����� ���� ���ǿ� �����Ͽ� ���Ǹ� ó���ؾ� �ϴ� ��� �����
 - ���������� '( )' �ȿ� ����ؾ���
 - INSERT �� ���Ǵ� ���������� '( )' ������� ����
 - �����ڿ� �Բ� ����� ���� �ݵ�� ������ �����ʿ� ��ġ
 - ���������� ���� ������ ���������� ����� ���� �������� ������� �����
 - ���������ȿ� ���������� ��밡��
 - ���������� ����
  . ������������ ������ ���ο� ����
   - ���ü��ִ� ��������, ���ü� ���� ��������
  . ����� ��ġ�� ����
   - �Ϲݼ�������(SELECT ��), �ζ��� �� ��������(FROM ��), ��ø��������(WHERE ��)

1. ���ü�(����) ���� ��������
 - ���������� ���� ���̺�� ���������� ���� ���̺��� �������� ������� ���� ��������
 
��뿹) ������̺��� ������� ��ձ޿����� �� ���� �޿��� �޴� ������� ��ȸ�Ͻÿ�.
  (�������� : �����)
   SELECT COUNT(*)
     FROM HR.EMPLOYEES
    WHERE SALARY >= (��������: ��ձ޿�)
    
  (��������: ��ձ޿�)
  SELECT AVG(SALARY)
    FROM HR.EMPLOYEES;
 
  (����)
   SELECT COUNT(*)
     FROM HR.EMPLOYEES
    WHERE SALARY >= (SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES);
                       
  (������ �ִ� ��������)
    SELECT COUNT(*)
     FROM HR.EMPLOYEES A, (SELECT AVG(SALARY) AS  ASAL
                             FROM HR.EMPLOYEES)B
    WHERE SALARY >= B.ASAL;
                       
��뿹) ��ǰ���̺��� ��ǰ�� 'P200'���� �з��� ���ϸ� ũ�������� ���� ��ǰ������ ��ȸ�Ͻÿ�
       Alias�� ��ǰ�ڵ�, ��ǰ��, �з��ڵ�, �з���
  
(��������: ��ǰ�� ��ǰ�ڵ�, ��ǰ��, �з��ڵ�, �з����� ���)
  SELECT ��ǰ�ڵ�, ��ǰ��, �з��ڵ�, �з���
  FROM PROD A, LPROD B
  WHERE PROD_LGU LIKE 'P2%'
  AND A. P.PRPOD_LGU = PROD_GU
  AND A.PROD_ID = (�������� : ũ�������� �������� ���� ��ǰ)
  
(�������� : ũ�������� �������� ���� ��ǰ
 SELECT PROD_ID
   FROM PROD
  WHERE PROD_SIZE IS NULL;
  
  (����)
  (IN�����ڻ��)
  SELECT PROD_ID AS ��ǰ�ڵ�,
         PROD_NAME AS ��ǰ��,
         PROD_LGU AS �з��ڵ�
   FROM PROD
  WHERE PROD_LGU LIKE 'P1%'
    AND PROD_ID IN (SELECT PROD_ID
                      FROM PROD
                     WHERE PROD_SIZE IS NULL);
                     
(EXISTS ������ ��� -> ������ �ִ� ��������)
  SELECT A.PROD_ID AS ��ǰ�ڵ�,
         A.PROD_NAME AS ��ǰ��,
         A.PROD_LGU AS �з��ڵ�
  FROM PROD A
  WHERE A.PROD_LGU LIKE 'P1%'
  AND EXISTS (SELECT 1
                FROM PROD B
               WHERE B.PROD_SIZE IS NULL
               AND A.PROD_ID=B.PROD_ID);
               

2. ������ �ִ� ��������
 - ���������� �������� ���̿� ���ο����� �����ϴ� ���
 
��뿹) �����������̺�(JOB_HISTORY)�� �ڷḦ �̿��Ͽ� ����������� ������ ��ȸ�Ͻÿ�.
       Alias�� �����ȣ, �����, �μ���ȣ, �μ���
       
  SELECT A.EMPLOYEE_ID AS �����ȣ,
        (SELECT B.EMP_NAME
            FROM HR.EMPLOYEES B
           WHERE B.EMPLOYEE_ID=A.EMPLOYEE_ID) AS �����,
         A.DEPARTMENT_ID AS �μ���ȣ,
         (SELECT C.DEPARTMENT_NAME
           FROM HR.DEPARTMENTS C
           WHERE C.DEPARTMENT_ID=A.DEPARTMENT_ID) AS �μ���
    FROM HR.JOB_HISTORY A
    ORDER BY 1;
    
��뿹) 2020�� ��ݱ� ��ǰ�� ���Լ����� ��ȸ�Ͽ� ���� 5����ǰ�� ��ǰ�ڵ�,��ǰ��,���Լ����հ踦 ��ȸ�Ͻÿ�.
  (�������� : ���� 5����ǰ�� ��ǰ�ڵ�, ��ǰ��, ���Լ����հ�)
    SELECT P.PROD_ID AS ��ǰ�ڵ�,
           P.PROD_NAME AS ��ǰ��, 
           A.���Լ����հ�
      FROM PROD P, (��������)A
     WHERE P.PROD_ID=A.��ǰ�ڵ�
       AND ROWNUM<=5;
  
  (�������� : 2020�� ��ݱ� ��ǰ�� ���Լ����� ��ȸ�Ͽ� ���Լ����� �������� ������������ ���)
    SELECT BUY_PROD AS ��ǰ�ڵ�,
           SUM(BUY_QTY) AS BSUM
        FROM BUYPROD
        WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
        GROUP BY BUY_PROD
        ORDER BY 2 DESC;
        
  (����)
  SELECT   A.BUY_PROD AS ��ǰ�ڵ�,
           P.PROD_NAME AS ��ǰ��, 
           A.BSUM AS ���Լ����հ�
      FROM PROD P, (SELECT BUY_PROD,
                       SUM(BUY_QTY) AS BSUM
                    FROM BUYPROD
                    WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
                    GROUP BY BUY_PROD
                    ORDER BY 2 DESC)A
     WHERE P.PROD_ID=A.BUY_PROD
       AND ROWNUM<=5;
       
 ***���� ������ �����ϴ� ��� �������̺��� �����Ͻÿ�.
  1) ���̺�� : REMAIN
  2) �÷���
   -------------------------------------------------------------------------------------
    �÷���               ������Ÿ��           N.N           PK&FK            DEFAULT VALUE
   ------------------------------------------------------------------------------------- 
   REMAIN_YEAR          CHAR(4)                           PK
   PROD_ID             VARCHAR2(10)                      PK&FK
   REMAIN_J_00          NUMBER(5)                                             0--�������
   REMAIN_J_I           NUMBER(5)                                             0--��������
   REMAIN_J_0           NUMBER(5)                                             0--����������          
   REMAIN_J_99          NUMBER(5)                                             0--�����  
   REMAIN_DATE        DATE
  ---------------------------------------------------------------------------------------
  
  3. DML ��ɰ� ��������
   1)INSERT ��
   - ������ �ڷḦ ���������� ����
 (�������)
   INSERT INTO ���̺��[(�÷�list)]
    ��������;
  . INSERT ������ ���������� ����� ��� VALUES ���� �����ϰ� '( )'�� ������
  . '��������' ���� SELECT ���� ����ϴ� �÷��� ����, ����, Ÿ�԰� '���̺��[(�÷�list)]'��
    �÷�list�� �÷��� ����, ����, Ÿ���� ��ġ�ؾ� ��
    
��뿹) ������ ������ ���̺� ���� �ڷḦ �Է��Ͻÿ�
    [�ڷ�]
    . �⵵ : '2020'
    . ��ǰ�ڵ� : PROD���̺��� ��ǰ�ڵ�
    . ������� : ��ǰ���̺��� PROD_PROPERSTOCK�� ��
    . ����/���� ���� : ����
    . �⸻��� : ��ǰ���̺��� PROD_PROPERSTOCK�� ��
    . ��¥ : 2020�� 1�� 1��
  INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID,REMAIN_J_00,REMAIN_J_99,REMAIN_DATE)
    SELECT '2020',PROD_ID,PROD_PROPERSTOCK,PROD_PROPERSTOCK,TO_DATE('20200101') 
     FROM PROD;
     
    SELECT * FROM REMAIN;
    COMMIT;
    
2) UPDATE 
 - SET ���� �ʿ��� �ڷḦ ���������� �̿��ϴ� ���
 (�������)
 UPDATE ���̺�� [��Ī]
    SET (�÷���[,�÷���,...])=(��������)
  [WHERE ����];
  . (�÷���[,�÷���,...]) : �����ų �ڷᰡ ����� �÷������� �������� ����� �� �ִ�.
  . �������� ����� �÷����� ����,����,Ÿ���� ���������� SELECT ���� ����Ǵ� �÷����� ����,����,Ÿ�԰� ��ġ�ؾ� ��.

��뿹) 2020�� 1�� ��ǰ�� ���Լ����հ踦 ���Ͽ� ���������̺��� �����Ͻÿ�.

(�������� : 2020�� 1�� ��ǰ�� ���Լ����հ�)
  
  SELECT BUY_PROD,--�ʿ����
         SUM(BUY_QTY)
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
    GROUP BY BUY_PROD;
    
(��������)
UPDATE REMAIN A
  SET (A.REMAIN_I, A.REMAIN_J_99, A.REMAIN_DATE) =        
      (SELECT A.REMAIN_I+B.SAMT, A.REMAIN_J_99+B.SAMT, TO_DATE('20200331')--���ο� ���Լ����� �������Լ����� ���ؾ��ؼ� +���Լ��� �ѹ� �� ���
        FROM (SELECT BUY_PROD,SUM(BUY_QTY) AS SAMT
                FROM BUYPROD
               WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200331')
               GROUP BY BUY_PROD)B
        WHERE A.PROD_ID=B.BUY_PROD)
   WHERE A.PROD_ID IN(SELECT DISTINCT BUY_PROD
                       FROM BUYPROD
                       WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200331'));
        
ROLLBACK;
COMMIT;

��뿹) 2020�� 4�� ��ǰ�� ���Լ����հ�� ��������հԸ� ���Ͽ� ���������̺��� �����Ͻÿ�.

 (�������� : 2020�� 4�� ��ǰ�� ���Լ����հ�� ��������հ�)
   SELECT C.PROD_ID AS ��ǰ�ڵ�,
          NVL(SUM(B.BUY_QTY),0) AS ���Լ����հ�,
          NVL(SUM(A.CART_QTY),0) AS ��������հ�
     FROM CART A
     RIGHT OUTER JOIN PROD C ON(A.CART_PROD=C.PROD_ID AND A.CART_NO LIKE '202004%')
     LEFT OUTER JOIN BUYPROD B ON(C.PROD_ID=B.BUY_PROD
     AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))          
    GROUP BY C.PROD_ID;      
    
  -- 4���� �߻��� ���Ի�ǰ
  SELECT DISTINCT(BUY_PROD)
    FROM BUYPROD
   WHERE BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430');
   
  --4���� �߻��� �����ǰ
  SELECT DISTINCT(CART_PROD)
    FROM CART
   WHERE CART_NO LIKE '202004%';
   
(�������� : ���������̺��� ����)
  UPDATE REMAIN R
     SET (R.REMAIN_I, R.REMAIN_O, R.REMAIN_J_99, R.REMAIN_DATE)=
         (SELECT R.REMAIN_I+D.SIMT,R.REMAIN_O+D.SOMT,R.REMAIN_J_99+D.SIMT-D.SOMT,
                 TO_DATE('20200430')
            FROM(SELECT C.PROD_ID AS CPID,
                        NVL(SUM(B.BUY_QTY),0) AS SIMT,
                        NVL(SUM(A.CART_QTY),0) AS SOMT
                   FROM CART A
                  RIGHT OUTER JOIN PROD C ON(A.CART_PROD=C.PROD_ID AND A.CART_NO LIKE '202004%')
                   LEFT OUTER JOIN BUYPROD B ON(C.PROD_ID=B.BUY_PROD
                    AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND TO_DATE('20200430'))          
                    GROUP BY C.PROD_ID)D   
            WHERE D.CPID=R.PROD_ID);

