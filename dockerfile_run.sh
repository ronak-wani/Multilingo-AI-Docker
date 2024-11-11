#!/bin/bash
source .env
docker stop group6
docker kill group6
docker rm group6
docker rmi rvwani
echo "Removing dangling images..."
docker images -qf dangling=true | xargs docker rmi
docker build --rm -f Dockerfile1 -t ronakwani/rvwani:latest . 2>&1 | tee build1.txt
docker build -t ronakwani/grafana:latest -f Dockerfile2 . 2>&1 | tee build2.txt
docker build -t ronakwani/prometheus:latest -f Dockerfile3 . 2>&1 | tee build3.txt
docker run --name group6 --network monitoring -d -p 127.0.0.1:8010:8010 --env GEMINI_API_KEY=$GEMINI_API_KEY --env NGROK_TOKEN=$NGROK_TOKEN ronakwani/rvwani:latest
docker run --name prometheus --network monitoring -d -p 127.0.0.1:8002:9090 -v ./prometheus.yml:/etc/prometheus/prometheus.yml ronakwani/prometheus:latest
docker run --name grafana --network monitoring -d -p 127.0.0.1:8003:3000 ronakwani/grafana:latest
