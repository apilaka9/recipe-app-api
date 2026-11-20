FROM python:3.9-alpine

LABEL maintainer="apilaka.com"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app

EXPOSE 8000

ARG DEV=false

# Step 1: Create virtual environment
RUN python -m venv /py

# Step 2: Upgrade pip
RUN /py/bin/pip install --upgrade pip

# Step 3: Install Django dependencies
RUN apk add --no-cache postgresql-dev build-base
RUN /py/bin/pip install -r /tmp/requirements.txt

# Step 4: Install development dependencies conditionally
RUN if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r   /tmp/requirements.dev.txt; \
    fi

# Step 5: Remove temporary files
RUN rm -rf /tmp/requirements.txt /tmp/requirements.dev.txt;

# Step 6: Create user
RUN adduser -D -H django-user

ENV PATH="/py/bin:$PATH"

USER django-user