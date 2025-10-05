# User setup

sudo useradd -m devops

visudo


# Privacy policy

# ufw
sudo apt install ufw        
sudo systemctl start ufw 
sudo systemctl enable ufw

sudo ufw allow ssh 
sudo ufw allow http
sudo ufw allow https
sudo ufw enable

# firewalld

sudo yum install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload


# SSH key setup

/etc/ssh/sshd_config

PasswordAuthentication no
ChallengeResponseAuthentication no      # Alternative authentication methods. E. g. passwords, tokens
UsePAM no                               # Linux subsystem for password checking, policies, time restrictions
PubkeyAuthentication yes
