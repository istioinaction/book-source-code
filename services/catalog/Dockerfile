# Base image for multi-stage build
FROM node:14-alpine AS BUILD_IMAGE
LABEL maintainer="Christian Posta <christian.posta@gmail.com>" 

RUN npm install json-server@0.14.2 faker@4.1.0

WORKDIR /usr/src/app
VOLUME /usr/src/app

COPY package.json /usr/src/app/
RUN npm install

# Final image
FROM node:14-alpine
WORKDIR /usr/src/app
# Copy build artifacts from BUILD_IMAGE
COPY --from=BUILD_IMAGE /usr/src/app/ /usr/src/app/
COPY --from=BUILD_IMAGE /node_modules /node_modules
COPY *.js /usr/src/app/
RUN apk add curl

EXPOSE 3000
ENTRYPOINT ["node", "server.js"]
CMD []
