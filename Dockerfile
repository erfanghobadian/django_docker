FROM python:3-alpine

RUN mkdir -p /opt/services/django_docker/src
WORKDIR /opt/services/django_docker/src

RUN apk update \
    && apk add --no-cache --virtual bash \
    && apk add gcc \
    && apk add musl-dev \
    && apk add linux-headers \
    && apk add jpeg-dev \
    && apk add zlib-dev \
    && apk add mariadb-dev \
    && apk add libffi-dev

COPY requirements.txt /opt/services/django_docker/requirements.txt
RUN pip install -r /opt/services/django_docker/requirements.txt


COPY . /opt/services/django_docker/src

COPY ./static /opt/services/django_docker/static
#COPY ./media /opt/services/django_docker/media
#RUN /opt/services/django_docker/src/manage.py collectstatic --no-input
#RUN /opt/services/django_docker/src/manage.py migrate --no-input

EXPOSE 8000

CMD [ "gunicorn", "--chdir", "django_docker", "--bind", ":8000", "django_docker.wsgi:application" ]