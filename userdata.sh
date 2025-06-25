#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Docker Hub'dan image çek ve yayına al
docker run -d -p 80:80 nidacambay/treepedia-site
