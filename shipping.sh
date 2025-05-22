#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
MYSQL_HOST="mysql.devopstraining.space"

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

dnf install maven -y &>> $LOGFILE
VALIDATE $? "Installing maven"

if [ $? -ne 0 ]
then 
   useradd roboshop
   VALIDATE $? "Creating roboshop user"
else
    echo -e "roboshop user already exist $Y Skipping $N" 
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "Creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
VALIDATE $? "Downloading shipping application"

cd /app &>> $LOGFILE
VALIDATE $? "change directory"

unzip -o /tmp/shipping.zip &>> $LOGFILE
VALIDATE $? "Unzipping the application"

mvn clean package &>> $LOGFILE
VALIDATE $? "installing dependenxies"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
VALIDATE $? "renaming jar file"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE
VALIDATE $? "Copying shipping services"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "Reloading the shipping deamon"

systemctl enable shipping &>> $LOGFILE
VALIDATE $? "Enabling the shipping"

systemctl start shipping &>> $LOGFILE
VALIDATE $? "Starting shipping"

dnf install mysql -y &>> $LOGFILE
VALIDATE $? "Installing mysql"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>> $LOGFILE
VALIDATE $? "Loading schema"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LOGFILE
VALIDATE $? "loading data to the user"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $LOGFILE
VALIDATE $? "loading data"

systemctl restart shipping &>> $LOGFILE
VALIDATE $? "Restarting the shipping"