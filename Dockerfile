# Pull base image 
From tomcat:8-jre8 

# Maintainer 
MAINTAINER "valaxytech@gmail.com" 
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war
