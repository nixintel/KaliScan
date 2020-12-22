#Create domain variable from argument passed


sublist3r -d $1 -v --output /home/outputs/subdomains.txt

echo "Subdomain list generated."


#Create https:// URLS from domains

awk '{print "https://"$0}' /home/outputs/subdomains.txt > /home/outputs/https_urls.txt

echo "HTTPS URLs created"

#A record lookup for all subdomains

for f in $(cat /home/outputs/subdomains.txt);
do dig $f | grep IN | grep -v ";" | tr -s "[:blank:]" "," | tee -a /home/outputs/dig_results.csv ;
done;

echo "DNS A record lookups saved to CSV"

#Get HTTP status codes, URL redirects and remote IPs with curl

for f in $(cat /home/outputs/subdomains.txt);
do curl -o /dev/null -s -w "%{http_code},%{url_effective},%{redirect_url},%{remote_ip}\n" $f | tee -a /home/outputs/curl_results.csv;
done;

echo "HTTP responses checked and saved"

#Create IPs from curl CSV, remove duplicates

cut -d ',' -f5 /home/outputs/dig_results.csv | sort -u > /home/outputs/ips.txt

echo  "SSL scan initiated"

#SSL scan

for f in $(cat /home/outputs/subdomains.txt);
do sslyze --regular $f >> /home/outputs/ssl_scans.txt
done;

echo "SSL scan completed."

#Use Masscan to port scan all ips

#Unicornscan TCP

echo "Scanning for open TCP ports"

for f in $(cat /home/outputs/ips.txt);

do unicornscan $f -mT | awk 'OFS="," {sub("]", "", $4); print $1, $2, $4, $6}' | tee -a /home/outputs/tcp_ports.csv;
done;

#Unicornscan UDP

echo "Scanning for open UDP ports"

for f in $(cat /home/outputs/ips.txt);
do unicornscan $f -mU | awk 'OFS="," {sub("]", "", $4); print $1, $2, $4, $6}' | tee -a /home/outputs/udp_ports.csv;

done;

echo "Checking security headers"

#Check for security header vulnerabilities
for f in $(cat /home/outputs/ips.txt);
do nmap -p80,443 --script http-security-headers $f | tee -a /home/outputs/security_headers.txt;
done;

#Capture screenshots of URLS with EyeWitness

echo "Running Eyewitness"

eyewitness -f '/home/outputs/https_urls.txt' --delay 10 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36" -d /home/outputs/ew_screenshots --no-prompt

echo "Done! All files saved to /home/output folder"
