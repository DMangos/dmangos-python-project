FROM python:3.10-slim-bookworm


LABEL Name="Python Flask Demo App" Version=1.4.2
LABEL org.opencontainers.image.source = "https://github.com/benc-uk/python-demoapp"


#Create a non-root user and a group.
RUN groupadd -g 1001 mygroup && \
    useradd -u 1001 -g mygroup -m -s /bin/bash myuser

#Switch to non-root user
USER myuser

ARG srcDir=src
WORKDIR /app
COPY $srcDir/requirements.txt .
ENV PATH="/home/myuser/.local/bin:${PATH}"
RUN python3.10 -m pip install --upgrade pip && \
    pip install --no-cache-dir --user -r requirements.txt   

COPY $srcDir/run.py .
COPY $srcDir/app ./app

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "run:app"]