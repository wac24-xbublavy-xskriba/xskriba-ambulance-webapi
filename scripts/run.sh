#!/bin/bash

command=$1

if [ -z "$command" ]; then
    command="start"
fi

ProjectRoot="$(dirname "$(readlink -f "$0")")/.."

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"
export AMBULANCE_API_MONGODB_USERNAME="root"
export AMBULANCE_API_MONGODB_PASSWORD="neUhaDnes"

mongo() {
    docker compose --file "${ProjectRoot}/deployments/docker-compose/compose.yaml" "$args"
}

case "$command" in
    "openapi")
        docker run --rm -ti -v "${ProjectRoot}:/local" openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
        ;;
    "start")
        try {
            mongo up --detach
            go run "${ProjectRoot}/cmd/ambulance-api-service"
        } finally {
            mongo down
        }
        ;;
    "mongo")
        mongo up
        ;;
    *)
        echo "Unknown command: $command"
        exit 1
        ;;
esac






