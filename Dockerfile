FROM gradle:7-jdk AS build

COPY ./src /srv/src
COPY ./build.gradle /srv/
COPY ./settings.gradle /srv/

WORKDIR /srv/
RUN gradle clean build

FROM openjdk:19-buster

RUN apt update -y && apt install -y unzip

COPY --from=build /srv/build/distributions/eureka-server-boot-*.zip /server/eureka-server-boot.zip

RUN cd /server/;unzip eureka-server-boot.zip
RUN cd /srv/; rm -rf ./*
RUN cd /server/eureka-server*/; mv ./* ../; cd ../; rm -rf ./eureka-server*/

WORKDIR /server/
CMD ./bin/eureka-server