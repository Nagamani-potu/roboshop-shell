#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "sripting started executaion at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $? -ne 0 ]
    then 
       echo -e " $2 ... $R failed $N"
       exit 1
    else
       echo -e " $2 ... $G success $N"
    fi
}

if [ $ID -ne 0 ]
then
   echo -e " $R ERROR: Please run with root access $N"
   exit 1
else
   echo -e " $G You are a root user"
fi

dnf module disable mysql -y

