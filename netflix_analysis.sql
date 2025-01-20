select top(20) * from titles;
-- 1) What were the top 10 movies according to IMDB score?
/*select title,imdb_score from titles
where type='movie'
order by imdb_score desc*/

--using cte function
with cte as (
select title,imdb_score,type,
row_number() over(partition by type order by imdb_score desc ) as top_10
from titles
where type='movie'
)
select * from cte
where top_10<=10

--using subquery
select title,type,imdb_score from(select top(10) *  from titles
where type='movie'
and imdb_score >8
order by imdb_score desc) as top_10

-- 2) What were the top 10 shows according to IMDB score? 
with cte as (
select title,imdb_score,type,
row_number() over(partition by type order by imdb_score desc ) as top_10
from titles
where type='show'
)
select * from cte
where top_10<=10

-- 3) What were the bottom 10 movies according to IMDB score? 

---question 1 code only change order to 'asc'

--4) What were the bottom 10 shows according to IMDB score? 
---question 2 code only change order to 'asc'

-- 5) What were the average IMDB and TMDB scores for shows and movies? 
select type, avg(imdb_score) as avg_IMDB ,avg(tmdb_score) as avg_tmdb from titles
group by type
order by avg(imdb_score) desc

-- 6) Count of movies and shows in each decade
select concat(floor(release_year/10)*10,'s') as decade ,
count(type) as Count_of_movies_shows from titles
group by concat(floor(release_year/10)*10,'s')
order by decade asc

-- 7) What were the average IMDB and TMDB scores for each production country?
select distinct(production_countries), avg(imdb_score) as avg_IMDB ,avg(tmdb_score) as avg_tmdb from titles
group by production_countries
order by avg(imdb_score) desc

-- 8) What were the average IMDB and TMDB scores for each age certification for shows and movies?
select distinct(age_certification), avg(imdb_score) as avg_IMDB ,avg(tmdb_score) as avg_tmdb,type from titles
group by age_certification,type
order by avg(imdb_score) desc

 -- 9) What were the 5 most common age certifications for movies?
 with cte as (select distinct(age_certification),type,
 dense_rank() over(partition by age_certification order by age_certification desc ) as top_5
 from titles
 where type ='movie'

 )
 select  * from cte
 where top_5<=5
 order by age_certification desc

 ---correct method
SELECT age_certification, 
COUNT(*) AS certification_count
FROM titles
WHERE type = 'Movie' 
AND age_certification != 'N/A'
GROUP BY age_certification
ORDER BY certification_count DESC

-- 10) Who were the top 20 actors that appeared the most in movies/shows? 
select * from credits

select distinct(a.name),count(*) as apperance from credits a
join titles b
on a.id=b.id
where a.role ='actor'
group by a.name
order by apperance desc
offset 0 rows
fetch next  20 rows only;

-- 11) Who were the top 20 directors that directed the most movies/shows? 
select distinct(a.name),count(*) as apperance from credits a
join titles b
on a.id=b.id
where a.role ='DIRECTOR'
group by a.name
order by apperance desc
offset 0 rows
fetch next  20 rows only;

-- 12) Calculating the average runtime of movies and TV shows separately
select type,AVG(runtime) as avg_runtime from titles
group by type
order by avg_runtime desc

-- 13) Finding the titles and  directors of movies released on or after 2010

select distinct(a.title),b.name as director,a.release_year as years from titles a
join credits b
on a.id=b.id
where b.role='DIRECTOR' and a.type='movie' and a.release_year>2010
order by years asc

-- 14) Which shows on Netflix have the most seasons?

select title,sum(seasons) as most from titles
where type='show'
group by title
order by most desc
offset 0 rows
fetch next 10 rows only;

--15) Which genres had the most movies? 

select genres,count(1) as title_count from titles
where type='movie'
group by genres
order by title_count desc
offset 0 rows
fetch next 10 rows only;

-- 16) Titles and Directors of movies with high IMDB scores (>7.5) and high TMDB popularity scores (>80) 

select distinct(a.title) as title,b.name as director from titles a
join credits b
on a.id=b.id
where a.type='movie' and a.imdb_score>7.5 and a.tmdb_popularity>80 and b.role='director'

--17) What were the total number of titles for each year? 
select release_year as each_year,count(*) as num_titles from titles
group by release_year
order by num_titles desc

-- 18) Actors who have starred in the most highly rated movies or shows
select b.name as actors,count(*)  as highly_rated_titles from titles a
join credits b
on a.id=b.id
where b.role='actor' and a.imdb_score>8.0 and a.tmdb_score>8.0 and a.type='movie' or a.type='show'
group by name
order by highly_rated_titles desc


select * from credits
select * from titles

-- 19) Which actors/actresses played the same character in multiple movies or TV shows? 
select b.name,count(*) as same_character ,b.character from titles a
join credits b
on a.id=b.id
where a.type='movie' or type='show' and b.role='actor' or b.role='actress' and b.character != 'NULL'
group by name,character
order by same_character desc

-- 20) What were the top 3 most common genres?

select  genres,count(*) as most_genres
from titles
group by genres
order by most_genres desc
offset 0 rows
fetch next 3 rows only

-- 21) Average IMDB score for leading actors/actresses in movies or shows 
select distinct(b.name) as actors_actresses  ,round(avg(imdb_score),2) as avg_imdb
from titles a
join credits b
on a.id=b.id
where b.role='actor' or b.role='actress' and b.character='leading role'
group by name
order by avg_imdb desc
