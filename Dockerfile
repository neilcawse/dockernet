FROM monokrome/wine
MAINTAINER Neil Cawse <neilcawse@hotmail.com>

# Wget is needed by winetricks. Git,Mercurial need by Go. Install GOLANG
RUN apt-get update && apt-get -y install \
  git-core \
  golang \
  mercurial \
  wget
  
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

# Install .NET Framework 4.0
RUN wine wineboot && xvfb-run winetricks --unattended dotnet40 corefonts
