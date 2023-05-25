
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
    g++-10 \
    git \
    gnupg \
    libfreeimage-dev \
    libglew-dev \
    libogre-next-dev \
    libxi-dev \
    libxmu-dev \
    ninja-build \
    pkg-config \
    redis-server \
    redis-tools \
    software-properties-common \
    lsb-release \
    wget \
    curl

# ---STANDARD GAZEBO INSTALL---
RUN apt-get -qq update && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-prerelease `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-prerelease.list' && \
    wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - && \
    add-apt-repository ppa:kisak/kisak-mesa && \
    curl -sSL http://get.gazebosim.org | sh && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 800 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10 && \
    apt-get -qq update && \
    apt-get -qq upgrade -y --no-install-recommends \
    libgz-cmake3-dev \
    libgz-common5-dev \
    libgz-fuel-tools8-dev \
    libgz-sim7-dev \
    libgz-gui7-dev \
    libgz-launch6-dev \
    libgz-math7-dev \
    libgz-msgs9-dev \
    libgz-physics6-dev \
    libgz-plugin2-dev \
    libgz-tools2-dev \
    libgz-transport12-dev \
    libgz-utils2-dev \
    libsdformat13 \
    && apt-get -qq -y autoclean \
    && apt-get -qq -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR "/root/gazebo"

# ---PREPARE GZ-RENDERING DIRECTORY---
RUN git clone -b update/sync-upstream-7 --single-branch https://github.com/DeepX-inc/gz-rendering.git && \
    mkdir -p gz-rendering/build

# ---PREPARE GZ-SENSORS DIRECTORY---
COPY . gz-sensors/

RUN mkdir -p gz-sensors/build