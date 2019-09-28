FROM amazonlinux

# Non priveleged user
ENV USER user

# Common Packages
RUN yum install -y autoconf binutils bison make

# Network Utils
RUN yum install -y curl dnsutils iperf mtr netcat net-tools nmap openssh-server procps telnet traceroute whois wget

# Misc Packages
RUN yum install -y jq mutt sudo tree unzip vim

# Install Dev Packages
RUN yum install -y git golang python3 python3-pip ruby tar

# Add ssh run
ADD files/run_shell.sh /run_shell.sh
RUN chmod 755 /run_shell.sh
RUN /usr/bin/ssh-keygen -A
RUN mkdir /run/sshd

# Add dotfiles management tools
RUN curl -s https://raw.githubusercontent.com/bashdot/bashdot/master/bashdot > /usr/bin/bashdot
RUN chmod 755 /usr/bin/bashdot

# Misc
RUN curl -L https://rawgit.com/weavenet/notes/latest-release/install.sh | bash

# Add user
RUN useradd $USER --shell /bin/bash
RUN echo "$USER    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /home/$USER/.ssh
ADD files/authorized_keys /home/$USER/.ssh/authorized_keys
RUN touch /home/$USER/.hushlogin
RUN chown $USER -R /home/$USER

# --- Run commands as user ---
USER $USER

RUN mkdir /home/$USER/workdir /home/$USER/code
RUN git clone https://github.com/weavenet/dotfiles /home/$USER/.dotfiles/dotfiles_weavenet
RUN rm ~/.bash_profile ~/.bashrc
RUN cd /home/$USER/.dotfiles && env WORK_DIR=/home/$USER/workdir bashdot install dotfiles_weavenet

USER root
# --- Completed user commands ---

# Finishing up
RUN date > /.timestamp
EXPOSE 22
CMD ["/run_shell.sh"]
