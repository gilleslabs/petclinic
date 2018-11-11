FROM alpine/git as clone
ARG url
WORKDIR /app
RUN git clone ${url}
FROM maven:3.5-jdk-8-alpine as build
ARG project
WORKDIR /app
COPY --from=clone /app/${project} /app
RUN mvn package -DskipTests
FROM openjdk:8-jre-alpine
ARG artifactid
ARG version
ENV artifact ${artifactid}-${version}.BUILD-SNAPSHOT.jar
WORKDIR /app
COPY --from=build /app/target/${artifact} /app
ENTRYPOINT ["sh", "-c"]
EXPOSE 8080
CMD ["java -jar ${artifact}"]