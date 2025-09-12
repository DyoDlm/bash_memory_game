
#test_argv() {
#	echo $BASH_ARGV
#	if [[ $BASH_ARGV == "foo" ]] ; then
#		echo yey
#	else
#		echo unvalid param
#	fi
#
#	export score=0
#	export line=""
#	echo "score set to : " $score
#}

export command_line=""
export number_to_guess=0
export players=0
export scores=0
export activ_player=0

display_header() {	# argument is header title
	echo "////////////////////////////"
	echo "////	" $@ "	////"
	echo "///////////////////////////"
}

display_end_game() {
	clear
	display_header "END GAME"
	echo final score : $score
}

display_commands() {
	echo write '1' to play a single game
	echo write '2' for multiplayer mode
	echo write '3' to compose a config file
	echo 
	echo write '4' to get back to your game
	echo
	echo sig_int or write '5' to exit program
}

timer() {
	export time=0
	while [[ true ]]
	do
		sleep 1
		((time++))
		if ((time > 10)) ; then 
			display_end_game
			export game_status=0
		fi
	done	
}

log_and_print_data() {
	$@ > player$activ_player.log
	cat player$activ_player.log
}

set_number() {	# argument is difficulty lvl
	export lvl=0
	export compare=0

	export number_to_guess=$RANDOM
	
	while [[ $lvl != $compare ]]
	do
		if [[ 1 ]] ; then
			echo set number
		else
			echo set another number
		fi
		((compare++))
	done
}

create_player() {
	echo creating new player
}

menu() {
	clear
	display_header "MENU    "
	echo
	display_commands
	trap exit INT
	echo Enter your action here :
	read -e command_line
	if (( command_line == 1)) ; then 
		echo start single game
	fi
	if ((command_line == 2)) ; then
		echo start multiplayer game
	fi
	if (( command_line == 3)) ; then
		echo create config file
	fi
	if (( command_line == 4 )) ; then
		echo go back to the game
	fi
	if (( command_line == 5 )) ; then 
		echo exiting game...
		exit
	fi
}

game() {
	display_header "BIENVENUE"
	export i=0
	trap "menu" INT
	echo sig_int to enter menu
	export game_status=1
	timer &
	while [[ true ]]
	do
		if ((game_status == 0)) ; then
			exit
		fi
		((i++))
		set_number
		echo $number_to_guess
		sleep 1
		clear ; display_header "ROUND " $i
		echo "what number was it ?"
		read -e $line
		sleep 1
		echo "Line is : " $REPLY
		echo response was : $number_to_guess
		if [[ $REPLY == $number_to_guess ]] ; then
			(( score+=1 ))
			echo well done !
		else
			echo too bad...
		fi
		sleep 1

		log_player $i $score
		echo "new score : " $score
		sleep 1
		echo ready ?
		sleep 1
		echo ...
		sleep 1
		clear
	done
}

save_digits() {
	echo $@ | tr -cd [:digit:] > tmp_digits
}

extract_digits() {
	cat tmp_digits
	rm tmp_digits
}

game
