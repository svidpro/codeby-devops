echo "dev provision!"

sudo apt-get update

sudo cat /home/vagrant/.ssh/vagrant_vm_rsa.pub >> /home/vagrant/.ssh/authorized_keys

sudo apt-get -y install python3 python3-pip
# sudo apt-get -y install mysql-client mysql-server
# sudo -u vagrant pip install PyMySQL