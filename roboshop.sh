#!/bin/bash

AMI_ID="ami-0b4f379183e5706b9"
SG_ID="sg-07891a5d518ef74be"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping" "payment" "web")

for i in "${INSTANCES[@]}"
do
  if [ "$i" == "mongodb" ] || [ "$i" == "shipping" ] || [ "$i" == "mysql" ]; then
    INSTANCE_TYPE="t3.small"
  else
    INSTANCE_TYPE="t2.micro"
  fi

  IP_ADDRESS=(aws ec2 run-instances --image-id ami-0b4f379183e5706b9 --instance-type $INSTANCE_TYPE --security-group-ids sg-07891a5d518ef74be --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
  --query 'Instances[0].PrivateIpAddress' --output text)
    echo "$i: $IP_ADDRESS"
done



