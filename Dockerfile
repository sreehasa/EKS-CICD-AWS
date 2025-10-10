# Pull base image
FROM tomcat:8-jre8

# Maintainer
MAINTAINER "valaxytech@gmail.com"

# Copy WAR file from root of build context
COPY webapp.war /usr/local/tomcat/webapps/
