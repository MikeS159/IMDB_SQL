SELECT COUNT(DISTINCT ts) AS some_alias FROM spotify_data_full sdf;
select count (*) from spotify_data_full sdf ;

select round((sum(ms_played)/60000),0) as mins, master_metadata_album_artist_name from spotify_data_full sdf group by master_metadata_album_artist_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, "master_metadata_track _name" from spotify_data_full sdf group by "master_metadata_track _name" order by mins desc;

select round((sum(ms_played)/60000),0) as mins, master_metadata_album_album_name from spotify_data_full sdf group by master_metadata_album_album_name order by mins desc;

select round((sum(ms_played)/60000),0) as mins, platform from spotify_data_full sdf group by platform order by mins desc;

select round((sum(ms_played)/60000),0) as mins, ip_addr_decrypted from spotify_data_full sdf group by ip_addr_decrypted order by mins desc;

select round((sum(ms_played)/3600000),0) from spotify_data_full sdf ;
