2023-0111-02) ������ �˻� ���
  - ���̺��� �ڷḦ �����Ҷ� ���
  - sql��� �� ���� ���� ����ϴ� ���
(�������)
  select [distinct] Į���� | * [as ��Ī][,]
         �÷��� [as ��Ī][,]
                :
         �÷��� [as ��Ī]--��������, ����
    from ���̺��
    [where ����] --���� �����ϴ� ����
    [group by �÷���[,�÷���,...]]--Ư�� Į���� ���� �����͵鳢�� ����
   [having ����]
    [order by �÷���|�÷� index [asc|desc][,�÷���|�÷�index [asc|desc],...]]
    
    
    . select �� : ����� �÷� ����
    . where �� : ����� ��(row) ���� --��������(������ ��� ���� ����)
    . 'distinct' : �÷� �� �� �ߺ����� ������Ŵ
    . 'as��Ī' : �÷��� �ο��� �� �ٸ� �̸�
    . select ���� select��, from���� �ʼ�����
    . ������� : from �� -> where �� -> group by �� -> having �� -> select �� 
    
��뿹) ȸ�����̺�(member)�� ����ڷḦ ��ȸ�Ͻÿ�
    select * from member;

��뿹) ȸ�����̺��� '����'�� �����ϴ� ȸ���� ȸ����ȣ,ȸ����,����,���ϸ����� ��ȸ�Ͻÿ�.
       ��, ���ϸ����� ���� ȸ������ ����Ͻÿ�.
       select mem_id as ȸ����ȣ,
              mem_name as ȸ����,
              mem_job as ����,
              mem_mileage as ���ϸ���
         from member
        where mem_add1 like '����%' --���ǹ�
        order by 4 desc; --4��° Į�������� ���� �������� desc(��������)
        
��뿹) ��ǰ���̺�(prod)���� �з��� ��ǰ�� ������ ��ȸ�Ͻÿ�.
       ��, ����� ��ǰ�� ������ ���� ������ �����Ͻÿ�.
       
       select a.prod_lgu as �з��ڵ�,
              b.lprod_nm as �з���,
              count(*) as "��ǰ������ ��" --�����̳� ��Ī�̳� Ư�����ڸ� ������ " "���
          from prod a, lprod b
        where a.prod_lgu = b.lprod_gu --��������
       
        group by a.prod_lgu, b.lprod_nm
        having count(*) >=10 --��뿹3 ��ǰ�� ���� 10���̻��� ��ǰ�� ��ȸ group������ ��� 
        order by count(*) desc; -- ��ǰ�� ������ ���������� ��ȸ

��뿹) ��ǰ���̺�(prod)���� �з��� ��ǰ�� ������ ��ȸ�ϵ� ��ǰ�� ���� 10�� �̻���
       ��ǰ�� ��ȸ�Ͻÿ�. ��, ����� �з���ȣ ū �з����� ����Ͻÿ�.
       
 **���̺� temp01~ temp10�� �����Ͻÿ�
    drop table temp01;
    drop table temp02;
    drop table temp03;
    drop table temp04;
    drop table temp05;
    drop table temp06;
    drop table temp07;
    drop table temp08;
    drop table temp09;
    drop table temp10;
    
    commit;
    
1)������
  -���������� : +, -, *, /
  
  ��뿹)HR������ ������̺��� ���ʽ��� ����ϰ� ���ʽ��� ������ �ڱݾ��� ��ȸ�Ͻÿ�
    Alias �� �����ȣ, �����, �޿�, ���ʽ�, ���޾�
    ���ʽ� = �޿�(salary)*���������ڵ�(commission_pct)
    ���޾� = �޿� + ���ʽ�
    
    select EMPLOYEE_ID as �����ȣ,
        FIRST_NAME ||' '|| LAST_NAME AS �����, -- || : ���ڿ��� + ������
        SALARY AS �޿�,
        NVL(SALARY*COMMISSION_PCT,0) AS ���ʽ�, -- NVL( ,0) : ���� �ϳ��� null�̸� �������� �״�� ���
        SALARY + NVL(SALARY*COMMISSION_PCT ,0) AS ���޾� 
        from HR.EMPLOYEES;
  
  -�񱳿�����(���迬����) : ����� true/false �� ��ȯ
    : >,  <, =, >=, <=, !=(<>)
    . ���ǽĿ� ���
    . ���ǽ��� WHERE ���� CASE WHEN - THEN(ǥ����: SELECT ���� ���)�� ���ǽĿ� ���
    
��뿹) ȸ�����̺��� �������ϸ����� 5000�̻��� ȸ���� ȸ����ȣ,ȸ����,����,���ϸ�����
       ��ȸ�Ͻÿ�. ��, ���ϸ����� ���� ȸ������ ����Ͻÿ�.
       
    SELECT mem_id AS ȸ����ȣ,
           mem_name AS ȸ����,
           mem_job AS ����,
           mem_mileage as ���ϸ���
    FROM member
    WHERE mem_mileage >= 5000 --select������ ��������
    ORDER BY mem_mileage DESC; -- mem_mileage��� ���ϸ��� ��밡��
    
    --������ �����ͺ��̽� �� ���踦 �̿��� ���� : JOIN
��뿹) �������̺�(BUYPROD)���� 2020�� 1�� ���Ե� ��ǰ���� ���Լ����� �հ谡 50�� �̻���
       ���������� ��ȸ�Ͻÿ�.
       ALIAS�� ��ǰ�ڵ�, ���Լ���, ���Աݾ��̸� ���Աݾ��� ���� ��ǰ���� ����Ͻÿ�.
    SELECT BUY_PROD AS ��ǰ�ڵ�,
           SUM(BUY_QTY) AS ���Լ���,
           SUM(BUY_QTY*BUY_COST) AS ���Աݾ�
        FROM BUYPROD 
        WHERE BUY_DATE >= '20200101' AND BUY_DATE <= '20200131'
        GROUP BY BUY_PROD
        HAVING SUM(BUY_QTY) >= 50
        ORDER BY 3 DESC; -- SELECT ���� 3���÷�
    
  -�������� : not, and, or
    
��뿹) ȸ�����̺�(MEMBER)���� ����ȸ���� ȸ����ȣ, ȸ����,����, ���ϸ����� ��ȸ�Ͻÿ�
    SELECT 
           MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_REGNO2 AS �ֹι�ȣ2,
           MEM_MILEAGE AS ���ϸ���
        FROM MEMBER
        --ù��° �ڸ����� 1���� �ڸ���/ OR : ���߿� �Ѱ��� ���� ����
           WHERE SUBSTR(MEM_REGNO2,1,1) = '2' OR SUBSTR(MEM_REGNO2,1,1)='4';
           --WHERE SUBSTR(MEM_REGNO2,1,1) IN('2','4')
    
��뿹)���ذ� �������� ������� �����Ͻÿ�(���� =4�ǹ���̸鼭 100�ǹ���� �ƴϰų� 400�� ����� �Ǵ� ��)
    SELECT CASE WHEN (MOD(EXTRACT(YEAR FROM SYSDATE),4) = 0 AND --MOD : ������
                      MOD(EXTRACT(YEAR FROM SYSDATE),100) != 0)OR
                      (MOD(EXTRACT(YEAR FROM SYSDATE),400) = 0) THEN
                      '���ش� �����Դϴ�.'
                 ELSE
                      '���ش� ����Դϴ�.'
                END AS ��� --�÷���
            FROM DUAL; --DUAL :���̺��� ���ʿ��ѵ� ������ ���̺��ڸ��� ���°�
            

��뿹) ������� ��ձ޿����� �����޿��� �޴� ����� �����ȣ, �����, �޿��� ��ȸ�ϵ�
       NOT �����ڸ� ����Ͻÿ�.
    (��ձ޿�)
    SELECT AVG(SALARY)
        FROM HR.EMPLOYEES;
        
    SELECT EMPLOYEE_ID AS �����ȣ,
           FIRST_NAME ||' '|| LAST_NAME AS �����,
           SALARY AS �޿�
        FROM HR.EMPLOYEES
        WHERE NOT SALARY >= (SELECT AVG(SALARY) FROM HR.EMPLOYEES)
        
        ORDER BY 3 DESC;

  
  
-��Ÿ������ : in, any, some, all, exists, between, like ��
  
       
                                                                 