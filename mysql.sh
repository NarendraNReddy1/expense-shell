#!/bin/bash
USER_ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
echo "Please enter DB password:"
read -s mysql_root_password


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
VALIDATE $? "Installation of mysql server"    




systemctl enable mysqld  &>>$LOG_FILE
VALIDATE $? "enablment of mysqld"


systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Start of mysqld"



# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
# VALIDATE $? "setting of mysql password"

#Idempotency

mysql -h db.narendra.shop -uroot -p${mysql_root_password} -e 'show databases' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password}
    VALIDATE $? "MySQL root password setup"
else
    echo -e "mySQL root password is already setup $Y SKIPPING $N "
    

fi        
