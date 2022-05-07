echo "enter which php do you want to change"; 
 
 read version;
 
{
 
    sudo update-alternatives --set php /usr/bin/php$version
        
} || {
        
    sudo apt-get install php$version php$version-zip php$version-mbstring php$version-gd php$version-dom php$version-mysql php$version-fpm php$version-curl
    sudo update-alternatives --set php /usr/bin/php$version

}
