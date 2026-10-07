-- роли
SELECT
    rolname,
    rolcanlogin,
    rolsuper
FROM
    pg_roles
WHERE
    rolname IN ('dorm_viewer', 'dorm_operator')
ORDER BY
    rolname;

-- выданные права
SELECT
    grantee,
    table_name,
    string_agg(
        privilege_type,
        ', '
        ORDER BY
            privilege_type
    ) AS privileges
FROM
    information_schema.role_table_grants
WHERE
    grantee IN ('dorm_viewer', 'dorm_operator')
GROUP BY
    grantee,
    table_name
ORDER BY
    grantee,
    table_name;

-- триггерные функции в режиме SECURITY DEFINER
SELECT
    proname,
    prosecdef
FROM
    pg_proc
WHERE
    proname ~ '^(after|before)_(student|settlement|payment)_'
ORDER BY
    proname;

-- владелец сводной таблицы
SELECT
    tablename,
    tableowner
FROM
    pg_tables
WHERE
    tablename = 'student_settlement_payment_counts';