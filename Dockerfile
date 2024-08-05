FROM python:3.8-slim-buster

WORKDIR /github-actions
COPY . .

RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir awscli

RUN chmod +x script.sh

CMD cd /github-actions && ./script.sh
