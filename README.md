# SQL_Projects

DataSet Used:

https://www.kaggle.com/datasets/victorsoeiro/netflix-tv-shows-and-movies?select=titles.csv

Business Problem: Netflix wants to gather useful insights on their shows and movies for their subscribers through their datasets. The issue is, they are working with too much data (approximately 82k rows of data combined) and are unsure how to effectively analyze and extract meaningful insights from it. They need a robust and scalable data analytics solution to handle the vast amount of data and uncover valuable patterns and trends.

How I Plan On Solving the Problem: In helping Netflix gather valuable insights from their extensive movies and shows dataset, I will be utilizing SQL and a data visualization tool like Tableau to extract relevant information, and conduct insightful analyses. By leveraging SQL's functions, I can uncover key metrics such as viewer ratings, popularity trends, genre preferences, and viewership patterns. Once the data has been extracted and prepared, I will leverage Tableau to present the findings. This will allow for interactive exploration of the data, enabling stakeholders at Netflix to gain actionable insights through visually appealing charts, graphs, and interactive visualizations. I plan on creating a dynamic dashboard in Tableau that enables users to delve into specific movie genres, viewer demographics, or geographical regions.


1. Which movies and shows on Netflix ranked in the top 10 and bottom 10 based on their IMDB scores?
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

