#!/bin/bash

# Sistem paketlerini güncelle
sudo apt update -y
sudo apt install -y docker.io

# Docker servisini başlat ve otomatik başlatmayı etkinleştir
sudo systemctl start docker
sudo systemctl enable docker

# Daha önce aynı container varsa durdur ve sil
sudo docker rm -f treepedia-container || true

# En güncel imajı çek ve yayına al
sudo docker pull nidacambay/treepedia-site
sudo docker run -d --name treepedia-container -p 80:80 nidacambay/treepedia-site
