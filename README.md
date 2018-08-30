# Interproscan
A docker file that installs interproscan

# Requirements
Docker is required to build the image. (https://www.docker.com/)

Need to download the following: (for academic use only)
* phobius1.01_linux.tar.gz (http://phobius.sbc.su.se/data.html)
* signalp-4.1f.Linux.tar.gz (http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?signalp)
* tmhmm-2.0c.Linux.tar.gz (http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?tmhmm)

# Installing
Place the required archives in this directory with proper name.
Then run:

    docker build -t interproscan .
    
After this, you can refer to the image as 'interproscan'.
