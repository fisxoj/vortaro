FROM parentheticalenterprises/sbcl-quicklisp-base:2.1.1-2021-01-24

MAINTAINER fisxoj@gmail.com

WORKDIR /app

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get -y -qq install --no-install-recommends build-essential libcurl4-openssl-dev libev4 ca-certificates curl git && \
    apt-get -y autoremove --purge && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./bin ./bin

COPY qlfile qlfile.lock vortaro.asd ./

RUN sbcl --non-interactive \
        --load bin/environment.lisp \
        --eval "(ql:quickload :vortaro)"

COPY . .

RUN ./bin/build

CMD ./vortaro
