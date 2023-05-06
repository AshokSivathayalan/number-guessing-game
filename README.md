# number_guessing_game

A game where users guess a number between 1 and 1000. User's best games and number of games played are tracked by username using a PostgreSQL database.

Created for freeCodeCamp's Relational Databases course.

## Database

Users - Stores a user's best game and number of games played, according to a unique username

To create database, run 'psql -U postgres < number_guess.sql'

## Script

Allows users to play the guessing game. First asks for their username, then runs the game, then updates statistics on the database.

To play game, run './number_guess.sh'
 
