FROM ubuntu:20.04 as ubuntu
USER root
RUN apt update
RUN apt install -y git
RUN snap install --classic go
RUN go version