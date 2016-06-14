# Based on Ubuntu 14.04 Trust Tahr base image
FROM ubuntu:trusty

ENV DEBIAN_FRONTEND=noninteractive

ENV SCALA_VERSION 2.10.5
ENV SCALA_FILENAME scala-$SCALA_VERSION.deb
ENV SCALA_DEBPATH http://downloads.typesafe.com/scala/$SCALA_VERSION/$SCALA_FILENAME

ENV SBT_VERSION 0.13.8
ENV SBT_JAR https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/$SBT_VERSION/sbt-launch.jar

# Configure apt to make Oracle Java and Google Chrome available, update, upgrade, and install packages
RUN apt-get -q update && apt-get -q -y install \
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
		mc \
        lxterminal \
        maven && \
    apt-get clean && \
    ln -s /usr/bin/vim /usr/bin/emacs

# Install Oracle Java 8, accepting the license, and set up env variables and Java defaults
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get -y -q install \
        oracle-java8-installer \
        oracle-java8-set-default && \
    apt-get clean && \
    update-java-alternatives -s java-8-oracle
	
# Install scala
RUN apt-get install -y libjansi-java
RUN wget -q $SCALA_DEBPATH
RUN dpkg -i $SCALA_FILENAME
RUN rm -f $SCALA_FILENAME

# Install SBT manually
ADD $SBT_JAR /usr/bin/sbt-launch.jar
COPY sbt.sh /usr/bin/sbt
RUN chmod u+x /usr/bin/sbt

#RUN echo "==> Fetching all sbt jars from Maven repo" && \
   #echo "==> This will take a while..." && \
   #sbt

# Install IntelliJ IDEA
RUN wget https://d1opms6zj7jotq.cloudfront.net/idea/ideaIC-15.0.4.tar.gz -O /tmp/intellij.tar.gz -q && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz

# Convenience scripts
COPY idea.sh /usr/bin/idea
COPY chrome.sh /usr/bin/chrome

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/synereo && \
    echo "synereo:x:${uid}:${gid}:synereo,,,:/home/synereo:/bin/bash" >> /etc/passwd && \
    echo "synereo:x:${uid}:" >> /etc/group && \
    echo "synereo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/synereo && \
    chmod 0440 /etc/sudoers.d/synereo && \
    chown ${uid}:${gid} -R /home/synereo
USER synereo
ENV HOME /home/synereo
ENTRYPOINT lxterminal
