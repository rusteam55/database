-- lesson 6 task 3
-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей. 

SELECT 
	(select concat(name,' ',lastname) from profiles where id = author_pst) as 'name',
	(select timestampdiff(year, birthday, now()) from profiles where id = author_pst) as 'age', 
	total_likes_posts
		from
		(select 
			count(profile_id) as total_likes_posts, 
			-- (select concat(name,' ',lastname) from profiles where id = (select profile_id from posts where id = post_id)) as 'name'
			(select profile_id from posts where id = post_id) as 'author_pst'
			-- (select timestampdiff(year, birthday, now()) from profiles where id = (select profile_id from posts where id = post_id))
		from 
		likes_posts 
		group by author_pst) tbl

ORDER BY -age DESC 
LIMIT 10;


