# Build the container
make build

# Publish a container to ghcr.
# This includes the login to the repo
# you must login to your registry
make publish

# Build an run the container
make up

# Stop the running container
make stop

# Build the container with differnt config and deploy file
make cnf=another_config.env dpl=another_deploy.env build