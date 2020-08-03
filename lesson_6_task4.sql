-- lesson 6 task 4
-- Определить, кто больше поставил лайков: мужчины или женщины. 

SELECT gender, sum(total_likes)
	FROM
		(SELECT 
			(select gender from profiles where id = p_id) as 'gender',
			(tot_pst + tot_pht) as total_likes, 
			p_id 
				FROM 
					(select count(*) tot_pst, profile_id as p_id from likes_posts group by profile_id) as pst 
					JOIN 
					(select count(*) tot_pht, profile_id from likes_photo group by profile_id) as pht
					ON pst.p_id = pht.profile_id
		) tbl
GROUP BY gender;

-- Этапы решения:
-- 1 Объединяем лайки в одну таблицу
SELECT tot_pst, tot_pht from 
(select count(*) tot_pst, profile_id from likes_posts group by profile_id) as pst 
JOIN 
(select count(*) tot_pht, profile_id from likes_photo group by profile_id) as pht
ON pst.profile_id = pht.profile_id;

-- 2 Суммируем лайки каждого пользователя
SELECT (tot_pst + tot_pht) as total_likes from 
(select count(*) tot_pst, profile_id from likes_posts group by profile_id) as pst 
JOIN 
(select count(*) tot_pht, profile_id from likes_photo group by profile_id) as pht
ON pst.profile_id = pht.profile_id;

-- 3 Соотносим с пользователем
SELECT (tot_pst + tot_pht) as total_likes, p_id from 
(select count(*) tot_pst, profile_id as p_id from likes_posts group by profile_id) as pst 
JOIN 
(select count(*) tot_pht, profile_id from likes_photo group by profile_id) as pht
ON pst.p_id = pht.profile_id;

-- 4 Прикрутили пол пользователя
SELECT 
(select gender from profiles where id = p_id) as 'gender',
(tot_pst + tot_pht) as total_likes, 
p_id 
FROM 
(select count(*) tot_pst, profile_id as p_id from likes_posts group by profile_id) as pst 
JOIN 
(select count(*) tot_pht, profile_id from likes_photo group by profile_id) as pht
ON pst.p_id = pht.profile_id;

-- 5 Суммировали лайки по каждому полу
SELECT gender, sum(total_likes)
	FROM
		(SELECT 
			(select gender from profiles where id = p_id) as 'gender',
			(tot_pst + tot_pht) as total_likes, 
			p_id 
				FROM 
					(select count(*) tot_pst, profile_id as p_id from likes_posts group by profile_id) as pst 
					JOIN 
					(select count(*) tot_pht, profile_id from likes_photo group by profile_id) as pht
					ON pst.p_id = pht.profile_id
		) tbl
GROUP BY gender;