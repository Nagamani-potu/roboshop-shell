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

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "Removing unwanted content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "Downloading web application"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "Chnaging the directory"

unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "Unzipping the application"

cp /home/centos/roboshop-shell/roboshop.config /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "Copying to roboshop reverse proxy config"

systemctl restart nginx  &>> $LOGFILE
VALIDATE $? "Restarting nginx"

