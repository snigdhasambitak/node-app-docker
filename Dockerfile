FROM alpine:3.8

RUN apk add --update nodejs nodejs-npm

# Create app directory
WORKDIR /usr/src/app

# npm install
RUN npm install

COPY package.json ./

# Bundle app source
COPY . .

# Expose port
EXPOSE 8888

CMD [ "node", "server.js" ]
