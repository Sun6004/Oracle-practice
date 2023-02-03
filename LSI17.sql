2023-0202-01) ������(SEQUENCE)
 - �ڵ������� ����(����)�Ǵ� ���� �����ϴ� ��ü (�ڵ����� �����Ǳ� ������ �ߺ��Ǿ��� ���� ����)
 - ���̺�� ���������� �����ϹǷ� ���� ���̺��� ������ �� ����
 - �� ���̺��� ������� �� �ٸ� ���̺��� ���ÿ� ����� �Ұ�
 - �������� �ѹ� ������ ���� �ٽ� ����� �� ����
 - ���Ǵ� ��
  . �⺻Ű�� ������ �÷��� �������� �ʴ� ���
  . �ڵ������� �����ϴ� ���� �ʿ��� ���
 - ��뿹 : �Խ��� ��ȣ

(�������)
 CREATE SEQUENCE �������̸�
   [START WITH n] --���� ��(�����Ǵ� ���� ���۵Ǵ� ��)������ �����ϸ� NINVALUE���� ���� 
   [INCREMENT BY n] -- ����[����]��
   [MINVALUE n|NOMINVALUE] --�ּҰ� ����. defaulf(�⺻��)�� NOMINVALUE�̸� �����Ǹ� �⺻���� 1
   [MAXVALUE n|NOMAXVALUE] --�ִ밪 ����. defaulf(�⺻��)�� NOMAXVALUE�̸� ����� �� �ִ� ����10^27 (�ִ� 99999)
   [CYCLE|NOCYCLE] --�ִ�[�ּ�]������ ���� �� �ٽ� ������ �������� ���� default(�⺻��)�� NONCYCLE
   [CACHE n|NOCACHE] -- ĳ���� �����س��� ������ ����. defult(�⺻��)�� CACHE20
   [ORDER|NOORDER] -- ������ ��� ������ ������ �������� ����. defult(�⺻��)�� NOORDER
   
** �������� ���� �� �� ���� �� ����
 . ��������.NEXTVAL : �������� ���� �� ��ȯ(������ �� ������ ���)
 . ��������.CURRVAL : �������� ���� �� ��ȯ
  => �������� ������ �� ���� ����� "��������.NEXTVAL" �̾�� ��
  => NEXTVAL,CURRVAL�� �������� �ǻ��÷�(Pseudo Column)�̶�� ��
  
��뿹)
  CREATE SEQUENCE seq_sample
    START WITH 10;
  
  SELECT seq_sample.CURRVAL FROM DUAL; --�����߻�: ���� ���ǵ��� ���� ������, NEXTVAL���� ��� �� ��밡��
  SELECT seq_sample.NEXTVAL FROM DUAL; --�����ų������ �� ����, **�ѹ� ���۵Ǹ� ���������� �ǵ����� ����

��뿹) �з����̺� ���� �ڷḦ �����Ͻÿ�.
      -------------------------------------
       LPROD_ID    LPROD_GU     LPROD_NM
      -------------------------------------
       ���������    p501         ��깰
           "       p502         ���깰 
           "       p503         �ӻ깰 
           
 (������ ���� : LPROD_ID�� ���)
 CREATE SEQUENCE seq_lprod
   START WITH 10;
 
 (�ڷ� ����)
 INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
   VALUES(seq_lprod.NEXTVAL,'P501','��깰');
   
  INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
   VALUES(seq_lprod.NEXTVAL,'P502','���깰');
   
   INSERT INTO LPROD(LPROD_ID,LPROD_GU,LPROD_NM)
   VALUES(seq_lprod.NEXTVAL,'P503','�ӻ깰');
   

2023-0202-02) ���Ǿ�(SYNONYM)
 - ����Ŭ ��ü�� �ο��� �� �ٸ� �̸�(��Ī)
 - ���̺��̳� �÷��� ��Ī���� �������� ���Ǿ�� ��� ������ ���������� ����(���)��
 - ���̺��̳� �÷��� ��Ī�� �ش� SQL�������� ��밡��
 - �ַ� �ٸ� ������ ���̺� ���� ��ü�� �����Ҷ� '��Ű����.��ü��'�� ����ؾ� �ϹǷ� �̸� �ٿ� ����ϴµ��� ���
 
(�������)
  CREATE [OR REPLACE] SYNONYM ��ü��Ī FOR ������ü��
  
��뿹) HR������ EMPLOYEES���̺�� DEPARTMENTS���̺� EMP �� DEFT��Ī�� �ο��Ͽ� ����Ͻÿ�.
  CREATE OR REPLACE SYNONYM EMP FOR HR.EMPLOYEES;
  
  CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPARTMENTS;  
  
  SELECT * FROM DEPT;
  SELECT * FROM HR.DEPARTMENTS; -- �Ȱ���
  
  SELECT A.EMPLOYEE_ID,A.EMP_NAME,B.DEPARTMENT_ID,B.DEPARTMENT_NAME
    FROM EMP A, DEPT B -- JOIN FROM������ ��ü��Ī ������� �ٿ���������.
   WHERE A.DEPARTMENT_ID=B.DEPARTMENT_ID;
   
   
  CREATE OR REPLACE SYNONYM VMEM FOR V_MILEAGE; 
  SELECT * FROM VMEM;
  
  
2023-0202-03) �ε���(INDEX)
 - Ư�� �ڷ��� �˻�ȿ���� ���̱� ���� ��ü
 - DB SERVER�� ������ �����ϴ� ��Ұ� �˻� �ɷ��̸�, SERVER�� ���ϸ� �ٿ� ��ü ������ ���
 - ��������
  . ������ �ð� �� ������ �ҿ�
  . �ڷ��� ����, ����, ������ �߻��Ǹ� �ε����� ������ �䱸��
  . �ε����� ���������ϴµ� ���� �ð��� �ҿ� (������ ����)
 - ����
  . Unique Index, Non Unigue Index --NULL���� ����(Unique���� �ΰ��� �ϳ��� �����ؾ���)
  . Single, Composite
  . Nomal, Bitmap, Function Based Nomal...etc
  
�������)
  CREATE [UNIQUE|BITMAP] INDEX �ε�����
      ON ���̺��(�÷���[,�÷���,...]) [ASC|DESC]
  . 'UNOQUE|BITMAP' : ������ �ε����� ����, �⺻�� NON_UNIQUE, NOMAL INDEX ��
  . '���̺��(�÷���[,�÷���,...])' : �ε����� ����� ���̺��� �ε��� ������ ���� �÷���(��) ���
  . '[ASC|DESC]' : �ε��� ������� �⺻�� ASC��

��뿹) 
  SELECT MEM_ID,MEM_NAME,MEM_ADD1||' '||MEM_ADD2
    FROM MEMBER
   WHERE MEM_REGNO2='2458323';  --���࿡ 0.002�� �ɸ�
   
  CREATE INDEX idx_mem_regno2
    ON MEMBER(MEM_REGNO2); --INDEX�� ����� �� �� ��SELECT�� 0.001�ʷ� ������
    
(�ε��� ����)    
  DROP INDEX idx_mem_regno2;
    

  CREATE TABLE TEMP
  AS
    SELECT * FROM CART,BUYPROD,MEMBER;
    
  SELECT * FROM TEMP;
  
  SELECT MEM_ID,MEM_NAME,CART_NO
    FROM TEMP
   WHERE MEM_ID='4382532'
     AND CART_PROD='P20200003'; --0.39�� => INDEX���� �� 0��
     
  CREATE INDEX idx_temp ON TEMP(MEM_ID,CART_PROD);
  
  DROP TABLE TEMP; --�������̺��� �������� INDEX���� ����
  
**�ε��� �籸��
 - ���̺��� ������ġ�� ����Ȱ��(���̺� �����̽� ����)
 - �ڷ��� ����/������ ���� �߻��� ���
(�������)
 ALTER INDEX �ε����� REBUILD
 

 
  