FROM mcr.microsoft.com/windows/servercore:20H2

# Install Dependencies
ADD https://download.microsoft.com/download/6/A/A/6AA4EDFF-645B-48C5-81CC-ED5963AEAD48/vc_redist.x64.exe /vc_redist.x64.exe
RUN C:\vc_redist.x64.exe /quiet /install

# Add Condor files
ADD condor/ /Condor
RUN md \Condor\log \Condor\execute

# Set up config files
COPY docker-entrypoint.bat /
COPY condor_config.local /Condor/condor_config.local


ENV CONDOR_CONFIG="/Condor/etc/condor_config.generic"
ENV _CONDOR_DESIGNATED_PROJECT="TEST"
ENV _CONDOR_CONDOR_HOST="condor_collector"
ENV JOB_DEFAULT_REQUESTMEMORY=128
CMD ["/docker-entrypoint.bat"]
