FROM gradle:4.10-jdk8 as builder
# copy first so /usr/app/src has correct owner, then set WD
COPY --chown=1000:1000 . /usr/app/src/
WORKDIR /usr/app/src/

RUN gradle --info --stacktrace assemble
RUN ./build.sh


FROM openjdk:8-jre-slim

RUN apt-get update && apt-get --yes upgrade && \
    apt-get install -y python3 python3-pip curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder --chown=0:0 /usr/app/src/build/output/kafka-gitops /usr/local/bin/kafka-gitops
