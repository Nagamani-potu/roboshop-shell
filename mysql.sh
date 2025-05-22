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
    if [ $1 -ne 0 ]
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

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "Disabling current mysql"

cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "copying mysql repo"

dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "installing mysql server"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "Enabling mysql"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "Starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "Setting mysql root password"
