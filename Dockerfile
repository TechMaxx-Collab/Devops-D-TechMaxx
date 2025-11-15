# Use a lightweight Java base image
FROM eclipse-temurin:21-jre-alpine

# Set a working directory
WORKDIR /app

# Copy the packaged jar file (maven banayega)
# Pehle build karna padega: mvn clean package
COPY target/*.jar app.jar

# Expose the port Spring Boot uses
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]