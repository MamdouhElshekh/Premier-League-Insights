DROP TABLE IF EXISTS English_Premier_League;
CREATE TABLE English_Premier_League
AS
WITH WINS AS (SELECT Season, Winner AS Team, COUNT(Winner) AS W
FROM epl
WHERE Winner != 'Draw'
GROUP BY Winner, Season),
LOSSES AS (SELECT Season, Loser AS Team, COUNT(Loser) AS L
FROM epl
WHERE Winner != 'Draw'
GROUP BY Loser, Season),
GD_H AS (SELECT Season, HomeTeam AS team, SUM(HomeGoals - AwayGoals) AS GHome
FROM epl
GROUP BY HomeTeam, Season),
GD_A AS (SELECT Season, AwayTeam AS team, SUM(AwayGoals - HomeGoals) AS GAway
FROM epl
GROUP BY AwayTeam, Season),
GF_H AS (SELECT Season, HomeTeam AS team, SUM(HomeGoals) AS GFHome
FROM epl
GROUP BY HomeTeam, Season),
GF_A AS (SELECT Season, AwayTeam AS team, SUM(AwayGoals) AS GFAway
FROM epl
GROUP BY AwayTeam, Season),
GA_H AS (SELECT Season, HomeTeam AS team, SUM(AwayGoals) AS GAHome
FROM epl
GROUP BY HomeTeam, Season),
GA_A AS (SELECT Season, AwayTeam AS team, SUM(HomeGoals) AS GAAway
FROM epl
GROUP BY AwayTeam, Season)
SELECT W.Season, W.Team, W.W*3 + (38-(W.W+L.L)) AS P,
	GA.GAway + GH.GHome AS GD, 
	(GF_H.GFHome + GF_A.GFAway) AS GF,
    (GA_H.GAHome + GA_A.GAAway) AS GA,
    RANK() OVER (PARTITION BY W.Season 
		ORDER BY W.W*3 + (38-(W.W+L.L)) DESC, GA.GAway + GH.GHome DESC) AS Position
FROM WINS AS W
JOIN LOSSES AS L
ON W.Team = L.Team AND W.Season = L.Season
JOIN GD_A AS GA
ON W.Team = GA.Team AND W.Season = GA.Season
JOIN GD_H AS GH
ON W.Team = GH.Team AND W.Season = GH.Season
JOIN GF_H 
ON W.Team = GF_H.Team AND W.Season = GF_H.Season
JOIN GF_A
ON W.Team = GF_A.Team AND W.Season = GF_A.Season
JOIN GA_H
ON W.Team = GA_H.Team AND W.Season = GA_H.Season
JOIN GA_A
ON W.Team = GA_A.Team AND W.Season = GA_A.Season
ORDER BY W.Season, P DESC, GD DESC, GF DESC, GA;
