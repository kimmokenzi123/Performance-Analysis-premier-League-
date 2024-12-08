SELECT * 
FROM matches;

-- Match Performance Analysis

--1. What is the win, loss, and draw record of the team for the 2022 season? 
--(Check goals scored vs. goals conceded)
--  GF : Goals scored 
-- GA:   Goals Concelead 
-- 

--  win : when GF > GA
--  Loss : when GF < GA
-- Draw  : When GF = GA 

-- get the win, loss, and draw record for the 2022 season:

SELECT 
    SUM(CASE WHEN GF > GA THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN GF < GA THEN 1 ELSE 0 END) AS Losses,
    SUM(CASE WHEN GF = GA THEN 1 ELSE 0 END) AS Draws
FROM matches
WHERE Season = '2022';
-- Goals Scoring Efficiency
--How does the team’s Goals For (GF) compare to Expected Goals (xG)
--across all matches? Are they overperforming or underperforming their xG?

-- compare the team’s Goals For (GF) with their Expected Goals (xG) and determine
--whether they are overperforming or underperforming, 
-- calculate the difference between these two metrics for each match and then aggregate the results

SELECT 
    SUM(GF) AS TotalGoalsFor,
    SUM(xG) AS TotalExpectedGoals,
    SUM(GF - xG) AS PerformanceDifference,
    CASE 
        WHEN SUM(GF - xG) > 0 THEN 'Overperforming'
        WHEN SUM(GF - xG) < 0 THEN 'Underperforming'
        ELSE 'On par with xG'
    END AS PerformanceStatus
FROM matches;

-- Interpretation:
--If PerformanceDifference is positive, the team is scoring more goals than expected (overperforming).
--If PerformanceDifference is negative, the team is scoring fewer goals than expected (underperforming).
--If the difference is 0, the team is performing exactly as expected.

-- 3. Defensive Analysis
-- How does the team’s Goals Against (GA) compare to Expected Goals Against (xGA)? 
--Are they conceding more or fewer goals than expected?

SELECT 
    SUM(GA) AS Total_GA,
    SUM(xGA) AS Total_xGA,
    SUM(GA) - SUM(xGA) AS Difference,
    CASE 
        WHEN SUM(GA) < SUM(xGA) THEN 'Conceding Fewer Goals Than Expected'
        WHEN SUM(GA) > SUM(xGA) THEN 'Conceding More Goals Than Expected'
        ELSE 'Conceding Expected Goals'
    END AS Goal_Comparison
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City';

--4 . Home vs Away Performance

-- analyze Manchester City's performance at home versus away in terms of wins, 
--goals scored, and goals conceded, 
--you can use the following SQL query

SELECT 
    Venue,
    COUNT(*) AS Total_Matches,
    SUM(CASE WHEN GF > GA THEN 1 ELSE 0 END) AS Wins,
    SUM(GF) AS Total_Goals_Scored,
    SUM(GA) AS Total_Goals_Conceded
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    Venue;
--5 . Possession-based Performance
-- Is there a correlation between higher Possession (Poss%) and match outcomes (win/draw/loss)?

--analyze the correlation between higher possession (Poss%) and match outcomes (win/draw/loss) 
--for Manchester City,
--you can use the following SQL query. This query will categorize the match outcomes and
-- calculate the average possession percentage for each outcome:

SELECT 
    CASE 
        WHEN GF > GA THEN 'Win'
        WHEN GF < GA THEN 'Loss'
        ELSE 'Draw'
    END AS Match_Outcome,
    AVG(Poss) AS Average_Possession
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    CASE 
        WHEN GF > GA THEN 'Win'
        WHEN GF < GA THEN 'Loss'
        ELSE 'Draw'
    END;

--6 : Shooting Efficiency
-- What is the team's shooting accuracy? (Compare Shots (Sh) to Shots on Target (SOT))

-- analyze Manchester City's shooting accuracy by comparing total shots (Sh) to shots on target (SOT),
--  we can use the following SQL query.

SELECT 
    SUM(Sh) AS Total_Shots,
    SUM(SOT) AS Total_Shots_On_Target,
    CASE 
        WHEN SUM(Sh) = 0 THEN 0
        ELSE (SUM(SOT) * 100.0 / SUM(Sh)
        ) END AS Shooting_Accuracy_Percentage
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City';

-- Explanation of the Query:
-- Total_Shots: Sums the total number of shots taken by Manchester City
-- Total_Shots_On_Target: Sums the total number of shots on target.
-- Shooting_Accuracy_Percentage: Calculates the shooting accuracy
--percentage of shots on target relative to total shots.
-- It checks to avoid division by zero by returning 0 if there are no shots.

-- 7. Penalty Kick Analysis
--What is the team’s success rate for penalty kicks? (Compare PK and PKatt) ?

-- analyze Manchester City's success rate for penalty kicks by comparing successful penalty kicks 
--(PK) to total penalty kick attempts (PKatt)

SELECT 
    SUM(PK) AS Total_Successful_Penalties,
    SUM(PKatt) AS Total_Penalty_Attempts,
    CASE 
        WHEN SUM(PKatt) = 0 THEN 0
        ELSE (SUM(PK) * 100.0 / SUM(PKatt)) 
    END AS Penalty_Success_Rate_Percentage
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City';
--8 .  top opponanats 
-- Against which opponents did the team struggle the most, based on goals conceded and losses?
-- identify the opponents against whom Manchester City struggled the most based 
--on goals conceded and losses,
--This will group the results by opponent and summarize the number of losses and goals conceded.

SELECT 
    Opponent,
    COUNT(CASE WHEN GF < GA THEN 1 END) AS Losses,
    SUM(GA) AS Total_Goals_Conceded
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    Opponent
ORDER BY 
    Losses DESC, Total_Goals_Conceded DESC;

-- additional question 
--retrieve all matches between Manchester City and Liverpool 
--in the year 2022, including wins, losses, and draws

SELECT 
    Date,
    Time,
    Comp AS Competition,
    Round,
    Venue,
    Opponent,
    GF AS Goals_For,
    GA AS Goals_Against,
    CASE 
        WHEN GF > GA THEN 'Win'
        WHEN GF < GA THEN 'Loss'
        ELSE 'Draw'
    END AS Match_Result
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City' AND 
    Opponent = 'Liverpool';

--9 . Captain’s Impact
--How does the team’s performance vary based on different captains for the match?
-- analyze how Manchester City's performance varies based on different captains 
--in the matches for the year 2022
-- This will summarize the performance metrics for each captain:

SELECT 
    Captain,
    COUNT(*) AS Total_Matches,
    SUM(CASE WHEN GF > GA THEN 1 END) AS Wins,
    SUM(CASE WHEN GF < GA THEN 1 END) AS Losses,
    SUM(CASE WHEN GF = GA THEN 1 END) AS Draws,
    SUM(GF) AS Total_Goals_Scored,
    SUM(GA) AS Total_Goals_Conceded,
    AVG(Poss) AS Average_Possession
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    Captain
ORDER BY 
    Total_Matches DESC;


--Captain: Groups the results by each captain
--Total_Matches: Counts the total number of matches played under each captain.
-- Wins, Losses, Draws: Counts the number of wins, losses, and draws for each captain.
--Total_Goals_Scored: Sums the total goals scored when each captain was playing.
--Total_Goals_Conceded: Sums the total goals conceded
-- Average_Possession: Calculates the average possession percentage for matches led by each captain
-- ORDER BY: Sorts the results by the total number of matches in descending order.
--  10 .Formation Effect
--Does the team perform better with specific formations? (e.g., formation vs win rate)?

-- analyze whether Manchester City performs better with specific formations 
-- by calculating the win rate for each formation 

SELECT 
    Formation,
    COUNT(*) AS Total_Matches,
    SUM(CASE WHEN GF > GA THEN 1 END) AS Wins,
    CAST(SUM(CASE WHEN GF > GA THEN 1 END) AS FLOAT) / COUNT(*) * 100 AS Win_Rate_Percentage
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    Formation
ORDER BY 
    Win_Rate_Percentage DESC;

-- Explination 
-- Formation: Groups the results by each formation used.
-- Total_Matches: Counts the total number of matches played with each formation.
-- Wins: Counts the number of matches won with each formation
-- Win_Rate_Percentage: Calculates the win rate as a percentage by dividing the
-- number of wins by the total matches and multiplying by 100
-- ORDER BY: Sorts the results by win rate in descending order

-- 11. Referee Analysis
-- Is there any relationship between the referees officiating the matches and the team's performance?

-- This will summarize match outcomes and performance metrics for each referee

SELECT 
    Referee,
    COUNT(*) AS Total_Matches,
    SUM(CASE WHEN GF > GA THEN 1 END) AS Wins,
    SUM(CASE WHEN GF < GA THEN 1 END) AS Losses,
    SUM(CASE WHEN GF = GA THEN 1 END) AS Draws,
    SUM(GF) AS Total_Goals_Scored,
    SUM(GA) AS Total_Goals_Conceded,
    AVG(Poss) AS Average_Possession
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    Referee
ORDER BY 
    Total_Matches DESC;

-- 12. Attendance Impact

-- Does higher attendance correlate with better team performance at home?
-- analyze whether higher attendance correlates with better team performance at home for Manchester City,
--This will summarize home matches, attendance, and performance metrics:

SELECT 
    Attendance,
    COUNT(*) AS Total_Matches,
    SUM(CASE WHEN GF > GA THEN 1 END) AS Wins,
    SUM(CASE WHEN GF < GA THEN 1 END) AS Losses,
    SUM(CASE WHEN GF = GA THEN 1 END) AS Draws,
    SUM(GF) AS Total_Goals_Scored,
    SUM(GA) AS Total_Goals_Conceded,
    AVG(Poss) AS Average_Possession
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City' AND 
    Venue = 'Home'
GROUP BY 
    Attendance
ORDER BY 
    Attendance DESC;

-- 13. Distance Covered Analysis
-- How does the total distance covered (Dist) by the team 
--in each match affect the match outcome (win/draw/loss)?    

-- analyze how the total distance covered (Dist) by Manchester City 
--in each match affects the match outcome (win/draw/loss)

SELECT 
    CASE 
        WHEN GF > GA THEN 'Win'
        WHEN GF < GA THEN 'Loss'
        ELSE 'Draw'
    END AS Match_Result,
    AVG(Dist) AS Average_Distance_Covered,
    COUNT(*) AS Total_Matches
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    CASE 
        WHEN GF > GA THEN 'Win'
        WHEN GF < GA THEN 'Loss'
        ELSE 'Draw'
    END
ORDER BY 
    Match_Result;

-- Explaination
-- Match_Result: Classifies each match as a 'Win', 'Loss', or 'Draw' based 
--on goals scored and conceded.

-- Average_Distance_Covered: Calculates the average distance covered in matches for each outcome.
-- Total_Matches: Counts the total number of matches for each result category
-- GROUP BY: Groups the results by match outcome
--ORDER BY: Sorts the results by match outcome

-- 14. Seasonal Analysis
-- Which month in the 2022 season was the most successful 
--for the team in terms of wins and goals scored?
-- determine which month in the 2022 season was the most successful for Manchester City
-- in terms of wins and goals scored.

SELECT 
    MONTH(Date) AS Match_Month,
    COUNT(*) AS Total_Matches,
    SUM(CASE WHEN GF > GA THEN 1 END) AS Wins,
    SUM(GF) AS Total_Goals_Scored
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    MONTH(Date)
ORDER BY 
    Wins DESC, Total_Goals_Scored DESC;

-- 15 . Opponent’s Expected Goals Comparison
-- Compare the team’s xGA against opponents’ xG. Were they able to restrict 
--opponents from achieving their expected goal tally?    

-- compare Manchester City's expected goals against (xGA) with their opponents'
-- expected goals (xG) in the 2022 season
--This will help you determine if Manchester City was able to restrict opponents 
--from achieving their expected goal tally:

SELECT 
    Opponent,
    SUM(xG) AS Opponent_xG,
    SUM(xGA) AS Manchester_City_xGA,
    CASE 
        WHEN SUM(xG) > SUM(xGA) THEN 'Exceeded Expected Goals'
        WHEN SUM(xG) < SUM(xGA) THEN 'Restricted Opponents'
        ELSE 'Met Expected Goals'
    END AS Goal_Tally_Comparison
FROM 
    matches
WHERE 
    Season = 2022 AND 
    Team = 'Manchester City'
GROUP BY 
    Opponent
ORDER BY 
    Opponent;

