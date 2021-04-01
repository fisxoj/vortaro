FROM parentheticalenterprises/sbcl-quicklisp-base:2.1.1-2021-01-24

MAINTAINER fisxoj@gmail.com

WORKDIR /app

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get -y -qq install --no-install-recommends build-essential libcurl4-openssl-dev libev4 ca-certificates curl git && \
    apt-get -y autoremove --purge && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./bin /app/bin

RUN git clone --branch 0.8.0 --depth=1 https://github.com/fisxoj/validate.git /quicklisp/local-projects/validate
RUN git clone --branch 0.3.4 --depth=1 https://gitlab.com/knttl/nest.git /quicklisp/local-projects/nest

# Precompile some of the libraries
RUN sbcl --non-interactive \
        --load bin/environment.lisp \
        --eval "(ql:quickload :nest)"

COPY vortaro.asd /app/

COPY ./ /app/

RUN sbcl --non-interactive \
        --load bin/environment.lisp \
        --eval "(ql:quickload :vortaro)"

RUN ./bin/build

CMD ./vortaro
