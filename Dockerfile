# infrid/python3-wine-staging
FROM ubuntu:20.04

ENV WINEARCH win64

RUN apt-get update \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install software-properties-common unzip curl wget libsm6:i386 tini -y \
    && wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
    && apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' \
    && apt-get update \
    && apt install --install-recommends winehq-stable -y \
    && apt-get install xvfb fonts-wine -y \
    && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x winetricks \
    && sh winetricks win10 \
    && wget https://www.python.org/ftp/python/3.9.5/python-3.9.5-amd64.exe -O python-3.9.5-amd64.exe \
    && xvfb-run wine python-3.9.5-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir=c:\Python3 \
    && rm python-3.9.5-amd64.exe \
    && wine C:/Python3/python.exe -m ensurepip --upgrade \
    && wine C:/Python3/python.exe -m pip install pyinstaller

ENTRYPOINT ["tini", "--"]
CMD ["/bin/bash"]
