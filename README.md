# tensorflow-object-detection-api-docker

A docker build file for Tensorflow Object Detection API: https://github.com/tensorflow/models/tree/master/research/object_detection

### Requirements
- Nvidia Docker runtime: https://github.com/NVIDIA/nvidia-docker#quickstart
- CUDA 10.1 or higher on your host, check with `nvidia-smi`

### Host machine
- build image:
    ```
    docker build -t tensorflow-object-detection-api:latest .
    ```
- Run docker:
    ```
    export DATASET_DIR=~/Documents/item_detection_han/ && \
    export MODEL_DIR=~/Documents/item_detection_han/models/ssd_mobilenet_v3_small_coco_2019_08_14
    docker run -v $DATASET_DIR:/datasets \
    -v $MODEL_DIR:/models \
    -v /etc/localtime:/etc/localtime \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY -e QT_X11_NO_MITSHM=1  \
    -it --rm --runtime=nvidia \
    --name tfObjDet tensorflow-object-detection-api:latest /bin/bash
    ```

- train model
    ```
    PIPELINE_CONFIG_PATH=/models/pipeline.config
    MODEL_DIR=/models
    NUM_TRAIN_STEPS=50000
    SAMPLE_1_OF_N_EVAL_EXAMPLES=1
    cd /models/research \
    python3 object_detection/model_main.py \
        --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
        --model_dir=${MODEL_DIR} \
        --num_train_steps=${NUM_TRAIN_STEPS} \
        --sample_1_of_n_eval_examples=$SAMPLE_1_OF_N_EVAL_EXAMPLES \
        --alsologtostderr
    ```