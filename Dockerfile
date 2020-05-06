ARG IMAGE_NAME=nvidia/cuda
FROM ${IMAGE_NAME}:10.1-devel-ubuntu18.04 AS base

LABEL maintainer="<jsyuanmq@gmail.com>"

ARG CUDNN_VERSION=7.6.4.38
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=${CUDNN_VERSION}-1+cuda10.1 \
            libcudnn7-dev=${CUDNN_VERSION}-1+cuda10.1 && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

FROM base AS ubuntu-cudnn

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3-dev python3-pip python3-setuptools libgtk2.0-dev git g++ wget make vim \
        protobuf-compiler python-pil python-lxml python-tk

# Upgrade pip to latest version is necessary, otherwise the default version cannot install tensorflow 2.1.0
RUN pip3 install --upgrade setuptools pip

#for python packages
RUN pip3 install cython \
        opencv-python==3.4.5.20 \
        tensorflow-gpu==1.14.0 \
        contextlib2 \
        pillow \
        lxml \
        matplotlib

FROM ubuntu-cudnn as obj-detection
WORKDIR /tfObjDet

RUN git clone https://github.com/tensorflow/models.git

RUN pip3 install --user pycocotools

RUN cd /tfObjDet/models/research && protoc object_detection/protos/*.proto --python_out=.

ENV PYTHONPATH "${PYTHONPATH}:/tfObjDet/models/research:/tfObjDet/models/research/slim"

CMD ["/bin/bash"]