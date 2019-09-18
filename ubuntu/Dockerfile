FROM ubuntu

# Non priveleged user
ENV USER ubuntu

# Update Apt get
RUN apt-get update --fix-missing

# Install man pages for everything
RUN cp /dev/null /etc/dpkg/dpkg.cfg.d/excludes
RUN apt-get install -y man-db man

# Install common packages
RUN apt-get install -y apt-utils
RUN env DEBIAN_FRONTEND=noninteractive \
    && apt-get update --fix-missing \
    && apt-get install -y tzdata
RUN apt-get update --fix-missing \
    && apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev make

# Install network utils
RUN apt-get update --fix-missing \ 
    && apt-get install -y curl dnsutils iperf mtr netcat nmap openssh-server telnet traceroute whois wget

# Install misc packages
RUN apt-get update --fix-missing \
    && apt-get install -y jq lnav lsb-core mutt sudo silversearcher-ag tree unzip vim

# Install dev packages
RUN apt-get update --fix-missing \
    && apt-get install -y bats openjdk-8-jre-headless clojure git golang nodejs npm python3 python3-distutils python3-pip ruby

# Install cloud utils
RUN apt-get install -y awscli
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

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

# 1Password
RUN apt-get update && apt-get install -y curl unzip jq && \
    curl -o 1password.zip \
    https://cache.agilebits.com/dist/1P/op/pkg/v0.5.5/op_linux_amd64_v0.5.5.zip && \
    unzip 1password.zip -d /usr/bin && \
    rm 1password.zip

# Add user
RUN useradd $USER --shell /bin/bash
RUN echo "$USER    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /home/$USER/.ssh
ADD files/authorized_keys /home/$USER/.ssh/authorized_keys
RUN chown $USER -R /home/$USER
RUN touch /home/$USER/.hushlogin

# --- Run commands as user ---
USER $USER

RUN mkdir -p ~/.aws
RUN touch ~/.aws/credentials
RUN echo "[default]\nregion = us-west-2" > ~/.aws/config

RUN mkdir /home/$USER/workdir /home/$USER/code
RUN git clone https://github.com/weavenet/dotfiles /home/$USER/.dotfiles/dotfiles_weavenet
RUN cd /home/$USER/.dotfiles && env WORK_DIR=/home/$USER/workdir bashdot install dotfiles_weavenet

# rbenv
ENV RUBY_VERSION 2.6.3
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN git clone https://github.com/tpope/rbenv-aliases.git ~/.rbenv/plugins/rbenv-aliases
RUN $HOME/.rbenv/bin/rbenv alias --auto
RUN git clone https://github.com/rbenv/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
RUN $HOME/.rbenv/bin/rbenv install $RUBY_VERSION
RUN $HOME/.rbenv/bin/rbenv global $RUBY_VERSION

RUN pip3 install --user aws-sam-cli
RUN pip3 install --user git+https://github.com/weavenet/aws_console@v1.0.2

USER root
# --- Completed user commands ---

# Finishing up
RUN date > /.timestamp
EXPOSE 22
CMD ["/run_shell.sh"]
