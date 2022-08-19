#!/usr/bin/env bash

wget https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz
tar -xf linux-amd64-1.1.0.tar.gz
cd linux-amd64-1.1.0
sudo cp ccat /usr/local/bin/
