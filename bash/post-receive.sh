#!/usr/bin/env bash

Id=`id`
Mask=`umask`

ProjectName='kenx'
Repository="/home/git/${ProjectName}.git"
DeployDir="/var/www/${ProjectName}"
User="www-data"
Group="www-data"

echo "------- Starting Git Hook [Auto Deployment] -------"

echo "Now we're going to deploy project [$ProjectName]"
echo "This project's working directory is \"$TempDir\""
echo "And then it will deploy to \"$DeployDir\""

if [[ ! -w "$DeployDir" ]]
then
# 部署位置有问题
    echo "** Directory \"$DeployDir\" can not write, please check..."
else
    echo "I am user[`whoami`] and [$Id]"
    echo "Now the mask is $Mask"

    if [[ $MASK != '0002' ]]
    then
        umask 0002
        echo 'umask change to 0002!'
    fi

    # 现在进入主目录
    cd $DeployDir
    echo "Now we are in \"`pwd`\""

    unset GIT_DIR
    if [[ ! -d ".git" ]]
    then
        echo "++ It seems we don't got git here, so we clone one..."
        git clone "$Repository" "$DeployDir"
        git pull origin master
    fi

    echo "Fetch all......"
    git fetch --all
    echo "Reset....."
    git reset --hard origin/master
    chown ${User} ./* -Rf
    chgrp ${Group} ./* -Rf
    echo "Update at `date`"
fi

echo "------- Git Hook End [Auto Deployment] -------"
