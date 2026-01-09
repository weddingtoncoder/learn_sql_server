USE master
GO

-- create the Dodgeball database if it does't already exist (idempotent)
IF DB_ID('Dodgeball') IS NULL
BEGIN
    CREATE DATABASE Dodgeball;
END
GO

USE Dodgeball
GO  
drop table if exists dbo.Match;
GO
drop table if exists dbo.Player;
GO
drop table if exists dbo.Team;
GO
drop table if exists dbo.Stadium;
GO
drop table if exists dbo.Season;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- create the Season table only if it doesn't already exist (idempotent)
IF OBJECT_ID('dbo.Season','U') IS NULL
BEGIN
    CREATE TABLE dbo.Season
    (
        Id          INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Season PRIMARY KEY,
        Name        VARCHAR(100) NOT NULL,
        StartDate   DATE NOT NULL,
        EndDate     DATE NOT NULL,
        IsActive    BIT NOT NULL CONSTRAINT DF_Season_IsActive DEFAULT (1),
        CreateDate  DATETIME2(0) NOT NULL CONSTRAINT DF_Season_CreateDate DEFAULT (SYSUTCDATETIME())
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Season)
BEGIN
    INSERT INTO dbo.Season (Name,StartDate,EndDate,IsActive)
    VALUES
    ('2021 Season', '2021-01-01', '2021-12-31', 1),
    ('2022 Season', '2022-01-01', '2022-12-31', 1),
    ('2023 Season', '2023-01-01', '2023-12-31', 1),
    ('2024 Season', '2024-01-01', '2024-12-31', 1),
    ('2025 Season', '2025-01-01', '2025-12-31', 1),
    ('2026 Season', '2026-01-01', '2026-12-31', 1);
END
GO

-- create the Stadium table only if it does't already exist (idempotent)
IF OBJECT_ID('dbo.Stadium', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Stadium
    (
        Id              INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Stadium PRIMARY KEY,
        Name            VARCHAR(100) NOT NULL,
        City            VARCHAR(100) NOT NULL,
        Country         VARCHAR(100) NOT NULL,
        Capacity        INT NOT NULL,
        OpenedDate      DATE NOT NULL,
        SurfaceType     VARCHAR(50) NOT NULL,
        RoofType        VARCHAR(50) NOT NULL,
        HomeTeamName    VARCHAR(100) NULL,
        AnnualRevenue   DECIMAL(18,2) NOT NULL CONSTRAINT DF_Stadium_AnnualRevenue DEFAULT (0.00),
        IsActive        BIT NOT NULL CONSTRAINT DF_Stadium_IsActive DEFAULT (1),
        CreateDate      DATETIME2(0) NOT NULL CONSTRAINT DF_Stadium_CreateDate DEFAULT (SYSUTCDATETIME())
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Stadium)
BEGIN
    INSERT INTO dbo.Stadium (Name,City,Country,Capacity,OpenedDate,SurfaceType,RoofType,HomeTeamName,AnnualRevenue,IsActive)
    VALUES
    ('Red Rock Arena','Phoenix','US',45000,CAST('1999-05-01' AS Date),'Grass','Open','Phoenix Rockers',12345678.90,1),
    ('Harbor Field','Seattle','US',38000,CAST('2001-07-12' AS Date),'Grass','Retractable','Seattle Harbors',9876543.21,1),
    ('Central Dome','Tokyo','JP',60000,CAST('2003-03-20' AS Date),'Synthetic','Retractable','Tokyo Titans',45200000.00,1),
    ('Maple Park','Toronto','CA',42000,CAST('1995-09-14' AS Date),'Grass','Open','Toronto Leafs',15800000.55,1),
    ('Granite Stadium','London','UK',50000,CAST('1988-06-01' AS Date),'Grass','Closed','London Granite',27450000.00,1),
    ('Oceanview Arena','San Diego','US',30000,CAST('2008-11-10' AS Date),'Grass','Open','San Diego Waves',8200000.75,1),
    ('Prairie Grounds','Winnipeg','CA',28000,CAST('1992-04-03' AS Date),'Synthetic','Open','Prairie Pioneers',4100000.00,1),
    ('Empire Field','New York','US',62000,CAST('2010-09-22' AS Date),'Grass','Retractable','New York Empire',67234000.10,1),
    ('Blue Ridge Park','Atlanta','US',36000,CAST('2000-08-15' AS Date),'Grass','Open','Atlanta Blue',9400000.00,1),
    ('Riverside Coliseum','Portland','US',27000,CAST('1997-10-05' AS Date),'Synthetic','Open','Portland Rivercats',3300000.20,1),
    ('Stadium Verde','Mexico City','MX',48000,CAST('1994-09-10' AS Date),'Grass','Open','Mexico Verde',11200000.00,1),
    ('Harbourfront Dome','Vancouver','CA',35000,CAST('2005-05-06' AS Date),'Synthetic','Retractable','Vancouver Vibe',6050000.40,1),
    ('Liberty Arena','Boston','US',41000,CAST('1985-06-20' AS Date),'Grass','Closed','Boston Liberty',14230000.00,1),
    ('Continental Park','Chicago','US',54000,CAST('1990-04-12' AS Date),'Grass','Open','Chicago Continentals',30560000.90,1),
    ('Sunset Bowl','Los Angeles','US',72000,CAST('2015-02-28' AS Date),'Grass','Retractable','LA Sunsets',88500000.00,1),
    ('Harbor Stadium','Barcelona','ES',46000,CAST('1998-03-17' AS Date),'Grass','Open','Barcelona Mariners',20120000.00,1),
    ('Stonebridge Park','Melbourne','AU',33000,CAST('2002-11-02' AS Date),'Grass','Open','Melbourne Strikers',7200000.95,1),
    ('Northgate Arena','Edinburgh','UK',29000,CAST('1996-09-30' AS Date),'Grass','Closed','Edinburgh North',3150000.00,1),
    ('Valley Field','Denver','US',39000,CAST('1989-07-09' AS Date),'Grass','Open','Denver Valleys',6900000.00,1),
    ('Cascade Dome','Oakland','US',25000,CAST('2004-05-20' AS Date),'Synthetic','Open','Oakland Cascades',2450000.50,1),
    ('Copper Bowl','Salt Lake City','US',31000,CAST('1993-08-18' AS Date),'Grass','Open','SLC Copperheads',2980000.00,1),
    ('Metro Stadium','Paris','FR',52000,CAST('1987-06-12' AS Date),'Grass','Closed','Paris Metros',22345000.00,1),
    ('Harbor Lights Park','Miami','US',29000,CAST('2006-11-01' AS Date),'Grass','Open','Miami Lights',8700000.00,1),
    ('Ironworks Arena','Pittsburgh','US',31000,CAST('1991-10-10' AS Date),'Grass','Closed','Pittsburgh Irons',4100000.00,1),
    ('Palace Field','Lisbon','PT',34000,CAST('2007-04-04' AS Date),'Grass','Retractable','Lisbon Royals',5500000.00,1),
    ('Beacon Stadium','Columbus','US',37000,CAST('1994-09-27' AS Date),'Grass','Open','Columbus Beacons',3600000.45,1),
    ('Harbour Gate','Oslo','NO',26000,CAST('2000-12-12' AS Date),'Synthetic','Closed','Oslo Gatekeepers',2100000.00,1),
    ('Liberty Field','Philadelphia','US',48000,CAST('1986-05-23' AS Date),'Grass','Open','Philly Liberty',12900000.00,1),
    ('Crystal Park','Singapore','SG',20000,CAST('2012-03-30' AS Date),'Synthetic','Retractable','SG Crystals',9700000.00,1),
    ('Harborview Stadium','Housto','US',44000,CAST('1998-09-18' AS Date),'Grass','Open','Houston Harbor',15000000.00,1),
    ('Praxis Arena','Berlin','DE',47000,CAST('2001-07-07' AS Date),'Grass','Retractable','Berlin Praxis',18120000.00,1),
    ('Kings Meadow','Manchester','UK',36000,CAST('1999-08-21' AS Date),'Grass','Closed','Manchester Kings',9400000.00,1),
    ('Gulfstream Park','Abu Dhabi','AE',28000,CAST('2013-11-11' AS Date),'Synthetic','Retractable','Abu Gulfstream',13200000.00,1),
    ('Stadium Azul','Buenos Aires','AR',52000,CAST('1984-06-30' AS Date),'Grass','Open','Buenos Azuls',19450000.00,1),
    ('Northern Lights Dome','Reykjavik','IS',18000,CAST('2009-02-14' AS Date),'Synthetic','Closed','Icebreakers',950000.00,1),
    ('Kingsford Stadium','Sydney','AU',61000,CAST('2016-05-05' AS Date),'Grass','Retractable','Sydney Kings',56200000.00,1),
    ('Citadel Park','Barcelona','ES',34000,CAST('1992-09-09' AS Date),'Grass','Open','Catalan Citadels',7200000.00,1),
    ('Riverbank Arena','Prague','CZ',24000,CAST('1997-03-03' AS Date),'Grass','Closed','Prague River',1850000.00,1),
    ('Eagle Nest','Charlotte','US',33000,CAST('2000-10-20' AS Date),'Grass','Open','Charlotte Eagles',4050000.00,1),
    ('Liberty Ridge','Stanford','US',15000,CAST('2018-08-08' AS Date),'Synthetic','Open','Stanford Rams',980000.00,1),
    ('Bayfront Stadium','Naples','IT',29000,CAST('1991-06-06' AS Date),'Grass','Closed','Naples Bay',2400000.00,1),
    ('Victory Field','Indianapolis','US',25000,CAST('1995-09-01' AS Date),'Grass','Open','Indy Victors',1850000.25,1),
    ('Aurora Arena','Sofia','BG',22000,CAST('2006-10-10' AS Date),'Synthetic','Open','Sofia Auroras',1120000.00,1);
END
GO

drop table if exists dbo.Team;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- create the Team table only if it does't already exist (idempotent)
IF OBJECT_ID('dbo.Team', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Team
    (
        Id                  INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Team PRIMARY KEY,
        Name                VARCHAR(100) NOT NULL,
        City                VARCHAR(100) NULL,
        Country             VARCHAR(100) NULL,
        HomeStadiumId       INT NULL,
        FoundedDate         DATE NULL,
        CoachName           VARCHAR(100) NULL,
        Mascot              VARCHAR(100) NULL,
        Colors              VARCHAR(100) NULL,
        ChampionshipCount   INT NOT NULL CONSTRAINT DF_Team_ChampionshipCount DEFAULT (0),
        IsActive            BIT NOT NULL CONSTRAINT DF_Team_IsActive DEFAULT (1),
        CreateDate          DATETIME2(0) NOT NULL CONSTRAINT DF_Team_CreateDate DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT FK_Team_Stadium FOREIGN KEY (HomeStadiumId) REFERENCES dbo.Stadium(Id)
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Team)
BEGIN
    INSERT INTO dbo.Team (Name,City,Country,HomeStadiumId,FoundedDate,CoachName,Mascot,Colors,ChampionshipCount,IsActive)
    VALUES
    ('Red Rockers','Phoenix','US',1,'1999-05-01','Alex Mercer','Rocky','Red/Black',2,1),
    ('Harbor Hawks','Seattle','US',2,'2001-07-12','Samira Cole','Hawk','Blue/White',1,1),
    ('Central Titans','Tokyo','JP',3,'2003-03-20','Hiro Tanaka','Titan','Navy/White',3,1),
    ('Maple Leafs','Toronto','CA',4,'1995-09-14','Gina Lopez','Leaf','Blue/Red',0,1),
    ('Granite United','London','UK',5,'1988-06-01','Oliver Stone','Grit','Gray/White',4,1),
    ('Oceanview Waves','San Diego','US',6,'2008-11-10','Maria Ortiz','Wave','Teal/White',0,1),
    ('Prairie Pioneers','Winnipeg','CA',7,'1992-04-03','Derek Young','Pioneer','Green/Gold',0,1),
    ('Empire FC','New York','US',8,'2010-09-22','Raymond King','Empire','Black/Gold',5,1),
    ('Blue Ridge FC','Atlanta','US',9,'2000-08-15','Ellen Park','Blue','Blue/Black',1,1),
    ('Rivercats','Portland','US',10,'1997-10-05','Chris Nolan','Rivercat','Maroon/White',0,1),
    ('Verde City','Mexico City','MX',11,'1994-09-10','Luis Alvarez','Verde','Green/White',2,1),
    ('Vancouver Vibe','Vancouver','CA',12,'2005-05-06','Tanya Reid','Vibe','Cyan/White',0,1),
    ('Liberty Stars','Boston','US',13,'1985-06-20','Frank Doyle','Star','Red/White',3,1),
    ('Continental','Chicago','US',14,'1990-04-12','Marco Rossi','Continent','Blue/Gold',2,1),
    ('Sunset FC','Los Angeles','US',15,'2015-02-28','Olivia Park','Sunset','Orange/Black',6,1),
    ('Harbor Mariners','Barcelona','ES',16,'1998-03-17','Diego Martinez','Mariner','Blue/Red',1,1),
    ('Stonebridge','Melbourne','AU',17,'2002-11-02','Noah Williams','Stone','Gray/Blue',0,1),
    ('Northgate','Edinburgh','UK',18,'1996-09-30','Fiona McLean','North','Navy/White',0,1),
    ('Valley Rovers','Denver','US',19,'1989-07-09','Tom Harris','Rover','Green/White',0,1),
    ('Cascade','Oakland','US',20,'2004-05-20','Ivy Chen','Cascade','Silver/Blue',0,1),
    ('Copperheads','Salt Lake City','US',21,'1993-08-18','Jake Harper','Copperhead','Copper/Black',0,1),
    ('Metro','Paris','FR',22,'1987-06-12','Sophie Laurent','Metro','Blue/Silver',2,1),
    ('Harbor Lights','Miami','US',23,'2006-11-01','Carlos Mendez','Light','Pink/White',0,1),
    ('Ironworks','Pittsburgh','US',24,'1991-10-10','Pete Gordon','Iron','Black/Gray',1,1),
    ('Palace Royals','Lisbon','PT',25,'2007-04-04','Rui Sousa','Royal','Purple/Gold',0,1),
    ('Beacon United','Columbus','US',26,'1994-09-27','Amy Carter','Beacon','Blue/Yellow',0,1),
    ('Oslo Gatekeepers','Oslo','NO',27,'2000-12-12','Kristin Dahl','Gate','Blue/White',0,1),
    ('Philly Liberty','Philadelphia','US',28,'1986-05-23','Roberto Diaz','Liberty','Red/Blue',2,1),
    ('SG Crystals','Singapore','SG',29,'2012-03-30','Wei Tan','Crystal','Teal/Gold',0,1),
    ('Houston Harbor','Houston','US',30,'1998-09-18','Anita Singh','Harbor','Blue/Red',1,1),
    ('Berlin Praxis','Berlin','DE',31,'2001-07-07','Hans Becker','Praxis','Red/Black',0,1),
    ('Manchester Kings','Manchester','UK',32,'1999-08-21','Oliver Grey','King','Red/White',3,1),
    ('Abu Gulfstream','Abu Dhabi','AE',33,'2013-11-11','Ahmed Al Fahad','Gulf','Gold/Blue',0,1),
    ('Azul FC','Buenos Aires','AR',34,'1984-06-30','Sofia Perez','Azul','Blue/White',4,1),
    ('Icebreakers','Reykjavik','IS',35,'2009-02-14','Jon Sigurdsson','Breaker','White/Blue',0,1),
    ('Kingsford','Sydney','AU',36,'2016-05-05','Mia Brown','King','Blue/Gold',0,1),
    ('Catalan Citadels','Barcelona','ES',37,'1992-09-09','Pau Garcia','Citadel','Maroon/Gold',0,1),
    ('River','Prague','CZ',38,'1997-03-03','Petr Novak','River','Blue/White',0,1),
    ('Charlotte Eagles','Charlotte','US',39,'2000-10-20','Derek Mills','Eagle','Navy/Gold',0,1),
    ('Stanford Rams','Stanford','US',40,'2018-08-08','Evelyn Shaw','Ram','Cardinal/White',0,1),
    ('Naples Bay','Naples','IT',41,'1991-06-06','Luca Romano','Bay','Blue/White',0,1),
    ('Indy Victors','Indianapolis','US',42,'1995-09-01','Gary Holt','Victor','Red/White',0,1),
    ('Sofia Auroras','Sofia','BG',43,'2006-10-10','Elena Ivanova','Aurora','Green/White',0,1)
END
GO

drop table if exists dbo.Player;
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- create the Player table only if it doesn't already exist (idempotent)
IF OBJECT_ID('dbo.Player','U') IS NULL
BEGIN
    CREATE TABLE dbo.Player
    (
        Id              INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Player PRIMARY KEY,
        FirstName       VARCHAR(100) NOT NULL,
        MiddleName      VARCHAR(50) NULL,
        LastName        VARCHAR(100) NOT NULL,
        PreferredName   VARCHAR(100) NULL,
        BirthDate       DATE NULL,
        Gender          VARCHAR(20) NULL,
        Nationality     VARCHAR(50) NULL,
        HeightCm        SMALLINT NULL,
        WeightKg        DECIMAL(5,2) NULL,
        Position        VARCHAR(50) NULL,
        JerseyNumber    TINYINT NULL,
        TeamId          INT NULL,
        IsActive        BIT NOT NULL CONSTRAINT DF_Player_IsActive DEFAULT (1),
        CreateDate      DATETIME2(0) NOT NULL CONSTRAINT DF_Player_CreateDate DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT FK_Player_Team FOREIGN KEY (TeamId) REFERENCES dbo.Team(Id)
    );
END
GO

-- create the Match table only if it doesn't already exist (idempotent)
IF OBJECT_ID('dbo.Match','U') IS NULL
BEGIN
    CREATE TABLE dbo.Match
    (
        Id              INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Match PRIMARY KEY,
        MatchDate       DATE NOT NULL,
        EventStartTime  DATETIME2(0) NOT NULL,
        DurationMinutes INT NULL,
        HomeTeamId      INT NOT NULL,
        AwayTeamId      INT NOT NULL,
        StadiumId       INT NULL,
        HomeScore       TINYINT NULL,
        AwayScore       TINYINT NULL,
        Status          VARCHAR(20) NOT NULL CONSTRAINT DF_Match_Status DEFAULT ('Scheduled'),
        SeasonId        INT NOT NULL ,
        Notes           VARCHAR(400) NULL,
        CreateDate      DATETIME2(0) NOT NULL CONSTRAINT DF_Match_CreateDate DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT FK_Match_HomeTeam FOREIGN KEY (HomeTeamId) REFERENCES dbo.Team(Id),
        CONSTRAINT FK_Match_AwayTeam FOREIGN KEY (AwayTeamId) REFERENCES dbo.Team(Id),
        CONSTRAINT FK_Match_Stadium FOREIGN KEY (StadiumId) REFERENCES dbo.Stadium(Id),
        CONSTRAINT FK_Match_Season FOREIGN KEY (SeasonId) REFERENCES dbo.Season(Id),
        CONSTRAINT CK_Match_DifferentTeams CHECK (HomeTeamId <> AwayTeamId)
    );
END
GO

-- Seed a larger set of explicit matches (150 rows) — inserted only if Match is empty
IF NOT EXISTS (SELECT 1 FROM dbo.Match)
BEGIN
    INSERT INTO dbo.Match (MatchDate,EventStartTime,DurationMinutes,HomeTeamId,AwayTeamId,StadiumId,HomeScore,AwayScore,Status, SeasonId,Notes)
    VALUES
    -- Cycle 1: 43 ordered pairs on 2025-09-01
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 1,2,1,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 2,3,2,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 3,4,3,12,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 4,5,4,9,6,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 5,6,5,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 6,7,6,8,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 7,8,7,14,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 8,9,8,9,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 9,10,9,15,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 10,11,10,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 11,12,11,8,6,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 12,13,12,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 13,14,13,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 14,15,14,12,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 15,16,15,9,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 16,17,16,14,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 17,18,17,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 18,19,18,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 19,20,19,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 20,21,20,13,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 21,22,21,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 22,23,22,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 23,24,23,15,14,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 24,25,24,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 25,26,25,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 26,27,26,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 27,28,27,9,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 28,29,28,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 29,30,29,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 30,31,30,12,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 31,32,31,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 32,33,32,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 33,34,33,9,6,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 34,35,34,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 35,36,35,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 36,37,36,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 37,38,37,15,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 38,39,38,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 39,40,39,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 40,41,40,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 41,42,41,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 42,43,42,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-01' AS date), CAST('2025-09-01T19:00:00' AS datetime2), 60, 43,1,43,13,11,'Completed',5,'Seeded match'),

    -- Cycle 2: same 43 pairs on 2025-09-02
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 1,2,1,9,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 2,3,2,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 3,4,3,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 4,5,4,8,6,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 5,6,5,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 6,7,6,7,5,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 7,8,7,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 8,9,8,8,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 9,10,9,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 10,11,10,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 11,12,11,7,6,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 12,13,12,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 13,14,13,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 14,15,14,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 15,16,15,8,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 16,17,16,13,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 17,18,17,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 18,19,18,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 19,20,19,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 20,21,20,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 21,22,21,8,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 22,23,22,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 23,24,23,14,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 24,25,24,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 25,26,25,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 26,27,26,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 27,28,27,8,6,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 28,29,28,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 29,30,29,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 30,31,30,11,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 31,32,31,9,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 32,33,32,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 33,34,33,8,5,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 34,35,34,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 35,36,35,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 36,37,36,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 37,38,37,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 38,39,38,9,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 39,40,39,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 40,41,40,8,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 41,42,41,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 42,43,42,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-02' AS date), CAST('2025-09-02T18:30:00' AS datetime2), 60, 43,1,43,12,10,'Completed',5,'Seeded match'),

    -- Cycle 3: same 43 pairs on 2025-09-03
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 1,2,1,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 2,3,2,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 3,4,3,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 4,5,4,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 5,6,5,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 6,7,6,9,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 7,8,7,15,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 8,9,8,10,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 9,10,9,16,14,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 10,11,10,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 11,12,11,9,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 12,13,12,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 13,14,13,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 14,15,14,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 15,16,15,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 16,17,16,15,14,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 17,18,17,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 18,19,18,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 19,20,19,13,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 20,21,20,14,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 21,22,21,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 22,23,22,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 23,24,23,16,15,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 24,25,24,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 25,26,25,13,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 26,27,26,15,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 27,28,27,10,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 28,29,28,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 29,30,29,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 30,31,30,13,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 31,32,31,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 32,33,32,15,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 33,34,33,10,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 34,35,34,14,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 35,36,35,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 36,37,36,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 37,38,37,16,14,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 38,39,38,11,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 39,40,39,15,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 40,41,40,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 41,42,41,13,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 42,43,42,12,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-03' AS date), CAST('2025-09-03T20:00:00' AS datetime2), 60, 43,1,43,14,12,'Completed',5,'Seeded match'),

    -- Extras: first 21 pairs on 2025-09-04
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 1,2,1,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 2,3,2,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 3,4,3,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 4,5,4,8,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 5,6,5,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 6,7,6,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 7,8,7,13,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 8,9,8,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 9,10,9,14,13,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 10,11,10,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 11,12,11,8,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 12,13,12,12,11,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 13,14,13,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 14,15,14,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 15,16,15,8,7,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 16,17,16,13,12,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 17,18,17,10,9,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 18,19,18,9,8,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 19,20,19,11,10,'Completed',5,'Seeded match'),
    (CAST('2025-09-04' AS date), CAST('2025-09-04T17:00:00' AS datetime2), 60, 20,21,20,12,11,'Completed',5,'Seeded match');
END
GO

-- Sample data for Player table
IF NOT EXISTS (SELECT 1 FROM dbo.Player)
BEGIN
    INSERT INTO dbo.Player (FirstName,MiddleName,LastName,PreferredName,BirthDate,Gender,Nationality,HeightCm,WeightKg,Position,JerseyNumber,TeamId,IsActive)
    VALUES
    ('John','A.','Doe','Johnny','1985-01-15','Male','US',180,75,'Thrower',10,1,1),
    ('Jane','B.','Smith','Janey','1990-02-20','Female','US',165,68,'Catcher',8,1,1),
    ('David','C.','Johnson','DJ','1988-03-30','Male','US',175,70,'Defender',5,1,1),
    ('Emily','D.','Davis','Em','1992-04-25','Female','US',170,60,'Sweeper',1,1,1),
    ('Michael','E.','Wilson','Mike','1983-05-10','Male','US',185,80,'Thrower',9,2,1),
    ('Jessica','F.','Moore','Jess','1995-06-05','Female','US',160,55,'Catcher',7,2,1),
    ('Daniel','G.','Taylor','Dan','1987-07-22','Male','US',178,72,'Defender',4,2,1),
    ('Sarah','H.','Anderson','Sadie','1991-08-18','Female','US',168,65,'Sweeper',1,2,1),
    ('Matthew','I.','Thomas','Matt','1984-09-12','Male','US',182,78,'Thrower',11,3,1),
    ('Ashley','J.','Jackson','Ash','1993-10-30','Female','US',163,57,'Catcher',6,3,1),
    ('Joshua','K.','White','Josh','1986-11-20','Male','US',177,74,'Defender',3,3,1),
    ('Amanda','L.','Harris','Mandy','1992-12-15','Female','US',165,62,'Sweeper',1,3,1),
    ('Ryan','M.','Martin','Rye','1989-01-05','Male','US',180,76,'Thrower',10,4,1),
    ('Nicole','N.','Thompson','Nikki','1994-02-14','Female','US',162,54,'Catcher',8,4,1),
    ('Brandon','O.','Garcia','Bran','1987-03-03','Male','US',179,73,'Defender',5,4,1),
    ('Samantha','P.','Martinez','Sam','1991-04-28','Female','US',167,64,'Sweeper',1,4,1),
    ('William','Q.','Robinson','Will','1985-05-17','Male','US',183,79,'Thrower',9,5,1),
    ('Elizabeth','R.','Clark','Liz','1990-06-30','Female','US',161,59,'Catcher',7,5,1),
    ('James','S.','Rodriguez','Jimmy','1988-07-19','Male','US',176,71,'Defender',4,5,1),
    ('Mary','T.','Lewis','Polly','1992-08-25','Female','US',169,66,'Sweeper',1,5,1),
    ('Charles','U.','Lee','Charlie','1984-09-10','Male','US',181,77,'Thrower',10,6,1),
    ('Patricia','V.','Walker','Pat','1993-10-15','Female','US',164,63,'Catcher',8,6,1),
    ('Joseph','W.','Hall','Joe','1986-11-30','Male','US',178,75,'Defender',3,6,1),
    ('Linda','X.','Allen','Lin','1991-12-20','Female','US',166,67,'Sweeper',1,6,1),
    ('Thomas','Y.','Young','Tommy','1989-01-10','Male','US',179,74,'Thrower',11,7,1),
    ('Barbara','Z.','King','Barb','1994-02-20','Female','US',160,56,'Catcher',6,7,1),
    ('Henry','A.','Scott','Hank','1987-03-15','Male','US',182,80,'Defender',4,7,1),
    ('Susan','B.','Green','Sue','1991-04-25','Female','US',170,69,'Sweeper',1,7,1),
    ('Kevin','C.','Adams','Kev','1985-05-30','Male','US',185,82,'Thrower',10,8,1),
    ('Jessica','D.','Baker','Jessie','1990-06-15','Female','US',165,64,'Catcher',7,8,1),
    ('Brian','E.','Gonzalez','Gonzo','1988-07-20','Male','US',177,76,'Defender',3,8,1),
    ('Maria','F.','Nelson','Ria','1992-08-30','Female','US',168,70,'Sweeper',1,8,1),
    ('Matthew','G.','Carter','Mattie','1989-09-10','Male','US',180,78,'Thrower',11,9,1),
    ('Amanda','H.','Mitchell','Mandy','1994-10-20','Female','US',162,55,'Catcher',6,9,1),
    ('Joshua','I.','Perez','Joshy','1986-11-25','Male','US',179,74,'Defender',4,9,1),
    ('Nicole','J.','Roberts','Nikki','1991-12-15','Female','US',165,63,'Sweeper',1,9,1),
    ('Ryan','K','Turner','Rye','1988-01-05','Male','US',182,80,'Thrower',10,10,1),
    ('Emily','L','Phillips','Em','1993-02-14','Female','US',170,68,'Catcher',8,10,1),
    ('David','M','Campbell','Dave','1987-03-30','Male','US',175,72,'Defender',5,10,1),
    ('Jessica','N','Parker','Jess','1992-04-25','Female','US',160,58,'Sweeper',1,10,1),
    ('Michael','O','Evans','Mike','1983-05-10','Male','US',185,81,'Thrower',9,11,1),
    ('Sarah','P','Edwards','Sadie','1995-06-05','Female','US',163,66,'Catcher',7,11,1),
    ('Matthew','Q','Collins','Matt','1986-07-22','Male','US',178,75,'Defender',4,11,1),
    ('Amanda','R','Stewart','Mandy','1991-08-18','Female','US',165,64,'Sweeper',1,11,1),
    ('William','S','Sanchez','Will','1985-09-12','Male','US',183,79,'Thrower',10,12,1),
    ('Elizabeth','T','Morris','Liz','1990-10-30','Female','US',161,60,'Catcher',8,12,1),
    ('James','U','Rogers','Jimmy','1988-11-20','Male','US',176,73,'Defender',3,12,1),
    ('Mary','V','Reed','Polly','1992-12-15','Female','US',169,67,'Sweeper',1,12,1),
    ('Charles','W','Cook','Charlie','1984-01-10','Male','US',181,76,'Thrower',10,13,1),
    ('Patricia','X','Morgan','Pat','1993-02-15','Female','US',164,62,'Catcher',7,13,1),
    ('Joseph','Y','Cooper','Joe','1986-03-03','Male','US',178,74,'Defender',4,13,1),
    ('Linda','Z','Bailey','Lin','1991-04-20','Female','US',166,65,'Sweeper',1,13,1),
    ('Thomas','A','Rivera','Tommy','1989-05-25','Male','US',179,77,'Thrower',11,14,1),
    ('Barbara','B','Kelly','Barb','1994-06-15','Female','US',160,57,'Catcher',6,14,1),
    ('Henry','C','Howard','Hank','1987-07-20','Male','US',182,81,'Defender',4,14,1),
    ('Susan','D','Ward','Sue','1991-08-25','Female','US',170,70,'Sweeper',1,14,1),
    ('Kevin','E','Torres','Kev','1985-09-30','Male','US',185,83,'Thrower',10,15,1),
    ('Jessica','F','Nguyen','Jessie','1990-10-15','Female','US',165,65,'Catcher',7,15,1),
    ('Brian','G','Hernandez','Gonzo','1988-11-10','Male','US',177,78,'Defender',3,15,1),
    ('Maria','H','Chavez','Ria','1992-12-05','Female','US',168,72,'Sweeper',1,15,1),
    ('Matthew','I','Jimenez','Mattie','1989-01-20','Male','US',180,79,'Thrower',11,16,1),
    ('Amanda','J','Maldonado','Mandy','1994-02-25','Female','US',162,56,'Catcher',6,16,1),
    ('Joshua','K','Rios','Joshy','1986-03-22','Male','US',179,75,'Defender',4,16,1),
    ('Nicole','L','Morales','Nikki','1991-04-18','Female','US',165,64,'Sweeper',1,16,1),
    ('Ryan','M','Gonzalez','Rye','1988-05-05','Male','US',182,82,'Thrower',10,17,1),
    ('Emily','N','Reyes','Em','1993-06-15','Female','US',170,69,'Catcher',8,17,1),
    ('David','O','Cruz','Dave','1987-07-10','Male','US',175,74,'Defender',5,17,1),
    ('Jessica','P','Ortega','Jess','1992-08-25','Female','US',160,58,'Sweeper',1,17,1),
    ('Michael','Q','Nieves','Mike','1983-09-10','Male','US',185,80,'Thrower',9,18,1),
    ('Sarah','R','Soto','Sadie','1995-10-05','Female','US',163,67,'Catcher',7,18,1),
    ('Matthew','S','Salazar','Matt','1986-11-20','Male','US',178,76,'Defender',4,18,1),
    ('Amanda','T','Pena','Mandy','1991-12-15','Female','US',165,65,'Sweeper',1,18,1),
    ('William','U','Hernandez','Will','1985-01-10','Male','US',183,79,'Thrower',10,19,1),
    ('Elizabeth','V','Mendoza','Liz','1990-02-20','Female','US',161,60,'Catcher',8,19,1),
    ('James','W','Castillo','Jimmy','1988-03-15','Male','US',176,72,'Defender',3,19,1),
    ('Mary','X','Vasquez','Polly','1992-04-25','Female','US',169,68,'Sweeper',1,19,1),
    ('Charles','Y','Delgado','Charlie','1984-05-30','Male','US',181,78,'Thrower',10,20,1),
    ('Patricia','Z','Jimenez','Pat','1993-06-15','Female','US',164,63,'Catcher',7,20,1),
    ('Joseph','A','Mora','Joe','1986-07-10','Male','US',178,75,'Defender',4,20,1),
    ('Linda','B','Salinas','Lin','1991-08-20','Female','US',166,66,'Sweeper',1,20,1),
    ('Thomas','C','Bermudez','Tommy','1989-09-25','Male','US',179,80,'Thrower',11,21,1),
    ('Barbara','D','Paredes','Barb','1994-10-15','Female','US',160,58,'Catcher',6,21,1),
    ('Henry','E','Rojas','Hank','1987-11-20','Male','US',182,82,'Defender',4,21,1),
    ('Susan','F','Cordero','Sue','1991-12-25','Female','US',170,70,'Sweeper',1,21,1),
    ('Kevin','G','Torres','Kev','1985-01-30','Male','US',185,85,'Thrower',10,22,1),
    ('Jessica','H','Lopez','Jessie','1990-02-15','Female','US',165,65,'Catcher',7,22,1),
    ('Brian','I','Martinez','Gonzo','1988-03-10','Male','US',177,78,'Defender',3,22,1),
    ('Maria','J','Hernandez','Ria','1992-04-20','Female','US',168,72,'Sweeper',1,22,1),
    ('Matthew','K','Salinas','Mattie','1989-05-25','Male','US',180,79,'Thrower',11,23,1),
    ('Amanda','L','Maldonado','Mandy','1994-06-15','Female','US',162,56,'Catcher',6,23,1),
    ('Joshua','M','Rios','Joshy','1986-07-20','Male','US',179,75,'Defender',4,23,1),
    ('Nicole','N','Morales','Nikki','1991-08-18','Female','US',165,64,'Sweeper',1,23,1),
    ('Ryan','O','Gonzalez','Rye','1988-09-15','Male','US',182,82,'Thrower',10,24,1),
    ('Emily','P','Reyes','Em','1993-10-10','Female','US',170,69,'Catcher',8,24,1),
    ('David','Q','Cruz','Dave','1987-11-05','Male','US',175,74,'Defender',5,24,1),
    ('Jessica','R','Ortega','Jess','1992-12-20','Female','US',160,58,'Sweeper',1,24,1),
    ('Michael','S','Nieves','Mike','1983-12-10','Male','US',185,80,'Thrower',9,25,1),
    ('Sarah','T','Soto','Sadie','1995-01-05','Female','US',163,67,'Catcher',7,25,1),
    ('Matthew','U','Salazar','Matt','1986-02-20','Male','US',178,76,'Defender',4,25,1),
    ('Amanda','V','Pena','Mandy','1991-03-15','Female','US',165,65,'Sweeper',1,25,1)
END
GO