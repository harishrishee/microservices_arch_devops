#jdk
FROM openjdk:11.0.10-jre
WORKDIR /app
COPY target/shoes-0.0.1-SNAPSHOT.jar /app 

EXPOSE 1002

CMD ["java", "-jar", "shoes-0.0.1-SNAPSHOT.jar"]
