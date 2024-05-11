#!/bin/bash
start_time=$(date +%s)

USERNAME="maharris"
IMAGENAME="jupyterfedora:latest"
ARCH="arm64"

docker build -t $IMAGENAME --progress=plain -f ./fedora/Dockerfile --build-arg USERNAME="$USERNAME" --build-arg ARCH="$ARCH" .


end_time=$(date +%s)
duration=$((end_time - start_time))

hours=$((duration / 3600))
minutes=$(( (duration % 3600) / 60 ))
seconds=$((duration % 60))
printf "%02d:%02d:%02d" $hours $minutes $seconds