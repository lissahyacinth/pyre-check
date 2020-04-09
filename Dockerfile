FROM python:3.8.2-alpine

ADD entrypoint.sh /entrypoint.sh

RUN apk add bash gcc musl-dev build-base linux-headers

RUN pip install --upgrade pip
RUN pip install pyre-check==0.0.41

ENTRYPOINT ["/entrypoint.sh"]
