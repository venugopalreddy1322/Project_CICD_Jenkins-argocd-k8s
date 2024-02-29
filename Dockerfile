# You can change this base image to anything else
# But make sure to use the correct version of Java
FROM adoptopenjdk/openjdk11-alpine

# Simply the artifact path
#ARG artifact=target/spring-boot-web.jar

WORKDIR /opt/app

#COPY ${artifact} app.jar
COPY target/spring-boot-web.jar /opt/app/app.jar

# This should not be changed
ENTRYPOINT ["java","-jar","app.jar"]