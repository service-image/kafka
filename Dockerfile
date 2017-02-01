FROM java:openjdk-8-jre-alpine

ENV SCALA_VERSION=2.11 \
    KAFKA_VERSION=0.10.1.1 \
    KAFKA_HOME=/opt/kafka \
    PATH=${PATH}:/opt/kafka/bin

RUN apk add --update bash vim curl jq docker && \
  mkdir /opt && \
  mirror=$(curl --stderr /dev/null https://www.apache.org/dyn/closer.cgi\?as_json\=1 | jq -r '.preferred') && \
  url="${mirror}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" && \
  wget -q "${url}" -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" && \
  tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && \
  rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
  ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME}

COPY scripts/* /usr/bin/

RUN chmod a+x /usr/bin/start-kafka.sh /usr/bin/create-topics.sh

EXPOSE 2181 9092

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
