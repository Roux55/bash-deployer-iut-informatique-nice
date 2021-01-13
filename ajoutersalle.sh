#! /bin/bash
# /!\ La variable d'environnement $REP_SALLES doit être définie afin que le programme fonctionne correctement.

REP_SALLES="."
if [[ $# -ne 3 ]] ; then 
    echo "Syntaxe : $0 <nom_salle> <numero_debut> <numero_fin>"
    exit 2
fi

if [[ ! -d $REP_SALLES ]] ; then 
    echo '$REP_SALLES absente ou incorrecte'
    exit 2
fi

if [[ $2 -gt 99 || $3 -gt 99 ]] ; then 
    echo "Le numéro des postes doit être situé entre 0 et 99 !"
    exit 2
fi

for NB in $(seq $2 $3) ; do
    if [[ $NB -le 9 ]] ; then
        echo ${1}-0$NB

    else 
        echo $1-$NB
   fi
done >> $REP_SALLES/FICHIER-DES-SALLES