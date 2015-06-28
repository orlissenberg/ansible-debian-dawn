#!/usr/bin/env bash

CURRENT_DIR=${PWD}
TMP_DIR=/tmp/ansible-test
mkdir -p $TMP_DIR 2> /dev/null

# Create hosts inventory
cat << EOF > $TMP_DIR/hosts
[webservers]
localhost ansible_connection=local
EOF

# Create test ssh keys
if [ ! -f $TMP_DIR/root_ssh.pub ]; then
ssh-keygen -t rsa -b 4096 -C "root@example.com" -q -f $TMP_DIR/root_ssh -N ""
fi

if [ ! -f $TMP_DIR/deployment_ssh.pub ]; then
ssh-keygen -t rsa -b 4096 -C "deployment@example.com" -q -f $TMP_DIR/deployment_ssh -N ""
fi

echo 'Enter a password for the deployment user:';
DEPLOYMENT_PWD="`echo 'import crypt,getpass; print crypt.crypt(getpass.getpass(), "$6$usesalt")' | python -`"

# Create group_vars for the webservers
mkdir -p $TMP_DIR/group_vars 2> /dev/null
cat << EOF > $TMP_DIR/group_vars/webservers
dawn_deployment_password: DEPLOYMENT_PWD
dawn_root_ssh: $TMP_DIR/root_ssh.pub
EOF

# Create Ansible config
cat << EOF > $TMP_DIR/ansible.cfg
[defaults]
roles_path = $CURRENT_DIR/../
host_key_checking = False
EOF

# Create playbook.yml
cat << EOF > $TMP_DIR/playbook.yml
---

- hosts: webservers
  gather_facts: yes
  sudo: yes

  roles:
    - ansible-debian-dawn

  vars_prompt:

    # Root user prompt
    - name: "dawn_root_password"
      prompt: "Enter password for root"
      private: yes
      encrypt: "sha512_crypt"
      confirm: yes
      salt_size: 7
      when: dawn_root_password == null
EOF

export ANSIBLE_CONFIG=$TMP_DIR/ansible.cfg

# Syntax check
# ansible-playbook $TMP_DIR/playbook.yml -i $TMP_DIR/hosts --syntax-check

# First run
ansible-playbook $TMP_DIR/playbook.yml -i $TMP_DIR/hosts

# Idempotence test
# ansible-playbook $TMP_DIR/playbook.yml -i $TMP_DIR/hosts | grep -q 'changed=3.*failed=0' \
# 	&& (echo 'Idempotence test: pass' \
# 	&& exit 0) || (echo 'Idempotence test: fail' && exit 1) \
