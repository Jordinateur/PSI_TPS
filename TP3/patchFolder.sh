#! /bin/bash
function diffOnDir {
	for fromFile in $1*; do
		printf "loop on $fromFile \n"
		if [ -d $fromFile ]; then
			printf "test existance on $2$(basename $fromFile) \n"
			if ! [ -d $2$(basename $fromFile) ]; then
				printf "create $2$(basename $fromFile) \n"
				mkdir $2$(basename $fromFile)
			fi
			printf "recall on $1$(basename $fromFile) $2$(basename $fromFile) \n"
			diffOnDir $1$(basename $fromFile)/ $2$(basename $fromFile)/
		else
			printf "file compared $1$(basename $fromFile) --- $2$(basename $fromFile) \n"
			if [ -e $2$(basename $fromFile) ];then
				if [ $1$(basename $fromFile) -nt $2$(basename $fromFile) ];then
					touch diff_$(basename $fromFile)
					diff $1$(basename $fromFile) $2$(basename $fromFile) > diff_$(basename $fromFile)
					patch -R $2$(basename $fromFile) < diff_$(basename $fromFile)
					rm diff_$(basename $fromFile)
				fi
			else
				cp $1$(basename $fromFile) $2$(basename $fromFile)
			fi
		fi
	done
}


if [ $# -ne 2 ]; then
	exit 1
fi
if ! [ -d $1 ]; then
	echo "$1 not a directory"
	exit 3
fi
if ! [ -d $2 ]; then
	if [ -e $2 ]; then
		echo "$2 already exist and is a file"
		exit 2
	else
		mkdir $2
	fi
fi;
FromPath=$(pwd .)/$1
ToPath=$(pwd .)/$2
printf "$FromPath <-- 1 Dir \n"
printf "$ToPath <-- 2 Dir \n"
diffOnDir $FromPath $ToPath

