FROM ubuntu

RUN apt-get update --fix-missing
RUN apt-get install -y bats 
RUN apt-get install -y curl
RUN apt-get install -y dnsutils
RUN apt-get install -y git
RUN apt-get install -y nmap
RUN apt-get install -y sudo
RUN apt-get install -y telnet
RUN apt-get install -y traceroute
RUN apt-get install -y vim

RUN rm -f /root/.bashrc
RUN curl -s https://raw.githubusercontent.com/weavenet/dotfiles/master/install.sh | bash
