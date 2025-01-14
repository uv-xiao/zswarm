FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -ri.bak -e 's/\/\/.*?(archive.ubuntu.com|mirrors.*?)\/ubuntu/\/\/mirrors.pku.edu.cn\/ubuntu/g' -e '/security.ubuntu.com\/ubuntu/d' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    tmux \
    build-essential \
    software-properties-common \
    python-pip\
    python3.6 \
    python3-pip \
    python3.6-dev \
    vim \
    scons \
    git \
    cmake \
    curl \
    autoconf \
    automake \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libopencv-dev \
    libtbb-dev \
    jq \
    parallel \
    cppcheck \
    coinor-libipopt-dev \
    libgtk-3-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    gfortran \
    openexr \
    libatlas-base-dev \
    libtbb2 \
    libdc1394-22-dev \
    git-lfs \
    clang-format \
    libconfig-dev \
    libconfig++-dev \
    libhdf5-dev \
    libelf-dev \
    feh \
    xvfb \
    python3-tk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    apt-get update && apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1

RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get install -y gcc-11 g++-11
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 60 --slave /usr/bin/g++ g++ /usr/bin/g++-11

WORKDIR /tartan

COPY requirements.txt .

RUN python3 -m pip install --upgrade --verbose pip setuptools wheel
RUN pip3 install --no-cache-dir -r requirements.txt
RUN python -m pip install scons_compiledb

COPY . .

RUN chmod +x ./setup.sh
RUN chmod +x ./replicate.py
