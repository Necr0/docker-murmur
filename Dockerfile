FROM alpine:latest
MAINTAINER Necro <necro@necro.dev>

ARG MURMUR_DATA=/var/lib/murmur

RUN apk add --no-cache murmur bash && \
    mkdir -p /etc/murmur

COPY ./murmur.ini /etc/murmur.ini
COPY ./run.sh /bin/run-murmur

ENV MURMUR_DATABASE="$MURMUR_DATA/murmur.sqlite" \
    MURMUR_DBDRIVER="QSQLITE" \
    MURMUR_DBPORT="0" \
    MURMUR_ICE="tcp -h 127.0.0.1 -p 6502" \
    MURMUR_AUTOBANATTEMPTS="10" \
    MURMUR_AUTOBANTIMEFRAME="120" \
    MURMUR_AUTOBANTIME="300" \
    MURMUR_WELCOMETEXT="<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />" \
    MURMUR_PORT="64738" \
    MURMUR_BANDWIDTH="128000" \
    MURMUR_USERS="100" \
    MURMUR_MESSAGEBURST="5" \
    MURMUR_MESSAGELIMIT="1" \
    MURMUR_ALLOWPING="true" \
    MURMUR_OPUSTHRESHHOLD="100" \
    MURMUR_CHANNELNESTINGLIMIT="10" \
    MURMUR_CHANNELCOUNTLIMIT="1000" \
    MURMUR_CHANNELNAME="[ \\\\-=\\\\w\\\\#\\\\[\\\\]\\\\{\\\\}\\\\(\\\\)\\\\@\\\\|]+" \
    MURMUR_USERNAME="[-=\\\\w\\\\[\\\\]\\\\{\\\\}\\\\(\\\\)\\\\@\\\\|\\\\.]+" \
    MURMUR_TEXTMESSAGELENGTH="5000" \
    MURMUR_IMAGEMESSAGELENGTH="131072" \
    MURMUR_ALLOWHTML="true" \
    MURMUR_LOGDAYS="-1" \
    MURMUR_BONJOUR="False" \
    MURMUR_SSLDHPARAMS="@ffdhe2048" \
    MURMUR_SSLCIPHERS="EECDH+AESGCM:EDH+aRSA+AESGCM:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:AES256-SHA:AES128-SHA" \
    MURMUR_UNAME="root" \
    MURMUR_CERTREQUIRED="False" \
    MURMUR_SENDVERSION="True" \
    MURMUR_LEGACYPASSWORDHASH="false" \
    MURMUR_KDFITERATIONS="-1" \
    MURMUR_ICE_WARN_UNKNOWNPROPERTIES="1" \
    MURMUR_ICE_MESSAGESIZEMAX="65536" \
    MURMUR_TIMEOUT="30" \
    MURMUR_USERSPERCHANNEL="0" \
    MURMUR_SQLITE_WAL="0"\
    MURMUR_DEFAULTCHANNEL="0"

EXPOSE 64738/tcp 64738/udp
VOLUME $MURMUR_DATA

CMD ["/bin/bash", "/bin/run-murmur"]
