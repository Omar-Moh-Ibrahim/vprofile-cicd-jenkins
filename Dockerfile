FROM tomcat:9.0.75-jre11

WORKDIR /usr/local/tomcat/webapps/

RUN rm -rf ROOT

COPY target/vprofile-v2.war ROOT.war
