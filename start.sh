#!/bin/sh
docker stop demo
docker build -t webapp .
docker system prune -f
docker rmi ubuntu:latest
docker run -d --name demo -p 80:80 webapp