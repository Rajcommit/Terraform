# Assignment 3: Dockerize Node.js App
# Your task: Fill in this Dockerfile following the requirements

# TODO: Add your Dockerfile instructions here

## This is the base image for our Node.js application. It includes Node.js and npm, which are necessary to run our app. The "alpine" version is a lightweight image that helps keep our final Docker image small., it also helps in faster build times and reduced attack surface, making it a good choice for production environments.
## We should use a specific version of Node.js to ensure consistency across different environments. In this case, we are using Node.js version 6, which is compatible with our application. Using a specific version also helps avoid potential issues that may arise from changes in newer versions of Node.js.
FROM node:6-alpine

## Now i will be adding tini for handling signal and reaping zombie processes, which is important for ensuring that our application can shut down gracefully when running in a containerized environment. Tini is a small init system that helps manage processes in Docker containers, preventing issues with orphaned processes and ensuring that signals are properly handled.
## By installing tini and setting it as the entry point, we can improve the stability and reliability of our Node.js application when running in a Docker container.
## Here no-cache option is used to prevent the caching of the package index, which helps reduce the size of the final image and ensures that we always get the latest version of tini when building the image.
##RUN. is used to execute commands in the Dockerfile. In this case, we are using it to install tini using the apk package manager, which is the default package manager for Alpine Linux. This command will add tini to our Docker image, allowing us to use it as the entry point for our application.
RUN apk add --no-cache tini

## The WORKDIR instruction sets the working directory for any subsequent instructions in the Dockerfile. In this case, we are setting it to /app, which is where our Node.js application will be located inside the container. This means that any commands we run after this instruction will be executed in the context of the /app directory.
WORKDIR /usr/src/app

##The reason we are putting WORKDIR after RUN is because we want to ensure that the necessary dependencies (like tini) are installed before we set the working directory for our application. By installing dependencies first, we can avoid potential issues that may arise from missing dependencies when we later set the working directory and try to run our application.
## If we were to set the WORKDIR before installing dependencies, we might encounter errors when trying to run our application, as it may not have access to the necessary dependencies that were installed in the previous step. By installing dependencies first, we can ensure that our application has everything it needs to run smoothly when we set the working directory and execute our application commands.
COPY package*.json ./

##Now we will copy the dependencies from our local machine to the docker image. This is necessary because we need to have all the required dependencies available in the container for our Node.js application to run properly. By copying the package.json and package-lock.json files, we can ensure that all the dependencies specified in those files are included in the Docker image.
## Also, we are using  npm install to install the dependencies listed in our package.json file. This command will read the package.json file and install all the required dependencies for our Node.js application. After installing the dependencies, we are using npm cache clean --force to clear the npm cache, which helps reduce the size of our Docker image by removing unnecessary files that were used during the installation process.
RUN npm install && npm cache clean --force

## Finally, we are copying the rest of our application code into the Docker image. This includes all the source files and any other necessary files for our Node.js application to run. By copying the entire application code, we can ensure that our application is fully contained within the Docker image and can be executed without any issues when we run the container.
##So basically we copied all the files from the current directory (where the Dockerfile is located) to the /usr/src/app/ directory inside the Docker image where we have our workdirectory. This allows our Node.js application to be available in the container and ready to run when we execute the appropriate commands to start our application.
COPY . /usr/src/app/

#Now let's Expose the port that our Node.js application will be running on. This is necessary to allow external access to our application when the container is running. By exposing the port, we can map it to a port on the host machine, allowing users to access our application through that port.Here we are exposing port 3030, which is the port that our Node.js application will be listening on. This means that when we run the container, we can map this port to a port on the host machine (e.g., 8080) to access our application from outside the container.
EXPOSE 3000

## Finally, we are setting the entry point for our Docker container to use tini as the init system. This ensures that our Node.js application can handle signals properly and shut down gracefully when running in a containerized environment. By using tini as the entry point, we can improve the stability and reliability of our application when it is running inside a Docker container.
## The -- option is used to separate the arguments for tini from the command that we want to run. In this case, we are telling tini to execute the npm start command, which will start our Node.js application. This setup allows our application to benefit from the process management features of tini, such as proper signal handling and reaping of zombie processes, which can help ensure that our application runs smoothly and can shut down gracefully when needed.
# ENTRYPOINT ["/sbin/tini", "--"]
# CMD ["npm", "start"]

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "./bin/www"]