#!/bin/bash

# Define ANSI color codes for better readability
BOLD="\e[1m"
CYAN="\e[96m"
GREEN="\e[32m"
RESET="\e[0m"

# Display banner with styled text
echo -e "${CYAN}${BOLD}"
cat << "EOF"
 ███████╗██╗   ██╗██████╗        ██████╗██████╗ ██████╗ ██████╗ 
 ██╔════╝██║   ██║██╔══██╗      ██╔════╝╚════██╗██╔══██╗██╔══██╗
 ███████╗██║   ██║██████╔╝█████╗██║      █████╔╝██████╔╝██████╔╝
 ╚════██║██║   ██║██╔══██╗╚════╝██║      ╚═══██╗██╔══██╗██╔══██╗
 ███████║╚██████╔╝██████╔╝      ╚██████╗██████╔╝██║  ██║██████╔╝
 ╚══════╝ ╚═════╝ ╚═════╝        ╚═════╝╚═════╝ ╚═╝  ╚═╝╚═════╝ 
                              
                                                                 
EOF

# Prompt for domain input
read -p "${RESET}Enter Domain: " domain

# Function to perform subdomain enumeration and save to file
perform_subdomain_enum() {
    subfinder -d "$1" > subdomains.txt
    amass enum -passive -d "$1" >> subdomains.txt
}

# Function to probe subdomains and save reachable ones to file
probe_subdomains() {
    while IFS= read -r subdomain; do
        subdomain=$(echo "$subdomain" | tr -d '\r\n')
        http="http://$subdomain"
        https="https://$subdomain"
        
        if curl -s --head "$http" >/dev/null; then
            echo -e "${GREEN}$http: $(getent hosts "$subdomain" | awk '{ print $1 }')"
            echo "$http" >> sub.txt
        fi

        if curl -s --head "$https" >/dev/null; then
            echo -e "${GREEN}$https: $(getent hosts "$subdomain" | awk '{ print $1 }')"
            echo "$https" >> sub.txt
        fi
    done < subdomains.txt
}

# Perform subdomain enumeration
echo -e "\n${CYAN}${BOLD}Scanning for subdomains...\n${RESET}"
perform_subdomain_enum "$domain"

# Probe subdomains
echo -e "\n${CYAN}${BOLD}Probing subdomains....\n${RESET}"
probe_subdomains

# Install required tools (if not already installed)
if! [ -x "$(command -v subfinder)" ]; then
    echo "Installing subfinder..."
    GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
fi

if! [ -x "$(command -v amass)" ]; then
    echo "Installing amass..."
    GO111MODULE=on go get -v github.com/OWASP/Amass/v3/...
fi

# Perform subdomain enumeration
echo -e "${GREEN}Performing subdomain enumeration...${RESET}"
perform_subdomain_enum "$domain"

# Check if subdomains.txt is empty
if [! -s subdomains.txt ]; then
    echo -e "${RED}No subdomains found.${RESET}"
    exit 1
fi

# Display found subdomains
echo -e "${GREEN}Found subdomains:${RESET}"
cat subdomains.txt

# Perform port scanning on found subdomains
echo -e "${GREEN}Performing port scanning on found subdomains...${RESET}"
nmap -iL subdomains.txt -Pn -p- -A -oN ports.txt

# Display open ports
echo -e "${GREEN}Open ports:${RESET}"
cat ports.txt

# Clean up temporary files
rm subdomains.txt ports.txt

echo -e "${GREEN}Subdomain enumeration and port scanning completed.${RESET}"
# Remove temporary files
rm subdomains.txt
