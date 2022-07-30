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

# copy yum


# copy apt





