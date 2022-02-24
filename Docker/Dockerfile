FROM ubuntu:18.04
MAINTAINER mbrown@broadinstitute.org
ENV DEBIAN_FRONTEND=noninteractive

#~~~~~~~~~~~~~~
# Install Preliminaries
#~~~~~~~~~~~~~~
RUN apt-get -qq update && apt-get -qq -y install --no-install-recommends \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    default-jre \
    g++ \
    gcc \
    git \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libdb-dev \
    libjpeg-dev \
    liblzma-dev \
    libpng-dev \
    libreadline-dev \
    libssl-dev \
    libtbb-dev \
    libx11-dev \
    libxml2-dev \
    libxt-dev \
    make \
    pbzip2 \
    pigz \
    python \
    python-pip \
    python-setuptools \
    python3-pip \
    r-base \
    unzip \
    wget \
    x11-common \
    zlib1g \
    zlib1g-dev \
    zlibc

# make python3 be the default python
# RUN ln -sf /usr/bin/python3 /usr/bin/python

#~~~~~~~~~~~~~~~~~~
# Install Java 1.6
#~~~~~~~~~~~~~~~~~~
# Pre-downloaded from https://www.oracle.com/java/technologies/javase-java-archive-javase6-downloads.html
#ADD jdk-6u45-linux-x64.bin /usr/local/src
#RUN ./jdk-6u45-linux-x64.bin && \
#    rm jdk-6u45-linux-x64.bin



#~~~~~~~~~~~
# Environmental Variables 
#~~~~~~~~~~~
ENV SRC /usr/local/src
ENV BIN /usr/local/bin


#~~~~~~~~~~~~~~~~~~
# Install BLAST+
#~~~~~~~~~~~~~~~~~~
WORKDIR $SRC
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.12.0+-x64-linux.tar.gz && \
    tar xf ncbi-blast-2.12.0+-x64-linux.tar.gz && \
    rm ncbi-blast-2.12.0+-x64-linux.tar.gz

#~~~~~~~~~~~~~~~~~
# Picard Tools
#~~~~~~~~~~~~~~~~~
WORKDIR $SRC
RUN wget https://github.com/broadinstitute/picard/releases/download/2.25.2/picard.jar
ENV PICARD_HOME $SRC/picard.jar

#~~~~~~~~~~~~~~~~~~~~~~~~~~
## Samtools (& bcftools)
#~~~~~~~~~~~~~~~~~~~~~~~~~~
WORKDIR $SRC
ENV SAMTOOLS_VERSION=1.12
RUN SAMTOOLS_URL="https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2" && \
    cd $SRC && \
    wget $SAMTOOLS_URL && \
    tar xf samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    cd samtools-${SAMTOOLS_VERSION}/htslib-${SAMTOOLS_VERSION} && ./configure && make && make install && \
    cd ../ && ./configure --without-curses && make && make install && \
    rm $SRC/samtools-${SAMTOOLS_VERSION}.tar.bz2 && rm -r $SRC/samtools-${SAMTOOLS_VERSION}


#~~~~~~~~~~~
## Bedtools
#~~~~~~~~~~~
RUN wget -q https://github.com/arq5x/bedtools2/releases/download/v2.30.0/bedtools-2.30.0.tar.gz && \
   tar xf bedtools-2.30.0.tar.gz && \
   cd bedtools2 && \
   make && \
   cp bin/* $BIN/ && \
   rm $SRC/bedtools-2.30.0.tar.gz && rm -r $SRC/bedtools2

#~~~~~~~~~~~~~~
# BWA
#~~~~~~~~~~~~~~
RUN git clone https://github.com/lh3/bwa.git && \
    cd bwa && \
    make && \
    cp -r * $BIN/ && \
    cd .. && \
    rm -r bwa







#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## BatVI
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

WORKDIR $SRC
#ARG CACHEBUST=1
RUN wget https://www.comp.nus.edu.sg/~bioinfo/batvi/batvi1.03.tar.gz && \
    tar -zxvf batvi1.03.tar.gz && \
        cd batvi1.03 && \
        ./build.sh

#~~~~~~~~~~~~~~~~~~~~~~~~~
# Install the git repo
#~~~~~~~~~~~~~~~~~~~~~~~~~
WORKDIR $SRC
ARG CACHEBUST=1
RUN git clone https://github.com/brownmp/BatVI.git



RUN apt-get -qq -y remove automake build-essential cmake curl git gcc g++ wget && \
    apt-get -qq -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/log/dpkg.log


