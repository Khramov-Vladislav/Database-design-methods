-- Составить запрос с JOIN, в котором используется созданное представление, и вывести для каждого студента количество поселений, количество платежей и количество отзывов.
SELECT
    student_settlement_payment_counts.last_name,
    student_settlement_payment_counts.first_name,
    student_settlement_payment_counts.middle_name,
    student_settlement_payment_counts.settlement_count,
    student_settlement_payment_counts.payment_count,
    COUNT(DISTINCT review.review_id) AS review_count
FROM
    student_settlement_payment_counts
    LEFT JOIN settlement ON settlement.student_id = student_settlement_payment_counts.student_id
    LEFT JOIN review ON review.settlement_id = settlement.settlement_id
GROUP BY
    student_settlement_payment_counts.student_id,
    student_settlement_payment_counts.last_name,
    student_settlement_payment_counts.first_name,
    student_settlement_payment_counts.middle_name,
    student_settlement_payment_counts.settlement_count,
    student_settlement_payment_counts.payment_count;