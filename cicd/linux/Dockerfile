FROM ubuntu:22.04
USER root

RUN mkdir -p /itsyrealm && \
	mkdir -p /itsyrealm/config && \
	mkdir -p /root/.local/share && \
	ln -s /itsyrealm/config /root/.local/share/ItsyRealm
ADD ./cicd/linux/love.AppImage /itsyrealm
ADD ./cicd/linux/settings.cfg /itsyrealm/config/settings.cfg

WORKDIR /itsyrealm

CMD ./love.AppImage --appimage-extract-and-run

EXPOSE 18323/udp
