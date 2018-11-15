FROM alpine/git as clone
ARG url
WORKDIR /app
RUN git clone -b tomcat ${url}
FROM maven:3.5-jdk-8-alpine as build
ARG project
WORKDIR /app
COPY --from=clone /app/${project} /app
RUN mvn package -DskipTests
FROM tomcat:9.0-jre8-alpine
ARG artifactid
ARG version
ENV artifact ${artifactid}-${version}.BUILD-SNAPSHOT.war
WORKDIR /app
COPY --from=build /app/target/${artifact} $CATALINA_HOME/webapps/petclinic.war
HEALTHCHECK --interval=1m --timeout=3s CMD wget --quiet --tries=1 --spider http://localhost:8080/petclinic/ || exit 1