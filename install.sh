#!/bin/bash

ok="[ \033[32;1mOK \033[0m]"
nok="[ \033[31;1mERROR \033[0m]"

c_error () {
  if [ $? -eq 0 ]; then
    echo -e $ok
  else
    echo -e $nok
    echo "Une erreur est survenue, fin du script..."
    exit
  fi
}

cat << "EOF"
 _ _                            _
(_) |                          | |
 _| | ___   __ _ _   _ ___   __| | _____   __
| | |/ _ \ / _` | | | / __| / _` |/ _ \ \ / /
| | | (_) | (_| | |_| \__ \| (_| |  __/\ V /
|_|_|\___/ \__, |\__,_|___(_)__,_|\___| \_/
            __/ |
           |___/

  https://github.com/ilogus/GLPI-Installer

EOF

echo "Bienvenue dans l'assistant d'installation de GLPI"

echo "Configuration du serveur..."
yum update -y
c_error

echo "Installation d'epel..."
yum install epel-release -y
c_error

echo "Installation des paquets d'administration..."
yum install nano wget -y
c_error

echo "Mise à jour du firewall..."
firewall-cmd --zone=public --permanent --add-port=80/tcp
c_error
firewall-cmd --zone=public --permanent --add-port=443/tcp
c_error
systemctl start firewalld
c_error
systemctl enable firewalld
c_error

echo "Désactivation de SELINUX..."
setenforce 0
c_error
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
c_error

echo "Téléchargement des ressources nécessaires..."
mkdir libs
c_error
cd libs
c_error
wget https://cdn.ilogus.fr/glpi-installer/libs/glpi.conf
c_error
cd ../
c_error

echo "Installation d'Apache..."
yum install httpd -y
c_error
echo "Démarrage et activation au boot d'Apache..."
systemctl start httpd.service
c_error
systemctl enable httpd.service
c_error

echo "Installation de MySQL..."
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
c_error
yum update -y
c_error
yum install MariaDB-server MariaDB-client -y
c_error

echo "Démarrage et activation au boot de MySQL..."
systemctl start mysql.service
c_error
systemctl start mariadb
c_error
systemctl enable mariadb
c_error

echo "Configuration de MySQL..."
mysql_secure_installation
c_error

echo "Installation de PHP (7.2)..."
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
c_error
yum install yum-utils -y
c_error
yum-config-manager --enable remi-php72
c_error
yum install php php-curl php-mbstring php-soap php-xml php-gd php-pecl-zip php-mysqli php-ldap php-imap php-opcache php-pear-CAS php-xmlrpc php-apcu -y
c_error

echo "Configuration de PHP..."
sed -i 's/post_max_size = 8M/post_max_size = 200M/g' /etc/php.ini
c_error
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/g' /etc/php.ini
c_error
systemctl restart httpd
c_error

echo "Configuration d'OPCache..."
sed -i 's/;opcache.enable_cli=0/opcache.enable_cli=1/g' /etc/php.d/10-opcache.ini
c_error
sed -i 's/opcache.memory_consumption=128/opcache.memory_consumption=256/g' /etc/php.d/10-opcache.ini
c_error
sed -i 's/;opcache.revalidate_freq=2/opcache.revalidate_freq=60/g' /etc/php.d/10-opcache.ini
c_error
sed -i 's/;opcache.enable_cli=0/opcache.enable_cli=1/g' /etc/php.d/10-opcache.ini
c_error
sed -i 's/;opcache.fast_shutdown=0/opcache.fast_shutdown=1/g' /etc/php.d/10-opcache.ini
c_error
systemctl restart httpd
c_error

echo "Téléchargement de GLPI..."
wget https://github.com/glpi-project/glpi/releases/download/9.4.4/glpi-9.4.4.tgz
c_error
tar -xvf glpi-9.4.4.tgz
c_error

echo "Création d'une base de données..."
read -p 'Entrez le mot de passe glpi : ' glpipass
echo "Mot de passe MySQL (root) :"
mysql -u root -p <<EOF
CREATE DATABASE glpi;
GRANT ALL PRIVILEGES ON glpi.* TO "glpi"@"localhost" IDENTIFIED BY '$glpipass';
FLUSH PRIVILEGES;
EOF
c_error

echo "Installation de GLPI..."
mkdir /var/www/glpi
c_error
mv glpi/* /var/www/glpi
c_error
chown -R apache:apache /var/www/glpi
c_error

echo "Configuration des vHosts..."
cp libs/glpi.conf /etc/httpd/conf.d/
c_error
systemctl restart httpd
c_error

echo "Fin de l'installation, vous devez relancer votre système pour prendre en compte les modifications SELINUX"
echo "Rendez vous sur https://127.0.0.1/glpi depuis un navigateur pour poursuivre l'installation"
echo "Au revoir, https://ilogus.dev"

while true; do
    read -p "Redémarrer le système maintenant ?" yn
    case $yn in
        [Yy]* ) shutdown -r now; break;;
        [Nn]* ) exit;;
        * ) echo ":( Yes/No...";;
    esac
done
