FROM ubuntu:latest AS build
LABEL authors="lucas"

RUN apt-get update
RUN apt-get install openjdk-21-jdk -y

COPY . .

RUN apt-get install maven -y
RUN mvn clean install

FROM openjdk:21-jdk-slim

EXPOSE 8080

COPY --from=build /target/todolist-0.0.1-.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]