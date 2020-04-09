FROM python:3.8.2-alpine

ADD entrypoint.sh /entrypoint.sh

RUN apk add bash gcc musl-dev

RUN pip install --upgrade pip
RUN pip install pyre-check
RUN pyre init

ENTRYPOINT["/entrypoint.sh"]
