FROM monokrome/wine
MAINTAINER Neil Cawse <neilcawse@hotmail.com>

# Wget is needed by winetricks. Git,Mercurial need by Go. Install GOLANG. vnc dependencies
RUN apt-get update && apt-get -y install \
  fluxbox \
  git-core \
  golang \
  mercurial \
  supervisor \
  wget \
  x11vnc \
  xdotool \
  xvfb

ENV GOPATH /usr/lib/go/
ENV PATH $GOPATH/bin:$PATH

# Install Drive (Google Drive)
RUN go get -u github.com/odeke-em/drive/cmd/drive

# Wine really doesn't like to be run as root, so let's set up a non-root
# environment
RUN useradd -d /home/wuser -m -s /bin/bash wuser
USER wuser
ENV HOME /home/wuser
ENV WINEPREFIX /home/wuser/.wine
ENV WINEARCH win32
ENV DISPLAY :0

# Install .NET Framework 4.0
RUN wine wineboot && xvfb-run winetricks --unattended dotnet40 corefonts

USER root
WORKDIR /root/
ADD novnc /root/novnc/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8080
CMD ["/usr/bin/supervisord"]
