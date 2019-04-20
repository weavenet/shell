FROM ubuntu

# Non priveleged user
ENV USER ubuntu

# Install common packages
RUN apt-get update --fix-missing
RUN apt-get install -y awscli
RUN apt-get install -y bats
RUN apt-get install -y curl
RUN apt-get install -y dnsutils
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y man
RUN apt-get install -y mutt
RUN apt-get install -y nmap
RUN apt-get install -y openssh-server
RUN apt-get install -y ruby
RUN apt-get install -y sudo
RUN apt-get install -y telnet
RUN apt-get install -y traceroute
RUN apt-get install -y whois
RUN apt-get install -y vim

# Add ssh run
ADD files/run_shell.sh /run_shell.sh
RUN chmod 755 /run_shell.sh
RUN /usr/bin/ssh-keygen -A
RUN mkdir /run/sshd

# Add user
RUN useradd $USER --shell /bin/bash
RUN echo "$USER    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /home/$USER/.ssh
ADD files/authorized_keys /home/$USER/.ssh/authorized_keys
RUN chown $USER -R /home/$USER
RUN touch /home/$USER/.hushlogin

# Add dotfiles management tools
RUN curl -s https://raw.githubusercontent.com/bashdot/bashdot/master/bashdot > /usr/bin/bashdot
RUN chmod 755 /usr/bin/bashdot

# Run commands as user
USER $USER
RUN mkdir /home/$USER/dotfiles /home/$USER/workdir
RUN git clone https://github.com/weavenet/dotfiles /home/$USER/.dotfiles/dotfiles_weavenet
RUN cd /home/$USER/.dotfiles && env WORK_DIR=/home/$USER/workdir bashdot install dotfiles_weavenet
USER root

# Misc
RUN date > /.time-stamp

# Start ssh
EXPOSE 22
CMD ["/run_shell.sh"]
