-- 1. Identify the team with the highest avarage possession
WITH possession AS (
	SELECT home_team_name AS team_name, ball_possession
	FROM home_teams_stats
	UNION ALL 
	SELECT away_team_name AS team_name, ball_possession
	FROM away_teams_stats)

SELECT team_name, ROUND(AVG(ball_possession)::numeric,2) AS average_possession
FROM possession
GROUP BY team_name
ORDER BY average_possession DESC
LIMIT 5;

-- 2.Identify top 5 teams with highest average pass accuracy
SELECT team_name, ROUND(AVG(passes_accurate),2) AS average_pass_accuracy
FROM (SELECT home_team_name AS team_name, passes_accurate
	FROM home_teams_stats
	UNION ALL 
	SELECT away_team_name AS team_name, passes_accurate
	FROM away_teams_stats) AS pass
GROUP BY team_name
ORDER BY average_pass_accuracy DESC
LIMIT 5;

-- 3.Identify top 5 team with the highest average shot per game
WITH shots AS
	(SELECT home_team_id AS team_id,home_team_name AS team_name, total_shots
	FROM home_teams_stats
	UNION ALL 
	SELECT away_team_id AS team_id, away_team_name AS team_name, total_shots
	FROM away_teams_stats)
SELECT team_name, ROUND(AVG(total_shots),2) AS average_shots_per_game
FROM shots
GROUP BY team_name
ORDER BY average_shots_per_game DESC
LIMIT 5;

-- 4.The goal conversion rate of Man City (MC) and Arsenal (ARS)
WITH shots AS
	(SELECT home_team_id AS team_id,home_team_name AS team_name, total_shots
	FROM home_teams_stats
	UNION ALL 
	SELECT away_team_id AS team_id, away_team_name AS team_name, total_shots
	FROM away_teams_stats),
	
	total_shots AS
	(SELECT team_id, team_name, sum(total_shots) AS total_shots_per_season
	FROM shots
	WHERE team_id IN (50, 42)
	GROUP BY team_name,team_id)

SELECT t_s.team_name, total_shots_per_season, goals_for,  ROUND(goals_for /total_shots_per_season::numeric*100,2) AS goal_conversion_rate_percent
FROM total_shots AS t_s
LEFT JOIN standings AS s
ON t_s.team_id =s.team_id;


-- 5.MC and ARS VS their opponents	
----MC
SELECT (CASE WHEN teams_home_id = 50 THEN teams_away_id
		WHEN teams_away_id = 50 THEN teams_home_id END) AS opponents_id,
	(CASE WHEN teams_home_id = 50 THEN teams_away_name 
		WHEN teams_away_id = 50 THEN teams_home_name END) AS opponents,
	(CASE WHEN 
		 ((CASE WHEN teams_home_id = 50 THEN goals_home
			WHEN teams_away_id = 50  THEN goals_away END) -
		(CASE WHEN teams_home_id = 50 THEN goals_away
			WHEN teams_away_id = 50 THEN goals_home END))>0 THEN 'W' ELSE 'L'END) AS MC_result
FROM matchday_results
WHERE (teams_home_id = 50 or teams_away_id = 50) 
	AND	(teams_home_id IN (33,34,40,42) OR teams_away_id IN (33,34,40,42))
ORDER BY fixture_date;

----ARS
SELECT (CASE WHEN teams_home_id = 42 THEN teams_away_id
		WHEN teams_away_id = 42 THEN teams_home_id END) AS opponents_id,
	(CASE WHEN teams_home_id = 42 THEN teams_away_name 
		WHEN teams_away_id = 42 THEN teams_home_name END) AS opponents,
	(CASE WHEN 
		 ((CASE WHEN teams_home_id = 42 THEN goals_home
			WHEN teams_away_id = 42  THEN goals_away END) -
		(CASE WHEN teams_home_id = 42 THEN goals_away
			WHEN teams_away_id = 42 THEN goals_home END))>0 THEN 'W' ELSE 'L'END) AS ARS_result
FROM matchday_results
WHERE (teams_home_id = 42 or teams_away_id = 42) 
	AND	(teams_home_id IN (33,34,40,50) OR teams_away_id IN (33,34,40,50))
ORDER BY fixture_date;

---6. Compare the points earned by MC and ARS in each month

WITH 
MC_score AS
(SELECT	EXTRACT(YEAR FROM fixture_date) AS year,
 		EXTRACT(month FROM fixture_date) AS month,
		(CASE WHEN teams_home_id = 50 THEN (CASE WHEN teams_home_winner = 'TRUE' THEN 3
												WHEN teams_home_winner = 'FALSE' THEN 0
												ELSE 1 END)
			WHEN teams_away_id = 50 THEN (CASE WHEN teams_away_winner = 'TRUE' THEN 3
												WHEN teams_away_winner = 'FALSE' THEN 0
												ELSE 1 END) END ) AS score_gain1,
 		(CASE WHEN teams_home_id = 50 THEN (CASE WHEN teams_home_winner = 'TRUE' THEN 0
												WHEN teams_home_winner = 'FALSE' THEN 3
												ELSE 2 END)
			WHEN teams_away_id = 50 THEN (CASE WHEN teams_away_winner = 'TRUE' THEN 0
												WHEN teams_away_winner = 'FALSE' THEN 3
												ELSE 2 END) END ) AS score_lose1
	   		FROM matchday_results
	   		WHERE teams_home_id = 50 or teams_away_id =50),
ARS_score AS
(SELECT	EXTRACT(YEAR FROM fixture_date) AS year,
 		EXTRACT(month FROM fixture_date) AS month,
		(CASE WHEN teams_home_id = 42 THEN (CASE WHEN teams_home_winner = 'TRUE' THEN 3
												WHEN teams_home_winner = 'FALSE' THEN 0
												ELSE 1 END)
			WHEN teams_away_id = 42 THEN (CASE WHEN teams_away_winner = 'TRUE' THEN 3
												WHEN teams_away_winner = 'FALSE' THEN 0
												ELSE 1 END) END ) AS score_gain2,
 		(CASE WHEN teams_home_id = 42 THEN (CASE WHEN teams_home_winner = 'TRUE' THEN 0
												WHEN teams_home_winner = 'FALSE' THEN 3
												ELSE 2 END)
			WHEN teams_away_id = 42 THEN (CASE WHEN teams_away_winner = 'TRUE' THEN 0
												WHEN teams_away_winner = 'FALSE' THEN 3
												ELSE 2 END) END ) AS score_lose2
	   		FROM matchday_results
	   		WHERE teams_home_id = 42 or teams_away_id =42),

sum_MC AS
(SELECT year, month, SUM(score_gain1) AS MC_score_gain, SUM(score_lose1) AS MC_score_lose
FROM MC_score AS m
GROUP BY m.year,m.month
ORDER BY m.year,m.month),

sum_ARS AS
(SELECT year, month, SUM(score_gain2) AS ARS_score_gain, SUM(score_lose2) AS ARS_score_lose
FROM ARS_score
GROUP BY year,month
ORDER BY year,month)

SELECT m.year,m.month, MC_score_gain, MC_score_lose, ARS_score_gain, ARS_score_lose
FROM sum_MC AS m
LEFT JOIN sum_ARS AS a
ON m.month = a.month
