FROM debian:stretch

MAINTAINER fisxoj@gmail.com

WORKDIR /app

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get -y -qq install --no-install-recommends build-essential libcurl4-openssl-dev libev4 ca-certificates curl git && \
    apt-get -y autoremove --purge && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install sbcl
ENV SBCL_VERSION="1.4.1"

RUN curl -O -L https://downloads.sourceforge.net/project/sbcl/sbcl/${SBCL_VERSION}/sbcl-${SBCL_VERSION}-x86-64-linux-binary.tar.bz2 && \
    bzip2 -cd sbcl-${SBCL_VERSION}-x86-64-linux-binary.tar.bz2 | tar xvf - && \
    cd sbcl-${SBCL_VERSION}-x86-64-linux && \
    sh install.sh && \
    cd .. && \
    rm -rf sbcl-${SBCL_VERSION}-x86-64-linux &&\
    rm sbcl-${SBCL_VERSION}-x86-64-linux-binary.tar.bz2

# Install Quicklisp
RUN curl -O https://beta.quicklisp.org/quicklisp.lisp && \
    sbcl --non-interactive --load quicklisp.lisp \
         --eval "(quicklisp-quickstart:install)" \
         --eval "(ql:quickload :qlot)" && \
    rm quicklisp.lisp

COPY ./bin ./bin

COPY qlfile qlfile.lock vortaro.asd ./

RUN sbcl --non-interactive --load bin/environment.lisp --eval "(qlot:install)"

COPY . .

RUN ./bin/build

CMD ./vortaro
