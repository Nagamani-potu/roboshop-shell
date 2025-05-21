#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST="mongodb.devopstraining.space"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Scripting started execution at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $? -ne 0 ]
    then 
       echo -e "$2 ...$R is failed $N"
       exit 1
    else
       echo -e "$2 ... $G is Success $N"
    fi
}

if [ $ID -ne 0 ]
then 
   echo -e "$R ERROR:: please run with root access $N"
   exit 1
else
    echo -e "$G you are a root user $N"
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabling cutrrent nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabling nodejs 18"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? " Installing nodejs"

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "creating roboshop user"
else
    echo -e "roboshop user already exist $Y Skipping $N"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "Create directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "Downloading the application"

cd /app &>> $LOGFILE
VALIDATE $? "Change directory"

unzip -o /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "Unzipping the application"

npm install &>> $LOGFILE
VALIDATE $? "Installing dependencies"

#use absolute path, becausee catalogue.service exists there
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? " Copied catalogue services"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Reloading deamon"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "Enabling catalogue"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? " Start catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? " Copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/catalogue.js
VALIDATE $? "loading catalogue data into mongodb"




