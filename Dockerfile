# a dockerfile that represents your app
FROM ubuntu:focal

RUN useradd --uid 1029 --user-group --create-home --shell /bin/bash abc
USER abc
RUN mkdir -p workdir
WORKDIR /home/abc/workdir

USER root
COPY entrypoint.sh /entrypoint
COPY matchown.sh /usr/local/bin/matchown
RUN chmod +x /entrypoint /usr/local/bin/matchown

COPY --chown=abc:abc app /home/abc/workdir/

ENTRYPOINT ["/entrypoint"]
CMD ["/bin/bash", "/app/hello.sh"]
