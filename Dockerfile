# With multi-stage docker build, to get light weight docker image
# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11-slim AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package

# Stage 2: Create the final image
FROM openjdk:11-jre-slim
WORKDIR /opt/app

# Copy only the built artifact from the previous stage
COPY --from=build /app/target/spring-boot-web.jar /opt/app/app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
