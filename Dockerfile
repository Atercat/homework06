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

# публикация приложения
RUN cp target/hello-1.0.war /var/lib/tomcat9/webapps/
EXPOSE 8080