#!/bin/bash

export PORT=5160

cd ~/www/checkers
./bin/checkers stop || true
./bin/checkers start

