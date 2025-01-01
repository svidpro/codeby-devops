echo "ansible provision!"

sudo apt-get update

# Установка Ansible
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install python3 python3-venv python3-pip
python3 -m venv venv
source venv/bin/activate
pip3 install ansible

# Запуск playbooks
export ANSIBLE_CONFIG=/home/vagrant/ansible/ansible.cfg
ansible-playbook /home/vagrant/ansible/playbooks/setup.yaml