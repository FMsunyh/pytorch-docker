#!/bin/bash
set -m

/usr/sbin/sshd -D &
jupyter lab --no-browser --port=8889 &

fg %1