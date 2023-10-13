#!/bin/bash


# set -m

# /usr/sbin/sshd -D &
# jupyter lab --no-browser --port=8889 &

# fg %1


# Start the first process
# /docker/entrypoint.sh &

/usr/sbin/sshd -D &

# Start the second process
jupyter lab  --allow-root --no-browser  --port=8889 --ip=0.0.0.0 &

python -u webui.py --listen --port 7860  --allow-code --medvram --xformers --enable-insecure-extension-access --api &
# /opt/conda/envs/env/bin/jupyter notebook --allow-root --no-browser --port=8889 &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?