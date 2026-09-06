FROM node:20-alpine

RUN apk add --no-cache git openssl bash

WORKDIR /app

RUN git clone --depth 1 https://github.com/steveseguin/vdo.ninja.git /app/vdo.ninja && \
    git clone --depth 1 https://github.com/steveseguin/offline_deployment.git /app/webserver

WORKDIR /app/webserver
RUN npm install && npm install express

RUN sed -i 's/\/\/ session\.customWSS = true;/session.wss = "wss:\/\/"+window.location.host;session.customWSS = true;session.salt = "vdo.ninja";session.configuration = {};/' /app/vdo.ninja/index.html

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8443
CMD ["/run.sh"]
