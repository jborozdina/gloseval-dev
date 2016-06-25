# gloseval-dev
Synereo backend developing and testing environment

This project defines a Docker image that allows development in an Ubuntu VM accessed via X (typically from a Windows workstation).

The image is based on Ubuntu 14.04 (Trusty Tahr) and includes:

Java 8
Scala 2.10.5
SBT 0.13.8
Maven
Git
IntelliJ IDEA 15.0.4 Community Edition

Running from Windows
Initial setup
Install Docker for Windows.
Install an X client, such as MobaXTerm. NB ensure that the X client access control
is disabled - this is the default on MobaXTerm, but eg XMing needs to be run with the -ac option.

Starting
Ensure X client is running.
Run "Boot2Docker Start" - this will open a Boot2Docker console.
Run the following command in the Boot2Docker console, substituting <DISPLAY>:
docker run -d -e DISPLAY=<DISPLAY> -v ~/docker/intellij:/home/dev --name ide jborozdina/gloseval-dev
<DISPLAY> is the X client display address. Typically this will be your workstation IP address plus ":0.0".
<USERNAME> is your Windows username. This path is used to persist the VM "dev" users home directory between
restarts.
A terminal window should open on your desktop from the VM. To start IntelliJ IDEA, run "sudo idea".

Getting started 

1. Install and run Docker Toolbox (https://www.docker.com/products/docker-toolbox)
2. Install and run an X client (such as MobaXTerm(http://mobaxterm.mobatek.net/download.html) for Windows / MacTerm(http://macdownload.informer.com/macterm/) for MacOS)
   NB ensure that the X client access control is disabled - this is the default on MobaXTerm, but eg XMing needs to be run with the -ac option.
3. Add memory for Docker VM   

