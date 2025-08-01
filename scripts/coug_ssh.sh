#!/bin/bash
# Created by Brighton Anderson, Nov 2024
#
# Connects to an avaliable CougUV via SSH
# - Make sure the router is powered on before running this script

# Check if sshpass is installed, and install it if it isn't
# TODO create a script to work on ssh keys
if ! command -v sshpass &> /dev/null; then
    echo "sshpass could not be found, installing..."
    exit
fi

# Define device variables
declare -A DEVICES=(
    [1]="coug1.local"
    [2]="coug2.local"
    [3]="coug3.local"
    [4]="coug4.local"
    [5]="coug5.local"
)

# Define username and password
declare -A CREDENTIALS=(
    [1]="frostlab:frostlab"
    [2]="frostlab:frostlab"
    [3]="frostlab:frostlab"
    [4]="frostlab:frostlab"
    [5]="frostlab:frostlab"
)

# Function to display menu
display_menu() {
    echo "Select a device to SSH into:"
    echo "1. Coug1"
    echo "2. Coug2"
    echo "3. Coug3"
    echo "4. Coug4"
    echo "5. Coug5"
    echo "Enter your choice (1-5):"
}

if [[ -z $1 ]]; then
    # Main script
    # Display the menu
    display_menu

    # Read user input
    read -r choice

    # Validate input
    if [[ ! "$choice" =~ ^[1-5]$ ]]; then
        echo "Invalid input. Please enter a number between 1 and 5."
        exit 1
    fi

    # Split credentials
    IFS=':' read -r USERNAME PASSWORD <<< "${CREDENTIALS[$choice]}"

    # Get the selected device IP
    DEVICE_IP="${DEVICES[$choice]}"

else
    echo "First argument is a number, not running the command."
    VEHICLE_ID="$1"
    USERNAME="frostlab"
    DEVICE_IP="$VEHICLE_ID.local"
fi

# Define the command to execute
CONNECT='mosh'

# Connect to the selected device
echo "Connecting to ${DEVICE_IP}..."
$CONNECT "$USERNAME@$DEVICE_IP" 