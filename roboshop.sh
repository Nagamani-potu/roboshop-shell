#!/bin/bash

AMI_ID="ami-03265a0778a880afb"
SG_ID="sg-087e7afb3a936fce7"
INSTANCES=("mongodb", "redis", "mysql", "rabbitmq", "catalogue", "cart","user", "shipping", "payment", "web")

for -i in "{$INSTANCES[@]}"
do
   if [ $i == "mongodb" ] || [ $i == "shipping" ] || [ $i == "mysql" ]
   then
      INSTANCE_TYPE="t3.small"
    else
       INSTANCE_TYPE="t2.micro"
    fi

      aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-087e7afb3a936fce7 
done


