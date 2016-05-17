FROM ubuntu:14.04
RUN apt-get update && apt-get install -y \
    firefox \
    openssl \
    libcurl3 \
    libnss3-tools


RUN export uid=1000 gid=1000 && \
    mkdir -p /home/itau && \
    echo "itau:x:${uid}:${gid}:itau,,,:/home/itau:/bin/bash" >> /etc/passwd && \
    echo "itau:x:${uid}:" >> /etc/group && \
    echo "itau ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/itau && \
    chmod 0440 /etc/sudoers.d/itau && \
    chown ${uid}:${gid} -R /home/itau

COPY warsaw_setup_64.deb /home/itau/
RUN dpkg -i /home/itau/warsaw_setup_64.deb

USER itau
ENV HOME /home/itau
CMD /usr/bin/firefox
