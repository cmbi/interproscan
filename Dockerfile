FROM ubuntu:xenial

ARG INTERPROSCAN_VERSION=5.30-69.0
ARG PANTHER_VERSION=11.1
ARG SIGNALP_VERSION=4.1
ARG TMHMM_VERSION=2.0
ARG PHOBIUS_VERSION=1.01
ARG BLAST_VERSION=2.6.0

# Install supportive software
RUN apt-get update && apt-get upgrade -y -q && apt-get install -y -q \
    software-properties-common \
    libboost-iostreams-dev libboost-system-dev libboost-filesystem-dev \
    zlibc gcc-multilib apt-utils zlib1g-dev python \
    cmake tcsh build-essential g++ git wget gzip perl python3-pip

# Install java
RUN add-apt-repository -y ppa:webupd8team/java && apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y -q oracle-java8-installer
RUN apt-get install -y -q oracle-java8-set-default
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV CLASSPATH=/usr/lib/jvm/java-8-oracle/bin


RUN mkdir /deps

# Download interproscan
WORKDIR /deps
RUN wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${INTERPROSCAN_VERSION}/interproscan-${INTERPROSCAN_VERSION}-64-bit.tar.gz && \
    wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${INTERPROSCAN_VERSION}/interproscan-${INTERPROSCAN_VERSION}-64-bit.tar.gz.md5 && \
    md5sum -c interproscan-${INTERPROSCAN_VERSION}-64-bit.tar.gz.md5

RUN tar -pxvzf interproscan-${INTERPROSCAN_VERSION}-64-bit.tar.gz && \
    rm interproscan-${INTERPROSCAN_VERSION}-64-bit.tar.gz interproscan-${INTERPROSCAN_VERSION}-64-bit.tar.gz.md5 && \
    mv interproscan-${INTERPROSCAN_VERSION} interproscan

# Install panther
WORKDIR /deps/interproscan/data
RUN wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-${PANTHER_VERSION}.tar.gz && \
    wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-${PANTHER_VERSION}.tar.gz.md5 && \
    md5sum -c panther-data-${PANTHER_VERSION}.tar.gz.md5

RUN tar -pxvzf panther-data-${PANTHER_VERSION}.tar.gz && rm panther-data-${PANTHER_VERSION}.tar.gz.md5 panther-data-${PANTHER_VERSION}.tar.gz

# Add to PATH variable
ENV PATH="/deps/interproscan:${PATH}"

# Install signalp
WORKDIR /deps/interproscan
COPY signalp-${SIGNALP_VERSION}f.Linux.tar.gz /deps
RUN tar -xzf /deps/signalp-${SIGNALP_VERSION}f.Linux.tar.gz -C /deps/interproscan/bin/signalp/${SIGNALP_VERSION} --strip-components 1
RUN sed -i "s|\$ENV{SIGNALP} = '.*';|\$ENV{SIGNALP} = '/deps/interproscan/bin/signalp/${SIGNALP_VERSION}/';|" /deps/interproscan/bin/signalp/${SIGNALP_VERSION}/signalp

# Install tmhmm
WORKDIR /deps/interproscan
COPY tmhmm-${TMHMM_VERSION}c.Linux.tar.gz /deps
RUN  tar -xzf /deps/tmhmm-${TMHMM_VERSION}c.Linux.tar.gz -C /deps && \
     cp /deps/tmhmm-${TMHMM_VERSION}c/bin/decodeanhmm.Linux_x86_64  /deps/interproscan/bin/tmhmm/${TMHMM_VERSION}c/decodeanhmm && \
     cp /deps/tmhmm-${TMHMM_VERSION}c/lib/TMHMM${TMHMM_VERSION}.model  /deps/interproscan/data/tmhmm/${TMHMM_VERSION}c/TMHMM${TMHMM_VERSION}c.model

# Install phobius
COPY phobius${PHOBIUS_VERSION}_linux.tar.gz /deps
RUN  tar -xzf /deps/phobius${PHOBIUS_VERSION}_linux.tar.gz -C /deps/interproscan/bin/phobius/${PHOBIUS_VERSION} --strip-components 3

# Overwrite rpsblast to overcome a dependency problem
WORKDIR /deps/interproscan
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${BLAST_VERSION}/ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz
RUN tar xvf ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz
RUN cp ncbi-blast-${BLAST_VERSION}+/bin/rpsblast /deps/interproscan/bin/blast/ncbi-blast-${BLAST_VERSION}+/rpsblast

# Make directories that interproscan needs
RUN mkdir /data
RUN chmod a+w /deps/interproscan
