menu() {
    echo "Menu"
    echo "1. Retour au menu"
    echo "2. Quitter la partie"
    read -e -n 1 action
    
    case "$action" in
        "1" ) option=continue ;;
        "2" ) exit ;;
        * ) echo "Option invalide. Please try again." ;;
    esac
}

menu
