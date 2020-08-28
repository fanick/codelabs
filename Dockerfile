FROM golang as go
USER root
RUN apk add --no-cache bash git 
WORKDIR /app

RUN git clone https://github.com/googlecodelabs/tools
RUN git clone https://github.com/fanick/codelabs.git
RUN go get github.com/googlecodelabs/tools/claat

RUN ls -ailh /app