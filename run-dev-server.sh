#!/bin/bash

docker run --rm -it --name lashtime -v ${PWD}:/app -w /app -p 0.0.0.0:3000:8080 node:16 bash
