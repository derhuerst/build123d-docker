# Docker images for build123d

This repo's *GitHub Actions* CI workflows build **Docker images for the [build123d Python-based parametric CAD modeler](https://build123d.readthedocs.io/)**.


## Usage

```shell
docker run --rm -it \
	-v $PWD:/app \
	ghcr.io/derhuerst/build123d \
	my-model-file.py
```
