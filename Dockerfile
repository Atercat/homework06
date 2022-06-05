# версия для Alpine
FROM alpine:3.11

# подготовка окружения для сборки
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add openjdk11 maven tomcat9 git

# скачивание и сборка
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
WORKDIR /boxfuse-sample-java-war-hello
RUN mvn package; exit 0