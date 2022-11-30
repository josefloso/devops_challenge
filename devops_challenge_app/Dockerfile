# pull official base image
FROM python:3.10-slim-buster

# set work directory
WORKDIR /usr/src/devops_challenge_app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt /usr/src/devops_challenge_app/requirements.txt
RUN pip install -r requirements.txt
RUN apk add --update --no-cache jpeg-dev postgresql-client 
# RUN apk add install -y --no-install-recommends  
RUN apk add --update --no-cache --virtual .tmp-build-deps \ 
    gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev

RUN apk del .tmp-build-deps

# copy entrypoint.sh
COPY ./entrypoint.sh /usr/src/devops_challenge_app/entrypoint.sh

# copy project
COPY . /usr/src/devops_challenge_app/
RUN ls -a
RUN chmod +x /entrypoint.sh
run entrypoint.sh
ENTRYPOINT ["/usr/src/devops_challenge_app/entrypoint.sh"]
CMD ["manage.py" ]


RUN mkdir /devops_challenge_app
COPY . /devops_challenge_app
WORKDIR /devops_challenge_app

ENTRYPOINT ["/entrypoint"]
