#!/usr/bin/env bash

nvidia-docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -it --rm --ipc=host -v $PWD:/workspace/fastpitch/ fastpitch:latest bash
