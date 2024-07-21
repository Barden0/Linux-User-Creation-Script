# Linux-User-Creation-Script

# User Creation Script

This repository contains a bash script, `create_users.sh`, that automates the process of creating new user accounts on a Linux system. The script reads a list of usernames and group names from a text file, creates the users, assigns them to groups, sets up their home directories, generates random passwords, and logs all actions.

## Features

- Creates users with personal groups.
- Assigns users to multiple groups.
- Sets up home directories with appropriate permissions.
- Generates random passwords for users.
- Logs all actions to `/var/log/user_management.log`.
- Stores generated passwords securely in `/var/secure/user_passwords.csv`.

## Requirements

- Linux system with bash shell.
- `openssl` for generating random passwords.
- Root or sudo privileges to create users and modify system files.

## Usage

### 1. Prepare the Input File

Create a text file with the usernames and groups formatted as `username;group1,group2,group3`. Each line should represent one user.

Example `users.txt`:
light; sudo,dev,www-data
idimma; sudo
mayowa; dev,www-data

### 2. Save and Make the Script Executable

Save the `create_users.sh` script in your preferred directory and make it executable:

```chmod +x create_users.sh```

### 3. Run the Script
Run the script with the input file as an argument:

```sudo ./create_users.sh users.txt```
Replace users.txt with the name of your input file.


### Script Explanation

#### Arguments and File Checks
The script begins by checking if an input file is provided and if it exists. If not, it exits with an error message.

#### Log and Password Files
The script creates and sets permissions for the log file (/var/log/user_management.log) and the password file (/var/secure/user_passwords.csv). The password file is secured so that only the root user can read it.

#### Main Processing Loop
The script reads the input file line by line, processes each user, and performs the following actions:

#### User and Group Creation:
Checks if the user already exists.
Creates the user and their personal group.
Sets up home directory permissions.
Group Assignments:

#### Assigns the user to additional groups.
Creates groups if they do not exist.
Password Generation:

#### Generates a random password using openssl.
Sets the user's password.
Stores the username and password in the secure file.
Logging
All actions and any errors are logged to /var/log/user_management.log.

#### Security Considerations

The password file is stored in /var/secure with permissions set to 600 to ensure only the root user can read it.
Home directories are set to 700 permissions, ensuring only the user has access to their files.

### Contributing
Contributions are welcome! Please submit a pull request or open an issue to discuss any changes.
