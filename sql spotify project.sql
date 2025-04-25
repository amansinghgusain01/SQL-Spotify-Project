-- Q1. Retrieve all columns from the spotify table
SELECT * FROM spotify;

-- Q2. Select only the artist and track columns from the table
SELECT artist, track FROM spotify;

-- Q3. Find all tracks where the energy is greater than 0.8
SELECT track FROM spotify WHERE energy > 0.8;

-- Q4. Count the total number of tracks in the table
SELECT COUNT(track) FROM spotify;

-- Q5. Get distinct album_type values from the table
SELECT DISTINCT(album_type) FROM spotify;

-- Q6. Find the average tempo of all tracks
SELECT AVG(tempo) AS avg_tempo FROM spotify;

-- Q7. List all tracks where duration_min is more than 5 minutes
SELECT track FROM spotify WHERE duration_min > 5;

-- Q8. Find the track with the highest number of likes
SELECT track, likes FROM spotify ORDER BY likes DESC LIMIT 1;

-- Q9. Count how many tracks are marked as official_video = TRUE
SELECT COUNT(track) FROM spotify WHERE official_video = TRUE;

-- Q10. Find the average views grouped by channel
SELECT channel, AVG(views) FROM spotify GROUP BY channel;

-- Q11. Get the top 10 most viewed tracks
SELECT track, views FROM spotify ORDER BY views DESC LIMIT 10;

-- Q12. List tracks where speechiness is greater than 0.5 and acousticness is less than 0.3
SELECT track, speechiness, acousticness FROM spotify WHERE speechiness > 0.5 AND acousticness < 0.3;

-- Q13. Find the number of tracks that are licensed
SELECT COUNT(*) FROM spotify WHERE licensed = TRUE;

-- Q14. Retrieve all tracks where comments is NULL or 0
SELECT track FROM spotify WHERE comments IS NULL OR comments = 0;

-- Q15. Calculate the average loudness grouped by album_type
SELECT album_type, AVG(loudness) FROM spotify GROUP BY album_type;

-- Q16. Show the number of tracks by each artist having less than 10
SELECT artist, COUNT(track) AS track_count FROM spotify GROUP BY artist HAVING COUNT(track) < 10;

-- Q17. Find the average energy for each album
SELECT album, AVG(energy) FROM spotify GROUP BY album;

-- Q18. Get the maximum duration_min for each artist
SELECT artist, MAX(duration_min) FROM spotify GROUP BY artist;

-- Q19. Retrieve tracks where track name starts with 'S'
SELECT * FROM spotify WHERE track LIKE 'S%';

-- Q20. Find the top 5 most liked tracks by each channel
WITH ranked_tracks AS (
  SELECT channel, track, likes, DENSE_RANK() OVER (PARTITION BY channel ORDER BY likes DESC) AS rnk
  FROM spotify
)
SELECT channel, track, likes FROM ranked_tracks WHERE rnk <= 5;

-- Q21. Get all tracks with a valence between 0.6 and 0.9
SELECT track, valence FROM spotify WHERE valence BETWEEN 0.6 AND 0.9;

-- Q22. Count how many tracks fall into each most_played_on category
SELECT most_played_on, COUNT(track) FROM spotify GROUP BY most_played_on;

-- Q23. Find the total stream count for each artist
SELECT artist, SUM(stream) AS total_streams FROM spotify GROUP BY artist;

-- Q24. Get the track and album where the instrumentalness is highest
SELECT track, album, instrumentalness FROM spotify ORDER BY instrumentalness DESC LIMIT 1;

-- Q25. List the tracks sorted by energy_liveness in descending order
SELECT track, energy_liveness FROM spotify ORDER BY energy_liveness DESC;

-- Q26. Find the track with the longest duration for each album_type
WITH ranked_tracks AS (
  SELECT album_type, track, duration_min,
         ROW_NUMBER() OVER (PARTITION BY album_type ORDER BY duration_min DESC) AS rn
  FROM spotify
)
SELECT album_type, track, duration_min FROM ranked_tracks WHERE rn = 1;

-- Q27. Show the average valence for official vs non-official videos
SELECT official_video, AVG(valence) AS avg_valence FROM spotify GROUP BY official_video;

-- Q28. Display track and artist where duration > avg duration
SELECT track, artist, duration_min FROM spotify
WHERE duration_min > (SELECT AVG(duration_min) FROM spotify);

-- Q29. List albums where avg views > 1M
SELECT album, AVG(views) FROM spotify GROUP BY album HAVING AVG(views) > 1000000;

-- Q30. Show artist and track in top 10 percentile of danceability
SELECT artist, track, danceability FROM spotify
WHERE danceability >= (
  SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY danceability)
  FROM spotify
);

-- Q31. Group tracks by channel and show total number of comments for each
SELECT channel, SUM(comments) AS total_comments FROM spotify GROUP BY channel;

-- Q32. List all artists who have more than 5 tracks
SELECT artist, COUNT(track) FROM spotify GROUP BY artist HAVING COUNT(track) > 5;

-- Q33. Rank all tracks based on likes
SELECT track, artist, likes, RANK() OVER (ORDER BY likes DESC) AS rank_by_likes FROM spotify;

-- Q34. Assign row number to each track ordered by stream descending
SELECT track, views, ROW_NUMBER() OVER (ORDER BY views DESC) AS rn FROM spotify;

-- Q35. Top 3 most liked tracks per most_played_on platform
WITH cte AS (
  SELECT most_played_on, views,
         DENSE_RANK() OVER (PARTITION BY most_played_on ORDER BY views DESC) AS rn
  FROM spotify
)
SELECT most_played_on, views, rn FROM cte WHERE rn <= 3;

-- Q36. Top 5 channels with highest total views
SELECT channel, SUM(views) AS total_views FROM spotify GROUP BY channel ORDER BY total_views DESC LIMIT 5;

-- Q37. Tracks whose views > avg views
SELECT track, views FROM spotify WHERE views > (SELECT AVG(views) FROM spotify);

-- Q38. Artists with more than 1 track with over 1M views
WITH high_view_tracks AS (
  SELECT artist, track FROM spotify WHERE views > 1000000
)
SELECT artist, COUNT(track) FROM high_view_tracks GROUP BY artist HAVING COUNT(track) > 1;

-- Q39. Avg energy, tempo, liveness by album_type
WITH cte AS (
  SELECT album_type, AVG(energy) AS avg_energy, AVG(tempo) AS avg_tempo, AVG(liveness) AS avg_liveness
  FROM spotify
  GROUP BY album_type
)
SELECT * FROM cte;

-- Q40. Track(s) with 2nd highest likes
SELECT track, likes FROM spotify WHERE likes < (SELECT MAX(likes) FROM spotify) ORDER BY likes DESC LIMIT 1;
