# KaliScan
KaliScan is intended to use speed up and automate domain enumeration.

KaliScan is a minimal, dockerized version of Kali containing only the bare minimum of discovery tools and automated with a custom script. Each KaliScan docker instance can be targeted a domain, with the output files saved to the host system.

### Features

The docker image contains a single bash script quickscan.sh. The script takes a single domain as an argument e.g.

```./quickscan.sh github.com```

Scanning/Enumeration of the target domain is done as follows:

1) Subdomain enumeration (Sublist3r)
2) IPv4 lookups for all identified subdomains (dig) 
3) HTTP response codes / redirects captured (curl) 
4) SSL scan for common SSL errors and vulnerabilities (SSLyze) 
5) Scan discovered IP addresses for open TCP/UDP ports (Unicornscan) 
6) Security header analysis (nmap)
7) Capture screenshots and source code (EyeWitness)

### Usage

Clone the repository:

```git clone https://github.com/nixintel/KaliScan```

Build the docker image

```cd kaliscan && docker build -t kaliscan .```

Create a folder on your local machine to store the output documents.

Start the Docker container:

```docker run -it -v /path/to/local/folder:/home/outputs kaliscan ./quickscan.sh yourtargetdomain.com```

As the scan runs the reports it generated will be saved to your local machine in the folder you specified.

To run the container in detached mode (i.e. without seeing the KaliScan shell) add the ```-d``` flag when launching the container.

To access the KaliScan shell without starting a scan run the following:

```docker run -it -v /path/to/local/folder:/home/outputs kaliscan```

The ```quickscan.sh``` bash script can be edited as needed. There is full access to the Kali repositories so any additional applications can be installed with ```apt``` as needed.

### Acknowledgements

The idea and initial work on this script was done by [Salaheldinaz](https://github.com/salaheldinaz).
