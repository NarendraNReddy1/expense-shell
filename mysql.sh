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



dnf install mysql-server -y &>>$LOG_FILE

if [ $? -eq 0 ]
then 
    echo -e "mysql already installed $Y SKIPPING $N"
else
    VALIDATE $? "Installation of mysql server"    
fi



systemctl enable mysqld  &>>$LOG_FILE
VALIDATE $? "enablment of mysqld"


systemctl start mysqld &>>$LOG_FILE
VALIDATE ?$ "Start of mysqld"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
VALIDATE ?$ "setting of mysql password"
