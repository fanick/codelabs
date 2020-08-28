FROM golang:alpine as go
USER root
RUN apk add --no-cache bash git 
WORKDIR /app
RUN mkdir -p /app/data
RUN git clone https://github.com/googlecodelabs/tools
RUN git clone https://github.com/fanick/codelabs.git
RUN go get github.com/googlecodelabs/tools/claat

RUN \
    cd /app/codelabs/markdown &&\
    for f in *.md ; do\
    claat export -o /app/data $f;\
    done

RUN ls -ailh /app