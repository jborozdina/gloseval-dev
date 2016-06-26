# gloseval-dev
Synereo backend development and testing environment (typically from Windows/MacOS workstation)

###Description for the existing files:

####1. docker/Dockerfile

   defines a Docker image that allows development in an Ubuntu VM accessed via X client.
   
   The running command:
   
    docker run -d -e DISPLAY=<DISPLAY> -v ~/docker/intellij:/home/dev/share --name ide jborozdina/gloseval-dev
   
   where <DISPLAY> is the X client display address. Typically this will be your workstation IP address plus ":0.0". 
   
   The image is based on Ubuntu 14.04 (Trusty Tahr) and includes:
   - Java 8
   - Scala 2.10.5
   - SBT 0.13.8
   - Maven
   - Git
   - IntelliJ IDEA 15.0.4 Community Edition

####2. docker/docker-compose.yml

   starts docker containers for the IDE and for the MongoDB instance
   
   The running command:
   
      docker-compose up
   
   Before running the file should be updated with setting the DISPLAY environment variable value that is the X client display address.
   
####3. build.sbt

   defines the aggregation build for Synereo's backend projects (GlosEval, AgentServises, SpecialK).
    
   See next section for the usage.

###Setting up the development environment 

   1. Install and run Docker Toolbox (https://www.docker.com/products/docker-toolbox)
   2. Install and run an X client (such as MobaXTerm(http://mobaxterm.mobatek.net/download.html) for Windows /       MacTerm(http://macdownload.informer.com/macterm/) for MacOS)
   NB ensure that the X client access control is disabled - this is the default on MobaXTerm, but eg XMing needs to be run with the -ac option.
   3. Add memory for Docker VM   

