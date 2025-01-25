-- Marketing Strategies

-- Rewarding Most Loyal Users: Finding the 5 oldest users of Instagram from the database

select * from users
order by created_at ASC
limit 5;

-- Remind Inactive Users to Start Posting: Finding the users who have never posted a single photo on Instagram

select u.id, u.username, u.created_at
from users u
left join photos p
on u.id = p.user_id
where p.id IS NULL;

-- Declaring Contest Winner: Identifing the winner of the contest and provide their details to the team (the user with the most likes on a single photo).

select u.id, u.username, p.id as photo_id, COUNT(l.user_id) as likes_count
from users u
join photos p on u.id = p.user_id
left join likes l on p.id = l.photo_id
group by u.id, u.username, p.id
order by likes_count desc
limit 1;

-- Hashtag Researching: Identifing and suggest the top 5 most commonly used hashtags on the platform.

select t.tag_name, count(t.tag_name) as hashtag_count
from tags t
inner join photo_tags pt
on t.id = pt.tag_id
group by t.tag_name
order by hashtag_count DESC
limit 5;

-- Launch AD Campaign: Determining the day of the week when most users register on Instagram to schedule an ad campaign.

select dayname(created_at) as day_of_week, count(*) as user_count
from users
group by day_of_week
order by user_count DESC
limit 2;

-- Investor Metrics

-- Average number of posts per user

select count(id)/count(distinct user_id) as avg_post_per_user
from photos;

-- Total number of photos on Instagram / Total number of users

select count(id) as total_photos, count(distinct user_id) as total_no_user
from photos;

-- Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts

select id, username 
from users
where id IN (select user_id from likes
	group by user_id
    having count(user_id) = (select count(id) from photos));
    