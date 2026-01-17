select * from dbo.Stadium

select * from dbo.Team

select * from dbo.Player

select * from match

select * from Player where BirthDate is null



-- Top 20 players by total points with their team info
SELECT TOP 20 p.FirstName,
                                 p.LastName,
                                 t.Name AS TeamName,
                                 pos.TotalPoints,
                                pos.GamesPlayed,
                                pos.SuccessfulHits,
                                pos.TotalCatches, 
FROM dbo.Player p
INNER JOIN dbo.Team t ON p.TeamId = t.Id
INNER JOIN dbo.PlayerOverallStatistics pos ON p.Id = pos.PlayerId
ORDER BY pos.TotalPoints DESC;

-- Find veteran and rookie pairings on same team
SELECT pv.FirstName + ' ' + pv.LastName AS Veteran,
             pr.FirstName + ' ' + pr.LastName AS Rookie,
             t.Name AS Team,
             DATEDIFF(YEAR, pv.BirthDate, GETDATE()) AS VeteranAge,
             DATEDIFF(YEAR, pr.BirthDate, GETDATE()) AS RookieAge
FROM dbo.Player pv
INNER JOIN dbo.Player pr ON pv.TeamId = pr.TeamId AND 
             pv.Id <> pr.Id AND 
             DATEDIFF(YEAR, pv.BirthDate, GETDATE()) >= 39 AND -- Veteran
             DATEDIFF(YEAR, pr.BirthDate, GETDATE()) <= 32 -- Younger player
INNER JOIN dbo.Team t ON pv.TeamId = t.Id
WHERE pv.IsActive = 1 AND pr.IsActive = 1
ORDER BY t.Name, VeteranAge DESC;

-- returns all teams and their players as well as teams without players
SELECT t.Name AS TeamName,
             t.City,
             p.FirstName,
             p.LastName,
              t.ChampionshipCount
FROM dbo.Team t
LEFT JOIN dbo.Player p ON t.Id = p.TeamId
ORDER BY t.Name, p.LastName;

-- returns all teams and their players as well as teams without players
SELECT t.Name AS TeamName,
             t.City,
             p.FirstName,
             p.LastName,
              t.ChampionshipCount
FROM dbo.Team t
RIGHT JOIN dbo.Player p ON t.Id = p.TeamId
ORDER BY t.Name, p.LastName;

-- returns all teams and their players as well as teams without players
SELECT t.Name AS TeamName,
             t.City,
             p.FirstName,
             p.LastName,
              t.ChampionshipCount
FROM dbo.Team t
FULL JOIN dbo.Player p ON t.Id = p.TeamId
ORDER BY t.Name, p.LastName;

-- returns all teams and their players as well as teams without players
SELECT t.Name AS TeamName,
             t.City,
             p.FirstName,
             p.LastName,
              t.ChampionshipCount
FROM dbo.Team t
CROSS JOIN dbo.Player p
ORDER BY t.Name, p.LastName;


-- Get unique list of all cities from both teams and stadiums
SELECT DISTINCT City, 'Team' AS Source
FROM dbo.Team
UNION
SELECT DISTINCT City, 'Stadium' AS Source
FROM dbo.Stadium
ORDER BY City;


-- Teams that have NEVER played a home match
SELECT Id FROM dbo.Team
EXCEPT
SELECT DISTINCT HomeTeamId FROM dbo.Match;

-- Teams That Have Players AND Have Played Matches
--
-- Teams with at least one player
SELECT DISTINCT TeamId
FROM dbo.Player
WHERE IsActive = 1
INTERSECT
-- Teams that have played matches
SELECT DISTINCT HomeTeamId
FROM dbo.Match


SELECT Country,
                  City,
                  COUNT(*) AS StadiumCount
FROM dbo.Stadium
GROUP BY ROLLUP(Country, City)
HAVING COUNT(*) > 1;