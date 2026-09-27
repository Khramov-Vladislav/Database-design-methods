-- insert
CREATE
OR REPLACE FUNCTION after_settlement_insert() RETURNS TRIGGER AS $ $ BEGIN
UPDATE
    student_settlement_payment_counts
SET
    settlement_count = settlement_count + 1
WHERE
    student_id = NEW.student_id;

RETURN NEW;

END;

$ $ LANGUAGE plpgsql;

CREATE TRIGGER after_settlement_insert
AFTER
INSERT
    ON settlement FOR EACH ROW EXECUTE FUNCTION after_settlement_insert();

-- delete
CREATE
OR REPLACE FUNCTION after_settlement_delete() RETURNS TRIGGER AS $ $ BEGIN
UPDATE
    student_settlement_payment_counts
SET
    settlement_count = settlement_count - 1
WHERE
    student_id = OLD.student_id;

RETURN OLD;

END;

$ $ LANGUAGE plpgsql;

CREATE TRIGGER after_settlement_delete
AFTER
    DELETE ON settlement FOR EACH ROW EXECUTE FUNCTION after_settlement_delete();

-- update
CREATE
OR REPLACE FUNCTION after_settlement_update() RETURNS TRIGGER AS $ $ BEGIN IF OLD.student_id IS NOT NULL THEN
UPDATE
    student_settlement_payment_counts
SET
    settlement_count = settlement_count - 1
WHERE
    student_id = OLD.student_id;

END IF;

IF NEW.student_id IS NOT NULL THEN
UPDATE
    student_settlement_payment_counts
SET
    settlement_count = settlement_count + 1
WHERE
    student_id = NEW.student_id;

END IF;

RETURN NEW;

END;

$ $ LANGUAGE plpgsql;

CREATE TRIGGER after_settlement_update
AFTER
UPDATE
    ON settlement FOR EACH ROW EXECUTE FUNCTION after_settlement_update();