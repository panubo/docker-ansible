FROM python:3.8-alpine

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIPENV_MAX_SUBPROCESS 8

RUN set -x \
  && pip install pipenv \
  && apk --no-cache add postgresql-dev libffi-dev make \
  && mkdir -p /etc/ansible \
  && addgroup -g 1000 ansible \
  && adduser -G ansible -u 1000 -D ansible \
  ;

WORKDIR /home/ansible

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY Pipfile* /

RUN set -x \
  && builddeps=".build-deps gcc g++" \
  && apk --no-cache add --virtual ${builddeps} \
  && pipenv install --system --deploy --verbose \
  && apk del ${builddeps} \
  ;

USER ansible
