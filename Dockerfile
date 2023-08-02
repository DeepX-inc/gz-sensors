
# Adds DeepX Gazebo Sensors image.
#
# Docker commands:
# - To build the image:
#   docker build -t deepx-gz-sensors .
# - To publish the image:
#   docker push ghcr.io/deepx-inc/deepx-gz-sensors

FROM ghcr.io/deepx-inc/base_images:1.0.0-foxy

# ---BUILD TOOLS---
RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
    cmake=3.16.* \
    ffmpeg=7:4.2.* \
    freeglut3-dev=2.8.* \
    g++-8=8.4.* \
    git=1:2.25.* \
    gnupg=2.2.* \
    libfreeimage-dev=3.18.* \
    libglew-dev=2.1.* \
    libogre-2.2-dev=2.2.* \
    libxi-dev=2:1.7.* \
    libxmu-dev=2:1.1.* \
    ninja-build=1.10.* \
    pkg-config=0.29.* \
    redis-server=5:5.0.* \
    redis-tools=5:5.0.* \
    software-properties-common=0.99.* \
    lsb-release=11.1.* \
    wget=1.20.* \
    curl=7.68.*

# ---STANDARD GAZEBO INSTALL---
RUN apt-get -qq update && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-prerelease `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-prerelease.list' && \
    wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - && \
    add-apt-repository ppa:kisak/kisak-mesa && \
    curl -sSL http://get.gazebosim.org | sh && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8 --slave /usr/bin/gcov gcov /usr/bin/gcov-8 && \
    apt-get -qq update && \
    apt-get -qq upgrade -y --no-install-recommends \
    libignition-cmake2-dev=2.16.* \
    libignition-common4-dev=4.7.* \
    libignition-fuel-tools7-dev=7.3.* \
    libignition-gazebo6-dev=6.14.* \
    libignition-gui6-dev=6.8.* \
    libignition-launch5-dev=5.3.* \
    libignition-math6-dev=6.14.* \
    libignition-msgs8-dev=8.7.* \
    libignition-physics5-dev=5.3.* \
    libignition-plugin-dev=1.4.* \
    libignition-tools-dev=1.5.* \
    libignition-transport11-dev=11.4.* \
    libignition-utils-dev=1.3.* \
    libsdformat12=12.7.* \
    && apt-get -qq -y autoclean \
    && apt-get -qq -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR "/root/gazebo"

# ---PREPARE GZ-RENDERING DIRECTORY---
RUN git clone -b sync/ignition-6-with-upstream --single-branch https://github.com/DeepX-inc/gz-rendering.git && \
    mkdir -p gz-rendering/build

# ---PREPARE GZ-SENSORS DIRECTORY---
COPY . gz-sensors/

RUN mkdir -p gz-sensors/build