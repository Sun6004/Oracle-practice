SELECT MAX(PRICE) AS MAX_PRICE FROM PRODUCT;
SELECT MAX(DATETIME) AS '시간' FROM ANIMAL_INS;
SELECT MIN(DATETIME) AS '시간' FROM ANIMAL_INS;
SELECT COUNT(ANIMAL_ID) FROM ANIMAL_INS;
SELECT count(distinct name) from animal_ins where name is not null;

SELECT a.TITLE, a.BOARD_ID, b.REPLY_ID, b.WRITER_ID, b.CONTENTS, TO_CHAR(b.CREATED_DATE, 'YYYY-MM-DD') as CREATED_DATE
    from USED_GOODS_BOARD a
    INNER JOIN USED_GOODS_REPLY b ON a.BOARD_ID = b.BOARD_ID
WHERE TO_CHAR(a.CREATED_DATE, 'YYYYMM') = '202210'
order by b.CREATED_DATE, a.TITLE asc;

SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(PRODUCT_ID) >= 2
ORDER BY USER_ID ASC, PRODUCT_ID DESC;