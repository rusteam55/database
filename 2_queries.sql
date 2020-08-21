USE bank;

-- 1. Остатки на счетe пользователя-физлица
select i.name, i.surname,
	(select account_balance from accounts where client_id = (select id from clients c where id = i.client_id)) as balance,
	(select account_type from accounts where client_id = (select id from clients c where id = i.client_id)) as account
from individuals i where i.client_id = 8; 


-- 2. Остатки на счетах пользователя-физлица (несколько счетов)
select i.name, i.surname, a.account_balance as balance, a.account_type as account
from accounts a
	LEFT JOIN individuals i 
	ON a.client_id = i.client_id
WHERE a.client_id = 45; 

-- 3. Поиск пользователя по номеру счета
select id, status, address 
from clients c
	where id = (select client_id from accounts where account_num = '209-58-563-73893-0842675');
	
--  выяснили, что счет принадлежит организации, далее:
select c.id, c.status, c.address, o.name
from clients c
	LEFT JOIN organizations o
	ON c.id = o.client_id 
where c.id = (select client_id from accounts where account_num = '209-58-563-73893-0842675');
	
-- 4. Клиенты с несколькими счетами
select count(*) as client_accounts, client_id from accounts group by client_id having client_accounts > 1;

-- 5.Топ 10 клиентов с максимальными остатками на счетах
select sum(account_balance) as summ, client_id from accounts group by client_id order by summ desc limit 10;

-- 6. Средний остаток на счетах клиентов-физлиц.
select avg(account_balance) from accounts a where client_id in (select client_id from individuals);

-- 7. Общая задолженность клиентов перед банком;
select sum(credit_balance) as debt, sum(interest_balance) as `%`, sum(credit_balance_overdue) as debt_overdue, sum(interest_balance_overdue) as `%_overdue` from credits;

-- 8. Общая задолженность клиентов физлиц/юрлиц перед банком;
SELECT 
	case(cl.status)
		when 'individual' then 'физлица'
		when 'organization' then 'юрлица'
		end as status,
	count(*) as credit_quantity,
	sum(crd.credit_balance) as debt, 
	sum(crd.interest_balance) as `%`,
	sum(crd.credit_balance_overdue) as debt_overdue, 
	sum(crd.interest_balance_overdue) as `%_overdue` 
FROM credits crd
LEFT JOIN clients cl 
ON crd.borrower_id = cl.id
GROUP BY cl.status;

-- 9. Структура кредитного портфеля по продуктам;
SELECT 
	p.name,
	sum(crd.credit_balance) as debt, 
	sum(crd.interest_balance) as `%`,
	sum(crd.credit_balance_overdue) as debt_overdue, 
	sum(crd.interest_balance_overdue) as `%_overdue` 
FROM credits crd
LEFT JOIN products p 
ON crd.product_id = p.id
GROUP BY p.name;

-- 10. Стоимость каждого из типов обеспечения
SELECT pt.name, sum(p.pledge_value) 
FROM pledges p
LEFT JOIN pledge_type pt 
ON p.pledge_type_id = pt.id
GROUP BY pt.name;

-- 11. Залоги по кредитам "на любые цели"
SELECT (debt + debt_overdue) as common_debt, pledge, value, value / (debt + debt_overdue) as value_to_debt
	FROM
			(SELECT 
				sum(crd.credit_balance) as debt, 
				sum(crd.credit_balance_overdue) as debt_overdue, 
				-- crd.product_id, 
				pt.name as pledge,
				sum(p.pledge_value) as value 
			FROM credits crd
			LEFT JOIN pledges p 
			ON crd.id = p.to_credit_id
			LEFT JOIN pledge_type pt
			ON p.pledge_type_id = pt.id 
			WHERE crd.product_id = 1
			GROUP BY pt.name
			ORDER BY value DESC
			) tbl;
			

-- 12. Залоги и залогодатель по конкретному кредитному договору
CREATE OR REPLACE VIEW pledgor(pledgor_ind, pledgor_org, status, pledge, value, credit_agreement)
AS SELECT 
	(SELECT concat(name, ' ', surname) FROM individuals WHERE client_id = from_client_id),
	(SELECT concat(name, ' ', legal_form) FROM organizations WHERE client_id = from_client_id),
	(SELECT status FROM clients WHERE id = from_client_id),
	(SELECT name FROM pledge_type WHERE id = pledge_type_id),
	pledge_value,
	(SELECT agreement_num FROM credits WHERE id = to_credit_id)
FROM pledges
WHERE to_credit_id = (SELECT id FROM credits WHERE agreement_num = '595-OP'); 
		
SELECT * FROM pledgor;
		
-- 13. Просрочка: 50 злостных просрочников
CREATE OR REPLACE VIEW overdue (borrower, debt, interests, days, reserve)
AS SELECT
	id,
	credit_balance_overdue,
	interest_balance_overdue,
	overdue,
	reserve_rate
FROM credits WHERE overdue > 0
ORDER BY overdue DESC LIMIT 50;

SELECT * FROM overdue;

-- 14. Размер сформированных резервов
CREATE OR REPLACE VIEW reserve (borrower, debt, debt_od, interests, interests_od, free_limit, reserve)
AS SELECT
	borrower_id,
	credit_balance,
	credit_balance_overdue,
	interest_balance,
	interest_balance_overdue,
	credit_limit,
	reserve_rate
FROM credits
ORDER BY reserve_rate DESC;

SELECT borrower, ((debt + debt_od + interests + interests_od + free_limit) * reserve) / 100 as reserving_sum FROM reserve ORDER BY reserving_sum DESC; -- по заемщикам

SELECT sum(((debt + debt_od + interests + interests_od + free_limit) * reserve) / 100) as reserving_sum FROM reserve; -- в целом по портфелю

-- 15. Извлечь должников и сумму задолженности в зависимости от группы просрочки
DELIMITER //
DROP PROCEDURE IF EXISTS overdue_cat//
CREATE PROCEDURE overdue_cat(overdue_cat CHAR(12))
BEGIN
	CASE overdue_cat
		WHEN '0-30' THEN
		SELECT 
			borrower_id,
			credit_balance_overdue,
			interest_balance_overdue,
			overdue
		FROM credits WHERE overdue > 0 AND overdue <= 30 ORDER BY overdue DESC; 
		WHEN '31-90' THEN
		SELECT 
			borrower_id,
			credit_balance_overdue,
			interest_balance_overdue,
			overdue
		FROM credits WHERE overdue > 30 AND overdue <= 90 ORDER BY overdue DESC; 
		WHEN '91-180' THEN
		SELECT 
			borrower_id,
			credit_balance_overdue,
			interest_balance_overdue,
			overdue
		FROM credits WHERE overdue > 90 AND overdue <= 180 ORDER BY overdue DESC; 
		WHEN '>180' THEN
		SELECT 
			borrower_id,
			credit_balance_overdue,
			interest_balance_overdue,
			overdue
		FROM credits WHERE overdue > 180 ORDER BY overdue DESC;
		ELSE
		SELECT 'Некорректное значение группы просрочников';
	END CASE;
END//

CALL overdue_cat('0-30')//
CALL overdue_cat('31-90')//
CALL overdue_cat('91-180')//
CALL overdue_cat('>180')//

-- 16. Неиспользованный (свободный) кредитный лимит физлиц или юрлиц
DELIMITER //
DROP PROCEDURE IF EXISTS status//
CREATE PROCEDURE status(status CHAR(20))
BEGIN 
	IF (status = 'individuals') THEN 
		SELECT 
			CONCAT(i.name, ' ', i.surname) as name, 
			crd.credit_limit 
		FROM individuals i 
			LEFT JOIN credits crd 
			ON i.client_id = crd.borrower_id 
		WHERE crd.credit_limit > 0;
	END IF;
	IF (status = 'organizations') THEN 
		SELECT 
			CONCAT(o.name, ' ', o.legal_form) as name, 
			crd.credit_limit 
		FROM organizations o 
			LEFT JOIN credits crd 
			ON o.client_id = crd.borrower_id 
		WHERE crd.credit_limit > 0;
	END IF;
	
END//

CALL status('organizations');

