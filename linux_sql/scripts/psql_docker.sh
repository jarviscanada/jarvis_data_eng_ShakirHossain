#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Ensure Docker is running
sudo systemctl status docker >/dev/null 2>&1 || sudo systemctl start docker

# Check if container exists
docker container inspect jrvs-psql >/dev/null 2>&1
container_status=$?

# Handle create | start | stop commands
case $cmd in
  create)
    # Check if container already exists
    if [ $container_status -eq 0 ]; then
      echo "Container 'jrvs-psql' already exists"
      exit 1
    fi

    # Check number of CLI arguments
    if [ $# -ne 3 ]; then
      echo "Create requires a username and password"
      echo "Usage: $0 create <db_username> <db_password>"
      exit 1
    fi

    # Create Docker volume
    docker volume create pgdata

    # Run Postgres container
    docker run --name jrvs-psql \
      -e POSTGRES_USER=$db_username \
      -e POSTGRES_PASSWORD=$db_password \
      -d -v pgdata:/var/lib/postgresql/data \
      -p 5432:5432 \
      postgres:9.6-alpine

    # Exit with docker run's status
    exit $?
    ;;

  start|stop)
    # Exit if container does not exist
    if [ $container_status -ne 0 ]; then
      echo "Error: container 'jrvs-psql' does not exist. Run 'create' first."
      exit 1
    fi

    # Start or stop the container
    docker container $cmd jrvs-psql
    exit $?
    ;;

  *)
    echo "Illegal command"
    echo "Commands: create | start | stop"
    exit 1
    ;;
esac