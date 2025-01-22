# Docker Image - Rill Data

_Revision Date: 1/21/2025_


<!---------- BREAK START ------------->
<!---------> &nbsp;<br>
<!---------- BREAK END --------------->

# Overview

This image installs Rill based on their install script: `curl https://rill.sh | sh` taken from [https://www.rilldata.com/](https://www.rilldata.com/).


<!---------- BREAK START ------------->
<!---------> &nbsp;<br>
<!---------- BREAK END --------------->


# Build Image

- **Docker Hub** image is accessible here: [automaatio / rill-data](https://hub.docker.com/repository/docker/automaatio/rill-data/general)
- `Dockerfile` is accesible here: [automaatio-dev / rill-data / Dockerfile](Dockerfile)

Example instructions for how to build and push this image:

```
docker buildx build --push --platform linux/amd64 \
  --tag automaatio/rill-data:latest \
  --tag automaatio/rill-data:0.52.7 .
```


<!---------- BREAK START ------------->
<!---------> &nbsp;<br>
<!---------- BREAK END --------------->


# Docker Compose

Example [docker-compose.yml](docker-compose.yml) for running this image. 

Access the web ui by going to `http://localhost:9009/`.

```
# Docker-Compose

################################################
# Services
################################################

services:

  ################################################
  # Rill Data
  ################################################

  rill-data:
    image: "automaatio/rill-data:latest"
    container_name: "rill-data"
    restart: "unless-stopped"
    command: "bash -c '[ -f /rill-data/rill.yaml ] || echo \"# Default rill.yaml content\" > /rill-data/rill.yaml && rill start'" # Adds placeholder file for intial setup
    ports:
      - "9009:9009"
    volumes:
      - "/home/docker/rill-data:/rill-data"
    networks:
      - "rill-data"


################################################
# Networks
################################################

networks:
  rill-data:
    name: "rill-data"
```