FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /App

COPY . ./

RUN dotnet restore

RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/runtime:6.0 
WORKDIR /App

RUN apt-get update &&  \
  apt-get install -y gnupg && \
  #apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  #echo "deb https://download.mono-project.com/repo/ubuntu stable-buster main" >> /etc/apt/sources.list.d/mono-official-stable.list && \
  echo "deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty multiverse deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty-updates multiverse deb http://us-west-2.ec2.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" | tee /etc/apt/sources.list.d/multiverse.list && \
  apt-get update && \
  apt-get install -y libfontconfig1 && \
  apt-get install -y libgdiplus && \
  apt-get install -y ttf-mscorefonts-installer

COPY --from=build-env /App/out .
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]