FROM fedora:latest
LABEL name brave-release-fedora

LABEL maintainer "Matt Bacchi <mbacchi@gmail.com>"

ARG UID_GID=1000
ENV UID_GID=${UID_GID}

RUN dnf install -y dnf-plugins-core libcanberra mesa-dri-drivers pulseaudio-libs libv4l \
 && dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/ \
 && rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc \
 && dnf install -y brave-browser

RUN groupadd -g ${UID_GID} -r brave && useradd -u ${UID_GID} -r -g brave -G audio,video brave \
    && mkdir -p /home/brave/Downloads && chown -R brave:brave /home/brave

USER brave

ENTRYPOINT brave-browser > /dev/null 2>&1
