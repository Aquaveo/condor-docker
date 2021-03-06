FROM mcr.microsoft.com/windows/servercore:20H2

# Install Dependencies
ADD https://download.microsoft.com/download/6/A/A/6AA4EDFF-645B-48C5-81CC-ED5963AEAD48/vc_redist.x64.exe /vc_redist.x64.exe
RUN C:\vc_redist.x64.exe /quiet /install

# Add Condor files
ADD condor/ /Condor

# Set up config files
COPY docker-entrypoint.bat /
COPY conf/condor_config.local /Condor/etc/condor_config.local
COPY conf/condor.d/worker /Condor/etc/condor_config.local

ENV CONDOR_CONFIG="/Condor/etc/condor_config"
ENV _CONDOR_DESIGNATED_PROJECT="TEST"
ENV JOB_DEFAULT_REQUESTMEMORY=128
CMD ["/docker-entrypoint.bat"]
