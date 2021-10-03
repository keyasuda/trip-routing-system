FROM valhalla/valhalla:run-3.1.3

RUN apt-get update && apt-get -y install python3-distutils

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD []
