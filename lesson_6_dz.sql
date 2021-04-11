use snet_v1;
select id, name, lastname, timestampdiff(year, birthday, now()) as 'age', mylikes.tl from profiles, ( 
select tl_photo + tl_post as tl, t1.prof_id as p1 from (
		
	(select count(ph_l) as tl_photo, prof_id from (select count(*) as ph_l, photo_id, 
				(select profile_id from photos where id = photo_id) 
		as prof_id from likes_photo group by photo_id) as total_photo_likes group by prof_id) as t1,
        
	(select count(po_l) as tl_post, prof_id from (select count(*) as po_l, post_id, 
			(select profile_id from photos where id = post_id) 
		as prof_id from likes_posts group by post_id) as total_post_likes group by prof_id ) as t2
        
) where t1.prof_id = t2.prof_id) as mylikes where p1 = profiles.id order by age, tl DESC limit 10;