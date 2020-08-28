#!/bin/sh
docker stop demo
docker build -t webapp .
docker system prune -f
docker rmi blang/golang-alpine:latest
docker run -d --name demo -p 80:80 webapp