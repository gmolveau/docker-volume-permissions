# a dockerfile that represents your app
FROM ubuntu:focal

RUN useradd --uid 911 --user-group --home /app --shell /bin/bash abc
RUN mkdir -p /app
WORKDIR /app

COPY entrypoint.sh /entrypoint
COPY matchown.sh /usr/local/bin/matchown
RUN chmod +x /entrypoint /usr/local/bin/matchown

COPY app /app

ENTRYPOINT ["/entrypoint"]
CMD ["/bin/bash", "/app/hello.sh"]
