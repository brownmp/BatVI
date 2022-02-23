#!/bin/bash

set -e


# docker build -f Dockerfile -t brownmp/virtect:devel ..

docker build --build-arg CACHEBUST=$(date +%s)  -f Dockerfile -t brownmp/batvi:devel ..
