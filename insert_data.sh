#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT  WINNER_GOAL OPPONENT_GOAL
do
  if [[ $WINNER != 'winner' ]]
  then
    NAME_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $NAME_ID ]]
    then
      INSERT_NAME_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_NAME_ID == 'INSERT 0 1' ]]
      then
        echo "$WINNER INSERTED"
      fi
    fi
  fi

  if [[ $OPPONENT != 'opponent' ]]
  then
    NAME_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $NAME_ID ]]
    then
      INSERT_NAME_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_NAME_ID == 'INSERT 0 1' ]]
      then
        echo "$OPPONENT INSERTED"
      fi
    fi
  fi

  if [[ $OPPONENT != 'opponent' ]]
  then
    WINNER_GOAL_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_GOAL_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_goals=$WINNER_GOAL AND opponent_goals=$OPPONENT_GOAL AND winner_goals=$WINNER_GOAL_ID AND opponent_goals=$OPPONENT_GOAL_ID")
    if [[ -z $GAME_ID ]]
    then
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_GOAL_ID, $OPPONENT_GOAL_ID, $WINNER_GOAL, $OPPONENT_GOAL)")

      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo "INSERTED $YEAR"
      fi
    fi
  fi
done
