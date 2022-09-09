FROM ubuntu:18.04
USER root

RUN mkdir -p /itsyrealm && mkdir -p /root/.local/share/ItsyRealm/
ADD love.AppImage itsyrealm.love /itsyrealm
ADD itsyscape/cicd/linux/settings.cfg /root/.local/share/ItsyRealm/settings.cfg

WORKDIR /itsyrealm
CMD ./love.AppImage --appimage-extract-and-run --fused ./itsyrealm.love

EXPOSE 18323/udp
