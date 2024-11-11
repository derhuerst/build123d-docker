# FROM python:3.12-alpine AS build123d
FROM python:3.12-slim AS build123d

LABEL org.opencontainers.image.title='build123d Python-based parametric CAD modeler'
# https://github.com/gumyr/build123d/blob/v0.7.0/LICENSE
LABEL org.opencontainers.image.licenses='Apache-2.0'

# pip: disable download progress bars
ENV PIP_PROGRESS_BAR=off

# install dependencies
# RUN apk add --no-cache --update \
# 	git mesa-gl
RUN apt update && apt install -y \
	git \
	libgl1-mesa-glx \
	&& rm -rf /var/lib/apt/lists/*

# install cadquery
# We do this manually to work around https://github.com/CadQuery/cadquery/issues/1626.
# ARG CATQUERY_VERSION=git+https://github.com/CadQuery/cadquery
ARG CATQUERY_VERSION=cadquery
RUN python3 -m pip install $CATQUERY_VERSION

# install build123d
# ARG BUILD123D_VERSION=git+https://github.com/gumyr/build123d
ARG BUILD123D_VERSION=build123d
RUN python3 -m pip install $BUILD123D_VERSION

WORKDIR /app

ENTRYPOINT [ "python3" ]
