FROM python:3.9.5-alpine

ENV PYTHONBUFFERED 1
COPY ./requirements.txt /requirements.txt

RUN apk add --update --no-cache postgresql-client
RUN apk add --update --no-cache --virtual .temp-build-deps \
        && apk add gcc libc-dev linux-headers postgresql-dev \
        && pip install --upgrade pip \
        && pip install -r requirements.txt \
        && apk del .temp-build-deps


RUN mkdir app
WORKDIR /devops_challenge_app
COPY /devops_challenge_app /devops_challenge_app
EXPOSE 8000
CMD ["python","manage.py","runserver","0.0.0.0:8000"]