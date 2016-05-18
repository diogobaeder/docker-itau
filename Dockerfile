FROM ubuntu:14.04
RUN apt-get update && apt-get install -y python-software-properties software-properties-common
RUN add-apt-repository multiverse && apt-get update && apt-get install -y \
    firefox \
    openssl \
    libcurl3 \
    libnss3-tools \
    xvfb \
    flashplugin-installer \
    openjdk-7-jre \
    icedtea-7-plugin \
    ca-certificates \
    ca-certificates-java \
    xfonts-base \
    xfonts-cyrillic \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-mathml \
    && echo finished

COPY warsaw_setup_64.deb /tmp/

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/itau && \
    echo "itau:x:${uid}:${gid}:itau,,,:/home/itau:/bin/bash" >> /etc/passwd && \
    echo "itau:x:${uid}:" >> /etc/group && \
    echo "itau ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/itau && \
    chmod 0440 /etc/sudoers.d/itau && \
    chown ${uid}:${gid} -R /home/itau

RUN bash -c 'Xvfb :1 -screen 0 1280x960x24 &' && \
    DISPLAY=:1 XDG_RUNTIME_DIR=/tmp PWD=/home/itau sudo -i -u itau firefox -CreateProfile default && \
    pkill firefox && \
    bash -c 'ps aux | grep firefox' && \
    dpkg -i /tmp/warsaw_setup_64.deb

USER itau
ENV HOME /home/itau
CMD sudo /usr/local/bin/warsaw/core && /usr/bin/firefox
