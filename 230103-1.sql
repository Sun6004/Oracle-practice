2023-0103-01)사용자생성 및 권한 부여
1. 사용자 생성 (관리자만 가능)
    - CREATE USER 명령 이용
    - (테이블 삭제는 DROP USER 사용)
 (사용형식)
    CREATE USER 계정명 IDENTIFIED BY  암호;
    . 계정명은 사용자 정의어 사용
    
    CREATE USER LSI IDENTIFIED BY java;
    
2. 권한부여
    -GRANT 명령으로 사용자의 권한 부여
    -권한 회수는 REVOKE 명령으로 수행
(사용형식)
    GRANT 권한명[,권한명,...] TO 계정명; ([]는 생략할 수 있음) 
    . 사용하는 권한으로는 CONNECT, RESOURCE, DBA 를 설정
    
    GRANT CONNECT,RESOURCE,DBA TO LSI
    
3. HR계정 활성화
    -HR계정은 오라클 설치시 비활성화되어 제공됨
    -ALTER 명령으로 활성화
(사용형식)
    ALTER USER 계정명 ACCOUNT UNLOCK;
    
(암호변경)
    ALTER USER 계정명 IDENTIFIED BY 암호
    
** 위 두 명령을 하나로 결합사용 가능
    ALTER USER 계정명 ACCOUNT UNLOCK IDENTIFIED BY 암호;
    
    ALTER USER HR ACCOUNT UNLOCK IDENTIFIED BY java;
