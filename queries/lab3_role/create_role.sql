-- роли
CREATE ROLE dorm_viewer LOGIN PASSWORD 'viewer_pass';

CREATE ROLE dorm_operator LOGIN PASSWORD 'operator_pass';

-- доступ к БД и схеме
GRANT CONNECT ON DATABASE dormitory TO dorm_viewer,
dorm_operator;

GRANT USAGE ON SCHEMA public TO dorm_viewer,
dorm_operator;

-- первый пользователь: только чтение сводной таблицы
GRANT
SELECT
    ON student_settlement_payment_counts TO dorm_viewer;

-- второй пользователь: управление таблицами, на которых висят триггеры
GRANT
SELECT
,
INSERT
,
UPDATE
,
    DELETE ON student,
    settlement,
    payment TO dorm_operator;

-- для SERIAL-столбцов (иначе INSERT без явного id не выполнится)
GRANT USAGE,
SELECT
    ON SEQUENCE student_student_id_seq,
    settlement_settlement_id_seq,
    payment_payment_id_seq TO dorm_operator;

-- триггерные функции выполняются с правами владельца
ALTER FUNCTION after_student_insert() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION after_student_update() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION after_student_delete() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION after_settlement_insert() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION after_settlement_update() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION after_settlement_delete() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION before_settlement_delete() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION after_payment_insert() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION after_payment_update() SECURITY DEFINER
SET
    search_path = public;

ALTER FUNCTION after_payment_delete() SECURITY DEFINER
SET
    search_path = public;