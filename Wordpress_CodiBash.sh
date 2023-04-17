#!/bin/bash

# Aquest script instal·la un servidor WordPress amb els requisits especificats.
# S'ha de executar com a superusuari (root).

# Es comprova si s'està executant com a superusuari.
if [ "$(id -u)" != "0" ]; then
   echo -e "\033[0;31mError: aquest script s'ha d'executar com a superusuari.\033[0m" 1>&2
   exit 1
fi

# Es pregunta per l'usuari que està executant l'script.
echo -e "\033[0;32mBenvingut/da! Qui ets?\033[0m"
read username

# Es comprova si l'usuari existeix.
if ! id "$username" &>/dev/null; then
    echo -e "\033[0;31mError: l'usuari $username no existeix.\033[0m"
    exit 1
fi

# Es demana al usuari si vol instal·lar Apache i MySQL
echo -e "\033[0;32mVols instal·lar Apache i MySQL (s/n)?\033[0m"
read answer

if [ "$answer" != "${answer#[Ss]}" ]; then
    # Es comprova si Apache ja està instal·lat.
    if [ $(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo -e "\033[0;32mS'instal·larà Apache.\033[0m"
        apt-get update
        apt-get install -y apache2
        echo -e "\033[0;32mApache s'ha instal·lat correctament.\033[0m"
    else
        echo -e "\033[0;32mApache ja està instal·lat.\033[0m"
    fi

    # Es comprova si MySQL ja està instal·lat.
    if [ $(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
        echo -e "\033[0;32mS'instal·larà MySQL.\033[0m"
        apt-get update
        apt-get install -y mysql-server
        echo -e "\033[0;32mMySQL s'ha instal·lat correctament.\033[0m"
    else
        echo -e "\033[0;32mMySQL ja està instal·lat.\033[0m"
    fi
fi

# Es comprova si PHP ja està instal·lat.
if [ $(dpkg-query -W -f='${Status}' php 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo -e "\033[0;32mS'instal·larà PHP.\033[0m"
    apt-get update
    apt-get install -y php php-mysql
    echo -e "\033[0;32mPHP s'ha instal·lat correctament.\033[0m"
else
    echo -e "\033[0;32mPHP ja està instal·lat.\033[0m"
fi
ese es el codigo del chatgp y aqui lo que queda del wordpress

# Descarregar i descomprimir WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress /var/www/html/

# Configurar WordPress
cd /var/www/html/wordpress
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$db_name/" wp-config.php
sed -i "s/username_here/$db_user/" wp-config.php
sed -i "s/password_here/$db_pass/" wp-config.php

# Assignar permisos als fitxers de WordPress
chown -R www-data:www-data /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;