#!/bin/bash
#
# This script implements a guessing game
# it will pick a secret number from 1 to 10
# it will then repeatedly ask the user to guess the number
#    until the user gets it right

# Give the user instructions for the game
cat <<EOF
Let's play a game.
I will pick a secret number from 1 to 10 and you have to guess it.
If you get it right, you get a virtual prize.
Here we go!

EOF

# Pick the secret number and save it
secretnumber=$(($RANDOM % 10 +1)) # save our secret number to compare later

# This loop repeatedly asks the user to guess and tells them if they got the right answer
# TASK 1: Test the user input to make sure it is not blank
# TASK 2: Test the user input to make sure it is a number from 1 to 10 inclusive
# TASK 3: Tell the user if their guess is too low, or too high after each incorrect guess

userguess=0 #set dummy variable

while [ $userguess != $secretnumber ]; do # ask repeatedly until they get it right

  read -p "Give me a number from 1 to 10: " userguess # ask for another guess

    if [ -z $userguess ]; then
	echo "Input cannot be blank"
	userguess=0 #set dummy variable to prevent error
	continue #goto start of while loop

    elif [ $userguess -gt 10 ] || [ $userguess -lt 1 ]; then
	echo "You must guess an number between 1 and 10, inclusive"
	continue #goto start of while loop

    elif [ $userguess = $secretnumber ]; then
	break #guess is correct, end loop

    elif [ $userguess -lt $secretnumber ]; then
	echo "Guess higher!"

    else
	echo "Guess lower!"
    fi

done

echo "You got it! Have a milkdud."

#script end.
