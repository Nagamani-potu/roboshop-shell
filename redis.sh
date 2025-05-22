#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.5.rpm -y &>> $LOGFILE
VALIDATE $? "Installing remi relase file"

dnf module reset redis -y &>> $LOGFILE
VALIDATE $? "Resetting redis module"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "Enabling redis module"

dnf install redis -y &>> $LOGFILE
VALIDATE $? "Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "adding remote access"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "enabling redis"

systemctl start redis &>> $LOGFILE
VALIDATE $? "Starting redis"

systemctl status redis &>> $LOGFILE
VALIDATE $? "To check status of redis"