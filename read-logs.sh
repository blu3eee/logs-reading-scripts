#!/bin/bash

# Initialize default values
DATE=$(date +%m-%d-%y) # Default to current date
TARGET="" # Target subdirectory
FIND="" # Find string
READ_ALL=false # Flag to read all logs

# Function to show usage
usage() {
    echo "Usage: $0 [-a|--all] [--date|-d date] [--target|-t target] [--find|-f find]"
    echo "  -a, --all      Read all log files in the target subdirectory"
    echo "  --date, -d     Specify the date (format MM-DD-YY). Ignored if --all is used."
    echo "  --target, -t   Specify the target subdirectory (e.g., 'bluetick/bot' or 'twitch')"
    echo "  --find, -f     Search for a string within the log files"
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--all)
            READ_ALL=true
            shift
            ;;
        -d|--date)
            DATE="$2"
            shift 2
            ;;
        -t|--target)
            TARGET="$2"
            shift 2
            ;;
        -f|--find)
            FIND="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

# Define log directory base path
LOG_DIR_BASE="/home/admin/logs"

# Check target directory
if [[ -z "$TARGET" ]]; then
    echo "Target subdirectory is required."
    usage
fi

# Function to read logs
read_logs() {
    local dir_path="$LOG_DIR_BASE/$1"
    local log_date="$2"
    local find_str="$3"
    local log_files=("$dir_path/${log_date}.log")

    if [[ "$READ_ALL" == "true" ]]; then
        log_files=($(find "$dir_path" -type f -name "*.log"))
    fi

    for log_file in "${log_files[@]}"; do
        if [[ -n "$find_str" ]]; then
            grep -- "$find_str" "$log_file" || echo "No matches found in $log_file."
        else
            cat "$log_file"
        fi
    done
}

# Call read_logs with the specified or default parameters
read_logs "$TARGET" "$DATE" "$FIND"
