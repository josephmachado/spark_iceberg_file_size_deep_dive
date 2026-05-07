# List available commands
default:
    just --list

# Docker compose up
up:
    docker compose up -d --build --scale spark-worker=2

# Docker compose down
down:
    docker compose down -v

# Docker compose down
down-clean:
    docker compose down -v
    sudo rm -rf ./minio_data/*
    sudo rm -rf ./notebooks/data/*

sh:
  docker exec -ti spark-master bash

nb:
  open http://localhost:8888/lab

airflow:
  open http://localhost:8080

# Restart docker containers
restart:
  just down 
  just up
