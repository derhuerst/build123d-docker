# FROM python:3.12-alpine AS build123d
FROM python:3.12-slim AS build123d

LABEL org.opencontainers.image.title='build123d Python-based parametric CAD modeler'
# https://github.com/gumyr/build123d/blob/v0.7.0/LICENSE
LABEL org.opencontainers.image.licenses='Apache-2.0'

# pip: disable download progress bars
ENV PIP_PROGRESS_BAR=off

# install dependencies
# RUN apk add --no-cache --update \
# 	git \
# 	mesa-gl
# gettext-base provides `envsubst`.
RUN apt update && apt install -y \
	git \
	libgl1-mesa-glx \
	&& rm -rf /var/lib/apt/lists/*

# install cadquery & build123d
RUN --mount=type=bind,target=/app \
	python3 -m pip install -r /app/requirements.txt

WORKDIR /app

ENTRYPOINT [ "python3" ]

# ---

FROM build123d AS yacv

LABEL org.opencontainers.image.title='CAD viewer capable of displaying OCP models (CadQuery/Build123d) in a web browser'
# build123d license + yacv license
# https://github.com/yeicor-3d/yet-another-cad-viewer/blob/v0.9.1/LICENSE
LABEL org.opencontainers.image.licenses='Apache-2.0 AND MIT'

# install yet-another-cat-viewer (yacv)
RUN --mount=type=bind,target=/app \
	python3 -m pip install -r /app/yacv.requirements.txt

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

# install cq-studio
RUN --mount=type=bind,target=/app \
	python3 -m pip install -r /app/cq-studio.requirements.txt

# from todo, but
# - we listen on 0.0.0.0 to allow connecting from outside the container
ENV YACV_HOST=0.0.0.0
ENV YACV_PORT=32323

ENTRYPOINT [ "/usr/local/bin/cq-studio", "--address", "${YACV_HOST}" ]
