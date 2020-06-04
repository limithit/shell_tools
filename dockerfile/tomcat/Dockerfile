FROM centos:latest

LABEL maintainer="sshfortress.com"

# instal dependencies
COPY tomcat /usr/local/tomcat
COPY jdk /usr/local/jdk
EXPOSE 8080
ENV CATALINA_HOME /usr/local/tomcat
ENV JAVA_HOME /usr/local/jdk
ENV JRE_HOME /usr/local/jdk/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib:${CLASSPATH}
ENV PATH ${JAVA_HOME}/bin:${JRE_HOME}/bin:${PATH}
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]


