FROM node:latest
MAINTAINER Christian Posta <christian.posta@gmail.com>

RUN npm install json-server faker lodash

WORKDIR /usr/src/app
VOLUME /usr/src/app

EXPOSE 3000

COPY *.js /usr/src/app/
COPY package*.json /usr/src/app/

RUN npm install

ENTRYPOINT ["node", "server.js"]
CMD []
