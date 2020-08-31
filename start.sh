#!/bin/sh
docker stop demo
docker build -t webapp .
docker system prune -f
docker rmi golang:alpine
docker rmi alpine:latest
#docker rmi nginx:alpine
docker run -d --name demo -p 80:80 webapp