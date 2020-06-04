FROM ubuntu:18.04

# Install HTCondor
RUN apt-get update -qq \
 && apt-get -yqq install wget gnupg2 supervisor > /dev/null \
 && mkdir -p /var/log/supervisor \
 && wget -qO - https://research.cs.wisc.edu/htcondor/ubuntu/HTCondor-Release.gpg.key | apt-key add - \
 && echo "deb http://research.cs.wisc.edu/htcondor/ubuntu/8.8/bionic bionic contrib" >> /etc/apt/sources.list \
 && echo "deb-src http://research.cs.wisc.edu/htcondor/ubuntu/8.8/bionic bionic contrib" >> /etc/apt/sources.list \
 && apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -yqq htcondor > /dev/null

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
