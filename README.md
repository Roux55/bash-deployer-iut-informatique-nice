# bash-deployer-iut-informatique-nice
M111 - Introduction aux systèmes informatiques

COVID SPECIAL - TP11 - Bash Project

This project was made by myself. Feel free to use it if you need it. It was made to work under l'IUT Informatique de Nice's network.

Here is the instructions that I had to use in order to make this project (it's in french) :
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Commande deployer : déployer une arborescence (*) locale sur une machine distante ou sur une série de machines distantes.
(*) : une arborescence peut se limiter à un seul fichier (ex : .bashrc, clé publique ssh, etc.).

Dans le cas où la commande s’adresse à une série de machines, deux méthodes sont prévues pour donner la ou
les machines concernées :
    a) Méthode « poste » - Le noms de la machine est donné en paramètre de la commande ;
    b) Méthode « salle » - Les noms des machines sont déduits du nom de la salle transmis en paramètre, la commande recherchant les noms de machine de la salle concernée dans un fichier décrivant en extension la composition des salles (syntaxe donnée plus loin).
    
Vous avez à votre disposition vos comptes Unix sur 3 serveurs linserv-info-01.campus.unice.fr, linserv-info03.campus.unice.fr et linserv-info-11.campus.unice.fr (i.e. linserv-info-{01,03,11}) pour effectuer vos différents tests à la place des postes de travail des salles de TD / TP.

Les notions de poste et de salle seront donc assimilées respectivement à un serveur local (e.g. linserv-info-01) et à un ensemble de serveurs distants (e.g. linserv-info-{01,03,11}).

Travail à rendre :
Chaque monôme doit réaliser une des trois commandes au choix et la commande de production
du fichier des salles ajoutersalle.sh (partiellement déjà réalisée). La répartition est fixée par l’enseignant.

Le répertoire du projet sur SupportCours contient une série de scripts qu’il convient de comprendre et d’exécuter avec succès avant de commencer le développement de la commande choisie.

NOM
 deployer – Déployer une arborescence locale ou un fichier sur une
machine distante ou sur une série de machines distantes
SYNOPSIS
 deployer [OPTION]...
DESCRIPTION
 Déployer une arborescence locale ou un fichier sur une machine distante
ou sur une série de machines distantes.
Il n’y a pas d’ordre dans les options. En cas de présence multiple, la
dernière (de gauche à droite) est prise en compte.
L’argument <salle> est incompatible avec l’argument <poste>.
Les options disponibles sont :
-l, --local <CHEMIN>
Indique l’arborescence ou le fichier à transférer.
-d, --distant <CHEMIN>
Indique le chemin où installer l’arborescence ou le fichier à transférer.
-p, --poste <NOM-POSTE> (e.g. {01, 03, 11}
Nom du poste cible.
-s, --salle <NOM-SALLE> (e.g. « linserv-info »)
Noms de la salle cible. Les noms des postes de la salle sont obtenus par
filtrage du fichier des salles nommé FICHIER-DES-SALLES dont le répertoire
d’accueil est indiqué par la variable d’environnement REP_SALLES.
Cf. commande <ajouterposte>.
-v, --verbose
Affiche les différentes étapes de la commande
-h, --help
Affiche un résumé du manuel de la commande
-L, --log <FICHIER-LOCAL>
Ecrit dans <FICHIER-LOCAL> tous les messages produits par la commande sur la
sortie standard locale et sur la sortie d’erreur locale. 
  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
