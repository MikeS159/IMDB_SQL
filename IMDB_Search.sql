select AVG("Your Rating") as myAVG, directors, COUNT(directors) as cnt, avg("IMDb Rating") as IMDB_AVG, avg("IMDb Rating")-avg("Your Rating") as Diff /*SELECT const, "Your Rating", "Date Rated", title, url, "Title Type", "IMDb Rating", "Runtime (mins)", "Year", genres, "Num Votes", "Release Date", directors*/
FROM "Stats"."IMDB"
group BY directors
/*having COUNT(directors) > 1*/
order by myavg desc;


select AVG("Your Rating") as myAVG, "Year", avg("IMDb Rating") as IMDB_AVG, COUNT("Year") as count, avg("IMDb Rating")-avg("Your Rating") as Diff /*SELECT const, "Your Rating", "Date Rated", title, url, "Title Type", "IMDb Rating", "Runtime (mins)", "Year", genres, "Num Votes", "Release Date", directors*/
FROM "Stats"."IMDB"
group BY "Year"
having COUNT("Year") > 1
order by myAVG desc;

select "Your Rating", COUNT(*) FROM "IMDB" group by "Your Rating" order by "Your Rating";

select AVG(("Your Rating" + "IMDb Rating")/2) as average, "Your Rating" as myRating, "IMDb Rating" as IMDB_avg, title from "IMDB" group by title, myRating, IMDB_avg order by average desc;


select title, genres, length(genres) - length(REPLACE(genres, ',', '')) from "IMDB";

select * from "IMDB" where genres like '%War%';

select genera, ROUND(AVG(rating), 2) as mike_avg, ROUND(cast(AVG("IMDb Rating") as numeric), 2) as IMDB_avg, ROUND(cast(AVG(rating) - AVG("IMDb Rating") as numeric), 2) as difference, ROUND(cast(AVG(rating) - AVG("IMDb Rating") as numeric) + 1.020909091, 2) as adjusted_diff, count(genera) as total_count
FROM
(
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 1)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 1) != ''
	UNION ALL
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 2)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 2) != ''
	UNION all
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 3)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 3) != ''
	UNION all
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 4)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 4) != ''
	UNION all
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 5)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 5) != ''
	UNION all
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 6)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 6) != ''
	UNION all
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 7)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 7) != ''
	UNION all
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 8)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 8) != ''
	UNION all
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 9)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 9) != ''
	UNION all
	SELECT title, "Your Rating" as rating, "IMDb Rating", TRIM(split_part(genres, ',', 10)) AS genera
	FROM "IMDB"
	where split_part(genres, ',', 10) != ''
) as tmp
group by genera
order by mike_avg desc;

/*delete from name_basics;
delete from title_akas;
delete from title_basics;
delete from title_crew;
delete from title_episode;
delete from title_principals;
delete from title_ratings;*/

select * from title_akas order by titleid desc limit 100;

select * from title_principals tp where tp.tconst like 'tt0068646';

SELECT nb.nconst, nb.primaryname, COUNT(tp.nconst) AS num_roles, AVG("IMDB"."Your Rating") AS avg_rating
FROM name_basics nb
JOIN title_principals tp ON nb.nconst = tp.nconst
JOIN "IMDB" ON tp.tconst = "IMDB".const
WHERE tp.category = 'actor' or tp.category = 'actress'
GROUP BY nb.nconst, nb.primaryname
having COUNT(tp.nconst) > 1
order by avg_rating desc;

SELECT nb.nconst, nb.primaryname, COUNT(tp.nconst) AS num_roles, AVG("IMDB"."Your Rating") AS avg_rating
FROM name_basics nb
JOIN title_principals tp ON nb.nconst = tp.nconst
JOIN "IMDB" ON tp.tconst = "IMDB".const
WHERE tp.category = 'director'
GROUP BY nb.nconst, nb.primaryname
order by num_roles desc;

SELECT nb.nconst, nb.primaryname, COUNT(tp.nconst) AS num_roles, AVG("IMDB"."Your Rating") AS avg_rating
FROM name_basics nb
JOIN title_principals tp ON nb.nconst = tp.nconst
JOIN "IMDB" ON tp.tconst = "IMDB".const
WHERE tp.category = 'composer'
GROUP BY nb.nconst, nb.primaryname
order by num_roles desc;

SELECT nb.nconst, nb.primaryname, COUNT(tp.nconst) AS num_roles, AVG("IMDB"."Your Rating") AS avg_rating
FROM name_basics nb
JOIN title_principals tp ON nb.nconst = tp.nconst
JOIN "IMDB" ON tp.tconst = "IMDB".const
WHERE tp.category = 'writer'
GROUP BY nb.nconst, nb.primaryname
order by num_roles desc;

SELECT nb.nconst, nb.primaryname, COUNT(tp.nconst) AS num_roles, AVG("IMDB"."Your Rating") AS avg_rating
FROM name_basics nb
JOIN title_principals tp ON nb.nconst = tp.nconst
JOIN "IMDB" ON tp.tconst = "IMDB".const
WHERE tp.category = 'producer'
GROUP BY nb.nconst, nb.primaryname
order by num_roles desc;

SELECT nb.nconst, nb.primaryname, COUNT(tp.nconst) AS num_roles, AVG("IMDB"."Your Rating") AS avg_rating
FROM name_basics nb
JOIN title_principals tp ON nb.nconst = tp.nconst
JOIN "IMDB" ON tp.tconst = "IMDB".const
WHERE tp.category = 'editor'
GROUP BY nb.nconst, nb.primaryname
order by num_roles desc;

SELECT nb.nconst, nb.primaryname, COUNT(tp.nconst) AS num_roles, AVG("IMDB"."Your Rating") AS avg_rating
FROM name_basics nb
JOIN title_principals tp ON nb.nconst = tp.nconst
JOIN "IMDB" ON tp.tconst = "IMDB".const
WHERE tp.category = 'cinematographer'
GROUP BY nb.nconst, nb.primaryname
order by num_roles desc;

select distinct tp.category from title_principals tp;


