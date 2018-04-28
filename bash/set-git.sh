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
	shift
done

if [[ $User ]]
then
	git config --global user.name "${User}"
fi

if [[ $Email ]]
then
	git config --global user.email "${Email}"
fi

git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=2678400'
