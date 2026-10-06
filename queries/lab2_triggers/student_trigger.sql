CREATE
OR REPLACE FUNCTION after_student_delete() RETURNS TRIGGER AS $ $ BEGIN
DELETE FROM
    student_settlement_payment_counts
WHERE
    student_id = OLD.student_id;

RETURN OLD;

END;

$ $ LANGUAGE plpgsql;

CREATE TRIGGER after_student_delete
AFTER
    DELETE ON student FOR EACH ROW EXECUTE FUNCTION after_student_delete();