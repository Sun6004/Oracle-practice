2023-0103-01)����ڻ��� �� ���� �ο�
1. ����� ���� (�����ڸ� ����)
    - CREATE USER ��� �̿�
    - (���̺� ������ DROP USER ���)
 (�������)
    CREATE USER ������ IDENTIFIED BY  ��ȣ;
    . �������� ����� ���Ǿ� ���
    
    CREATE USER LSI IDENTIFIED BY java;
    
2. ���Ѻο�
    -GRANT ������� ������� ���� �ο�
    -���� ȸ���� REVOKE ������� ����
(�������)
    GRANT ���Ѹ�[,���Ѹ�,...] TO ������; ([]�� ������ �� ����) 
    . ����ϴ� �������δ� CONNECT, RESOURCE, DBA �� ����
    
    GRANT CONNECT,RESOURCE,DBA TO LSI
    
3. HR���� Ȱ��ȭ
    -HR������ ����Ŭ ��ġ�� ��Ȱ��ȭ�Ǿ� ������
    -ALTER ������� Ȱ��ȭ
(�������)
    ALTER USER ������ ACCOUNT UNLOCK;
    
(��ȣ����)
    ALTER USER ������ IDENTIFIED BY ��ȣ
    
** �� �� ����� �ϳ��� ���ջ�� ����
    ALTER USER ������ ACCOUNT UNLOCK IDENTIFIED BY ��ȣ;
    
    ALTER USER HR ACCOUNT UNLOCK IDENTIFIED BY java;
