-- lesson 6 task 5
-- Найти 10 пользователй, которые проявляют наименьшую активность в использовании социальной сети. 

SELECT 
(select concat(name,' ',lastname) from profiles where id = p_id) as 'name',
(lk_pst*0.2 + lk_pht*0.2 + repost*0.5 + post + cmt*0.7) as rate 
	from 
		(select count(*) lk_pst, profile_id as p_id from likes_posts group by profile_id) as pst 
		JOIN
		(select count(*) lk_pht, profile_id from likes_photo group by profile_id) as pht
		ON pst.p_id = pht.profile_id
			JOIN 
			(select count(*) repost, likepage from likes_posts  group by likepage) as rpt
			ON pst.p_id = rpt.likepage
				JOIN 
				(select count(*) post, profile_id from posts group by profile_id) as p
				ON pst.p_id = p.profile_id
					JOIN 
						(select count(*) cmt, profile_id from comments group by profile_id) as com 
						ON pst.p_id = com.profile_id
ORDER BY rate
LIMIT 10;


-- Этапы решения:
-- 1 Собрали в одну таблицу количество лайков, репостов, постов, комментов каждого пользователя
SELECT lk_pst, lk_pht, repost, post, cmt, p_id 
	from 
		(select count(*) lk_pst, profile_id as p_id from likes_posts group by profile_id) as pst 
		JOIN
		(select count(*) lk_pht, profile_id from likes_photo group by profile_id) as pht
		ON pst.p_id = pht.profile_id
			JOIN 
			(select count(*) repost, likepage from likes_posts  group by likepage) as rpt
			ON pst.p_id = rpt.likepage
				JOIN 
				(select count(*) post, profile_id from posts group by profile_id) as p
				ON pst.p_id = p.profile_id
					JOIN 
						(select count(*) cmt, profile_id from comments group by profile_id) as com 
						ON pst.p_id = com.profile_id;
						
-- 2 Суммировали активности каждого пользователя с учетом веса активности
SELECT (lk_pst*0.2 + lk_pht*0.2 + repost*0.5 + post + cmt*0.7) as rate, p_id 
	from 
		(select count(*) lk_pst, profile_id as p_id from likes_posts group by profile_id) as pst 
		JOIN
		(select count(*) lk_pht, profile_id from likes_photo group by profile_id) as pht
		ON pst.p_id = pht.profile_id
			JOIN 
			(select count(*) repost, likepage from likes_posts  group by likepage) as rpt
			ON pst.p_id = rpt.likepage
				JOIN 
				(select count(*) post, profile_id from posts group by profile_id) as p
				ON pst.p_id = p.profile_id
					JOIN 
						(select count(*) cmt, profile_id from comments group by profile_id) as com 
						ON pst.p_id = com.profile_id;
						
-- 3 Вывели имя и отсортировали по коэффициенту активности
SELECT 
(select concat(name,' ',lastname) from profiles where id = p_id) as 'name',
(lk_pst*0.2 + lk_pht*0.2 + repost*0.5 + post + cmt*0.7) as rate 
	from 
		(select count(*) lk_pst, profile_id as p_id from likes_posts group by profile_id) as pst 
		JOIN
		(select count(*) lk_pht, profile_id from likes_photo group by profile_id) as pht
		ON pst.p_id = pht.profile_id
			JOIN 
			(select count(*) repost, likepage from likes_posts  group by likepage) as rpt
			ON pst.p_id = rpt.likepage
				JOIN 
				(select count(*) post, profile_id from posts group by profile_id) as p
				ON pst.p_id = p.profile_id
					JOIN 
						(select count(*) cmt, profile_id from comments group by profile_id) as com 
						ON pst.p_id = com.profile_id
ORDER BY rate
LIMIT 10;
						
						