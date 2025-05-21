#!/bin/bash
ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Scripting started executing at $TIMESTAMP"  &>> $LOGFILE

VALIDATE(){
    if [ $? -ne 0 ]
    then 
       echo -e "ERROR:: $2 ...$R is failed $N"
    else 
      echo -e " $2 ...$G is success $N"
    fi
}
if [ $ID -ne 0 ]
then
   echo -e "ERROR:: $R please run with root access"
   exit 1
else
   echo -e "$ $G you are root user"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copied mongodb repo"
