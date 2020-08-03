-- lesson 6 task 2
-- Пусть задан некоторый пользователь.
-- Из всех друзей пользователя найти человека, который больше всех общался с нашим пользователем.

SELECT id, name, total_msg
	FROM
		(select 
			initiator_profile_id as id, 
			(select concat(name,' ',lastname) from profiles where id = initiator_profile_id) as name 
				from friend_requests 
					where target_profile_id = 1 and status = 'approved'
		union
		select 
			target_profile_id, 
			(select concat(name,' ',lastname) from profiles where id = target_profile_id) 
				from friend_requests 
					where initiator_profile_id = 1 and status = 'approved'
		) as friends_tbl
		
	JOIN 
		(select 
			count(*) as total_msg, 
			from_profile_id as sender_id,
			(select concat(name,' ',lastname) from profiles where id = from_profile_id) as sender 
				from messages 
					where to_profile_id = 1 and is_read = 1 
						group by from_profile_id
		) as sender_tbl
	ON friends_tbl.id = sender_tbl.sender_id

ORDER BY total_msg DESC
LIMIT 1;



-- Этапы решения:
-- 1 Список друзей
select 
	initiator_profile_id, 
	(select concat(name,' ',lastname) from profiles where id = initiator_profile_id) 
from friend_requests 
	where target_profile_id = 1 and status = 'approved'
union
select 
	target_profile_id, 
	(select concat(name,' ',lastname) from profiles where id = target_profile_id) 
from friend_requests 
	where initiator_profile_id = 1 and status = 'approved'

-- 2 Кто общался с пользователем 1 (от кого получались сообщения)
select 
	count(*) as total_msg_sender, 
	from_profile_id as sender_id,
	(select concat(name,' ',lastname) from profiles where id = from_profile_id) as sender 
from messages 
where to_profile_id = 1 and is_read = 1 group by from_profile_id


-- 3 Кто из друзей больше всех общался с пользователем 1
SELECT id, name, total_msg
	FROM
		(select 
			initiator_profile_id as id, 
			(select concat(name,' ',lastname) from profiles where id = initiator_profile_id) as name 
				from friend_requests 
					where target_profile_id = 1 and status = 'approved'
		union
		select 
			target_profile_id, 
			(select concat(name,' ',lastname) from profiles where id = target_profile_id) 
				from friend_requests 
					where initiator_profile_id = 1 and status = 'approved'
		) as friends_tbl
		
	JOIN 
		(select 
			count(*) as total_msg, 
			from_profile_id as sender_id,
			(select concat(name,' ',lastname) from profiles where id = from_profile_id) as sender 
				from messages 
					where to_profile_id = 1 and is_read = 1 
						group by from_profile_id
		) as sender_tbl
	ON friends_tbl.id = sender_tbl.sender_id

ORDER BY total_msg DESC
LIMIT 1;

