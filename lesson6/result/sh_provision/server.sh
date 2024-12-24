#!/bin/bash

echo "server provision!"
# sudo apt-get update

sudo cat /home/vagrant/.ssh/vagrant_vm_rsa.pub >> /home/vagrant/.ssh/authorized_keys