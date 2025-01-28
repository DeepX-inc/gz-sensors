
# Adds DeepX Gazebo Sensors image.
#
# Docker commands:
# - To build the image:
#   docker build -t deepx-gz-sensors .
# - To publish the image:
#   docker push ghcr.io/deepx-inc/deepx-gz-sensors

FROM ghcr.io/deepx-inc/base_images:humble

# ---BUILD TOOLS---
RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
    cmake \
    ffmpeg \
    freeglut3-dev \
    g++ \
    git \
    gnupg \
    libfreeimage-dev=3.18.* \
    libglew-dev=2.2.* \
    libogre-next-dev=2.2.* \
    libxi-dev=2:1.* \
    libxmu-dev=2:1.* \
    ninja-build=1.10.* \
    pkg-config=0.29.* \
    software-properties-common=0.99.22.* \
    lsb-release=11.1.* \
    wget=1.21.* \
    curl=7.81.*

# ---STANDARD GAZEBO INSTALL---
RUN apt-get -qq update && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-prerelease `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-prerelease.list' && \
    wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - && \
    add-apt-repository ppa:kisak/kisak-mesa && \
    curl -sSL http://get.gazebosim.org | sh && \
    apt-get -qq update && \
    apt-get -qq upgrade -y --no-install-recommends \
    libgz-cmake3-dev \
    libgz-common5-dev \
    libgz-fuel-tools8-dev \
    libgz-gui7-dev \
    libgz-launch6-dev \
    libgz-math7-dev \
    libgz-msgs9-dev \
    libgz-physics6-dev \
    libgz-plugin2-dev \
    libgz-sim7-dev \
    libgz-tools2-dev \
    libgz-transport12-dev \
    libgz-utils2-dev \
    libsdformat13 \
    && apt-get -qq -y autoclean \
    && apt-get -qq -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR "/root/gazebo"

# ---PREPARE GZ-RENDERING DIRECTORY---
RUN git clone -b gz-rendering7 --single-branch https://github.com/DeepX-inc/gz-rendering.git && \
    mkdir -p gz-rendering/build

# ---PREPARE GZ-SENSORS DIRECTORY---
COPY . gz-sensors/

RUN mkdir -p gz-rendering/build && cd gz-rendering/build && cmake .. && make -j4 && make install

RUN mkdir -p gz-sensors/build && cd gz-sensors/build && cmake .. && make -j4
