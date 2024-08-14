#!/bin/bash
USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"



VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 
    else 
        echo -e "$2...$G SUCCESS $N"    

    fi
}

if [ $USER_ID -ne 0 ]
then
    echo "Please be a super user"
    exit 1
else 
    echo "You are super user" 
fi 

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Node JS disable" 

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Nodejs enable" 

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installation of nodejs" 


id expense &>>$LOG_FILE
if [ $? -ne 0 ]
then 
    echo "user already exists $Y SKIPPING $N"
else 
     useradd expense &>>$LOG_FILE
     VALIDATE $? "user add expense"
fi       



# mkdir /app &>>$LOG_FILE
# VALIDATE $? "Installation of mysql server" 

# curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
# VALIDATE $? "Installation of mysql server" 

# cd /app &>>$LOG_FILE
# VALIDATE $? "Installation of mysql server"  

# unzip /tmp/backend.zip &>>$LOG_FILE
# VALIDATE $? "Installation of mysql server" 


# cd /app &>>$LOG_FILE
# VALIDATE $? "Installation of mysql server" 

# npm install &>>$LOG_FILE
# VALIDATE $? "Installation of mysql server" 


