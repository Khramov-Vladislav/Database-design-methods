--  Operator меняет данные, viewer видит результат
-- Viewer, исходное состояние:
SELECT
    *
FROM
    student_settlement_payment_counts
WHERE
    student_id = 4;

-- Operator, добавление поселения и платежа:
INSERT INTO
    settlement (student_id, employee_id, place_id)
VALUES
    (4, 2, 2);

INSERT INTO
    payment (settlement_id, payment_amount, payment_date)
VALUES
    (26, 5000, CURRENT_DATE);

-- Viewer, после добавления (ожидаю 5 и 38):
SELECT
    *
FROM
    student_settlement_payment_counts
WHERE
    student_id = 4;

-- Operator, удаление добавленных данных:
DELETE FROM
    payment
WHERE
    payment_id = (
        SELECT
            MAX(payment_id)
        FROM
            payment
    );

DELETE FROM
    settlement
WHERE
    settlement_id = (
        SELECT
            MAX(settlement_id)
        FROM
            settlement
        WHERE
            student_id = 4
    );

-- Viewer, после удаления (ожидаю 4 и 37):
SELECT
    *
FROM
    student_settlement_payment_counts
WHERE
    student_id = 4;

-- Запросы, которые должны завершиться ошибкой
--  Viewer не может читать исходные таблицы:
SELECT
    *
FROM
    payment
LIMIT
    1;

--  Viewer не может изменять данные:
INSERT INTO
    settlement (student_id, employee_id, place_id)
VALUES
    (4, 2, 2);

--  Operator не может менять сводную таблицу напрямую:
UPDATE
    student_settlement_payment_counts
SET
    payment_count = 0
WHERE
    student_id = 4;

-- Запрос, который не выполнится ни у кого
DROP TABLE student_settlement_payment_counts;