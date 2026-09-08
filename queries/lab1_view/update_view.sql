UPDATE
    student_settlement_payment_counts
SET
    settlement_count = 10
WHERE
    student_id = 1;

INSERT INTO
    student_settlement_payment_counts (
        student_id,
        last_name,
        first_name,
        middle_name,
        settlement_count,
        payment_count
    )
VALUES
    (100, 'Khramov', 'Vlad', 'Dmitry', 5, 3);