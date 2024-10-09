#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Truncate the table
$PSQL "TRUNCATE TABLE games,teams;"

# Insert unique teams from the games.csv
while IFS="," read -r year round winner opponent winner_goals opponent_goals;do
  if [[ $year != "year" ]]; then # Skip header
    # Check and insert team if it doesn't exist
    winner_exists=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner';")
    if [[ -z $winner_exists ]]; then
      $PSQL "INSERT INTO teams(name) VALUES ('$winner');"
    fi

    # Check and insert opponet if it doesn't exsits
    opponent_exists=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent';")
    if [[ -z $opponent_exists ]]; then
      $PSQL "INSERT INTO teams (name) VALUES ('$opponent');"
    fi
  fi
done < ./games.csv

# Insert data from games.csv
while IFS="," read -r year round winner opponent winner_goals opponent_goals;do
  if [[ $year != "year" ]]; then # Skip header
    # Get team IDs
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner';")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent';")

    # Insert the game data
    $PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($year, '$round',$winner_id,$opponent_id,$winner_goals,$opponent_goals);"
  fi
done < ./games.csv
    
