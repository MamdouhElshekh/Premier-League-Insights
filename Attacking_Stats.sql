DROP TABLE IF EXISTS Attacking_stats;
CREATE TABLE Attacking_stats
AS

-- Calculating Total Shots
(WITH H_Shots AS (
SELECT Season, HomeTeam AS Team, SUM(HomeShots) AS Shots
FROM epl
GROUP BY HomeTeam, Season
),
A_Shots AS (
SELECT Season, AwayTeam AS Team, SUM(AwayShots) AS Shots
FROM epl
GROUP BY AwayTeam, Season
),

-- Calculating Total Shots on Target
H_ShotsON AS (
SELECT Season, HomeTeam AS Team, SUM(HomeShotsOnTarget) AS ShotsOn
FROM epl
GROUP BY HomeTeam, Season
),
A_ShotsON AS (
SELECT Season, AwayTeam AS Team, SUM(AwayShotsOnTarget) AS ShotsOn
FROM epl
GROUP BY AwayTeam, Season
),

-- Calculating Total Goals Scored
Goals_H AS (
SELECT Season, HomeTeam AS team, SUM(HomeGoals) AS GHome
FROM epl
GROUP BY HomeTeam, Season
),
Goals_A AS (
SELECT Season, AwayTeam AS team, SUM(AwayGoals) AS GAway
FROM epl
GROUP BY AwayTeam, Season
)

-- Forming Final table through joining CTEs
SELECT Goals_A.Season, Goals_A.Team, (H_Shots.Shots + A_Shots.Shots) AS TotalShots,
	(H_ShotsON.ShotsOn + A_ShotsON.ShotsOn) AS Total_Shots_ON_Target,
    (Goals_H.GHome + Goals_A.GAway) AS TotalGoals
FROM H_Shots 
JOIN A_Shots 
ON H_Shots.Season = A_Shots.Season AND H_Shots.Team = A_Shots.Team
JOIN H_ShotsON 
ON H_ShotsON.Season = H_Shots.Season AND H_ShotsON.Team = H_Shots.Team
JOIN A_ShotsON 
ON A_ShotsON.Season = H_Shots.Season AND A_ShotsON.Team = H_Shots.Team
JOIN Goals_H 
ON Goals_H.Season = H_Shots.Season AND Goals_H.Team = H_Shots.Team
JOIN Goals_A 
ON Goals_A.Season = H_Shots.Season AND Goals_A.Team = H_Shots.Team
ORDER BY Season, TotalGoals DESC);

SELECT *
FROM Attacking_stats;





/*SELECT H.season, H.Team, (H.Shots + A.Shots) AS totalshots
FROM H_Shots AS H
JOIN A_Shots AS A 
ON H.Season = A.Season AND H.Team = A.Team
GROUP BY H.Team, H.Season
ORDER BY H.Season, totalshots DESC)*/