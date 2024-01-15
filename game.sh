#!/bin/bash

# Initialize player and food positions
player_x=5
player_y=5
food_x=0
food_y=0

# Player state and symbols
player_states=(':-)' ':-D' 'X_X')
player_state=0

# Game area size
area_width=20
area_height=20

# Randomly place food
place_food() {
    food_x=$(( RANDOM % area_width + 1 ))
    food_y=$(( RANDOM % area_height + 1 ))
    food_type=$(( RANDOM % 3 ))
}

# Change player state based on food
change_player_state() {
    player_state=$food_type
    if [[ $player_state -eq 2 ]]; then
        sleep 1 # Pause for a second if bad food is eaten
    fi
}

# Place food initially
place_food

# Game loop
while true; do
    clear

    # Draw game area
    for ((y=1; y<=area_height; y++)); do
        for ((x=1; x<=area_width; x++)); do
            if [[ $x -eq $player_x && $y -eq $player_y ]]; then
                echo -n ${player_states[$player_state]}
            elif [[ $x -eq $food_x && $y -eq $food_y ]]; then
                case $food_type in
                    0) echo -n '@';;
                    1) echo -n '$';;
                    2) echo -n '#';;
                esac
            else
                echo -n "."
            fi
        done
        echo
    done

    echo "Use W A S D to move. Q to quit."

    # Read user input
    read -n 1 -s key

    case $key in
        [Ww]) if [[ $player_y -gt 1 ]]; then player_y=$((player_y - 1)); fi;;
        [Ss]) if [[ $player_y -lt $area_height ]]; then player_y=$((player_y + 1)); fi;;
        [Aa]) if [[ $player_x -gt 1 ]]; then player_x=$((player_x - 1)); fi;;
        [Dd]) if [[ $player_x -lt $area_width ]]; then player_x=$((player_x + 1)); fi;;
        [Qq]) exit;;
    esac

    # Check if player gets the food
    if [[ $player_x -eq $food_x && $player_y -eq $food_y ]]; then
        change_player_state
        place_food
    fi
done
