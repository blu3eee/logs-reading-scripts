#!/bin/bash

# Load environment variables from .env.import file
set -o allexport
source .env.import
set +o allexport

# Check if a database name was provided as a parameter
if [ -z "$1" ]; then
    echo "Please provide the database name as a parameter."
    exit 1
fi

# Check if the SQL file exists
if [ ! -f "$1.sql" ]; then
    echo "The file '$1.sql' does not exist."
    exit 1
fi

# Get the container ID of the MySQL container
MYSQL_CONTAINER_ID=$(docker ps | grep mysql | awk '{print $1}')

# Import the SQL file into the MySQL container
if docker exec -i "$MYSQL_CONTAINER_ID" mysql -u "$MYSQL_DB_USERNAME" -p"$MYSQL_DB_PASSWORD" "$1" --set-gtid-purged=OFF < "$1.sql"; then
    echo "Database '$1' imported successfully."
else
    echo "Error importing database '$1'."
    exit 1
fi