
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
    cmake=3.22.* \
    ffmpeg=7:4.4.* \
    freeglut3-dev=2.8.* \
    g++-10=10.4.* \
    git=1:2.34.* \
    gnupg=2.2.* \
    libfreeimage-dev=3.18.* \
    libglew-dev=2.2.* \
    libogre-next-dev=2.2.* \
    libxi-dev=2:1.* \
    libxmu-dev=2:1.* \
    ninja-build=1.10.* \
    pkg-config=0.29.* \
    redis-server=5:6.0.* \
    redis-tools=5:6.0.* \
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
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8 --slave /usr/bin/gcov gcov /usr/bin/gcov-8 && \
    apt-get -qq update && \
    apt-get -qq upgrade -y --no-install-recommends \
    libgz-cmake3-dev=3.2.* \
    libgz-common5-dev=5.4.* \
    libgz-fuel-tools8-dev=8.0.* \
    libgz-gui7-dev=7.2.* \
    libgz-launch6-dev=6.0.* \
    libgz-math7-dev=7.1.* \
    libgz-msgs9-dev=9.4.* \
    libgz-physics6-dev=6.4.* \
    libgz-plugin2-dev=2.0.* \
    libgz-sim7-dev=7.5.* \
    libgz-tools2-dev=2.0.* \
    libgz-transport12-dev=12.2.* \
    libgz-utils2-dev=2.0.* \
    libsdformat13=13.5.* \
    && apt-get -qq -y autoclean \
    && apt-get -qq -y autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR "/root/gazebo"

# ---PREPARE GZ-RENDERING DIRECTORY---
RUN git clone -b sync-to-origin-7-attempt-2 --single-branch https://github.com/DeepX-inc/gz-rendering.git && \
    mkdir -p gz-rendering/build

# ---PREPARE GZ-SENSORS DIRECTORY---
COPY . gz-sensors/

RUN mkdir -p gz-sensors/build