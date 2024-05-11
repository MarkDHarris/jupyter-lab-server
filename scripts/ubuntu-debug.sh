#!/bin/bash
start_time=$(date +%s)

USERNAME="maharris"
IMAGENAME="jupyterubuntu:latest"

docker run -it -p 8888:8888 --rm --mount "type=bind,src=./notebooks,target=/opt/notebooks" --entrypoint /bin/bash $IMAGENAME

end_time=$(date +%s)
duration=$((end_time - start_time))

hours=$((duration / 3600))
minutes=$(( (duration % 3600) / 60 ))
seconds=$((duration % 60))

printf "%02d:%02d:%02d" $hours $minutes $seconds