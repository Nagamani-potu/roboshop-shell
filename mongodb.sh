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
    if [ $1 -ne 0 ]
    then 
       echo -e "ERROR:: $2 ...$R is failed $N"
       exit 1
    else 
      echo -e " $2 ...$G is success $N"
    fi
}
if [ $ID -ne 0 ]
then
   echo -e " $R ERROR::please run with root access"
   exit 1
else
   echo -e "$ you are root user"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copied mongodb repo"

dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "installing mongodb" 

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "Enabling mongodb"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "Start mangodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Remote access to mongodb"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarting Mongodb"
