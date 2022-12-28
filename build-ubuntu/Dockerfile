FROM fedora:latest as BUILD

RUN set -x \
  && dnf update -y && dnf install unzip procps -y

ENV LC_ALL=en_US.utf8 \
    LANG=en_US.utf8 \
    LANGUAGE=en_US.utf8 \
    PCBEDIR=/opt/APC/PowerChuteBusinessEdition/Agent \
    PCBEVER=10.0.5-301

WORKDIR /tmp/pcbe/$PCBEVER
RUN set -x \
  && curl -o pcbeagent-$PCBEVER-EN.x86_64.tar.gz "https://download.schneider-electric.com/files?p_enDocType=Software+-+Release&p_File_Name=pcbeagent-$PCBEVER-EN.x86_64.tar.gz" \
  && tar -xzf pcbeagent-$PCBEVER-EN.x86_64.tar.gz \
  && mkdir -p /etc/rc.d/init.d/ \
  && rpm -ivh --prefix=$PCBEDIR pbeagent-*.x86_64.rpm \
  && cd $PCBEDIR \
  && rm -rf /tmp/pcbe/$PCBEVER \
  && ( ../jre/bin/java --add-exports java.base/com.sun.crypto.provider=ALL-UNNAMED -jar ./lib/pcbeconfig.jar user=apcadm pass=Qq111111 signal=serial port=/dev/ttyS0 || true )

# ----------

FROM ubuntu:latest

RUN set -x \
  && apt-get update && apt-get install openssh-client -y

ENV PCBEDIR=/opt/APC/PowerChuteBusinessEdition/Agent
ENV JAVA_RUNTIME=$PCBEDIR/../jre/bin/java \
    LD_LIBRARY_PATH=$PCBEDIR/lib/linux64

COPY --from=BUILD /opt/APC/PowerChuteBusinessEdition /opt/APC/PowerChuteBusinessEdition
COPY entrypoint.sh /

WORKDIR $PCBEDIR

RUN set -x \
  && chmod +x /entrypoint.sh \
  && mkdir -p /var/lock/subsys \
  && touch /var/lock/subsys/PBEAgent

EXPOSE 6547/tcp

LABEL org.opencontainers.image.description "APC PowerChute Business Edition as a Docker container"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["../jre/bin/java", "-Dpicard.main.thread=blocking", "-classpath", "lib/*:Resources/*:comp/*", "com.apcc.m11.application.PicardApplication", "@critical.cfg"]
