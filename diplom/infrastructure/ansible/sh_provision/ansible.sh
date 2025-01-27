echo "ansible provision!"

sudo apt-get update

sudo cat /home/vagrant/.ssh/vagrant_vm_rsa.pub >> /home/vagrant/.ssh/authorized_keys

# Установка Ansible
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install python3 python3-venv python3-pip
python3 -m venv venv
source venv/bin/activate
pip3 install ansible

# Запуск playbook
# после добавления ansible.cfg, dev определена как среда по умолчанию
export ANSIBLE_CONFIG=/home/vagrant/ansible/ansible.cfg
ansible-playbook /home/vagrant/ansible/playbooks/prod.yaml --limit prod_host