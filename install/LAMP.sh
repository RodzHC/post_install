# Install LAMP stack

echo "Installing Apache"
apt install apache2 -y

echo "Installing Mysql Server"
apt install mysql-server -y

echo "Installing PHP"
apt install php libapache2-mod-php php-mcrypt php-mysql -y

echo "Installing Phpmyadmin"
apt install phpmyadmin -y

echo "Cofiguring apache to run Phpmyadmin"
echo "Include /etc/phpmyadmin/apache.conf" >>/etc/apache2/apache2.conf

echo "Enabling module rewrite"
sudo a2enmod rewrite
echo "Restarting Apache Server"
service apache2 restart
