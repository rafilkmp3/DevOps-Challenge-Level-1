FROM python:3.9-alpine

LABEL maintainer="rafilkmp3  <rafaelbsathler@gmail.com>" \
      version="1.0.0"

RUN pip install --upgrade pip

RUN adduser -D worker
USER worker
WORKDIR /home/worker

COPY --chown=worker:worker requirements.txt requirements.txt
RUN pip install --user -r requirements.txt

ENV PATH="/home/worker/.local/bin:${PATH}"

COPY --chown=worker:worker . .

ENV FLASK_APP=main.py
ENV FLASK_DEBUG=1

STOPSIGNAL SIGTERM

ENTRYPOINT [ "gunicorn", "--log-level", "debug", "--graceful-timeout", "30", "--bind", "0.0.0.0:9007", "main:app" ]

EXPOSE 9007
