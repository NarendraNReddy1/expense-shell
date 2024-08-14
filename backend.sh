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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Node JS disable" 

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Nodejs enable" 

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Installation of nodejs" 


id expense &>>$LOG_FILE
if [ $? -eq 0 ]
then 
    echo -e "user already exists $Y SKIPPING $N"
else 
     useradd expense &>>$LOG_FILE
     VALIDATE $? "user add expense"
fi       



mkdir -p /app &>>$LOG_FILE
VALIDATE $? "App folder creation" 

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloading the code" 

cd /app &>>$LOG_FILE
VALIDATE $? "Moved to app directory"  

unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "Unzipping the code" 
/etc/systemd/system/backend.service


npm install &>>$LOG_FILE
VALIDATE $? "Installation of NPM" 

cp -rf /home/ec2-user/expense-shell/backend.service &>>$LOG_FILE
VALIDATE $? "Backend service copy" 


systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "Daemon Reload"

systemctl start backend &>>$LOG_FILE
VALIDATE $? "Start backend"

systemctl enable backend &>>$LOG_FILE
VALIDATE $? "Enable backend"

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "installation of mysql"

mysql -h db.narendra.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE $? "Schema Loading"

systemctl restart backend &>>$LOG_FILE
VALIDATE $? "Restarting backend"









