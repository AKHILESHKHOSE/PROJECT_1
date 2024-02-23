#Overview
Welcome to the final project - Sports Analytics using SQL! In this project, we will delve into the exciting world of sports analytics, focusing specifically on the Indian Premier League (IPL) cricket matches. We have been provided with two datasets: one containing ball-by-ball data and the other containing match-wise data.

Our task is to import these datasets into an SQL database and analyze them to extract valuable insights and trends from the IPL matches.

About the Data
Please download the datasets by clicking here and ensure they are ready before we begin our analysis.

# Ball-by-Ball Data
The first CSV file contains ball-by-ball data, encompassing information on all 193,468 balls bowled between the years 2008 and 2020. It comprises 17 columns, each providing specific details about the ball bowled. Here's a brief overview of the columns:

id: Unique identifier for the ball
inning: Inning number
over: Over number
ball: Ball number within the over
batsman: Name of the batsman facing the ball
non_striker: Name of the non-striker batsman
bowler: Name of the bowler
batsman_runs: Runs scored by the batsman
extra_runs: Extra runs conceded
total_runs: Total runs scored off the ball
is_wicket: Indicates if a wicket fell (1 for yes, 0 for no)
dismissal_kind: Type of dismissal, if applicable
player_dismissed: Name of the dismissed player
fielder: Name of the fielder involved in the dismissal
extras_type: Type of extra run conceded
batting_team: Name of the batting team
bowling_team: Name of the bowling team

#Match-wise Data
The second file contains match-wise data, comprising information on 816 IPL matches. It also consists of 17 columns, providing insights into each IPL match. Here's a brief overview of the columns in this table:

id: Unique identifier for the match
city: City where the match was played
date: Date of the match
player_of_match: Player of the match
venue: Venue where the match was held
neutral_venue: Indicates if the match was held at a neutral venue (1 for yes, 0 for no)
team1: First team participating in the match
team2: Second team participating in the match
toss_winner: Team winning the toss
toss_decision: Decision taken by the team winning the toss (batting/fielding)
winner: Winning team of the match
result: Result of the match (e.g., runs, wickets, tie)
result_margin: Margin of victory (in runs or wickets)
eliminator: Indicates if the match involved an eliminator round
method: Method used to determine the result
umpire1: Name of the first umpire
umpire2: Name of the second umpire

#License
This project is licensed under the terms of the MIT license. Feel free to use and modify the code as per your requirements.

