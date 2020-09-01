FROM golang:alpine as go
USER root
RUN apk add --no-cache bash git 
WORKDIR /app
RUN git clone https://github.com/fanick/codelabs.git
RUN go get github.com/googlecodelabs/tools/claat
RUN mkdir -p /app/tools/site/codelabs
RUN mkdir -p /var/www/codelabs

RUN \
    cd /app/codelabs/markdown &&\
    for f in *.md ; do\
    claat export -o /var/www/codelabs $f;\
    done

FROM alpine as alpine
RUN apk add --no-cache bash git nodejs npm nginx
WORKDIR /app
RUN git clone https://github.com/googlecodelabs/tools
WORKDIR /app/tools/site
RUN mkdir -p /app/tools/site/codelabs
COPY --from=go /var/www/codelabs/* /app/tools/site/codelabs/
# install
RUN npm install > /dev/null
RUN npm install -g gulp-cli > /dev/null
RUN npm audit fix --force > /dev/null
RUN gulp dist --codelabs-dir=codelabs
RUN cp -r /app/tools/site/dist/* /var/www/
RUN  ls -ailh /var/www
COPY --from=go /app/codelabs/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
