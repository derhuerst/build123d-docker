# Docker images for build123d & related projects

This repo's *GitHub Actions* CI workflows build **Docker images for the [build123d Python-based parametric CAD modeler](https://build123d.readthedocs.io/)** and for related projects:
- [yet-another-cad-viewer a.k.a. yacv](https://github.com/yeicor-3d/yet-another-cad-viewer)
- [cq-studio](https://github.com/ccazabon/cq-studio)


## Usage

### plain build123d

```shell
docker run --rm -it \
	-v $PWD:/app \
	ghcr.io/derhuerst/build123d \
	my-model-file.py
```

### yet-another-cad-viewer

```shell
docker run --rm -it \
	-v $PWD:/app \
	-p 32323:32323 \
	ghcr.io/derhuerst/build123d:with_yacv \
	my-model-file.py
```

### cq-studio

```shell
docker run --rm -it \
	-v $PWD:/app \
	-p 32323:32323 \
	ghcr.io/derhuerst/build123d:with_cq_studio \
	my-model-file.py
```
