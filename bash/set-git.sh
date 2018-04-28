#!/bin/bash

User=
Email=

while getopts 'u:e:' opt
do
	case $opt in
		u)
		User=$OPTARG
		;;
		e)
		Email=$OPTARG
		;;
		?)
		echo "Usage: `basename $0` [-u user] [-e email]"
		;;
	esac
done

shift $(($OPTIND-1))

if [[ $User ]]
then
	echo "Set User($User) to global settings."
	git config --global user.name "${User}"
fi

if [[ $Email ]]
then
	echo "Set Email($Email) to global settings."
	git config --global user.email "${Email}"
fi

git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=2678400'


git config --list --global

#eof
