FROM python:3.7

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get install -y build-essential jq

RUN pip install --upgrade pip
RUN pip install pyre-check==0.0.41

ENTRYPOINT ["/entrypoint.sh"]
