2023-0117-01) �����Լ�
 1) ������ �Լ�
   - ABS, SIGN, SQRT, POWER �� ����
     . ABS(n) : n�� ���밪 ��ȯ
     . SIGN(n) : n�� ��ȣ�� ���� �����1, ������ ũ�⿡ ������� -1, 0�̸� 0����ȯ
     . SQRT(n) : n�� ��ݱ� �� ��ȯ
     . POWER(e,n):e�� n�°� ��ȯ
   - �� �ۿ��� ���������� ���Ǵ� ���� �Լ��� ����(EXP, LOG ��)
   
2) GREATEST(n1, n2, ...), LEAST(n1, n2, ...)
  - GREATEST : �־��� �����ڷ� n1, n2, ... �� ���� ū �� ��ȯ
  - LEAST : �־��� �����ڷ� n1, n2, ... �� ���� ���� �� ��ȯ
  - MAX, MIN �Լ����� �������� GREATEST�� LEAST�� ���࿡�� ���� �� �� �� �ִ� �ּҰ���
    ��ȯ�ϴ� �Լ��̰�, MAX, MIN�Լ��� �ϳ��� �� ���ο��� �ִ� �ּҰ��� ��ȯ�ϴ� �Լ�
    ex)50���� ����, ����, ����, ���� ���������� ����� ���̺��� 
       �� �л��� 4���� �� �ְ�/���� ���� ����˻��� GREATEST�� LEAST
       �� ������ �ְ�,�������� ����� �л��� �˻��� MAX,MIN �Լ�
       
��뿹)
  SELECT GREATEST (120,50,70), LEAST(120,50,70),
         GREATEST ('A','ȫ�浿',256), LEAST('�۾���','������','������'),
         GREATEST ('ȫ�浿','ȫ���','ȫ�泲'), LEAST('ȫ�浿','ȫ���','ȫ�泲')
    FROM DUAL;
    
��뿹2) ȸ�����̺��� ���ϸ����� 1000 �̸��� ȸ���� ���ϸ����� 1000���� �ο��Ͽ� ��ȸ�Ͻÿ�
        1000�̻��� ȸ���� �״�� ���
        Alias �� ȸ����ȣ, ȸ����, ���� ���ϸ���, ��ȯ ���ϸ���
        
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_MILEAGE AS �������ϸ���,
           GREATEST(MEM_MILEAGE, 1000) AS ��ȯ���ϸ���
        FROM MEMBER;
        
3) ROUND(n [,loc]), TRUNC(n [,loc])
  - ���õ� ��n���� �Ҽ��� ���� loc+1��° �ڸ����� �ݿø�(ROUND) �Ǵ� �ڸ�����(TRUNC) �Ͽ� loc�ڸ����� ��ȯ
  - loc�� �����Ǹ� 0���� ���ֵ�
  - loc�� �����̸� ����� loc ��ġ���� �ݿø� �Ǵ� �ڸ�����
  
��뿹)
  SELECT ROUND(12345.6789,2),
         TRUNC(12345.6789,2),
         ROUND(12345.6789),
         TRUNC(12345.6789),
         ROUND(12365.6789,-2),
         TRUNC(12365.6789,-2)
     FROM DUAL;
     
��뿹) ȸ�����̺��� ���ɴ뺰(GROUP) ��ո��ϸ���, ȸ������ ���Ͻÿ�.
  SELECT  
        TRUNC (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS ���ɴ�,
        AVG(MEM_MILEAGE) AS ��ո��ϸ���,
        COUNT(*) AS ȸ����
         
   FROM MEMBER
    GROUP BY TRUNC (EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
    ORDER BY 1;
    
4) FLOOR(n), CEIL(n) - '**'
    -FLOOR : n�� ���ų� �����ʿ��� ���� ū ����(���ʿ��� ���� ����� ����)
    -CEIL : n�� ���ų� ū�ʿ��� ���� ���� ����(�����ʿ��� ���� ����� ����)
    - �ݾװ� ���õ� ��꿡 �ַ� ���

��뿹)
    SELECT FLOOR(20), FLOOR(20.567), FLOOR(-20.567),
           CEIL(20), CEIL(20.567), CEIL(-20.567)
        FROM DUAL;
    
5) MOD(n,c)-'***', REMAINDER(n,c)-'*'
    -�������� ��ȯ
    -���ο� �����ϴ� �Լ��� MOD�� REMAINDER�� �ٸ�
    ex) a�� b�� ���� ������
        MOD : a-b * FLOOR(a/b)
  REMAINDER : a-b * ROUND(a/b)
  
    ex) MOD(27,5) : 27-5*FLOOR(27/5)
                    27-5*FLOOR(5.4)
                    27-5*5
                    27-25
                    2(������)
        REMAINDER(27,5) : 27-5*ROUND(27/5)
                          27-5*ROUND(5.4)
                          27-5*5
                          2(������)
                          
��뿹) Ű����� �⵵�� �Է¹޾� �� �ذ� �������� ������� �Ǻ��Ͻÿ�
       ���� : 4�� ����̸鼭 100�� ����� �ƴϸ鼭 400�� ����� ��
       
    ACCEPT P_YEAR PROMPT '�⵵�Է�(4�ڸ���) :'
    DECLARE
      L_YEAR NUMBER := '&P_YEAR';
      L_RES VARCHAR2(200);
    BEGIN
      IF (MOD(L_YEAR,4)=0 AND MOD(L_YEAR,100)!=0) OR MOD(L_YEAR,400)=0 THEN
          L_RES:=L_YEAR|| '���� �����Դϴ�.';
          ELSE
          L_RES:=L_YEAR|| '���� ����Դϴ�.';
          END IF;
          DBMS_OUTPUT.PUT_LINE(L_RES); -- JAVA�� Print��
          END;
    
6) WIDTH_BUCKET(n, min_val, max_val, b)
  -  min_val���� max_val������ b���� �������� ���� �� n�� ��� ������ ���ϴ���
     ���� ������ �ε����� ��ȯ
  - ������ ���� ���� ���Ե��� ���� (n�� ���Ե� �������� max_val <= n < max_val)
  - ����ϴ� ������ ���� b+2����(���Ѱ� ���� ���� ����, b���� ����, ���Ѱ����� ũ�ų� ���� ����)
  
��뿹) ȸ�����̺��� ���ϸ����� 1000-8000�� 3���� �������� �����ϰ� ȸ������ ���ϸ����� ��� ������ ���ϴ��� ��Ÿ���ÿ�.
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_MILEAGE AS ���ϸ���,
           5-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,3) AS ������,
           CASE WHEN 5-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,3)IN(1,2) THEN '���ȸ��'
           WHEN 5-WIDTH_BUCKET(MEM_MILEAGE,1000,8000,3) IN(3,4) THEN '����ȸ��'
           ELSE '�ʽ�ȸ��'
           END AS ���
        FROM MEMBER;
    
  