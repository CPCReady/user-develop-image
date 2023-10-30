FROM ubuntu:22.04
ARG USERNAME=amstrad
ARG USERPASS=amstrad
ENV TZ=Europe/Minsk
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update && apt-get install -y openssh-server virtualenv twine python3.10-venv sudo pasmo dos2unix build-essential flex vim bison libboost-dev libfreeimage-dev curl unzip zip git whois locales python3-pip zsh fonts-powerline nano
                                                                   
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
RUN useradd -ms /bin/bash ${USERNAME}
RUN apt purge -y whois && apt -y autoremove && apt -y autoclean && apt -y clean
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
ADD software/usr/local/share/fonts /usr/local/share/fonts

# VARIABLES DE ENTORNO
ENV ENVIRONMENT=docker
ENV CPCREADY=/home/${USERNAME}/CPCReady
ENV CPCREADY_CFG=/home/${USERNAME}/CPCReady/cfg
ENV PATH=$PATH:/home/${USERNAME}/CPCReady/tools/bin
ENV PATH=$PATH:/home/${USERNAME}/CPCReady/tools/z88dk/bin
ENV ZCCCFG=/home/${USERNAME}/CPCReady/tools/z88dk/lib/config

USER $USERNAME
# DESACTIVAMOS DIRECTORIOS SEGUROS GIT
RUN git config --global --add safe.directory '*'
WORKDIR /home/${USERNAME}

# CONFIGURAMOS POWER LINK
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
COPY software/.p10k.zsh /home/${USERNAME}/.p10k.zsh
COPY software/.zshrc /home/${USERNAME}/.zshrc
# COPY software/develop.sh /usr/local/bin/develop.sh
# COPY software/test.sh /usr/local/bin/test.sh
COPY VERSION /home/${USERNAME}/VERSION

# COPIAMOS Y COMPILAMOS Z88DK
# RUN wget http://nightly.z88dk.org/z88dk-latest.tgz
# RUN tar -xzf z88dk-latest.tgz
# RUN cpanm --local-lib=~/perl5 App::Prove CPU::Z80::Assembler Data::Dump Data::HexDump File::Path List::Uniq Modern::Perl Object::Tiny::RW Regexp::Common Test::Harness Text::Diff Text::Table YAML::Tiny
# RUN eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
# RUN rm -rf z88dk-latest.tgz
# RUN cd z88dk && \
#     export BUILD_SDCC=1 && \
#     export BUILD_SDCC_HTTP=1 && \
#     chmod 777 build.sh && \
#     ./build.sh

# CLONE INSTALATOR
# RUN git clone https://github.com/CPCReady/installer.git ~/CPCReady
# RUN chmod -R 777 /home/${USERNAME}/CPCReady/tools/bin
# RUN chmod -R 777 /home/${USERNAME}/CPCReady/z88dk/bin

# COPY VERSION /home/${USERNAME}/VERSION
# COPY software/head.sh /home/${USERNAME}/.head.sh
# RUN echo 'source ~/.head.sh' >>~/.zshrc

# RUN pip install -r /home/${USERNAME}/CPCReady/requirements.txt
# RUN ln -s /workspaces/sdk/CPCReady /home/amstrad/.local/lib/python3.10/site-packages/CPCReady

USER root
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL " >> /etc/sudoers
RUN chown $USERNAME:$USERNAME /home/${USERNAME}/.p10k.zsh
RUN chown $USERNAME:$USERNAME /home/${USERNAME}/.zshrc
RUN chown $USERNAME:$USERNAME /home/${USERNAME}/VERSION

WORKDIR /home/$USERNAME
ENV JAVA_HOME /usr
EXPOSE 22
USER $USERNAME
ENV TERM xterm

ENV SHELL /bin/zsh

CMD ["/usr/sbin/sshd", "-D"]
