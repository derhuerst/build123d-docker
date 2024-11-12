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

# ---

FROM build123d AS yacv

LABEL org.opencontainers.image.title='CAD viewer capable of displaying OCP models (CadQuery/Build123d) in a web browser'
# build123d license + yacv license
# https://github.com/yeicor-3d/yet-another-cad-viewer/blob/v0.9.1/LICENSE
LABEL org.opencontainers.image.licenses='Apache-2.0 AND MIT'

# install yet-another-cat-viewer (yacv)
# ARG YACV_VERSION=git+https://github.com/yeicor-3d/yet-another-cad-viewer
ARG YACV_VERSION=yacv-server
RUN python3 -m pip install $YACV_VERSION

# from https://github.com/yeicor-3d/yet-another-cad-viewer/blob/v0.9.1/yacv_server/yacv.py#L172, but
# - we listen on 0.0.0.0 to allow connecting from outside the container
ENV YACV_HOST=0.0.0.0
ENV YACV_PORT=32323

# ---

FROM build123d AS cq_studio

LABEL org.opencontainers.image.title='hot-reloading live server for visualizing 3D models designed with CadQuery code'
# build123d license + cq-studio license
# https://github.com/ccazabon/cq-studio/blob/release/0.8.1/README.md#license
LABEL org.opencontainers.image.licenses='Apache-2.0 AND GPL-2.0-only'

RUN python3 -m pip install cq-studio

# from todo, but
# - we listen on 0.0.0.0 to allow connecting from outside the container
ENV YACV_HOST=0.0.0.0
ENV YACV_PORT=32323

ENTRYPOINT [ "/usr/local/bin/cq-studio", "--address", "${YACV_HOST}" ]
