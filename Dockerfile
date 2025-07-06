FROM debian:bookworm-slim

ARG CUID=1000 # UID of runtime user

ENV USER="steam"
ENV HOMEDIR="/home/${USER}"
ENV STEAMCMD_DIR="${HOMEDIR}/steamcmd"
ENV AVORION_DIR="${HOMEDIR}/avorion"
ENV VOLUME_DIR="/data"

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        curl \
        lib32gcc-s1 \
        lib32stdc++6 \
        locales \
        libsdl2-2.0-0 \
        unzip && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    useradd -u "${CUID}" -m "${USER}" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* /var/tmp/* && \
    mkdir -p "${VOLUME_DIR}" && \
    chown -R "${CUID}:${CUID}" "${VOLUME_DIR}"

USER steam

RUN mkdir -p "${STEAMCMD_DIR}" && \
    curl -sSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xvz -C "${STEAMCMD_DIR}" && \
    chmod +x "${STEAMCMD_DIR}/steamcmd.sh" && \
    rm -f "steamcmd_linux.tar.gz" && \
    "./${STEAMCMD_DIR}/steamcmd.sh" +quit

RUN mkdir -p "${HOMEDIR}/.avorion/galaxies" && \
    ln -sf "${VOLUME_DIR}" "${HOMEDIR}/.avorion/galaxies/avorion_galaxy"

RUN "${STEAMCMD_DIR}/steamcmd.sh" \
        +login anonymous \
        +force_install_dir "${AVORION_DIR}" \
        +app_update 565060 validate \
        +quit

WORKDIR "${AVORION_DIR}"

VOLUME ["/data"]

EXPOSE 27000/udp 27000/tcp 27003/udp 27020/udp 27021/udp

# We do entrypoint so we can pass additional arguments at runtime
ENTRYPOINT ["server.sh"]