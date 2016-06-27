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
   
   Before running, the file should be updated with setting the DISPLAY environment variable value that is the X client display address.
   
####3. build.sbt

   defines the aggregation build for Synereo's backend projects (GlosEval, AgentServises, SpecialK).
    
   See #5 in the next section for the usage.

###Setting up the development environment 

   1. Install and run [Docker Toolbox] (https://www.docker.com/products/docker-toolbox). 
   
      This installs Docker Client, Docker Machine, Docker Compose, VirtualBox and Kitematic. 
   2. Install and run an X client (such as [MobaXTerm] (http://mobaxterm.mobatek.net/download.html) for Windows /       [MacTerm] (http://macdownload.informer.com/macterm/) for MacOS)
   
   *NB ensure that the X client access control is disabled - this is the default on MobaXTerm, but eg XMing needs to be run with the -ac option.*
   3. Add memory for Docker VM
   
      The Docker virtual machine with the name "default", being created on the initial run of Docker Toolbox, has 1GB memory.
      This is not enough for compiling and running Synereo's backend projects with IntelliJ IDEA within the Docker container, and should be increased to 4GB.

      Please follow these step for increasing the "default" VM memory:
      - stop and remove the "default" VM
      
      ```
         docker-machine stop default
         docker-machine rm default
      ```
      - create "default" VM with proper memory size
      
      ```
         docker-machine create -d virtualbox --virtualbox-memory 4096 default
      ```
      - start the "default" VM
      
      ```
         docker-machine start default
      ```   
   4. Start the IDE and MongoDB Docker containers:

      - copy docker-compose.yml file to your host machine and change it with setting DISPLAY variable to your X client ip
      - open a docker console here and run the ``` docker-compose up``` command. This will pull the images for IDE and MongoDB and start the docker containers. As a result of successfull containers' start, the X terminal window will open.
      
   5. Build Synereo backend projects with IntelliJ IDEA
    
     - in the X terminal window of the IDE docker container first clone gloseval-dev project from Github to the current dirrectory (/home/dev). Enter into /gloseval-dev directory, move /lib folder, /project folder and build.sbt file to the /home/dev directory, return to /home/dev and remove /gloseval-dev folder.
     - clone GlosEval, AgentServices and SpecialK projects from Github to /home/dev directory
     - copy /gloseval/eval.conf to /home/dev directory and then, in /home/dev/eval.conf file, change the value of dbHost property to you docker-machine ip. Use ```docker-machine ip``` command from the Docker CLI to get the ip.
     - start IntelliJ IDEA with ```idea``` command. On the first run IntelliJ IDEA will ask you about installing additional plugins. Please install the Scala plugin.
     - import SBT project. In the window that opened after start and initial set up of IntelliJ IDEA choose the **Import project** option. In the filesystem window choose /home/dev/build.sbt file. In the project settings window enable Project Auto-import and set the project SDK to Java8 JDK.
     - wait for SBT .ivy cache build ends and click OK in the window with the project modules
     - wait for IDEA finishes the indexing process and run Make Project with CTRL-F9
     - once the project modules are compiled successfully enter IDE top menu  **Run -> Edit Configuration**. Create new SBT Task configuration, in the Name field write what ever you want, in the Task field write ``` run ```.
     - now you can start or debug Synereo backend projects. 

