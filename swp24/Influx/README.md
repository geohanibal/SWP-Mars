# Supplementary Materials (SWP 2024)

This repository contains supplementary materials for the software project in the
winter semester 2024/2025. The repository contains the following assets in their
respective directories:

## 3D Models

This directory contains 3D models of the laboratory module, PBR, and sensor
board. Each is contained in a separate subfolder, which contains four different
files each.

The first file is suffixed with `_large`, denoting the large version of the
models that have been kindly provided to us by the ZARM. These models are CAD
models in the STL format and depict a detailed version of the respective part.
They are far too detailed for real-time rendering and should therefore not be
used in the UI. In addition, these models suffer from flipped normals and
scaling issues.

The second file is suffixed with `_small`, denoting the low-poly version of the
models. These models are optimized for real-time rendering and should be used in
the UI instead. There are three different formats available: `stl`, `obj`, and
`blend`. The `blend` file is the source file and can be used to make changes to
the model using Blender, if desired. The `stl` and `obj` files are meant to be
imported directly. As for the libraries that may be used,
[DiTreDi](https://pub.dev/packages/ditredi) - while being a bit more cumbersome
than alternatives - is the preferred choice for importing the models, as it is
the most reliable choice.

## Influx

This directory contains a Dockerfile that can be used to build an InfluxDB
container with sample data. The sample data is a realistic representation of the
data that will be used in actual operation.

### Build Image
```sh
docker build -t <image-name> .
```
For example:
```sh
docker build -t myinfluxdb .
```

### Start Container
```sh
docker run -d --name <container-name> -p 8086:8086 \
        -v <local-path>:/var/lib/influxdb <image-name>
```
For example:
```sh
docker run -d --name idb -p 8086:8086 \
        -v ./influx-data:/var/lib/influxdb myinfluxdb
```

### Stop Container
```sh
docker stop <container-name>
```
For example:
```sh
docker stop idb
```

### Start Container
```sh
docker start <container-name>
```
For example:
```sh
docker start idb
```

### Check Content
```sh
docker exec -it <container-name> /bin/sh
```
For example:
```sh
docker exec -it idb /bin/sh
```

This starts an interactive sh shell in the container. Then enter:

```sh
influx
use openhab_db
show measurements
```

Then all measurements or tables should be displayed.