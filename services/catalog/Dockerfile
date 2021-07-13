FROM node:14
LABEL maintainer="Christian Posta <christian.posta@gmail.com>" 

RUN npm install json-server@0.14.2 faker@4.1.0

WORKDIR /usr/src/app
VOLUME /usr/src/app

COPY package*.json /usr/src/app/
RUN npm install

EXPOSE 3000

COPY *.js /usr/src/app/

ENTRYPOINT ["node", "server.js"]
CMD []
