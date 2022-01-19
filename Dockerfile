FROM python:3.8-alpine

RUN pip install --upgrade pip

RUN adduser -D worker
USER worker
WORKDIR /home/worker

COPY --chown=worker:worker requirements.txt requirements.txt
RUN pip install --user -r requirements.txt

ENV PATH="/home/worker/.local/bin:${PATH}"

COPY --chown=worker:worker . .

LABEL maintainer="rafilkmp3  <rafaelbsathler@gmail.com>" \
      version="1.0.0"

CMD ["python", "./main.py"]