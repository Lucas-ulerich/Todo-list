FROM ubuntu:latest AS build
LABEL authors="lucas"

# Atualizando os pacotes e instalando o JDK
RUN apt-get update && apt-get install -y openjdk-21-jdk maven

# Define o diretório de trabalho no contêiner
WORKDIR /app

# Copia o POM e o código-fonte para o contêiner
COPY pom.xml .
COPY src ./src

# Executa o build do Maven para gerar o arquivo JAR
RUN mvn clean install

# Segunda etapa: imagem mais enxuta para executar a aplicação
FROM openjdk:21-jdk-slim

# Define o diretório de trabalho no contêiner
WORKDIR /app

# Expondo a porta 8080
EXPOSE 8080

# Copia o arquivo JAR gerado na fase de build
COPY --from=build /app/target/todolist-0.0.1-SNAPSHOT.jar app.jar

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "app.jar"]
