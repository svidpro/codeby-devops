echo "ansible provision!"

sudo apt-get update

# Установка Ansible
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install python3 python3-venv python3-pip
python3 -m venv venv
source venv/bin/activate
pip3 install ansible

# Запуск playbook
#ansible-playbook -i /home/vagrant/ansible/env/dev/inventory.yaml /home/vagrant/ansible/playbooks/setup.yaml
# после добавления ansible.cfg, dev определена как среда по умолчанию
export ANSIBLE_CONFIG=/home/vagrant/ansible/ansible.cfg
ansible-playbook -i /home/vagrant/ansible/env/prod/inventory.yaml /home/vagrant/ansible/playbooks/setup.yaml
ansible-playbook /home/vagrant/ansible/playbooks/setup.yaml

# test
# ansible-playbook -vvvv --private-key=/home/vagrant/.ssh/vagrant_vm_rsa -i /home/vagrant/ansible/env/prod/inventory.yaml /home/vagrant/ansible/playbooks/setup.yaml