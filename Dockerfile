FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install curl unicornscan nano libpcap-dev nmap sslyze dnsutils wget eyewitness git sublist3r

VOLUME /home/outputs
RUN mkdir /home/outputs/ew_screenshots
COPY quickscan.sh /home/
RUN chmod +x /home/quickscan.sh

VOLUME /root /var/lib/postgresql

WORKDIR /home
ENTRYPOINT ["/bin/bash"]