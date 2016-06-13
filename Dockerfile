# Based on Ubuntu 14.04 Trust Tahr base image
FROM ubuntu:trusty

ENV DEBIAN_FRONTEND=noninteractive

# Configure apt to make Oracle Java and Google Chrome available, update, upgrade, and install packages
RUN apt-get -y install \
        software-properties-common \
        wget && \
    add-apt-repository ppa:webupd8team/java && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -y update && \
    apt-get -y -q dist-upgrade && \
    apt-get -y -q upgrade && \
    apt-get -y -q install \
        git \
        google-chrome-beta \
        lxterminal \
        maven \
        vim && \
    apt-get clean && \
    ln -s /usr/bin/vim /usr/bin/emacs

# Install Oracle Java 8, accepting the license, and set up env variables and Java defaults
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get -y -q install \
        oracle-java8-installer \
        oracle-java8-set-default && \
    apt-get clean && \
    update-java-alternatives -s java-8-oracle
	
# Install scala 2.10.4 and sbt
RUN apt-get remove scala-library scala \
    wget www.scala-lang.org/files/archive/scala-2.10.4.deb \
    dpkg -i scala-2.10.4.deb \
    apt-get update \
    apt-get install scala \
    wget http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/0.12.4/sbt.deb \
    dpkg -i sbt.deb \
    apt-get update \
    apt-get install sbt

# Install IntelliJ IDEA
RUN wget http://download.jetbrains.com/idea/ideaIC-14.1.tar.gz -O /tmp/intellij.tar.gz -q && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz

# Convenience scripts
COPY idea.sh /usr/bin/idea
COPY chrome.sh /usr/bin/chrome

# Create "dev" user with "dev" password and grant passwordless sudo permission
ENV USERNAME dev
RUN adduser --disabled-password --gecos '' $USERNAME && \
    echo dev:dev | chpasswd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    sudo adduser dev sudo
	
# Mark dev user home as data volume
VOLUME /home/dev	

# Start an X terminal as dev user
USER $USERNAME
WORKDIR /home/$USERNAME
ENTRYPOINT lxterminal
