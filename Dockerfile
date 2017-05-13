FROM ubuntu:rolling
MAINTAINER Neil Cawse <neilcawse@hotmail.com>
# Install prerequisites

RUN apt-get update -y && \
	apt-get -y install \
	curl \
	git \
	net-tools \
	python \
	python-numpy \
	python-pkg-resources \
	vim \
	websockify \
	wget \
	xdotool \
	xfonts-base \
	x11-utils \
	x11vnc \
	xvfb \
  dirmngr

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
  && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' \
  && sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ yakkety main" > /etc/apt/sources.list.d/dotnetdev.list' \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893

RUN apt-get update -y && \
  apt-get -y install \
  chromium-browser \
  code \
  dotnet-dev-1.0.4
  
ENV DISPLAY=:0

RUN cd / && git clone git://github.com/kanaka/noVNC 

ADD index.html /noVNC/
ADD init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 80

CMD ["/init.sh"]
