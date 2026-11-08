#!/bin/bash
VERT="\e[32m"
ROUGE="\e[31m"
JAUNE="\e[33m"
RESET="\e[0m"
 
# Vérifier que nmap est bien installé
if ! command -v nmap &> /dev/null
then
    echo -e "${ROUGE}Erreur : nmap n'est pas installé.${RESET}"
    echo "Installe-le avec : sudo apt install nmap"
    exit 1
fi
 
# Fonction pour afficher le menu
afficher_menu() {
    echo ""
    echo "=============================="
    echo "   SCANNER RESEAU - NMAP"
    echo "=============================="
    echo "1) Scan rapide (ping scan - voir les machines actives)"
    echo "2) Scan des ports ouverts (scan standard)"
    echo "3) Scan des ports + détection de version des services"
    echo "4) Scan de vulnérabilités basique (script vuln de nmap)"
    echo "5) Scan complet (ports + versions + OS + vuln)"
    echo "6) Quitter"
    echo "=============================="
}
 
# Demander la cible (IP, plage ou nom de domaine)
demander_cible() {
    read -p "Entre la cible à scanner (ex: 192.168.1.1 ou 192.168.1.0/24) : " CIBLE
    if [ -z "$CIBLE" ]
    then
        echo -e "${ROUGE}Tu dois entrer une cible valide.${RESET}"
        CIBLE=""
    fi
}
 
# Boucle principale du script
while true
do
    afficher_menu
    read -p "Choisis une option (1-6) : " CHOIX
 
    case $CHOIX in
        1)
            demander_cible
            if [ -n "$CIBLE" ]; then
                echo -e "${JAUNE}Lancement du scan rapide sur $CIBLE...${RESET}"
                nmap -sn "$CIBLE"
            fi
            ;;
        2)
            demander_cible
            if [ -n "$CIBLE" ]; then
                echo -e "${JAUNE}Scan des ports ouverts sur $CIBLE...${RESET}"
                nmap "$CIBLE"
            fi
            ;;
        3)
            demander_cible
            if [ -n "$CIBLE" ]; then
                echo -e "${JAUNE}Scan des ports + versions des services sur $CIBLE...${RESET}"
                nmap -sV "$CIBLE"
            fi
            ;;
        4)
            demander_cible
            if [ -n "$CIBLE" ]; then
                echo -e "${JAUNE}Scan de vulnérabilités basique sur $CIBLE...${RESET}"
                echo "(Cela peut prendre un peu de temps)"
                nmap -sV --script vuln "$CIBLE"
            fi
            ;;
        5)
            demander_cible
            if [ -n "$CIBLE" ]; then
                echo -e "${JAUNE}Scan complet sur $CIBLE (ports, versions, OS, vulnérabilités)...${RESET}"
                echo "(Cela peut prendre plusieurs minutes)"
                sudo nmap -sV -O --script vuln "$CIBLE"
            fi
            ;;
        6)
            echo -e "${VERT}A bientôt !${RESET}"
            exit 0
            ;;
        *)
            echo -e "${ROUGE}Option invalide, choisis un chiffre entre 1 et 6.${RESET}"
            ;;
    esac
 
    echo ""
    read -p "Appuie sur Entrée pour revenir au menu..."
done
