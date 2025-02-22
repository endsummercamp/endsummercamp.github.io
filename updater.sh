#!/bin/bash

while true; do

inotifywait -e modify,create,delete -r . && \
zola build --force --output-dir /tmp/esc

done