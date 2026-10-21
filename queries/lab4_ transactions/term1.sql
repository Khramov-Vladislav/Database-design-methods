BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT
    payment_id,
    payment_amount
FROM
    payment
WHERE
    payment_id = 125;

SELECT
    payment_id,
    payment_amount
FROM
    payment
WHERE
    payment_id = 125;

COMMIT;