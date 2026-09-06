-- Составить запрос с JOIN, в котором используется созданное представление, и вывести для каждого студента количество поселений, количество платежей и количество отзывов.
SELECT
    students_count_settlement_and_payment.last_name,
    students_count_settlement_and_payment.first_name,
    students_count_settlement_and_payment.middle_name,
    students_count_settlement_and_payment.settlement_count,
    students_count_settlement_and_payment.payment_count,
    COUNT(DISTINCT review.review_id) AS review_count
FROM
    students_count_settlement_and_payment
    LEFT JOIN settlement ON settlement.student_id = students_count_settlement_and_payment.student_id
    LEFT JOIN review ON review.settlement_id = settlement.settlement_id
GROUP BY
    students_count_settlement_and_payment.student_id,
    students_count_settlement_and_payment.last_name,
    students_count_settlement_and_payment.first_name,
    students_count_settlement_and_payment.middle_name,
    students_count_settlement_and_payment.settlement_count,
    students_count_settlement_and_payment.payment_count;