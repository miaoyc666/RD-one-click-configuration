#!/bin/bash

# get os version
version=`lsb_release -a`
echo $version


# 1.copy ccat
sudo cp bin/ccat /usr/local/bin/ccat

# 2.copy alias
cp config/my_alias ~/.my_alias
echo "" >> ~/.bashrc
echo ". ~/.my_alias" >> ~/.bashrc
echo "export LANG=\"zh_CN.UTF-8\"" >> ~/.bashrc
echo "export LC_ALL=\"zh_CN.UTF-8\"" >> ~/.bashrc


# copy yum


# copy apt


# install tmux





