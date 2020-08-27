FROM ubuntu:20.04 as ubuntu
RUN apt update
RUN apt install -y git
RUN sudo snap install --classic go
RUN go version