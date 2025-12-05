#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start docker
# Make sure you understand the double pipe operator
sudo systemctl status docker || systemctl #todo

# Check container status (try the following cmds on terminal)
docker container inspect jrvs-psql
container_status=$?

# User switch case to handle create|stop|start options
case $cmd in
  create)
    # Check if container already exists
    if [ $container_status -eq 0 ]; then
      echo "Container already exists"
      exit 1
    fi

    # Check number of CLI arguments
    if [ $# -ne 3 ]; then
      echo "Create requires a username and password"
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
