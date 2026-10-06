CREATE TABLE student_settlement_payment_counts AS
SELECT
    student.student_id,
    student.last_name,
    student.first_name,
    student.middle_name,
    COUNT(DISTINCT settlement.settlement_id) AS settlement_count,
    COUNT(DISTINCT payment.payment_id) AS payment_count
FROM
    student
    LEFT JOIN settlement ON student.student_id = settlement.student_id
    LEFT JOIN payment ON settlement.settlement_id = payment.settlement_id
GROUP BY
    student.student_id,
    student.last_name,
    student.first_name,
    student.middle_name;

ALTER TABLE
    student_settlement_payment_counts
ADD
    PRIMARY KEY (student_id);