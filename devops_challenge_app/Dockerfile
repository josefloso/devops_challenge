# 

FROM python:3.9.5-alpine


ENV PYTHONUNBUFFERED 1
COPY  ./requirements.txt /requirements.txt
RUN apk add --update --no-cache jpeg-dev postgresql-client 
# RUN apk add install -y --no-install-recommends  
RUN apk add --update --no-cache --virtual .tmp-build-deps \ 
    gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev

RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps


RUN mkdir /devops_challenge_app
COPY . /devops_challenge_app
WORKDIR /devops_challenge_app