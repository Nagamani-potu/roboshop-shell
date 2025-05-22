#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MONGODB_HOST="mongodb.devopstraining.space"

echo "scripting started execution at $TIMESTAMP" &>> $LOGFILE

Validate(){
    if [ $? -ne 0 ]
then 
  echo -e " $2...$R failed $N"
  exit 1
else
   echo -e " $2 ...$G success $N"
fi
}

if [ $ID - ne 0 ]
then
   echo -e " $R ERROR:: Please run with root access $N"
   exit 1
else 
  echo -e " $G you are a root user"
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabling current nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabling nodejs"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing nodejs"

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "creating roboshop user"
else
    echo -e "roboshop user already exist $Y Skipping $N"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "Creating directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
VALIDATE $? "Downloading Application"

cd /app  &>> $LOGFILE
VALIDATE $? "Changing directory"

unzip -o /tmp/user.zip &>> $LOGFILE
VALIDATE $? "Unzipping the application"

npm install  &>> $LOGFILE
VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>> LOGFILE
VALIDATE $? "Copying user service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Reloading user deamon"

systemctl enable user &>> $$LOGFILE
VALIDATE $? "Enabling user"

systemctl start user &>> $LOGFILE
VALIDATE $? "Starting user"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copying mongodb repo to user"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing mongodb client"

mongo --host $MONGODB_HOST </app/schema/user.js &>> $LOGFILE
VALIDATE $? "loading user data into mongodb"