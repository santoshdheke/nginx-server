#!/bin/bash

# to be able to work this function globally, copy or create link in /usr/local/bin

# --------------------------------------------------------------------

makeServerBlock() {
    try_files='try_files $uri $uri/ /index.php?$query_string;'
    block="/etc/nginx/sites-available/$domain"

     #--------------------------------------------------------------------

    # add to /etc/hosts file
    sudo sh -c 'echo "127.0.0.1             '$domain'" >> /etc/hosts'


# Create the Nginx server block file:
sudo tee $block > /dev/null <<EOF
server {
            listen 80;
            listen [::]:80;

            root $path;
            index index.php index.html index.htm;

            server_name $domain;

         location / {
            #autoindex on;
            $try_files
            }

            location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php$php-fpm.sock;
            }

          location ~ /\.ht {
                deny all;
           }
    }


EOF

# Link to make it available
sudo ln -s $block /etc/nginx/sites-enabled/

# Test configuration and reload if successful
sudo nginx -t && sudo service nginx reload

# Give write Permission to /bootstrap/cache & /storage
if [ -d $(pwd)/storage ] ; then
   sudo chgrp -R www-data $(pwd)/storage $(pwd)/bootstrap/cache
   sudo chmod -R ug+rwx $(pwd)/storage $(pwd)/bootstrap/cache
fi

}

# get accessories ready for server block
prepareForServerBlock() {
    echo Enter your local domain name:
    read domain

    echo Select PHP version for the project? [7.2]:
    read php
    if [ -z "$php" ]
        then
            php='7.2'
        else
            php=$php
    fi

    makeServerBlock $domain $path $php
}


echo Is this a laravel project? [y/n]:
    read isLaravel

    case $isLaravel in
        [Yy]* )
         path=$(pwd)/public
          ;;
        [Nn]* )
         path=$(pwd)
          ;;
        * )
        path=$(pwd)/public
          ;;
    esac
    prepareForServerBlock $path
