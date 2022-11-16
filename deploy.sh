#!/usr/bin/env bash
set -e

ENV_TYPE=prod
BUILD_TAG=django-$ENV_TYPE-$BUILD_NUMBER


#Pushing the Image to Dockerhub
echo $DOCKERHUB_PASSWORD | docker login -u $DOCKER_USER --password-stdin

docker build -f ./k8s/app/Dockerfile . -t django/webapp
docker tag django/webapp greentropikal/django-webapp:$BUILD_TAG
docker push greentropikal/django-webapp:$BUILD_TAG

docker build -f ./k8s/celery-worker/Dockerfile . -t django/celery-worker 
docker tag django/celery-worker greentropikal/celery-worker:$BUILD_TAG
docker push greentropikal/celery-worker:$BUILD_TAG