FROM node:latest
LABEL maintainer="Christian Posta <christian.posta@gmail.com>" 

RUN npm install json-server faker

WORKDIR /usr/src/app
VOLUME /usr/src/app

COPY package*.json /usr/src/app/
RUN npm install

EXPOSE 3000

COPY *.js /usr/src/app/

ENTRYPOINT ["node", "server.js"]
CMD []
