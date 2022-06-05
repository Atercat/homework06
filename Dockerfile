# версия для Alpine
FROM alpine:3.11

# подготовка окружения для сборки
RUN apk update && apk add openjdk11 maven git

# скачивание и сборка
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
WORKDIR /boxfuse-sample-java-war-hello
RUN mvn package; exit 0

# установка Tomcat 9
ENV tc9_ver="9.0.63"
RUN wget https://dlcdn.apache.org/tomcat/tomcat-9/v${tc9_ver}/bin/apache-tomcat-${tc9_ver}.tar.gz
RUN tar -xf apache-tomcat-${tc9_ver}.tar.gz -C /opt
EXPOSE 8080

# публикация приложения и запуск Tomcat
ENV apps_dir=/opt/apache-tomcat-${tc9_ver}/webapps
RUN rm -rf ${apps_dir}/*
RUN cp target/hello-1.0.war ${apps_dir}/
RUN ln -s ${apps_dir}/hello-1.0 ${apps_dir}/ROOT
CMD ["sh", "-c", "/opt/apache-tomcat-${tc9_ver}/bin/catalina.sh run"]