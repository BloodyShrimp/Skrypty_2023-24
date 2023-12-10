#!/bin/bash

save_file="save.txt"

board=()

# Clear the Tic Tac Toe board
clear_board()
{
    for i in {0..8}
    do
        board[$i]="$i"
    done
}

# Display the Tic Tac Toe board
display_board()
{
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "---|---|---"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "---|---|---"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
}


check_winner()
{
    local symbol=$1

    #Check rows and columns
    for i in {0..2}
    do
        if [ "${board[$((i*3))]}" == "$symbol" ] && [ "${board[$((i*3 + 1))]}" == "$symbol" ] && [ "${board[$((i*3 + 2))]}" == "$symbol" ]
        then
            return 0
        fi

        if [ "${board[$i]}" == "$symbol" ] && [ "${board[$((i + 3))]}" == "$symbol" ] && [ "${board[$((i + 6))]}" == "$symbol" ]
        then
            return 0
        fi
    done

    #Check diagonals
    if [ "${board[0]}" == "$symbol" ] && [ "${board[4]}" == "$symbol" ] && [ "${board[8]}" == "$symbol" ]
    then
        return 0
    fi

    if [ "${board[2]}" == "$symbol" ] && [ "${board[4]}" == "$symbol" ] && [ "${board[6]}" == "$symbol" ]
    then
        return 0
    fi

    return 1
}

# Check if the board is full
check_draw()
{
    for i in {0..8}
    do
        if [ "${board[$i]}" == "$i" ]
        then
            return 1
        fi
    done

    return 0
}

# Computer's move (random)
computer_move()
{
    local empty_cells=()

    for i in {0..8}
    do
        if [ "${board[$i]}" == "$i" ]
        then
            empty_cells+=($i)
        fi
    done

    if [ ${#empty_cells[@]} -eq 0 ]
    then
        return
    fi

    local random_index=$((RANDOM % ${#empty_cells[@]}))
    local computer_choice=${empty_cells[$random_index]}
    board[$computer_choice]="X"
}

save_game()
{
    echo "${board[@]}" > "$save_file"
}

load_game()
{
    if [ -f "$save_file" ]
    then
        read -r -a board < "$save_file"
    else
        echo "No saved game found."
        sleep 2
    fi
}

while true
do
    clear
    clear_board
    display_board

    echo "1. New Game"
    echo "2. Load Game"
    echo "3. Quit"
    read -r choice

    case $choice in
        1)
            clear_board
            ;;
        2)
            load_game
            ;;
        3)
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, or 3."
            sleep 2
            continue
            ;;
    esac

    while true
    do
        clear
        display_board

        echo "Enter your move (0-8) or 's' to save the game: "
        read -r human_choice

        if [ "$human_choice" == "s" ]
        then
            save_game
            echo "Game saved successfully."
            sleep 2
            break
        fi

        if [ "${board[$((human_choice))]}" == "$human_choice" ]
        then
            board[$((human_choice))]="O"

            if check_winner "O"
            then
                clear
                display_board
                echo "You win. Congratulations!"
                sleep 2
                break
            fi

            if check_draw
            then
                clear
                display_board
                echo "It's a draw."
                sleep 2
                break
            fi

            computer_move

            if check_winner "X"
            then
                clear
                display_board
                echo "Computer wins!"
                sleep 2
                break
            fi

        else
            echo "Invalid move. Cell already taken. Try again."
            sleep 2
        fi

    done
done