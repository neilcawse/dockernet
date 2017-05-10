FROM ubuntu:rolling
MAINTAINER Neil Cawse <neilcawse@hotmail.com>

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list' \
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893 \
apt-get update && apt-get -y install \
  fluxbox \
  git \
  supervisor \
  x11vnc \
  xdotool \
  xvfb \
  chromium-browser \
  code \
  dotnet-dev-1.0.4

USER root
WORKDIR /root/
ADD novnc /root/novnc/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8080
CMD ["/usr/bin/supervisord"]
