FROM mcr.microsoft.com/windows/servercore:20H2
SHELL ["powershell", "-Command"]

# Install Dependencies
ADD https://download.microsoft.com/download/6/A/A/6AA4EDFF-645B-48C5-81CC-ED5963AEAD48/vc_redist.x64.exe /vc_redist.x64.exe
RUN C:\vc_redist.x64.exe /quiet /install

# Add Condor files
ADD condor/ /Condor
RUN md \Condor\log \
  ; md \Condor\execute

# Set permissions
RUN $Acl = Get-Acl "C:\Condor\execute" \
  ; $Ar = New-Object System.Security.AccessControl.FileSystemAccessRule('User Manager\ContainerAdministrator', 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow') \
  ; $Acl.SetAccessRule($Ar) \
  ; Set-Acl "C:\Condor\execute" $Acl

# Set up config files
COPY docker-entrypoint.bat /
COPY condor_config.local /condor/condor_config.local

ENV CONDOR_CONFIG="/condor/etc/condor_config.generic"
ENV _CONDOR_DESIGNATED_PROJECT="TEST"
ENV _CONDOR_CONDOR_HOST="condor_collector"
ENV JOB_DEFAULT_REQUESTMEMORY=128

EXPOSE 9618

CMD ["/docker-entrypoint.bat"]
