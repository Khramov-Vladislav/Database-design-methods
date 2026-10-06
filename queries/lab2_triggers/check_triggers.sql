-- after_student_delete
SELECT
    *
FROM
    student_settlement_payment_counts
WHERE
    student_id = 120;

DELETE FROM
    student
WHERE
    student_id = 120;

SELECT
    *
FROM
    student_settlement_payment_counts
WHERE
    student_id = 120;

-- after_settlement_insert
SELECT
    student_id,
    settlement_count
FROM
    student_settlement_payment_counts
WHERE
    student_id = 2;

INSERT INTO
    settlement (student_id, employee_id, place_id)
VALUES
    (2, 2, 2);

SELECT
    student_id,
    settlement_count
FROM
    student_settlement_payment_counts
WHERE
    student_id = 2;

-- after_settlement_delete 
SELECT
    student_id,
    settlement_count
FROM
    student_settlement_payment_counts
WHERE
    student_id = 2;

DELETE FROM
    settlement
WHERE
    settlement_id = 12;

SELECT
    student_id,
    settlement_count
FROM
    student_settlement_payment_counts
WHERE
    student_id = 2;

-- after_settlement_update 
SELECT
    student_id,
    settlement_count
FROM
    student_settlement_payment_counts
WHERE
    student_id IN (2, 3);

UPDATE
    settlement
SET
    student_id = 3
WHERE
    settlement_id = 13;

SELECT
    student_id,
    settlement_count
FROM
    student_settlement_payment_counts
WHERE
    student_id IN (2, 3);

-- after_payment_insert 
SELECT
    student_id,
    payment_count
FROM
    student_settlement_payment_counts
WHERE
    student_id = 2;

INSERT INTO
    payment (settlement_id, payment_amount, payment_date)
VALUES
    (21, 5000, CURRENT_DATE);

SELECT
    student_id,
    payment_count
FROM
    student_settlement_payment_counts
WHERE
    student_id = 2;

-- after_payment_delete 
SELECT
    student_id,
    payment_count
FROM
    student_settlement_payment_counts
WHERE
    student_id = 3;

DELETE FROM
    payment
WHERE
    payment_id = 125;

SELECT
    student_id,
    payment_count
FROM
    student_settlement_payment_counts
WHERE
    student_id = 3;

-- after_payment_update 
SELECT
    student_id,
    payment_count
FROM
    student_settlement_payment_counts
WHERE
    student_id IN (2, 3);

UPDATE
    payment
SET
    settlement_id = 14
WHERE
    payment_id = 126;

SELECT
    student_id,
    payment_count
FROM
    student_settlement_payment_counts
WHERE
    student_id IN (2, 3);