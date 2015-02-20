#!/bin/bash

if [ $# -eq 4 ]
	then
	wget -O banque --header="User-Agent: Mozilla/5.0 (Windows NT 6.0) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11" --header="Referer: Hello" "http://www.banque-france.fr/fileadmin/user_upload/banque_de_france/Economie_et_Statistiques/Changes_et_Taux/2.csv"
	clear
	echo Fichier mis a jour
fi
if [ $# -eq 1 ] & [ $1 = "-v" ]
	then
	echo "Liste des monnaies"
	echo $(head -n 8 banque | tail -n 1 | cut -d';' -f 2- | tr ';' '\n')
fi
if [ $# -gt 4 ] | [ $# -lt 2 ]
then
	exit 1 
fi
if [ $1 = $3 ]
	then
	echo "$2 $(echo $1 | tr '[:lower:]' '[:upper:]') = $2 $(echo $1 | tr '[:lower:]' '[:upper:]')"
	exit 0
fi

head -n 8 banque | tail -n 1 | tr ';' '\n' > pays
tail -n 1 banque | tr ';' '\n' > money
paste pays money > final
echo Mise a jour du $(head -n 1 money)
rm money
rm pays


pays=$(grep -i $1 final | cut -f2 | tr ',' '.')

if [ $# -eq 3 ]
then
pays_f=$(grep -i $3 final | cut -f2 | tr ',' '.')
fi
rm final
valeur_int=$(bc -l <<< "$2/$pays")

if [ $# -eq 2 ]
then 
	echo "$2 $(echo $1 | tr '[:lower:]' '[:upper:]') = $(echo $valeur_int | sed 's/\([0-9]\{1,\}\)\.\([0-9][0-9]\)*/\1,\2/') EUR "
	exit 0
fi

valeur_final=$(bc -l <<< "$valeur_int*$pays_f")
echo "$2 $(echo $1 | tr '[:lower:]' '[:upper:]') = $(echo $valeur_final | sed 's/\([0-9]\{1,\}\)\.\([0-9][0-9]\)*/\1,\2/') $(echo $3 | tr '[:lower:]' '[:upper:]') "

exit 0

