#!/bin/sh

# Set the environment variables to your needs
EXPERIMENT_TITLE="basic-check-deployment-availability"
NAMESPACE_NAME=" "
LABEL_SELECTOR=" "
TIMEOUT=" "
DEPLOYMENT_NAME=" "

echo "Validate chaos experiment $EXPERIMENT_TITLE"

chaos validate basic-check-deployment-availability.json 

[ $? -eq 0 ] || exit $?;

echo "Running chaos experiment $EXPERIMENT_TITLE"

export NAMESPACE_NAME=$NAMESPACE_NAME; \
export LABEL_SELECTOR=$LABEL_SELECTOR; \
export TIMEOUT=$TIMEOUT; \
export DEPLOYMENT_NAME=$DEPLOYMENT_NAME; \

chaos run basic-check-deployment-availability.json 