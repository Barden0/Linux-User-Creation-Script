#!/bin/bash

# Check if the correct number of arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <groups>"
    exit 1
fi

USERNAME=$1
GROUPS=$2

# Log file path
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Ensure the log and password files exist
touch $LOG_FILE
mkdir -p /var/secure
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Function to generate a random password
generate_password() {
    openssl rand -base64 12
}

# Check if the user already exists
if id -u $USERNAME >/dev/null 2>&1; then
    log_message "User $USERNAME already exists. Skipping."
    exit 0
fi

# Create the user and personal group
useradd -m -G $USERNAME $USERNAME
if [ $? -eq 0 ]; then
    log_message "User $USERNAME created successfully."
else
    log_message "Failed to create user $USERNAME."
    exit 1
fi

# Set up home directory permissions
chmod 700 /home/$USERNAME
chown $USERNAME:$USERNAME /home/$USERNAME
log_message "Home directory for $USERNAME set up with correct permissions."

# Add user to additional groups
IFS=',' read -ra GROUP_LIST <<< "$GROUPS"
for GROUP in "${GROUP_LIST[@]}"; do
    GROUP=$(echo $GROUP | xargs)
    if ! getent group $GROUP >/dev/null 2>&1; then
        groupadd $GROUP
        log_message "Group $GROUP created."
    fi
    usermod -aG $GROUP $USERNAME
    log_message "User $USERNAME added to group $GROUP."
done

# Generate and set a random password for the user
PASSWORD=$(generate_password)
echo "$USERNAME:$PASSWORD" | chpasswd
log_message "Password for $USERNAME set."

# Store the username and password in the secure file
echo "$USERNAME,$PASSWORD" >> $PASSWORD_FILE

exit 0
