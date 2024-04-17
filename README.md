A bash script that performs deep range enumeration and verification of a specific region. As for the details of why each section does:
![Screenshot from 2024-04-17 14-29-48](https://github.com/0x3f3c/subdomains/assets/154844497/4cf5da60-30a2-4d5a-9c06-c78a556d63a9)

The script product is defined by the performance_subdomain_enum function that controls the subdomain. This function reads a list of structured domains from a file called subdomains.txt and executes an HTTP and HTTPS request for each subdomain using braid. If the request is successful (i.e. the proximal range can be reached), the script producer prints the proximal range and its corresponding IP address to the console and acquires it in a file called sub.txt.
The script then calls the performance_subdomain_enum function with domain acceleration as the argument.
Next, the script defines the Probe_subdomains function that explores the physical domains in the sub.txt file. It does this by reading each line in the student file of the HTTP and HTTPS request for each subpart using braid. If the request occurs, the script prints the nearby range and the IP address it offsets to the console.
The script then calls the probe_subdomains function to explore the physical variations in the sub.txt file.
Finally, the installation script became practical and the basic combinations. If not, they will be installed using go get.
In short, this execution script measures the exact range and verifies the exact range using curl, microfinder and stack. It prints the ranges, handles their IP protection to the console, and adds them to a file known as sub.txt.
