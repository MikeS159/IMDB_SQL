SELECT COUNT(DISTINCT ts) AS some_alias FROM spotify_data_full sdf;
select count (*) from spotify_data_full sdf ;

select round((sum(ms_played)/60000),0) as mins, master_metadata_album_artist_name from spotify_data_full sdf group by master_metadata_album_artist_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, master_metadata_track_name from spotify_data_full sdf group by master_metadata_track_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, master_metadata_album_album_name from spotify_data_full sdf group by master_metadata_album_album_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, platform from spotify_data_full sdf group by platform order by mins desc;

select round((sum(ms_played)/60000),0) as mins, ip_addr from spotify_data_full sdf group by ip_addr order by mins desc;

select round((sum(ms_played)/3600000),0) as hours from spotify_data_full sdf ;


select round((sum(ms_played)/60000),0) as mins, master_metadata_album_artist_name from spotify_data_full sdf WHERE EXTRACT(YEAR FROM ts::timestamp) = 2014 group by master_metadata_album_artist_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, master_metadata_track_name from spotify_data_full sdf WHERE EXTRACT(YEAR FROM ts::timestamp) = 2014 group by master_metadata_track_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, master_metadata_album_album_name from spotify_data_full sdf WHERE EXTRACT(YEAR FROM ts::timestamp) = 2014 group by master_metadata_album_album_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, episode_show_name from spotify_data_full sdf WHERE EXTRACT(YEAR FROM ts::timestamp) = 2014 group by episode_show_name order by mins desc;


select EXTRACT(YEAR FROM ts::timestamp) AS year, ROUND((SUM(ms_played) / 60000), 0) AS total_mins from spotify_data_full GROUP by year ORDER by year;

select EXTRACT(YEAR FROM ts::timestamp) AS year, COUNT(DISTINCT ts) AS SongCount from spotify_data_full GROUP by year ORDER by year;

select * from spotify_data_full sdf where master_metadata_track_name = null ;


select round((sum(ms_played)/60000),0) as mins, episode_name from spotify_data_full sdf group by episode_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, episode_show_name from spotify_data_full sdf group by episode_show_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, audiobook_title from spotify_data_full sdf group by audiobook_title order by mins desc;

/*Generate SQL for year ranges*/
WITH years AS (
    SELECT generate_series(2013, 2025) AS y
)
SELECT
    'SELECT master_metadata_track_name,' || E'\n' ||
    string_agg(
        format(
            '    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = %1$s) / 60000, 0), 0) AS mins_%1$s',
            y
        ),
        E',\n'
    ) ||
    E',\n' ||
    -- total column computed over the whole range to avoid NULLs and rounding-sum artifacts
    format(
        '    ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) BETWEEN %1$s AND %2$s) / 60000, 0) AS total_mins',
        (SELECT min(y) FROM years),
        (SELECT max(y) FROM years)
    ) || E'\n' ||
    'FROM spotify_data_full' || E'\n' ||
    'GROUP BY master_metadata_track_name' || E'\n' ||
    'ORDER BY total_mins DESC;' AS pivot_sql
FROM years;


/*Podcasts by year*/
SELECT episode_show_name,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2013) / 60000, 0), 0) AS mins_2013,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2014) / 60000, 0), 0) AS mins_2014,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2015) / 60000, 0), 0) AS mins_2015,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2016) / 60000, 0), 0) AS mins_2016,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2017) / 60000, 0), 0) AS mins_2017,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2018) / 60000, 0), 0) AS mins_2018,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2019) / 60000, 0), 0) AS mins_2019,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2020) / 60000, 0), 0) AS mins_2020,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2021) / 60000, 0), 0) AS mins_2021,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2022) / 60000, 0), 0) AS mins_2022,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2023) / 60000, 0), 0) AS mins_2023,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2024) / 60000, 0), 0) AS mins_2024,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2025) / 60000, 0), 0) AS mins_2025,
    ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) BETWEEN 2013 AND 2025) / 60000, 0) AS total_mins
FROM spotify_data_full
GROUP BY episode_show_name
ORDER BY total_mins DESC;

/*Artists by year*/
SELECT master_metadata_album_artist_name,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2013) / 60000, 0), 0) AS mins_2013,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2014) / 60000, 0), 0) AS mins_2014,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2015) / 60000, 0), 0) AS mins_2015,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2016) / 60000, 0), 0) AS mins_2016,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2017) / 60000, 0), 0) AS mins_2017,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2018) / 60000, 0), 0) AS mins_2018,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2019) / 60000, 0), 0) AS mins_2019,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2020) / 60000, 0), 0) AS mins_2020,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2021) / 60000, 0), 0) AS mins_2021,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2022) / 60000, 0), 0) AS mins_2022,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2023) / 60000, 0), 0) AS mins_2023,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2024) / 60000, 0), 0) AS mins_2024,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2025) / 60000, 0), 0) AS mins_2025,
    ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) BETWEEN 2013 AND 2025) / 60000, 0) AS total_mins
FROM spotify_data_full
GROUP BY master_metadata_album_artist_name
ORDER BY total_mins DESC;


/*Album by year*/
SELECT master_metadata_album_album_name,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2013) / 60000, 0), 0) AS mins_2013,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2014) / 60000, 0), 0) AS mins_2014,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2015) / 60000, 0), 0) AS mins_2015,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2016) / 60000, 0), 0) AS mins_2016,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2017) / 60000, 0), 0) AS mins_2017,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2018) / 60000, 0), 0) AS mins_2018,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2019) / 60000, 0), 0) AS mins_2019,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2020) / 60000, 0), 0) AS mins_2020,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2021) / 60000, 0), 0) AS mins_2021,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2022) / 60000, 0), 0) AS mins_2022,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2023) / 60000, 0), 0) AS mins_2023,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2024) / 60000, 0), 0) AS mins_2024,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2025) / 60000, 0), 0) AS mins_2025,
    ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) BETWEEN 2013 AND 2025) / 60000, 0) AS total_mins
FROM spotify_data_full
GROUP BY master_metadata_album_album_name
ORDER BY total_mins DESC;


/*Track by year*/
SELECT master_metadata_track_name,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2013) / 60000, 0), 0) AS mins_2013,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2014) / 60000, 0), 0) AS mins_2014,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2015) / 60000, 0), 0) AS mins_2015,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2016) / 60000, 0), 0) AS mins_2016,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2017) / 60000, 0), 0) AS mins_2017,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2018) / 60000, 0), 0) AS mins_2018,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2019) / 60000, 0), 0) AS mins_2019,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2020) / 60000, 0), 0) AS mins_2020,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2021) / 60000, 0), 0) AS mins_2021,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2022) / 60000, 0), 0) AS mins_2022,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2023) / 60000, 0), 0) AS mins_2023,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2024) / 60000, 0), 0) AS mins_2024,
    COALESCE(ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) = 2025) / 60000, 0), 0) AS mins_2025,
    ROUND(SUM(ms_played) FILTER (WHERE EXTRACT(YEAR FROM ts::timestamp) BETWEEN 2013 AND 2025) / 60000, 0) AS total_mins
FROM spotify_data_full
GROUP BY master_metadata_track_name
ORDER BY total_mins DESC;





/*Per year rankings*/
WITH params AS (
    SELECT 2013 AS start_year, 2025 AS end_year
),
years AS (
    SELECT generate_series(start_year, end_year) AS y
    FROM params
),
agg AS (
    SELECT
        string_agg(
            'COALESCE(ROUND(MAX(CASE WHEN year = ' || y || ' THEN mins END),0),0) AS mins_' || y,
            E',\n'
        ) AS mins_cols,
        string_agg(
            'COALESCE(MAX(CASE WHEN year = ' || y || ' THEN position END), global_max.global_max_rank) AS pos_' || y,
            E',\n'
        ) AS pos_cols,
        string_agg(
            'COALESCE(MAX(CASE WHEN year = ' || y || ' THEN position END), global_max.global_max_rank)',
            ' + '
        ) AS avg_sum_expr
    FROM years
)
SELECT
    'WITH ranked AS (
        SELECT
            master_metadata_track_name,
            EXTRACT(YEAR FROM ts::timestamp)::int AS year,
            SUM(ms_played)/60000 AS mins,
            RANK() OVER (
                PARTITION BY EXTRACT(YEAR FROM ts::timestamp)
                ORDER BY SUM(ms_played)/60000 DESC
            ) AS position
        FROM spotify_data_full
        WHERE EXTRACT(YEAR FROM ts::timestamp)::int BETWEEN ' || (SELECT start_year FROM params) || ' AND ' || (SELECT end_year FROM params) || '
        GROUP BY master_metadata_track_name, EXTRACT(YEAR FROM ts::timestamp)
    ),
    global_max AS (
        SELECT MAX(position) AS global_max_rank FROM ranked
    )
    SELECT
        master_metadata_track_name,
        ' || (SELECT mins_cols FROM agg) || E',\n' ||
        (SELECT pos_cols FROM agg) || E',\n' ||
        'ROUND((' || (SELECT avg_sum_expr FROM agg) || ')::numeric / ' || (SELECT COUNT(*) FROM years) || ',2) AS avg_position
    FROM ranked
    CROSS JOIN global_max
    GROUP BY master_metadata_track_name, global_max.global_max_rank
    ORDER BY avg_position ASC;' AS pivot_sql;


/*Podcasts position ranking*/
WITH ranked AS (
        SELECT
            episode_show_name,
            EXTRACT(YEAR FROM ts::timestamp)::int AS year,
            SUM(ms_played)/60000 AS mins,
            RANK() OVER (
                PARTITION BY EXTRACT(YEAR FROM ts::timestamp)
                ORDER BY SUM(ms_played)/60000 DESC
            ) AS position
        FROM spotify_data_full
        WHERE EXTRACT(YEAR FROM ts::timestamp)::int BETWEEN 2020 AND 2025
        GROUP BY episode_show_name, EXTRACT(YEAR FROM ts::timestamp)
    ),
    global_max AS (
        SELECT MAX(position) AS global_max_rank FROM ranked
    )
    SELECT
        episode_show_name,
COALESCE(MAX(CASE WHEN year = 2020 THEN position END), global_max.global_max_rank) AS pos_2020,
COALESCE(MAX(CASE WHEN year = 2021 THEN position END), global_max.global_max_rank) AS pos_2021,
COALESCE(MAX(CASE WHEN year = 2022 THEN position END), global_max.global_max_rank) AS pos_2022,
COALESCE(MAX(CASE WHEN year = 2023 THEN position END), global_max.global_max_rank) AS pos_2023,
COALESCE(MAX(CASE WHEN year = 2024 THEN position END), global_max.global_max_rank) AS pos_2024,
COALESCE(MAX(CASE WHEN year = 2025 THEN position END), global_max.global_max_rank) AS pos_2025,
ROUND((COALESCE(MAX(CASE WHEN year = 2020 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2021 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2022 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2023 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2024 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2025 THEN position END), global_max.global_max_rank))::numeric / 6,2) AS avg_position
    FROM ranked
    CROSS JOIN global_max
    GROUP BY episode_show_name, global_max.global_max_rank
    ORDER BY avg_position ASC;

/*Artist position rank*/
WITH ranked AS (
        SELECT
            master_metadata_album_artist_name,
            EXTRACT(YEAR FROM ts::timestamp)::int AS year,
            SUM(ms_played)/60000 AS mins,
            RANK() OVER (
                PARTITION BY EXTRACT(YEAR FROM ts::timestamp)
                ORDER BY SUM(ms_played)/60000 DESC
            ) AS position
        FROM spotify_data_full
        WHERE EXTRACT(YEAR FROM ts::timestamp)::int BETWEEN 2013 AND 2025
        GROUP BY master_metadata_album_artist_name, EXTRACT(YEAR FROM ts::timestamp)
    ),
    global_max AS (
        SELECT MAX(position) AS global_max_rank FROM ranked
    )
    SELECT
        master_metadata_album_artist_name,
COALESCE(MAX(CASE WHEN year = 2013 THEN position END), global_max.global_max_rank) AS pos_2013,
COALESCE(MAX(CASE WHEN year = 2014 THEN position END), global_max.global_max_rank) AS pos_2014,
COALESCE(MAX(CASE WHEN year = 2015 THEN position END), global_max.global_max_rank) AS pos_2015,
COALESCE(MAX(CASE WHEN year = 2016 THEN position END), global_max.global_max_rank) AS pos_2016,
COALESCE(MAX(CASE WHEN year = 2017 THEN position END), global_max.global_max_rank) AS pos_2017,
COALESCE(MAX(CASE WHEN year = 2018 THEN position END), global_max.global_max_rank) AS pos_2018,
COALESCE(MAX(CASE WHEN year = 2019 THEN position END), global_max.global_max_rank) AS pos_2019,
COALESCE(MAX(CASE WHEN year = 2020 THEN position END), global_max.global_max_rank) AS pos_2020,
COALESCE(MAX(CASE WHEN year = 2021 THEN position END), global_max.global_max_rank) AS pos_2021,
COALESCE(MAX(CASE WHEN year = 2022 THEN position END), global_max.global_max_rank) AS pos_2022,
COALESCE(MAX(CASE WHEN year = 2023 THEN position END), global_max.global_max_rank) AS pos_2023,
COALESCE(MAX(CASE WHEN year = 2024 THEN position END), global_max.global_max_rank) AS pos_2024,
COALESCE(MAX(CASE WHEN year = 2025 THEN position END), global_max.global_max_rank) AS pos_2025,
ROUND((COALESCE(MAX(CASE WHEN year = 2013 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2014 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2015 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2016 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2017 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2018 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2019 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2020 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2021 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2022 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2023 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2024 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2025 THEN position END), global_max.global_max_rank))::numeric / 13,2) AS avg_position
    FROM ranked
    CROSS JOIN global_max
    GROUP BY master_metadata_album_artist_name, global_max.global_max_rank
    ORDER BY avg_position ASC;

/*Album positon rank*/
WITH ranked AS (
        SELECT
            master_metadata_album_album_name, master_metadata_album_artist_name,
            EXTRACT(YEAR FROM ts::timestamp)::int AS year,
            SUM(ms_played)/60000 AS mins,
            RANK() OVER (
                PARTITION BY EXTRACT(YEAR FROM ts::timestamp)
                ORDER BY SUM(ms_played)/60000 DESC
            ) AS position
        FROM spotify_data_full
        WHERE EXTRACT(YEAR FROM ts::timestamp)::int BETWEEN 2013 AND 2025
        GROUP BY master_metadata_album_album_name, master_metadata_album_artist_name, EXTRACT(YEAR FROM ts::timestamp)
    ),
    global_max AS (
        SELECT MAX(position) AS global_max_rank FROM ranked
    )
    SELECT
        master_metadata_album_album_name, master_metadata_album_artist_name,
COALESCE(MAX(CASE WHEN year = 2013 THEN position END), global_max.global_max_rank) AS pos_2013,
COALESCE(MAX(CASE WHEN year = 2014 THEN position END), global_max.global_max_rank) AS pos_2014,
COALESCE(MAX(CASE WHEN year = 2015 THEN position END), global_max.global_max_rank) AS pos_2015,
COALESCE(MAX(CASE WHEN year = 2016 THEN position END), global_max.global_max_rank) AS pos_2016,
COALESCE(MAX(CASE WHEN year = 2017 THEN position END), global_max.global_max_rank) AS pos_2017,
COALESCE(MAX(CASE WHEN year = 2018 THEN position END), global_max.global_max_rank) AS pos_2018,
COALESCE(MAX(CASE WHEN year = 2019 THEN position END), global_max.global_max_rank) AS pos_2019,
COALESCE(MAX(CASE WHEN year = 2020 THEN position END), global_max.global_max_rank) AS pos_2020,
COALESCE(MAX(CASE WHEN year = 2021 THEN position END), global_max.global_max_rank) AS pos_2021,
COALESCE(MAX(CASE WHEN year = 2022 THEN position END), global_max.global_max_rank) AS pos_2022,
COALESCE(MAX(CASE WHEN year = 2023 THEN position END), global_max.global_max_rank) AS pos_2023,
COALESCE(MAX(CASE WHEN year = 2024 THEN position END), global_max.global_max_rank) AS pos_2024,
COALESCE(MAX(CASE WHEN year = 2025 THEN position END), global_max.global_max_rank) AS pos_2025,
ROUND((COALESCE(MAX(CASE WHEN year = 2013 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2014 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2015 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2016 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2017 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2018 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2019 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2020 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2021 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2022 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2023 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2024 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2025 THEN position END), global_max.global_max_rank))::numeric / 13,2) AS avg_position
    FROM ranked
    CROSS JOIN global_max
    GROUP BY master_metadata_album_album_name, master_metadata_album_artist_name, global_max.global_max_rank
    ORDER BY avg_position ASC;

/*Track positon rank*/
WITH ranked AS (
        SELECT
            master_metadata_track_name, master_metadata_album_artist_name,
            EXTRACT(YEAR FROM ts::timestamp)::int AS year,
            SUM(ms_played)/60000 AS mins,
            RANK() OVER (
                PARTITION BY EXTRACT(YEAR FROM ts::timestamp)
                ORDER BY SUM(ms_played)/60000 DESC
            ) AS position
        FROM spotify_data_full
        WHERE EXTRACT(YEAR FROM ts::timestamp)::int BETWEEN 2013 AND 2025
        GROUP BY master_metadata_track_name, master_metadata_album_artist_name, EXTRACT(YEAR FROM ts::timestamp)
    ),
    global_max AS (
        SELECT MAX(position) AS global_max_rank FROM ranked
    )
    SELECT
        master_metadata_track_name, master_metadata_album_artist_name,
COALESCE(MAX(CASE WHEN year = 2013 THEN position END), global_max.global_max_rank) AS pos_2013,
COALESCE(MAX(CASE WHEN year = 2014 THEN position END), global_max.global_max_rank) AS pos_2014,
COALESCE(MAX(CASE WHEN year = 2015 THEN position END), global_max.global_max_rank) AS pos_2015,
COALESCE(MAX(CASE WHEN year = 2016 THEN position END), global_max.global_max_rank) AS pos_2016,
COALESCE(MAX(CASE WHEN year = 2017 THEN position END), global_max.global_max_rank) AS pos_2017,
COALESCE(MAX(CASE WHEN year = 2018 THEN position END), global_max.global_max_rank) AS pos_2018,
COALESCE(MAX(CASE WHEN year = 2019 THEN position END), global_max.global_max_rank) AS pos_2019,
COALESCE(MAX(CASE WHEN year = 2020 THEN position END), global_max.global_max_rank) AS pos_2020,
COALESCE(MAX(CASE WHEN year = 2021 THEN position END), global_max.global_max_rank) AS pos_2021,
COALESCE(MAX(CASE WHEN year = 2022 THEN position END), global_max.global_max_rank) AS pos_2022,
COALESCE(MAX(CASE WHEN year = 2023 THEN position END), global_max.global_max_rank) AS pos_2023,
COALESCE(MAX(CASE WHEN year = 2024 THEN position END), global_max.global_max_rank) AS pos_2024,
COALESCE(MAX(CASE WHEN year = 2025 THEN position END), global_max.global_max_rank) AS pos_2025,
ROUND((COALESCE(MAX(CASE WHEN year = 2013 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2014 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2015 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2016 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2017 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2018 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2019 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2020 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2021 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2022 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2023 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2024 THEN position END), global_max.global_max_rank) + COALESCE(MAX(CASE WHEN year = 2025 THEN position END), global_max.global_max_rank))::numeric / 13,2) AS avg_position
    FROM ranked
    CROSS JOIN global_max
    GROUP BY master_metadata_track_name, master_metadata_album_artist_name, global_max.global_max_rank
    ORDER BY avg_position ASC;
