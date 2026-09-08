-- Выполнить запрос к созданному представлению для вывода студентов, у которых количество выполненных платежей меньше, чем у студента «А».
SELECT
    student_settlement_payment_counts.last_name,
    student_settlement_payment_counts.first_name,
    student_settlement_payment_counts.middle_name,
    student_settlement_payment_counts.settlement_count,
    student_settlement_payment_counts.payment_count
FROM
    student_settlement_payment_counts
WHERE
    student_settlement_payment_counts.payment_count < (
        SELECT
            payment_count
        FROM
            student_settlement_payment_counts
        WHERE
            last_name = 'Glover'
            AND first_name = 'Nels'
            AND middle_name = 'Aimee'
    )
ORDER BY
    settlement_count DESC,
    payment_count DESC;

SELECT
    settlement_count,
    payment_count
FROM
    student_settlement_payment_counts
WHERE
    last_name = 'Glover'
    AND first_name = 'Nels'
    AND middle_name = 'Aimee';