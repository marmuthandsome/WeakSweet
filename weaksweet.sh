#!/bin/bash

# Define color codes
RESTORE='\033[0m'
BLACK='\033[00;30m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
LBLACK='\033[01;30m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'
OVERWRITE='\e[1A\e[K'

# Function to display task information
function _task {
    if [[ $TASK != "" ]]; then
        printf "${OVERWRITE}${LGREEN}[✓]  ${LGREEN}${TASK}\n"
    fi
    TASK=$1
    printf "${LBLACK}[ ]  ${TASK} \n${LRED}"
}

# Function to run commands and handle errors
function _cmd {
    if ! output=$(eval "$1" 2>&1); then
        printf "${OVERWRITE}${LRED}[X]  ${TASK}${LRED}\n"
        printf "      ${output}\n\n"
        exit 1
    fi
    return 0
}

# Function to display help message
function display_help {
    # Display your custom banner
    cat << "EOF"


    ██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗██╗    ██╗███████╗███████╗████████╗
    ██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝██║    ██║██╔════╝██╔════╝╚══██╔══╝
    ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗██║ █╗ ██║█████╗  █████╗     ██║   
    ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║██║███╗██║██╔══╝  ██╔══╝     ██║   
    ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║╚███╔███╔╝███████╗███████╗   ██║   
     ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   
EOF
    printf "${LBLACK}WEAK SSH ALGO and SWEET32 Information System ${YELLOW}WEAKSWEET checker v1.0${RESTORE}\n"
    printf "${LPURPLE}Created by MarmutHandsome${RESTORE}"
    printf "\n"
    printf "\n"
    echo "Usage: $0 [-h] [-i input_file] [-o output_file]"
    echo "  -h: Display this help message"
    echo "  -i: Input file containing a list of IP addresses"
    echo "  -o: Output file for the scan results"
    printf "\n"
    exit 0
}

# Initialize variables
INPUT_FILE=""
OUTPUT_FILE="output.txt"

# Parse command-line options
while getopts "hi:o:" opt; do
    case $opt in
        h)
            display_help
            ;;
        i)
            INPUT_FILE="$OPTARG"
            ;;
        o)
            OUTPUT_FILE="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Check for root privileges
if [[ $(id -u) -ne 0 ]]; then
    printf "\n${LRED} Please run as root${RESTORE}\n\n"
    exit 1
fi

# Display the custom banner
cat << "EOF"


    ██╗    ██╗███████╗ █████╗ ██╗  ██╗███████╗██╗    ██╗███████╗███████╗████████╗
    ██║    ██║██╔════╝██╔══██╗██║ ██╔╝██╔════╝██║    ██║██╔════╝██╔════╝╚══██╔══╝
    ██║ █╗ ██║█████╗  ███████║█████╔╝ ███████╗██║ █╗ ██║█████╗  █████╗     ██║   
    ██║███╗██║██╔══╝  ██╔══██║██╔═██╗ ╚════██║██║███╗██║██╔══╝  ██╔══╝     ██║   
    ╚███╔███╔╝███████╗██║  ██║██║  ██╗███████║╚███╔███╔╝███████╗███████╗   ██║   
     ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   
EOF
printf "${LBLACK}WEAK SSH ALGO and SWEET32 Information System ${YELLOW}WEAKSWEET checker v1.0${RESTORE}\n"
printf "${LPURPLE}Created by MarmutHandsome${RESTORE}"
printf "\n"
printf "\n"

# Display task information
_task "SSH WEAK KEY"

# Initialize output file
> "$OUTPUT_FILE"

printf "%-20s | %-20s | %-20s\n" "IP Address" "Port Status" "Scan Result"
printf "%s\n" "-----------------------------------------------------------------"

# Read IP addresses from the input file
while read -r ip || [[ -n "$ip" ]]; do
    port_status=$(nmap -T5 -Pn -p 22 "$ip" 2>/dev/null | grep "22" | awk '{print $2}')
    
    if [ "$port_status" == "closed" ] || [ "$port_status" == "filtered" ]; then

        printf "\033[0;33m%-20s | %-20s | %-20s\033[0m\n" "$ip" "$port_status" "Filtered or Closed"
    else

        result=$(nmap -T5 -Pn -sV --script ssh2-enum-algos -p 22 "$ip" 2>/dev/null | grep -E "diffie-hellman-group-exchange-sha1|diffie-hellman-group1-sha1")
        
        if [ -z "$result" ]; then
            printf "\033[0;32m%-20s | %-20s | %-20s\033[0m\n" "$ip" "open" "No vulnerabilities"
        else
            printf "\033[0;31m%-20s | %-20s | %-20s\033[0m\n" "$ip" "open" "Vulnerable to SSH Weak Key Exchange"
            echo "IP Address: $ip" >> "$OUTPUT_FILE"
            echo "Port Status: open" >> "$OUTPUT_FILE"
            echo "Scan Result: Vulnerable to SSH Weak Key Exchange" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
        fi
    fi
done < "$INPUT_FILE"

printf "\n"
printf "\n"
printf "\n"
_task "SWEET32"

printf "%-20s | %-20s | %-20s\n" "IP Address" "Port Status" "Scan Result"
printf "%s\n" "-----------------------------------------------------------------"

# Read IP addresses from the input file again for SWEET32 scan
while read -r ip || [[ -n "$ip" ]]; do
    port_status=$(nmap -T5 -Pn -p 443 "$ip" 2>/dev/null | grep "443" | awk '{print $2}')
    
    if [ "$port_status" == "closed" ] || [ "$port_status" == "filtered" ]; then
        printf "\033[0;33m%-20s | %-20s | %-20s\033[0m\n" "$ip" "$port_status" "Filtered or Closed"
    else
        result=$(nmap -T5 -Pn -sV --script ssl-enum-ciphers -p 443 "$ip" 2>/dev/null | grep "64-bit block cipher 3DES vulnerable to SWEET32 attack")
        
        if [ -z "$result" ]; then
            printf "\033[0;32m%-20s | %-20s | %-20s\033[0m\n" "$ip" "open" "No vulnerabilities"
        else
            printf "\033[0;31m%-20s | %-20s | %-20s\033[0m\n" "$ip" "open" "Vulnerable to SWEET32 attack"
            echo "IP Address: $ip" >> "$OUTPUT_FILE"
            echo "Port Status: open" >> "$OUTPUT_FILE"
            echo "Scan Result: Vulnerable to SWEET32 attack" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
        fi
    fi
done < "$INPUT_FILE"

printf "${OVERWRITE}${LGREEN}[✓]  ${LGREEN}${TASK}\n"
