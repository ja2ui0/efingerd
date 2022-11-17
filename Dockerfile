FROM alpine:edge

RUN apk add --no-cache socat

COPY bin/ /usr/bin/

CMD ["sh", "/usr/bin/init.sh"]

EXPOSE 79

