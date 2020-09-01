FROM golang:alpine as goapp
USER root
RUN apk add --no-cache bash git 
WORKDIR /app
RUN git clone https://github.com/fanick/codelabs.git
RUN git clone https://github.com/googlecodelabs/tools
RUN go get github.com/googlecodelabs/tools/claat
RUN mkdir -p /app/tools/site/codelabs
RUN mkdir -p /tmp/codelabs

RUN \
    cd /app/codelabs/markdown &&\
    for f in *.md ; do\
    claat export -o /tmp/codelabs $f;\
    done

FROM node:stretch as nodeapp
WORKDIR /app
RUN mkdir -p /app/tools
RUN mkdir -p /app/tools/site/codelabs
COPY --from=goapp /app/tools/* /app/tools/
WORKDIR /app/tools/site
COPY --from=goapp /tmp/codelabs/* /app/tools/codelabs/
# install
RUN npm install > /dev/null
RUN npm install -g gulp-cli > /dev/null
RUN npm audit fix --force > /dev/null
RUN gulp dist --codelabs-dir=codelabs

FROM nginx:latest as nginx
RUN rm -rf /usr/share/nginx/html/*
RUN mkdir -p /usr/share/nginx/html/dist/
COPY --from=nodeapp /app/tools/site/dist/* /usr/share/nginx/html/dist/
RUN ls -ailh /usr/share/nginx/html/
COPY --from=goapp /app/codelabs/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]