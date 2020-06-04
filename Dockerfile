FROM ubuntu:18.04

# Install HTCondor
RUN apt-get update -qq \
 && apt-get -yqq install wget gnupg2 supervisor > /dev/null \
 && mkdir -p /var/log/supervisor \
 && wget -qO - https://research.cs.wisc.edu/htcondor/ubuntu/HTCondor-Release.gpg.key | apt-key add - \
 && echo "deb http://research.cs.wisc.edu/htcondor/ubuntu/8.8/bionic bionic contrib" >> /etc/apt/sources.list \
 && echo "deb-src http://research.cs.wisc.edu/htcondor/ubuntu/8.8/bionic bionic contrib" >> /etc/apt/sources.list \
 && apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -yqq htcondor=8.8.2-1 libclassad10=8.8.2-1 > /dev/null \
 && rm -rf /var/lib/apt/lists/*

# Set up config files
COPY docker-entrypoint.sh /
COPY conf/condor_config.local /etc/condor/
COPY conf/supervisord.conf /etc/supervisor/
COPY conf/supervisor.d/condor.conf /etc/supervisor/conf.d/

ENV _CONDOR_DESIGNATED_PROJECT="TEST"
ENV JOB_DEFAULT_REQUESTMEMORY=128
CMD ["/docker-entrypoint.sh"]
