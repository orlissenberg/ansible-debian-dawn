#!/usr/bin/env bash

apt-get install software-properties-common -y
apt-get install sshpass -y
apt-get update

apt-get install -y python-dev python-apt python-pycurl python-pip python-virtualenv
pip install paramiko PyYAML Jinja2 httplib2
pip install ansible
pip install passlib