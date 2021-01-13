#!/bin/bash
# DEPLOYER ------ PINET Marc S1T-G5
# Spécial COVID-19
# Utilisation du fichier : ./deployer.sh --local | -l <local_path> [--poste | -p <poste>] [--salle | -s <salle>] --distant | -d <distant_path>
# /!\ Utilisez le fichier ajoutersalle.sh pour pouvoir utiliser correctement l'option --salle;
# /!\ La variable d'environnement $REP_SALLES doit être définie afin que le programme fonctionne correctement.
REP_SALLES="."
localpath="" ; distantpath="" ; salle="" ; poste="" ; logpath="" ; verbose="" ; aide=1 ; compatible=0 ; sallevalide=0 ;
# L'astuce ici est de ne pas avoir à mettre de if pour la verbose, mais de simplement mettre $verbose dans toutes les commandes scp afin de 
# garantir, selon le choix de l'utilisateur, le respect de l'argument (par défaut, vide donc aucun impact tandis que si oui, alors cette variable
# aura comme valeur la valeur "-v" ce qui mettra automatiquement tous les scp de ce programme en mode verbose). 

while [[ $# -gt 0 ]] ; do 
# Tant que le nombre d'argument n'est pas égal à 0
    case $1 in
        "-l" | "--local" ) localpath=$2
        # On test chaque argument et on  shift de 2 pour décaler les arguments et enlever ceux déjà analysés (pour terminer le while)
            shift 2 ;;

        "-d" | "--distant" ) distantpath=$2
            shift 2 ;;

        "-s" | "--salle" ) salle=$2
            # On test si le -p ou le -s ont été rentrés tous les deux (si oui, on exit car erreur, ces deux options sont incompatibles)
            # Code d'erreur = 2
            if [[ $compatible -eq  1 ]] ; then
                echo "$0: Erreur: Impossible de rentrer à la fois les options -s et -p !"
                exit 2
            fi
            compatible=1
            shift 2 ;;

        "-p" | "--poste" ) poste=$2
            # On test si le -p ou le -s ont été rentrés tous les deux (si oui, on exit car erreur, ces deux options sont incompatibles)
            # Code d'erreur = 2
            if [[ $compatible -eq  1 ]] ; then
                echo "$0: Erreur: Impossible de rentrer à la fois les options -s et -p !"
                exit 2
            fi
            compatible=1
            shift 2 ;;

        "-v" | "--verbose" ) verbose="-v"
            # On ne shiftera qu'une seule fois ici car aucun argument ne covient à cette option
            shift ;;

        "-h" | "--help" ) aide=0
            shift ;;

        "-L" | "--log" ) logpath=$2
            shift 2 ;;

        * ) echo "$0: Erreur: $1 = Paramètre illégal."
            exit 2 
    esac
done

# Choix personnel : si l'option -h ou --help est intégrée avec d'autres fonctions, je ne veux pas que la commande s'exécute. 
# Je veux que seule l'aide d'utilisation de la commande se montre, rien de plus.
if [[ $aide -eq 0 ]] ; then
    # Il s'agit là d'une "template" d'aide de commande Linux (je me suis servi de celle de la commande "ls --help" et j'ai traduit quelques morceaux)
    echo "Usage: deployer -l <local_path> [-p <poste>] [-s <salle>] -d <distant_path>

Les arguments obligatoires pour les options longues sont également obligatoires pour les options courtes.

  -l | --local      chemin du fichier ou de l'arborescence local(e).
  -d | --distant    chemin du fichier ou de l'arborescence distant(e).
  -s | --salle      nom de la salle cible vers laquelle déployer (e.g. « linserv-info »).
  -p | --poste      nom du/des poste(s) cible(s) vers le(s)quel(s) déployer (e.g. « linserv-info-{01,03,11} »)..
  -v | --verbose    affiche les actions réalisées durant le processus.
  -L | --log        stock les actions effectuées dans le chemin du fichier fourni en argument.
  -h | --help       affiche l'aide.

Les arguments, pour certains, ne sont pas optionnels (voir usage).
Les arguments --poste et --local sont incompatibles.

État de sortie:
 0  si OK,
 1  si problème mineur (e.g., impossible d'accèder à un fichier/répértoire),
 2  si sérieux problème (e.g., impossible de lire un argument)." ; exit 0

else

    if [ -z $poste ] && [ -n "$localpath" ] && [ -n "$distantpath" ] ; then
        # nom de la salle cible vers laquelle déployer, depuis local (e.g. « linserv-info »).
        while read p ; do
            # Je préfère utiliser le read que le grep car plus intuitif
            if [[ -z $logpath ]] ; then
                if [[ $p == $salle* ]] ; then
                    # Si aucune salle n'a été trouvée, alors la variable sallevalide restera vide et un message d'erreur sera renvoyé.
                    sallevalide=1
                    # Note: pour les scp, j'ai choisi l'option de facilité en les rendant tous "récursifs" grâce ) l'option -r
                    # Toutefois, cela n'a aucun impacte sur l'utilisation de la commande, ni-même du déplacement de fichiers ou de dossier (tout marche)
                    scp -r $verbose $localpath $p:~/$distantpath
                fi
            else
                if [[ $p == $salle* ]] ; then
                    sallevalide=1
                    # Le &> signifie que cela va rediriger TOUTES les sorties.
                    scp -r $verbose $localpath $p:~/$distantpath &> $logpath
                fi
            fi
        done < "$REP_SALLES"/FICHIER-DES-SALLES

        if [[ $sallevalide -eq 0 ]] ; then
            echo "$0: Erreur: $salle n'est pas une salle correcte (ou n'a pas été enregistrée dans \$REP_SALLES.)"
            exit 1
        fi

    elif [ -z $salle ] && [ -n "$localpath" ] && [ -n "$distantpath" ] ; then
        # nom du poste cible vers lequel déployer, depuis local (e.g linserv-info-01)
        if [[ -z $logpath ]] ; then
            scp -r $verbose $localpath $poste:~/$distantpath
        else
            scp -r $verbose $localpath $poste:~/$distantpath &> $logpath
        fi

    else
        # Aucun traitement possible si poste ou salle n'est pas rempli(e).
        echo "$0: Erreur: Impossible d'effectuer cette action (opérande ou argument manquant)." 
        echo "Veillez aussi à rentrer soit --poste soit --salle mais pas les deux !"
        exit 2
    fi

fi

exit 0
