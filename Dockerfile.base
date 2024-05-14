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

# Set up config files
COPY docker-entrypoint.sh /
COPY conf/condor_config.local /etc/condor/
COPY conf/supervisord.conf /etc/supervisor/
COPY conf/supervisor.d/condor.conf /etc/supervisor/conf.d/

ENV _CONDOR_DESIGNATED_PROJECT="TEST"
ENV JOB_DEFAULT_REQUESTMEMORY=128
CMD ["/docker-entrypoint.sh"]
