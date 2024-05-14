FROM ubuntu:22.04

# Install HTCondor
RUN apt-get update -qq \
 && apt-get -yqq install wget gnupg2 supervisor > /dev/null \
 && mkdir -p /var/log/supervisor \
 && wget -qO - https://research.cs.wisc.edu/htcondor/repo/keys/HTCondor-23.x-Key | gpg --dearmour -o /etc/apt/trusted.gpg.d/condor.gpg \
 && echo "deb https://research.cs.wisc.edu/htcondor/repo/ubuntu/23.x jammy main" >> /etc/apt/sources.list \
 && apt-get update -qq \
&& DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -yqq condor=23.4.0-1.1 > /dev/null \
&& rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
