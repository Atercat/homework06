# Alpine version
FROM alpine:3.11

ENV boxfuse="boxfuse-sample-java-war-hello"
ENV tc9_ver="9.0.63"
ENV wars_dir=/opt/apache-tomcat-${tc9_ver}/webapps

# WAR build
RUN apk update && apk add openjdk11 maven git \
    && git clone https://github.com/boxfuse/${boxfuse}.git \
    && mvn -f ${boxfuse}/pom.xml package \
    && mv ${boxfuse}/target/hello-1.0.war / \
    && rm -rf ${boxfuse} \
    && apk del openjdk11 maven git

# Install Tomcat9 and publish the app
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v${tc9_ver}/bin/apache-tomcat-${tc9_ver}.tar.gz \
    && tar -xf apache-tomcat-${tc9_ver}.tar.gz -C /opt \
    && rm -rf ${wars_dir}/* \
    && mv hello-1.0.war ${wars_dir}/ \
    && ln -s ${wars_dir}/hello-1.0 ${wars_dir}/ROOT
EXPOSE 8080

# Run Tomcat
RUN apk add openjdk11-jre
CMD ["sh", "-c", "/opt/apache-tomcat-${tc9_ver}/bin/catalina.sh run"]