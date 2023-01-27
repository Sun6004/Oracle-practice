2023-0118-02)��ȯ�Լ�
  - ������ Ÿ���� ��ȯ�ϴ� �Լ�
  - TO_CHAR, TO_NUMBER, TO_DATE, CAST ���� ������
  1)CAST(EXPR AS Ÿ�Ը�)
   -'EXPR'�� ����� �����͸� AS ������ ����� 'Ÿ��'���� ��ȯ
   
��뿹)
  SELECT BUY_DATE AS COL1,
         CAST(BUY_DATE AS CHAR(20)) AS COL2
         --CAST(BUY_PROD AS NUMBER(20)) AS CPL3 : ���ڷ� ��ȯ�ɼ� ���� ������ ���ԵǾ��ֱ⶧���� ��ȯ�Ұ�
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200115');
    
    SELECT CAST(1234.56 AS VARCHAR2(7)) FROM DUAL; --�Ҽ���(.)���� ���ԵǴ� �ڸ����� �����ؾ���
    
2) TO_CHAR(data [,'FMT']) - '*****'
  - �־��� ������('data')�� �����������ڿ�('fmt')�� ���߾� ���ڷ� ��ȯ
  - 'data'�� ���� �� �ִ� �ڷ��� Ÿ����
   . ���ڿ�(CHAR, CLOB) => VARCHAR2�� ��ȯ
   . ����Ÿ�� => ���ڿ� Ÿ������ ��ȯ
   . ��¥Ÿ�� => ���ڿ� Ÿ������ ��ȯ
 
  - ���� �������� ���ڿ�
  --------------------------------------------------------------------------------------
  FORMAT          ����              ��
  --------------------------------------------------------------------------------------
  BC, AD         ����(�����)       SELECT TO_CHAR(SYSDATE, 'BC') FROM DUAL;
  CC             ����              SELECT TO_CHAR(SYSDATE, 'BC CC') FROM DUAL;
  YYYY,YYY,
  YY,Y           ����              SELECT TO_CHAR(SYSDATE, 'YYYY YYY YY Y') FROM DUAL;
  RM,MM,
  MONTH, MON     ��                SELECT TO_CHAR(SYSDATE, 'YYYY-MM'), TO_CHAR(SYSDATE,'YYYY-RM'),
                                          TO_CHAR(SYSDATE,'YYYY-MONTH'),TO_CHAR(SYSDATE,'YYYY-MON') FROM DUAL;
  DD,DDD,D       ��                SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DY'),TO_CHAR(SYSDATE, 'YYYY-MM-DD'),
                                          TO_CHAR(SYSDATE, 'YYYY-MM-D'), 
                                          TO_CHAR(SYSDATE, 'YYYY-MM-DD WW'),TO_CHAR(SYSDATE, 'YYYY-MM-DD W')
                                             FROM DUAL;
  DAY,DY         ����
  WW, W          ��                     
  
  A.M. , P.M.    ����/����          SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DAY AM'),TO_CHAR(SYSDATE, 'YYYY-MM-DAY PM') FROM DUAL;
  HH,HH12,HH24   �ð�              SELECT TO_CHAR(TO_DATE('20210213133127','YYYYMMDDHH24MISS'),'YYYY/MM/DD HH:MI:SS') FROM DUAL;
  MI             ��                
  SS,SSSSS       �� --�Ϸ� 86400�ʸ� ����ϱ����� S�� 5�ڸ�
  "���ڿ�"        ����� ���� ���ڿ�   SELECT TO_CHAR(SYSDATE,'YYYY"��" MM"��" DD"��"') FROM DUAL;
  
  
   - ���� �������� ���ڿ�
   --------------------------------------------------------------------------------------
   FORMAT         ����                                      ��
   --------------------------------------------------------------------------------------
    9         ����ڸ��� ���� �� ��ȿ���ڿ�                  
              �����Ͽ� ��ȿ���� ��� ��ȿ��0��
              ����ó��
    0         ����ڸ��� ���� �� ��ȿ���ڿ�                  SELECT TO_CHAR(12345.789,'99999.9'),
              �����Ͽ� ��ȿ���� ��� ��ȿ��0��                      TO_CHAR(12345.789,'99999.99'),--�Ǽ��κ��� �ڸ����� �����ϸ� �ݿø��Ǽ� �����
              '0'�� ���                                        TO_CHAR(12345.789,'99999'),
                                                               TO_CHAR(12345.789,'00000.0'),
                                                               TO_CHAR(12345.789,'00000.09'),
                                                               TO_CHAR(12345.789,'00000') FROM DUAL;
   
    $,L       ȭ���ȣ�� ���� ���ʿ� ���                  SELECT TO_CHAR(123456,'$9,999,999'),TO_CHAR(123456,'L9,999,999')   FROM DUAL;   
    MI        '-'��ȣ�� ���� �����ʿ� ���                SELECT TO_CHAR(-123456,'9,999,999MI'),TO_CHAR(123456,'9,999,999MI')   FROM DUAL;     
    PR        �����ڷ��'<>'�ȿ� ���                     SELECT TO_CHAR(-123456,'9,999,999PR'),TO_CHAR(123456,'9,999,999PR')   FROM DUAL;
   ,(comma)   3�ڸ����� �ڸ��� ���
              ��ȿ��','�� �������(9 MODE)
   .(dot)     �Ҽ��� ���
   
3) TO_DATE(expr [,'FMT']) -'***'
  - ��¥�� ��ȯ ������ 'expr'(���ڿ� �Ǵ� ����)�� ��¥Ÿ������ ��ȯ
  - ��¥�� ��ȯ�� �� ���� ���ڿ��� ���Ե� ��� �ش� ���ڿ��� ��µǱ� ���Ͽ� �ʿ��� �����������ڿ��� ����ؾ� ��
  - 'fmt'�� TO_CHAR�� ���Ǵ� ��¥���� ���� ���ڿ��� ����
  
��뿹):
  SELECT TO_DATE('20221217'),
         TO_DATE(20221217),
         TO_DATE('2022-12-17 14:27:45','YYYY-MM-DD HH24:MI:SS'),
         TO_DATE('2022.12.17','YYYY.MM.DD')
    FROM DUAL;
    
��뿹) ��ٱ������̺��� 2020�� 6�� 1�Ϻ��� 6�� 15�ϱ��� �߻��� �����ڷḦ ��ȸ�Ͻÿ�
       Alias�� ����, ��ǰ�ڵ�, �Ǹż����̴�
       SELECT TO_DATE (SUBSTR (CART_NO,1,8))AS ����,
              CART_PROD AS ��ǰ�ڵ�,
              CART_QTY AS �Ǹż���
         FROM CART
         WHERE TO_DATE (SUBSTR (CART_NO,1,8)) BETWEEN '20200601' AND '20200615';
    
4) TO_NUMBER(expr [,'fmt'9]) -'***'
  - ���ڷ� ��ȯ ������ 'expr'(���ڿ�)�� ����Ÿ������ ��ȯ
  - ���ڷ� ��ȯ�� �� ���� ���ڿ��� ���Ե� ��� �ش� ���ڿ��� ��µǱ� ���Ͽ� �ʿ��� �����������ڿ��� ����ؾ� ��
  - 'fmt'�� TO_CHAR�� ���Ǵ� �������� ���� ���ڿ��� ����
  
��뿹)
  SELECT TO_NUMBER('12345'),
         TO_NUMBER('12345.9'),
         TO_NUMBER('12,345','99,999'),
         TO_NUMBER('��12,345','L00,000'),
         TO_NUMBER('<12345>','99999PR')
    FROM DUAL;
    
��뿹) ������ 2020�� 7�� 1���̶�� �����ϰ� ���ο� ��ٱ��Ϲ�ȣ�� �����ϴ� SQL�� �ۼ��Ͻÿ�
  SELECT --TO_CHAR(SYSDATE, 'YYYYMMDD')||TRIM(TO_CHAR(TO_NUMBER(SUBSTR (MAX(CART_NO),9))+1,'00000'))
         MAX(CART_NO)+1
    FROM CART
    WHERE CART_NO LIKE '20200701%';
                     
      
    