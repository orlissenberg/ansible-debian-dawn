Ansible Debian Dawn Role
========================

Configure a new Debian server.

- Add deployment user.
- Add ssh keys.
- Add basic (dev) tools like git, vim and fail2ban.
- Update apt.
- Schedule automatic security updates.

Requirements
------------

Debian 7/8

Role Variables
--------------

**SSH service port number:**
dawn_ssh_port

**Root password and ssh public key location:**
dawn_root_password
dawn_root_ssh

**Deployment used password, ssh public key and username:**
dawn_deployment_password
dawn_deployment_ssh
dawn_deployment_name

Dependencies
------------

None.

Example Playbook
----------------

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

License
-------

MIT

References & Notes
------------------

  ssh deployment@yourserver -p 2222 -i ./deployment_ssh

  ansible-playbook -i hosts playbook.yml --ask-sudo-pass

Inspired by:
[First Five (and a Half) Minutes on a Server with Ansible - Matthew Smith](http://lattejed.com/first-five-and-a-half-minutes-on-a-server-with-ansible)

Crypted passwords, generated on a Linux box using: 

	echo 'import crypt,getpass; print crypt.crypt(getpass.getpass(), "$6$usesalt")' | python -

[Service Name and Transport Protocol Port Number Registry](http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml)

[Securing Debian Manual](https://www.debian.org/doc/manuals/securing-debian-howto/index.en.html)

[Convert PPK to id_rsa in Linux](https://techtuts.info/2014/06/convert-ppk-id_rsa-linux/)

[Mosh (Mobile Shell)](https://mosh.mit.edu/)

[Unattended Upgrades](https://wiki.debian.org/UnattendedUpgrades)

    # perform dry-run
    unattended-upgrade --debug --dry-run

    sudo dpkg-reconfigure -plow unattended-upgrades

