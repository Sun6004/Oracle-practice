2023-0116-01) �Լ�
  - ���� ����� ��ȯ�ϴ� ����� �̸� �ۼ��ϰ� �������Ͽ� ���� ������ ���·� ������
    ��ȯ���� �ִ� ���� ���α׷�
  - Į���� ���̳� ������ Ÿ���� ����
  - ����, ��¥ �ڷ��� ��� ���� ����
  - Ư�� ���� �������� �����͸� �׷�ȭ�ϰ� �� �׷쿡�� ���踦 ����
  - ������/������ �Լ�
  - ���ڿ� �Լ�/ �����Լ�/ ��¥�Լ�/ ��ȯ�Լ�/ �����Լ�/ �м��Լ� ������ ����
  
1. ���ڿ� �Լ� '||'
  . ���ڿ� ���տ�����
  . �ڹ��� ���ڿ� ������ '+'�� ���ϱ�� ����

��뿹) ȸ�����̺��� ������ �����ϴ� ȸ�������� ��ȸ�Ͻÿ�.
       Alias �� ȸ����ȣ, ȸ����,�ֹι�ȣ,�ּ��̸� �ֹι�ȣ�� �����'XXXXXX-XXXXXX'���·�,
       �ּҴ� �⺻�ּҿ� ���ּҸ� �������� �����Ͽ� ����Ͻÿ�.
       
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_REGNO1 ||'-'|| MEM_REGNO2 AS �ֹι�ȣ,
           MEM_ADD1 ||'-'|| MEM_ADD2 AS �ּ�
      FROM MEMBER
      WHERE MEM_ADD1 LIKE '����%';
      
2) CONCAT (C1,C2 ) - '**'
  . ���ڿ� C1�� C2�� �����Ͽ� ���ο� ���ڿ��� ��ȯ
  . '||' �����ڿ� ���� ��� ����
  
��뿹) ȸ�����̺��� ������ �����ϴ� ȸ�������� ��ȸ�Ͻÿ�.
       Alias �� ȸ����ȣ, ȸ����,�ֹι�ȣ,�ּ��̸� �ֹι�ȣ�� �����'XXXXXX-XXXXXX'���·�,
       �ּҴ� �⺻�ּҿ� ���ּҸ� �������� �����Ͽ� ����Ͻÿ�.
       
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           CONCAT (CONCAT (MEM_REGNO1,'_'  ),MEM_REGNO2) AS �ֹι�ȣ1,
           CONCAT (MEM_REGNO1, CONCAT ('_', MEM_REGNO2 )) AS �ֹι�ȣ2,
           CONCAT (CONCAT (MEM_ADD1, '_'  ),MEM_ADD2) AS �ּ� 
        FROM MEMBER
        WHERE MEM_ADD1 LIKE '����%';
3) CHR(N), ASCII(C) - '**'
  . CHR :  �־��� N�� ����ϴ� ASCII �ڵ��� ���� ���
  . ASCII : �־��� ���ڿ� C�� ù ���ڿ� ���� ASCII �ڵ尪(����) ���
  

��뿹)
  SELECT CHR(90), ASCII ('KOREA'), ASCII ('���ѹα�'),CHR(ASCII('KOREA')),
         CHR(ASCII('���ѹα�'))
    FROM DUAL;
    

4) LOWER(C), UPPER(C),INITCAP(C)
    . LOWER : �־��� ���ڿ� C�� ���Ե� ��� ���ڸ� �ҹ��ڷ� ��ȯ
    . UPPER : �־��� ���ڿ� C�� ���Ե� ��� ���ڸ� �빮�ڷ� ��ȯ
    . INITCAP : �ܾ��� ù ���ڸ� �빮�ڷ� ��ȯ
    
  SELECT * FROM MEMBER
    WHERE UPPER(MEM_ID) = 'T001';
    
  SELECT FIRST_NAME,
         LAST_NAME,
         INITCAP((LOWER(EMP_NAME))
    FROM HR.EMPLOYEES;
    
4) LPAD(C1, N [,C2]), RPAD(C1, N [,C2])
  . LPAD : Nũ���� �������� C1 ���ڿ��� �����Ű�� ���� ���� �������� C2 ���ڿ���
           ä��. C2�� �����Ǹ� ������ Ȯ��Ǿ� ä����
           ��ǥ��ȣ���ڷ� ���Ǿ���
  . RPAD : Nũ���� �������� C1 ���ڿ��� �����Ű�� ���� ������ �������� C2 ���ڿ���
           ä��. C2�� �����Ǹ� ������ Ȯ��Ǿ� ä����
           
�ÿ뿹) ��ǰ���̺��� ���� �ڷḦ �־��� ���ǿ� ���߾� ����Ͻÿ�.
       ALIAS�� ��ǰ�ڵ�, ��ǰ��, ���԰���
       ���԰����� 10�ڸ��� ����ϵ� ���� ������� '*'�� Ȯ���Ͽ� ����ϰ� 
       ��ǰ���� 25�ڸ��� ������ �����Ͽ� ����Ͻÿ�
       
       SELECT PROD_ID AS ��ǰ�ڵ�,
              LPAD(TRIM(PROD_NAME),30) AS ��ǰ��,
              LPAD (PROD_COST,10'*') AS ���԰���
         FROM PROD;
         
5) LTRIM(C1 [,C2[), RTRIM(C1 [,C2[) -'****'
  . LTRIM : �־������ڿ� C1�� ���� ù �������� C2���ڿ��� ��ġ�ϸ� �ش� ���ڿ��� ����
  . RTRIM : �־������ڿ� C1�� ������ ù �������� C2���ڿ��� ��ġ�ϸ� �ش� ���ڿ��� ����
  . C2�� �����Ǹ� ������ ���ŵ�
  
  ��뿹) HR������ ������̺��� ������� �̸�(EMP_NAME)�� ������ Ÿ���� VARCHAR2(50) ����
         CHAR(50)���� �����Ͻÿ�.
         
  ALTER TABLE HR.EMPLOYEES MODIFY(EMP_NAME CHAR(50));
  SELECT EMPLOYEE_ID, EMP_NAME
    FROM HR.EMPLOYEES;
 ** ����� 'STEVEN KING'����� �����ȣ, �����, �Ի���, �����ڵ� ��ȸ
    SELECT EMPLOYEE_ID AS �����ȣ,
           RTRIM (EMP_NAME) AS �����,
           HIRE_DATE AS �Ի���,
           JOB_ID AS �����ڵ�
        FROM HR.EMPLOYEES
        WHERE EMP_NAME = 'Steven King'
        
    SELECT LTRIM('APAPAPPLE PESIMMON BANNA', 'AP'),
           LTRIM('APAPAPPLE PESIMMON BANNA', 'APP')
           
        FROM DUAL;
    
6) TRIM(C1) - '***'
  . �־��� ���ڿ� C1�� ��, �ڿ� �����ϴ� ������ ����
  . ���ڿ� ������ ������ �������� ����
  
��뿹) HR������ ������̺��� �̸�(EMP_NAME)�� �÷��� �ڷ����� VARCHAR2(50)���� ���ͽ�Ű�ÿ�.
    ALTER TABLE HR.EMPLOYEES MODIFY(EMP_NAME VARCHAR2(50));
    
    
        UPDATE HR.EMPLOYEES
            SET EMP_NAME = TRIM(EMP_NAME);
            
        COMMIT;
        
    SELECT EMPLOYEE_ID, EMP_NAME, LENGTHB(EMP_NAME)
        FROM HR.EMPLOYEES;
        
7) SUBSTR(C, SIDX [,CNT]) - '*****'
  . �־��� ���ڿ� C���� SIDX��ġ���� CNT ������ŭ�� �κ� ���ڿ��� �����Ͽ� ��ȯ
  . C�� ���ڼ����� ū ���� CNT�� ���ǰų� CNT�� �����Ǹ� SIDX���� ��� ���ڿ��� ��ȯ
  . SIDX�� �����̸� �����ʺ��� ó��
  
��뿹)
    SELECT SUBSTR('������ �߱� ���� 846',3,5) AS COL1,
           SUBSTR('������ �߱� ���� 846',3) AS COL2,
           SUBSTR('������ �߱� ���� 846',3,35) AS COL3,
           SUBSTR('������ �߱� ���� 846',-10,5) AS COL4
           
        FROM DUAL;
        
 **ǥ���� : CASE WHEN THEN
   - �ڹ��� ���ߺб�� ����� ��� ����
   (�������-1)
   CASE WHEN ����1 THEN
             ��1
        WHEN ����2 THEN
             ��2
             :
        ELSE
             ��N
        END
        . SELECT ���� SELECT ������ ���
        . '����1'�� ���̸� ��1�� ��ȯ�ϰ� END ���� ��� ����
        . '����1'�� �����̸� �� ���� ���ǵ��� ���ϸ� ��� ���ǵ��� �����̸� ELSE ������ ��N�� ��ȯ
        
     (�������-2)
   CASE ���� WHEN ��1 THEN
             ���2
        WHEN ��2 THEN
             ���2
             :
        ELSE
             ���N
        END     
        
����] ȸ�����̺��� �ֹε�Ϲ�ȣ�� �̿��Ͽ� ���̸� ����Ͽ� 20�� ȸ���� ��ȸ�Ͻÿ�
    ȸ����ȣ, ȸ����, �ֹι�ȣ, ����, ���ϸ���
    
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_REGNO1 || '-' || MEM_REGNO2 AS �ֹι�ȣ,
           EXTRACT(YEAR FROM SYSDATE)-
           CASE WHEN SUBSTR(MEM_REGNO2,1,1)IN('1','2') 
           THEN 1900+ TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))
           ELSE 2000+ TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)) END AS ����, 
           MEM_MILEAGE AS ���ϸ���
        FROM MEMBER
        WHERE ( EXTRACT(YEAR FROM SYSDATE)-
           (CASE WHEN SUBSTR(MEM_REGNO2,1,1)IN('1','2') 
           THEN 1900+ TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))
           ELSE 2000+ TO_NUMBER(SUBSTR(MEM_REGNO1,1,2)) END)) BETWEEN 20 AND 29;
         
2) REPLACE(C1,C2[,C3]) - '***'
  . �־��� ���ڿ� C1���� C2���ڿ��� ã�� C3���ڿ��� ��ġ
  . C3�� �����Ǹ� ã�� C3�� ������
  . ���ڿ� ���� ������ ������ �� ����
  
��뿹)
    SELECT REPLACE ('��켭�񽺼���','���','APPLE'),
           REPLACE ('APPLE PERSSIOM','A'),
           REPLACE ('ORACLE MYSQL MSSQL',' ')
        FROM DUAL;
        
9) INSTR(C1,C2 [,M[,N]]) - '**'
  . C1 ���ڿ����� C2 ���ڿ��� ó�� ���� ��ġ(INDEX)�� ��ȯ
  . M�� �˻� ������ġ ���� ��
  . N�� C2�� N��° ���� ��ġ�� ��ȯ ���� �� ���
  
��뿹)
  SELECT INSTR('APPLEPERSSIBANANAIMIOANCE','L'),
         INSTR('APPLEPERSSIBANANAIMIOANCE','A',3),
         INSTR('APPLEPERSSIBANANAIMIOANCE','A',10,2)
    FROM DUAL;
    
10) LENGTH(C), LENGTHB(C) - '***'
  . LENGTH : �־��� ���ڿ� C�� ���Ե� ���ڼ� ��ȯ
  . LENGTHB : �־��� ���ڿ� C�� ����(BYTE ��) ��ȯ
           
    

    
        