
###
# Created on 1/16/2025
# Modified on 1/21/2025
# Image Name: Rill-Data
###


################################################################
### Base Image
################################################################

# Use an official Ubuntu base image
FROM ubuntu:latest


################################################################
### Environment
################################################################

# Suppress interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Set terminal type to xterm for better compatibility with terminal operations
ENV TERM=xterm

# Define the working directory for the application
ENV WORKDIR=/rill-data

# Set the working directory within the container
WORKDIR ${WORKDIR}


################################################################
### Install/Update Packages & Entrypoint Script
################################################################

# Install required system packages and clean up
RUN apt-get update && \
    apt-get install -y curl bash coreutils openssl wget unzip perl && \
    rm -rf /var/lib/apt/lists/*

# Ensure sha256sum is available as shasum
RUN ln -sf /usr/bin/sha256sum /usr/local/bin/shasum


################################################################
### Install Application
################################################################

# Download the script and modify the script to use correct shasum
RUN curl -fsSL https://rill.sh -o /tmp/rill.sh && \
    sed -i '/promtInstallChoice()/a INSTALL_DIR="/usr/local/bin"; return;' /tmp/rill.sh && \
    sed -i '/read -r ans/d' /tmp/rill.sh && \
    sed -i 's/sudo //g' /tmp/rill.sh && \
    sed -i 's/shasum --algorithm 256/sha256sum/g' /tmp/rill.sh && \
    sed -i 's/tput[^;]*;//g' /tmp/rill.sh && \
    chmod +x /tmp/rill.sh

# Make script executable
RUN chmod +x /tmp/rill.sh

# Run the modified script
RUN bash /tmp/rill.sh

# Create the default Rill project directory and add a basic rill.yaml
RUN mkdir -p $WORKDIR && \
    touch $WORKDIR/rill.yaml


################################################################
### Rill
################################################################

# Expose the default Rill port
EXPOSE 9009

# Start Rill
CMD ["rill", "start"]