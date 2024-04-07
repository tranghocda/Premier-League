CREATE TABLE standings(
	rank_n int2,
	points int2,
	goalsDiff int4,
	team_id int4,
	team_name varchar(40),
	matches_played int2,
	wins int2,
	draws int2,
	losses int2,
	goals_for int2,
	goals_against int2,
	home int2,
	home_wins int2,
	home_draw int2,
	home_loss int2,
	home_goals_for int2,
	home_goals_against int2,
	away int2,
	away_wins int2,
	away_draw int2,
	away_lose int2,
	away_goals_for int2,
	away_goals_against int2);
SELECT *
FROM standings
	
CREATE TABLE matchday_results (
	match_no int,
	fixture_id int,
	fixture_date timestamp,
	teams_home_id int,
	teams_home_name varchar(40),
	teams_home_winner bool,
	teams_away_id int,
	teams_away_name varchar(40),
	teams_away_winner bool,
	goals_home int,
	goals_away int);
	
SELECT * 
FROM matchday_results
	
CREATE TABLE home_teams_stats (
	fixture_id int,
	home_team_id int,
	home_team_name varchar,
	shots_on_goal int,
	shots_off_goal int,
	total_shots int,
	blocked_shots int,
	shots_insidebox int,
	shots_outsidebox int,
	fouls int,
	corner_kicks int,
	offsides int,
	ball_possession float,
	yellow_cards int,
	red_cards int,
	goalkeeper_saves int,
	total_passes int,
	passes_accurate int,
	passes_percent float,
	expected_goals float);
	
	
CREATE TABLE away_teams_stats(
	fixture_id int,
	away_team_id int,
	away_team_name varchar,
	shots_on_goal int,
	shots_off_goal int,
	total_shots int,
	blocked_shots int,
	shots_insidebox int,
	shots_outsidebox int,
	fouls int,
	corner_kicks int,
	offsides int,
	ball_possession float,
	yellow_cards int,
	red_cards int,
	goalkeeper_saves int,
	total_passes int,
	passes_accurate int,
	passes_percent float,
	expected_goals float);
	