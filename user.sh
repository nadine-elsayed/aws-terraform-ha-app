#!/bin/bash
apt update -y
apt install -y nginx mysql-client jq

if ! command -v aws &> /dev/null
then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install
fi

SECRET=$(aws secretsmanager get-secret-value --secret-id nadine-rds-secret --region eu-north-1 --query SecretString --output text)
DB_USER=$(echo $SECRET | jq -r .username)
DB_PASS=$(echo $SECRET | jq -r .password)
DB_HOST=${db_host}

mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e "CREATE DATABASE IF NOT EXISTS testdb; USE testdb; CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(50));"

echo "Hello from Nadine!" > /var/www/html/index.html
