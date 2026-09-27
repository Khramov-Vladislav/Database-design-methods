-- insert
CREATE
OR REPLACE FUNCTION after_payment_insert() RETURNS TRIGGER AS $ $ BEGIN
UPDATE
    student_settlement_payment_counts
SET
    payment_count = payment_count + 1
WHERE
    student_id = (
        SELECT
            student_id
        FROM
            settlement
        WHERE
            settlement_id = NEW.settlement_id
    );

RETURN NEW;

END;

$ $ LANGUAGE plpgsql;

CREATE TRIGGER after_payment_insert
AFTER
INSERT
    ON payment FOR EACH ROW EXECUTE FUNCTION after_payment_insert();

-- delete
CREATE
OR REPLACE FUNCTION after_payment_delete() RETURNS TRIGGER AS $ $ BEGIN
UPDATE
    student_settlement_payment_counts
SET
    payment_count = payment_count - 1
WHERE
    student_id = (
        SELECT
            student_id
        FROM
            settlement
        WHERE
            settlement_id = OLD.settlement_id
    );

RETURN OLD;

END;

$ $ LANGUAGE plpgsql;

CREATE TRIGGER after_payment_delete
AFTER
    DELETE ON payment FOR EACH ROW EXECUTE FUNCTION after_payment_delete();

-- update 
CREATE
OR REPLACE FUNCTION after_payment_update() RETURNS TRIGGER AS $ $ BEGIN IF OLD.settlement_id IS NOT NULL THEN
UPDATE
    student_settlement_payment_counts
SET
    payment_count = payment_count - 1
WHERE
    student_id = (
        SELECT
            student_id
        FROM
            settlement
        WHERE
            settlement_id = OLD.settlement_id
    );

END IF;

IF NEW.settlement_id IS NOT NULL THEN
UPDATE
    student_settlement_payment_counts
SET
    payment_count = payment_count + 1
WHERE
    student_id = (
        SELECT
            student_id
        FROM
            settlement
        WHERE
            settlement_id = NEW.settlement_id
    );

END IF;

RETURN NEW;

END;

$ $ LANGUAGE plpgsql;

CREATE TRIGGER after_payment_update
AFTER
UPDATE
    ON payment FOR EACH ROW EXECUTE FUNCTION after_payment_update();