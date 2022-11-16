FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
  efingerd openbsd-inetd finger \
  && rm -rf /var/lib/apt/lists/* \
  /etc/adduser.conf /etc/login.defs \
  /etc/skel && mkdir /etc/skel \
  && chmod 755 /etc/efingerd/* \
  && echo "finger stream tcp nowait efingerd /usr/sbin/tcpd /usr/sbin/efingerd -n -f" > /etc/inetd.conf

COPY ./init.sh /

CMD ["sh","init.sh"]

EXPOSE 79

