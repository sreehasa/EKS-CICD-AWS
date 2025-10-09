# -----------------------
# Stage 1: Build
# -----------------------
FROM public.ecr.aws/docker/library/maven:3.9.5-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# -----------------------
# Stage 2: Runtime with JMX + Heap Config
# -----------------------
FROM public.ecr.aws/docker/library/openjdk:21-jdk-slim

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar hello-world.jar

# Enable JMX (can be overridden in K8s)
ENV JAVA_JMX_OPTS="-Dcom.sun.management.jmxremote \
                   -Dcom.sun.management.jmxremote.port=9010 \
                   -Dcom.sun.management.jmxremote.rmi.port=9010 \
                   -Dcom.sun.management.jmxremote.ssl=false \
                   -Dcom.sun.management.jmxremote.authenticate=false \
                   -Djava.rmi.server.hostname=127.0.0.1"

# Default heap memory settings
ENV JAVA_HEAP_OPTS="-Xms1024m -Xmx1024m"

# Optional: JVM tuning flags
ENV JAVA_MISC_OPTS="-XX:+UseG1GC -XX:+ExitOnOutOfMemoryError"

# Expose both app port and JMX port
EXPOSE 8085 9010

# Start the service
ENTRYPOINT ["sh", "-c", "java $JAVA_HEAP_OPTS $JAVA_JMX_OPTS $JAVA_MISC_OPTS -jar hello-world.jar"]
