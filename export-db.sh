#!/bin/bash

# Load environment variables from .env file
set -o allexport
source .env.export
set +o allexport

# Check if a database name was provided as a parameter
if [ -z "$1" ]; then
    echo "Please provide the database name as a parameter."
    exit 1
fi

# Export the specified MySQL database
mysqldump -h "$MYSQL_DB_HOST" -u "$MYSQL_DB_USERNAME" -p"$MYSQL_DB_PASSWORD" --port="$MYSQL_DB_PORT" "$1" --set-gtid-purged=OFF > "$1".sql

echo "Database '$1' exported to $1.sql"