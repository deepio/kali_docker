FROM debian

ARG BUILD_DATE
ARG VERSION
ARG VCS_URL
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-url=$VCS_URL \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.version=$VERSION \
  org.label-schema.name='Kali Linux' \
  org.label-schema.description='un0ff1c14l Kali Linux docker image' \
  org.label-schema.usage='https://www.kali.org/news/official-kali-linux-docker-images/' \
  org.label-schema.url='https://www.kali.org/' \
  org.label-schema.vendor='Offensive Security' \
  org.label-schema.schema-version='1.0' \
  org.label-schema.docker.cmd='docker run --rm d33pi0/kali:latest' \
  org.label-schema.docker.cmd.devel='docker run --rm -ti d33pi0/kali:latest' \
  org.label-schema.docker.debug='docker logs $CONTAINER' \
  io.github.deepio.docker.dockerfile="Dockerfile" \
  io.github.offensive-security.license="GPLv3" \
  MAINTAINER="d33pi0"

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
  # Core
  && apt-get -yq update \
  && apt-get -yqq dist-upgrade \
  && apt-get install -yqq \
    apt-transport-https \
    gnupg \
    wget \
    python-pip \
  # Add kali repositories
  && echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list \
  && echo "deb-src http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list \
  && wget -q -O /opt/archive-key.asc https://archive.kali.org/archive-key.asc \
  && apt-key add /opt/archive-key.asc \
  # Add tools
  && apt-get -yqq update \
  && apt-get -yqq install \
    metasploit-framework \
    dsniff \
    hydra \
    netcat \
  # Clean up PPA
  && rm -rf /var/lib/apt/lists/*


COPY ./entrypoint /run/entrypoint
RUN sed -i 's/\r//' /run/entrypoint
RUN chmod +x /run/entrypoint

ENTRYPOINT ["/run/entrypoint"]
CMD ["bash"]