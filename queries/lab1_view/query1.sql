-- Выполнить запрос к созданному представлению для вывода студентов, у которых количество выполненных платежей меньше, чем у студента «А».
SELECT
    students_count_settlement_and_payment.last_name,
    students_count_settlement_and_payment.first_name,
    students_count_settlement_and_payment.middle_name,
    students_count_settlement_and_payment.settlement_count,
    students_count_settlement_and_payment.payment_count
FROM
    students_count_settlement_and_payment
WHERE
    students_count_settlement_and_payment.payment_count < (
        SELECT
            payment_count
        FROM
            students_count_settlement_and_payment
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
    students_count_settlement_and_payment
WHERE
    last_name = 'Glover'
    AND first_name = 'Nels'
    AND middle_name = 'Aimee';