# Interproscan
A docker file that installs interproscan

# Requirements
Need to download the following: (for academic use only)
* phobius1.01_linux.tar.gz (http://phobius.sbc.su.se/data.html)
* signalp-4.1f.Linux.tar.gz (http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?signalp)
* tmhmm-2.0c.Linux.tar.gz (http://www.cbs.dtu.dk/cgi-bin/nph-sw_request?tmhmm)

# Building
Place the required archives in this directory with proper name.
Then run:
    docker build .
