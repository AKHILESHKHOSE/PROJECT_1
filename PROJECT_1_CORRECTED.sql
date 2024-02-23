--  PROJECT NAME: SPORT-ANALYTICS 
--  LANGUAGE :   SQL(structured Query Language)
/*  
  PROJECT DESCRIPTION:  
  					
  The Project aims to draw valuable INSIGHTS 
  like BEST PERFORMING TEAM,PLAYERS AND  DATA MANIPULAION IF
  FOUND INCORRECT. 
  
*/
--1
--CREATING 'matches' TABLE IN A NON-PUBLIC SCHEMA 'myschema'  WITH REQUIRED FIELDS MENTIONED IN PROJECT_STATEMENT
CREATE TABLE myschema.matches (
    id bigint PRIMARY KEY,
    city varchar,
    date date,
    player_of_match varchar,
    venue varchar,
    neutral_venue int,
    team1 varchar,
    team2 varchar,
    toss_winner varchar,
    toss_decision varchar,
    winner varchar,
    result varchar,
    result_margin int,
    eliminator varchar,
    method char(15),
    umpire1 varchar,
    umpire2 varchar
);

SELECT * FROM myschema.matches;

--2

--CREATING 'deliveries' TABLE IN A NON-PUBLIC SCHEMA 'myschema'  WITH REQUIRED FIELDS MENTIONED IN PROJECT_STATEMENT
-- VERIFICATION
CREATE TABLE myschema.deliveries (
    id bigint,
    FOREIGN KEY (id) REFERENCES myschema.matches,
    inning smallint,
    over smallint,
    ball smallint,
    batsman char(50),
    non_striker char(50),
    bowler char(50),
    batsman_runs int,
    extra_runs smallint,
    total_runs int,
    is_wicket smallint,
    dismissal_kind char(20),
    player_dismissed char(50),
    fielder char(50),
    extras_type char(50),
    batting_team char(50),
    bowling_team char(50)
);

SELECT * FROM myschema.deliveries;

---STEP 3

--IMPORT DATA FROM CSV FILES AND VERIFYING
--3
COPY myschema.matches FROM 'C:\Program Files\PostgreSQL\16\data\PROJECT_INTERNHSALA\IPL_matches.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM myschema.matches;


SELECT * FROM myschema.deliveries;

--4
COPY myschema.deliveries FROM 'C:\Program Files\PostgreSQL\16\data\PROJECT_INTERNHSALA\IPL_Ball.csv' DELIMITER ',' CSV HEADER;


--ALTER COMMAND IS USED TO RE-DEFINE DATATYPE OF dismissal_kind to char(50) 
--as for some data the length exceeded and then COPY AGAIN

ALTER TABLE myschema.deliveries ALTER COLUMN dismissal_kind TYPE char(50);


--5
--FIRST 20 MATCHES THAT WERE PLAYED IN IPL
SELECT * FROM myschema.matches AS a ORDER BY a.id, a.date LIMIT 20;

SELECT * FROM myschema.deliveries WHERE id=335982 order by inning,over,ball;
--6
--FIRST 20 BALLS OF THE 1st GAME

SELECT * FROM myschema.deliveries AS a ORDER BY a.id, a.inning, a.over, a.ball LIMIT 20;

SELECT * FROM myschema.matches order by id,date;
--7
--NO. OF MATCHES PLAYED ON MAY 2nd 2013
SELECT * FROM myschema.matches WHERE date = '2013-05-02';

--8
--TEAMS WINNING THE MATCHES ON BASIS OF 'RUNS > 100'
SELECT DISTINCT * FROM myschema.matches WHERE result = 'runs' AND result_margin > 100;

--9
--TIED MATCHES ORDER BY DATE DESC ORDER
SELECT * FROM myschema.matches WHERE winner = 'NA' ORDER BY date DESC;

SELECT * FROM myschema.matches WHERE result='tie' and date='2020-10-18;



--10
--COUNT OF CITIES HOSTING IPL MATCHES

SELECT COUNT(DISTINCT city) AS NO_OF_HOST_CITY FROM myschema.matches;


--NEW TABLE WITH NEW COLUMN AS ball_result

SELECT * FROM myschema.deliveries;

--11
CREATE TABLE myschema.deliveries_v02 AS 	
SELECT
    deliveries.*,
    CASE
        WHEN extra_runs + total_runs = 0 THEN 'dot'
        WHEN extra_runs + total_runs = 1 THEN 'single'
        WHEN extra_runs + total_runs = 2 THEN 'double'
        WHEN extra_runs + total_runs = 3 THEN 'triple'
        ELSE 'boundary'
    END AS ball_result
FROM
    myschema.deliveries;	
	

SELECT * FROM myschema.deliveries_v02;

--12
--FIND TOTAL NO. OF BOUNDARIES and dot balls in all the matches

SELECT  ball_result, COUNT(ball_result) FROM myschema.deliveries_v02 GROUP BY ball_result;

--13
-- TEAM WISE BOUNDARIES DESCENDING ORDER

SELECT batting_team, ball_result, COUNT(ball_result) FROM myschema.deliveries_v02 WHERE ball_result = 'boundary' GROUP BY batting_team, ball_result ORDER BY COUNT(ball_result) DESC;


--14
--TEAM WISE DOT BALLS DESCENDING ORDER

SELECT bowling_team, ball_result, COUNT(ball_result) FROM myschema.deliveries_v02 WHERE ball_result = 'dot' GROUP BY bowling_team, ball_result ORDER BY COUNT(ball_result) DESC;



--15
--TOTAL DISMISSALS WHERE KIND IS NOT NA
SELECT COUNT(dismissal_kind) FROM myschema.deliveries WHERE dismissal_kind != 'NA' ;


--16
--TOP 5 BOWLERS 

SELECT * FROM myschema.deliveries;

SELECT bowler, SUM(is_wicket) AS TOTAL_WICKETS FROM myschema.deliveries WHERE dismissal_kind != 'run out' GROUP BY bowler ORDER BY SUM(is_wicket) DESC LIMIT 5;


SELECT bowler, SUM(extra_runs) AS TOTAL_WICKETS FROM myschema.deliveries WHERE dismissal_kind != 'run out' GROUP BY bowler ORDER BY SUM(extra_runs) DESC LIMIT 5;


--17
--CREATE deliveries_v03 with all data of deliveries_v02 and
--with venue and match_date

CREATE TABLE myschema.deliveries_v03 AS
SELECT a.*, b.venue, b.date FROM myschema.deliveries_v02 AS a INNER JOIN myschema.matches AS b ON a.id = b.id;



--18
--TOTAL RUNS SCORED FOR EACH VENUE IN DESCENDING ORDER OF RUNS FROM deliveries_v03 

SELECT venue, SUM(total_runs) AS TOTAL_RUNS FROM myschema.deliveries_v03 GROUP BY venue ORDER BY SUM(total_runs) DESC;


--19
--YEAR WISE RUNS AT EDEN GARDEN IN DESCENDING ORDER

SELECT venue, date, SUM(total_runs) AS TOTAL_RUNS FROM myschema.deliveries_v03 WHERE venue = 'Eden Gardens' GROUP BY venue, date ORDER BY SUM(total_runs) DESC;


--20
--CORRECT TEAM NAME RISING PUNE SUPERGIANTS 
SELECT * FROM myschema.matches;


CREATE TABLE matches_corrected AS
SELECT *, REPLACE(team1, 'Supergiant', 'Supergiants') AS team1_corr, REPLACE(team2, 'Supergiant', 'Supergiants') AS team2_corr FROM myschema.matches;


--21
--COMBINE MATCH_ID, INNING, OVER, BALL SEPARATED BY  '-'

SELECT * FROM myschema.deliveries_v03;

CREATE TABLE myschema.deliveries_v04 AS
SELECT id || '-' || inning || '-' || over || '-' || ball AS ball_id, batsman, non_striker, bowler, batsman_runs, extra_runs, total_runs,
is_wicket, dismissal_kind, player_dismissed, fielder, extras_type, batting_team, bowling_team, ball_result, venue, date  FROM myschema.deliveries_v03 ;

--OR

CREATE TABLE myschema.deliveries_v04 AS
SELECT CONCAT(id,'-',inning,'-',over,'-',ball) AS ball_id, batsman, non_striker, bowler, batsman_runs, extra_runs, total_runs,
is_wicket, dismissal_kind, player_dismissed, fielder, extras_type, batting_team, bowling_team, ball_result, venue, date  FROM myschema.deliveries_v03 ;


--22
--TOTAL COUNT OF ROWS AND TOTAL BALL_ID COMPARISON FROM deliveries_v04
SELECT COUNT(DISTINCT ball_id) FROM myschema.deliveries_v04;


SELECT COUNT(ball_id) FROM myschema.deliveries_v04;


--23
--USE ROW_NUMBER() FUNCTION TO ASSIGN UNQIUE NO. TO EACH 
--ROW
CREATE TABLE myschema.deliveries_v05 AS
SELECT ROW_NUMBER() OVER(PARTITION BY ball_id) AS r_num, a.* FROM myschema.deliveries_v04 AS a;


--24
--INSTANCES WHERE BALL_ID IS REPEATING
SELECT * FROM myschema.deliveries_v05 WHERE r_num = 2;

--25
--DATA OF REPEATING BALL_ID

SELECT * FROM myschema.deliveries_v05 WHERE ball_id IN (SELECT BALL_ID FROM myschema.deliveries_v05 WHERE r_num = 2);
