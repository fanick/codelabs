FROM golang:alpine as go
USER root
RUN apk add --no-cache bash git 
WORKDIR /app
RUN mkdir -p /app/data
RUN git clone https://github.com/fanick/codelabs.git
RUN go get github.com/googlecodelabs/tools/claat

RUN \
    cd /app/codelabs/markdown &&\
    for f in *.md ; do\
    claat export -o /app/data $f;\
    done

FROM alpine as alpine
RUN apk add --no-cache bash git nodejs npm
WORKDIR /app
RUN mkdir -p /app/data
RUN mkdir -p /app/dist
RUN git clone https://github.com/googlecodelabs/tools
RUN mkdir -p /app/tools/site/codelabs
COPY --from=go /app/data/* /app/tools/site/codelabs/
WORKDIR /app/tools/site
RUN npm install > /dev/null
RUN npm install -g gulp-cli > /dev/null
RUN npm audit fix --force > /dev/null
RUN gulp dist --codelabs-dir=codelabs
RUN ls -ailh dist
RUN cp -r dist/* /app/dist

RUN unlink /app/tools/site/dist/codelabs
RUN mkdir -p /app/tools/site/dist/codelabs
RUN cp -r /app/tools/site/codelabs/* /app/tools/site/dist/codelabs/

FROM nginx:alpine as nginx
#!/bin/sh
RUN rm -rf /usr/share/nginx/html/*
COPY --from=alpine /app/tools/site/dist/* /usr/share/nginx/html/
RUN ls -ailh /usr/share/nginx/html/
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
