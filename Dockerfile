# Use Tomcat base image with JRE 8
FROM tomcat:8-jre8

LABEL maintainer="valaxytech@gmail.com"

# Remove default ROOT app to clean Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the generated WAR from Maven build
COPY webapp/target/webapp.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
