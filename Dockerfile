FROM ubuntu:20.04

# чтобы tzdata установилась тихо
ENV DEBIAN_FRONTEND=noninteractive

# подготовка окружения для сборки
RUN apt update
RUN apt install default-jdk maven tomcat9 git -y

# скачивание и сборка
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
WORKDIR /boxfuse-sample-java-war-hello
RUN mvn package

# публикация приложения в корень
ENV apps_dir=/var/lib/tomcat9/webapps
RUN cp target/hello-1.0.war ${apps_dir}/
RUN rm -rf ${apps_dir}/ROOT
RUN ln -s ${apps_dir}/hello-1.0 ${apps_dir}/ROOT
EXPOSE 8080

# очистка ненужных пакетов и файлов
RUN apt purge default-jdk maven git -y
RUN apt autoremove -y
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*
WORKDIR /
RUN rm -rf boxfuse-sample-java-war-hello
RUN rm -rf /root/.m2

# запуск tomcat
ENV CATALINA_BASE=/var/lib/tomcat9
CMD ["/usr/share/tomcat9/bin/catalina.sh", "run"]