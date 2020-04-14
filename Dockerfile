FROM python:latest

ADD entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get install -y build-essential

RUN pip install --upgrade pip
RUN pip install pyre-check==0.0.41

ENTRYPOINT ["./entrypoint.sh"]
