#!/bin/bash


# set -m

# /usr/sbin/sshd -D &
# jupyter lab --no-browser --port=8889 &

# fg %1


# Start the first process
/usr/sbin/sshd -D &

# Start the second process
# /opt/filebrowser/filebrowser config set --address 0.0.0.0 --port 8080  --config /opt/filebrowser/.filebrowser.json
cd /opt/filebrowser/
./filebrowser  &

# Start the second process
cd /
jupyter lab  --allow-root --no-browser  --port=8889 --ip=0.0.0.0 &
# /opt/conda/envs/env/bin/jupyter notebook --allow-root --no-browser --port=8889 &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?