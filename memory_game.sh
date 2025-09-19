
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


log_player() {
	echo player actions logged
}

set_number() {	# argument is round

	export compare=0
	export number_to_guess=$RANDOM

#	export incr=1
#	if [[ $1 == 2 ]] ; then 
#		echo lets go faster
#		export incr=0.5
#	fi

	if [[ $i > 5 ]] ; then
		((number_to_guess+=330000))
		((number_to_guess+=123455))
	fi
	echo $number_to_guess
#	while [[ $lvl != $compare ]]
#	do
#		if [[ $@ > 2 ]] ; then
#			echo set number
#			n
#		else
#			echo set another number
#		fi
#		((compare++))
#	done
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
		game cat player1Log.config
	fi
	if ((command_line == 2)) ; then
		for ((i = 0; i < $players; i++)) do
			game cat player"$i"Log.config | grep name
		done
		echo start multiplayer game
	fi
	if (( command_line == 3)) ; then
		echo create a new player
		create_player 3
	fi
	if (( command_line == 4 )) ; then
		echo go back to the game
		echo not implemented...
	fi
	if (( command_line == 5 )) ; then 
		echo exiting game...
		exit
	fi
}

log_action() {	# arguments : action player_nb
	echo action logged
}

game() {	# arguments : player_nb

	display_header "BIENVENUE"
	export i=0
	export timer=60
	trap "menu" INT
	echo sig_int to enter menu
	export game_status=1
	while [[ true ]]
	do
		if ((game_status == 0)) ; then
			break		
		fi
		((i++))
		((timer--))
		set_number $1
		if [[ $i > 3 ]] ; then
			sleep 0.5
		else
			sleep 1
		fi
		echo $number_to_guess
		sleep 
		clear ; display_header "ROUND " $i
		echo "what number was it ?"
		read -e $line
		sleep 1
		echo "Line is : " $REPLY
		echo response was : $number_to_guess
		if [[ $REPLY == $number_to_guess ]] ; then
			(( score+=1 ))
			log_action $1
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

ask() {
	echo The question : $1 
	echo Do some animation
	read -e question
	export $2=$question
}

create_player() {
	echo creating player $@
	ask "Enter a player name" "player"
	file="playerLog$@.config"
	data="//////playerLOG nb $@//////////"
	echo $data > $file
	echo "score : 0" >> $file
	echo "player name : $player" >> $file
	
#cat playerLog$@.config
}

#	intro
while [[ true ]]
do
	display_header "INTRO / CONFIG"
	echo how many playser ?
	
	read -e ask
	case "$ask" in
		"1") export players=1;; # explicit errir
		"2") export players=2 ;;
		"3") export players=3 ;;
		*) echo bad response, maximum players : 4; break ;;
	esac
	break
done

#	create players
for i in {1..4}
do
	echo creating new player
	if (( i > $players)) ; then
		break
	fi
	create_player $i
done

clear ; menu

#	launch game
game 

