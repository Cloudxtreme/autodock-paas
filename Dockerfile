FROM gliderlabs/alpine:3.1

ENTRYPOINT ["/entrypoint.sh"]
CMD ["up"]

ENV DOMAIN=mydomain.com

RUN \
    apk add --update ca-certificates wget python && \
    rm -rf /var/cache/apk/* && \
	wget -q -O - https://bootstrap.pypa.io/ez_setup.py | python - && \
	wget -q -O - https://bootstrap.pypa.io/get-pip.py | python - && \
	rm /*.zip && \
	pip install docker-compose j2cli

COPY entrypoint.sh /entrypoint.sh
COPY docker-compose.yml.j2 /docker-compose.yml.j2
