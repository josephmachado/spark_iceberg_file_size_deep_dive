## Setup 

**Prerequisites**:

1. [docker](https://docs.docker.com/engine/install/) & [docker compose](https://docs.docker.com/compose/)
2. Atleast 4GB (preferably 8GB or more) memory

Start the container by opening a terminal in the downloaded project folder and starting the containers

```bash
docker compose up --build -d --scale spark-worker=2
sleep 30
```

Open Jupyter lab at **[http://localhost:8888/lab/](http://localhost:8888/lab/)**.

Stop containers with

```bash
docker compose down -v
sudo rm -rf ./minio_data/*
sudo rm -rf ./notebooks/data/*
```

## Licensing & Attribution

### MinIO
This course uses [MinIO](https://min.io) for object storage demonstrations. MinIO is open source software licensed under GNU AGPL v3.

