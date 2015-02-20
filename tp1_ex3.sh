#!/bin/bash


#wget "http://www.banque-france.fr/fileadmin/user_upload/banque_de_france/Economie_et_Statistiques/Changes_et_Taux/2.csv" > banque

if [ $# -gt 3 ] | [ $# -lt 2 ]
then
	exit 1 
	echo
fi

head -n 8 banque | tail -n 1 | tr ';' '\n' > pays

tail -n 1 banque | tr ';' '\n' > money

paste pays money > final


pays=$(grep -i $1 final | cut -f2 | tr ',' '.')

if [ $# -eq 3 ]
then
pays_f=$(grep -i $3 final | cut -f2 | tr ',' '.')
fi

valeur_int=$(bc -l <<< "$2/$pays")
echo "$#"

if [ $# -eq 2 ]
then 
	echo " $1 = $valeur_int eur "
	exit 0
fi

valeur_final=$(bc -l <<< "$valeur_int*$pays_f")

echo " $1 = $valeur_final $3 "

exit 0

