FROM python:3.9-alpine3.13

LABEL maintainer="adithjaison"

ENV PYTHONUNBUFFERED=1

# Copy requirements and app files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Set working directory
WORKDIR /app

# Expose port 8000
EXPOSE 8000

# Add arguments for development
ARG DEV=false

# Create a virtual environment and install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    # Add user 'django-user'
    adduser --disabled-password --no-create-home django-user

# Set virtual environment path to PATH
ENV PATH="/py/bin:$PATH"

# Use the created user
USER django-user
