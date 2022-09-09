FROM ubuntu:18.04

RUN mkdir -p /itsyrealm && mkdir -p /root/.local/share/ItsyRealm/
ADD love.AppImage itsyrealm.love /itsyrealm
ADD settings.cfg /root/.local/share/ItsyRealm/settings.cfg

WORKDIR /itsyrealm
RUN ./love.AppImage --fused ./itsyrealm.love

EXPOSE 18323/udp
