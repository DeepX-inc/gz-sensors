
# Adds DeepX Gazebo Sensors image.
#
# Docker commands:
# - To build the image:
#   docker build -t deepx-gz-sensors .
# - To publish the image:
#   docker push ghcr.io/deepx-inc/deepx-gz-sensors

FROM ghcr.io/deepx-inc/base_images:1.0.0-foxy

# ---BUILD TOOLS---
RUN apt -qq update \
    && apt -qq install -y --no-install-recommends \
    cmake \
    ffmpeg \
    freeglut3-dev \
    g++-8 \
    git \
    gnupg \
    libfreeimage-dev \
    libglew-dev \
    libogre-2.2-dev \
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
RUN apt -qq update && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-prerelease `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-prerelease.list' && \
    wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - && \
    add-apt-repository ppa:kisak/kisak-mesa && \
    curl -sSL http://get.gazebosim.org | sh && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8 --slave /usr/bin/gcov gcov /usr/bin/gcov-8 && \
    apt -qq update && \
    apt -qq upgrade -y --no-install-recommends \
    libignition-cmake2-dev \
    libignition-common4-dev \
    libignition-fuel-tools7-dev \
    libignition-gazebo6-dev \
    libignition-gui6-dev \
    libignition-launch5-dev \
    libignition-math6-dev \
    libignition-msgs8-dev \
    libignition-physics5-dev \
    libignition-plugin-dev \
    libignition-tools-dev \
    libignition-transport11-dev \
    libignition-utils-dev \
    libsdformat12 \
    libignition-plugin-dev \
    && apt -qq -y autoclean \
    && apt -qq -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR "/root/gazebo"

# ---PREPARE GZ-RENDERING DIRECTORY---
RUN git clone https://github.com/DeepX-inc/gz-rendering.git && \
    mkdir -p gz-rendering/build

# ---PREPARE GZ-SENSORS DIRECTORY---
COPY . gz-sensors/

RUN mkdir -p gz-sensors/build