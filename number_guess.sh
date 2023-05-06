#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

#Function to allow users to track their games by username
LOGIN() {
  #Getting the username
  echo "Enter your username:"
  read USERNAME
  #Checking if the user has previously played games
  USERNAME_EXISTS=$($PSQL "SELECT username FROM users WHERE username = '$USERNAME';")
  if [[ -z $USERNAME_EXISTS ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    #Getting the user's statistics
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username = '$USERNAME';")
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME';")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
}

#Function to handle actual gameplay
PLAY_GAME() {
  #Generating the random number
  NUMBER=$(($RANDOM%1000+1));
  #Getting the user's guess
  echo "Guess the secret number between 1 and 1000:"
  read GUESS
  #Looping until they guess the correct number
  COUNT=1
  while [[ $GUESS != $NUMBER ]]
  do
    #Checking if the input was a number
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
    else
      #Determining what hint to give the user
      if [[ $GUESS -gt $NUMBER ]]
      then
        echo "It's lower than that, guess again:"
      else
        echo "It's higher than that, guess again:"
      fi
    fi
    #Reading in the next guess
    read GUESS
    COUNT=$(($COUNT + 1))
  done
  #Outputting result once user is done
  echo "You guessed it in $COUNT tries. The secret number was $NUMBER. Nice job!"
}

UPDATE_STATS() {
  #Checking if a new account needs to be made
  if [[ -z $USERNAME_EXISTS ]]
  then
    #Adding the user to the database
    ADD_USER_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 1, $COUNT);")
  else
    GAMES_PLAYED=$(($GAMES_PLAYED + 1))
    UPDATE_GAMES_RESULT=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username = '$USERNAME';")
    if [[ $COUNT -lt $BEST_GAME ]]
    then
      UPDATE_BEST_RESULT=$($PSQL "UPDATE users SET best_game = $COUNT WHERE username = '$USERNAME' AND best_game > $COUNT;")
    fi
  fi
}

LOGIN
PLAY_GAME
UPDATE_STATS