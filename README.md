# nodejs template project

This project serves as a template to create a basic hello world project with
nodejs.

Use docker image to create a container and run a node js application. It also explains how to mount volumes to a container. Mounting volumes are useful as you can use it to makes the code changes be available inside the container.


## Understanding project structure and files

```
node-app-docker
├── Dockerfile
├── index.htlm
├── package.json
├── server.js
└── README.md
```

### Dockerfile

```bash
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

```

### package.json

```
{
  "name": "docker_web_app",
  "version": "1.0.0",
  "description": "Node.js on Docker",
  "author": "Snigdha Sambit Aryakumar <first.last@example.com>",
  "main": "server.js",
  "dependencies": {
    "express": "^4.16.1"
  }
}
```
### server.js


```
let http = require('http');
let fs = require('fs');


let handleRequest = (request, response) => {
    response.writeHead(200, {
        'Content-Type': 'text/html'
    });
    fs.readFile('./index.html', null, function (error, data) {
        if (error) {
            response.writeHead(404);
            respone.write('AWW SNAP! File not found!');
        } else {
            response.write(data);
        }
    response.end();
});
};
http.createServer(handleRequest).listen(8888);

```

### index.html

```
<!doctype html>
<html lang="en">

<head>
    <title>Hello, world!</title>
</head>

<body>
    <h1>Hello, SREs, It's a beautiful day today!</h1>
</body>

</html>
```

## Build your application

* How to build a docker image.

```bash
docker build -t node-app-docker .
```

* How to create a docker container from the image.

We expose port 8080 from the local machine to 8888 of the container.

```bash
docker run -p 8080:8888 node-app-docker:latest
```
You can hit the browser at localhost:8080 to see the node application

## Build and test simultaneously 

Suppose, you would like to change the application and want to see the changes without having to build the docker image from the scratch. Which is a fair requirement as you need to make the changes and test the results

Let's change the Dockerfile a bit

```bash

FROM alpine:3.8
 
RUN apk add --update nodejs nodejs-npm
 
# Create app directory
WORKDIR /usr/src/app
 
COPY package.json ./
 
# npm install
RUN npm install
 
# Expose port
EXPOSE 8888

```

Build a new container

```bash
docker build -t node-app-docker .
```

Spin a container using the new image

```bash
docker run -it -p 8080:8888 -v ($pwd):/usr/src/app node-app-docker node server.js
```
  
`docker -it` will open the shell once the container is up and running and it will executes the "node server.js" command which starts the node server. Now if you change in anything the application, lets say the index.html, you will able to see the changes once you refresh the browser.

